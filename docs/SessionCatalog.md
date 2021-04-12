# SessionCatalog &mdash; Session-Scoped Registry of Relational Entities

`SessionCatalog` is a catalog of relational entities in [SparkSession](SparkSession.md#catalog) (e.g. databases, tables, views, partitions, and functions).

## Creating Instance

`SessionCatalog` takes the following to be created:

* <span id="externalCatalogBuilder"> Function to create an [ExternalCatalog](ExternalCatalog.md)
* <span id="globalTempViewManagerBuilder"> Function to create a [GlobalTempViewManager](GlobalTempViewManager.md)
* <span id="functionRegistry"> [FunctionRegistry](FunctionRegistry.md)
* <span id="conf"> [SQLConf](SQLConf.md)
* <span id="hadoopConf"> Hadoop Configuration
* <span id="parser"> [ParserInterface](sql/ParserInterface.md)
* <span id="functionResourceLoader"> `FunctionResourceLoader`

![SessionCatalog and Spark SQL Services](images/spark-sql-SessionCatalog.png)

`SessionCatalog` is created (and cached for later usage) when `BaseSessionStateBuilder` is requested for [one](BaseSessionStateBuilder.md#catalog).

## Accessing SessionCatalog

`SessionCatalog` is available through [SessionState](SessionState.md#catalog) (of the owning [SparkSession](SparkSession.md#sessionState)).

```text
scala> :type spark
org.apache.spark.sql.SparkSession

scala> :type spark.sessionState.catalog
org.apache.spark.sql.catalyst.catalog.SessionCatalog
```

## <span id="DEFAULT_DATABASE"> Default Database Name

`SessionCatalog` defines `default` as the name of the default database.

## <span id="externalCatalog"> ExternalCatalog

`SessionCatalog` creates an [ExternalCatalog](ExternalCatalog.md) for the metadata of permanent entities (when first requested).

`SessionCatalog` is in fact a layer over `ExternalCatalog` (in a [SparkSession](SparkSession.md#sessionState)) which allows for different metastores (i.e. `in-memory` or [hive](hive/HiveSessionCatalog.md)).

## <span id="lookupFunction"> Looking Up Function

```scala
lookupFunction(
  name: FunctionIdentifier,
  children: Seq[Expression]): Expression
```

`lookupFunction` looks up a function by `name`.

For a function with no database defined that exists in [FunctionRegistry](#functionRegistry), `lookupFunction` requests `FunctionRegistry` to [find the function](FunctionRegistry.md#lookupFunction) (by its unqualified name, i.e. with no database).

If the `name` function has the database defined or does not exist in `FunctionRegistry`, `lookupFunction` uses the fully-qualified function `name` to check if the function exists in [FunctionRegistry](#functionRegistry) (by its fully-qualified name, i.e. with a database).

For other cases, `lookupFunction` requests [ExternalCatalog](#externalCatalog) to find the function and [loads its resources](#loadFunctionResources). `lookupFunction` then [creates a corresponding temporary function](#createTempFunction) and [looks up the function](FunctionRegistry.md#lookupFunction) again.

`lookupFunction` is used when:

* [ResolveFunctions](logical-analysis-rules/ResolveFunctions.md) logical resolution rule executed (and resolves [UnresolvedGenerator](expressions/UnresolvedGenerator.md) or [UnresolvedFunction](expressions/UnresolvedFunction.md) expressions)
* `HiveSessionCatalog` is requested to [lookupFunction0](hive/HiveSessionCatalog.md#lookupFunction0)

## <span id="lookupRelation"> Looking Up Relation

```scala
lookupRelation(
  name: TableIdentifier): LogicalPlan
```

`lookupRelation` finds the `name` table in the catalogs (i.e. [GlobalTempViewManager](#globalTempViewManager), [ExternalCatalog](#externalCatalog) or [registry of temporary views](#tempViews)) and gives a `SubqueryAlias` per table type.

Internally, `lookupRelation` looks up the `name` table using:

1. [GlobalTempViewManager](#globalTempViewManager) when the database name of the table matches the [name](GlobalTempViewManager.md#database) of `GlobalTempViewManager`
    * Gives `SubqueryAlias` or reports a `NoSuchTableException`

1. [ExternalCatalog](#externalCatalog) when the database name of the table is specified explicitly or the [registry of temporary views](#tempViews) does not contain the table
    * Gives `SubqueryAlias` with `View` when the table is a view (aka _temporary table_)
    * Gives `SubqueryAlias` with `UnresolvedCatalogRelation` otherwise

1. The [registry of temporary views](#tempViews)
    * Gives `SubqueryAlias` with the logical plan per the table as registered in the [registry of temporary views](#tempViews)

!!! NOTE
    `lookupRelation` considers **default** to be the name of the database if the `name` table does not specify the database explicitly.

### <span id="lookupRelation-demo"> Demo

```text
scala> :type spark.sessionState.catalog
org.apache.spark.sql.catalyst.catalog.SessionCatalog

import spark.sessionState.{catalog => c}
import org.apache.spark.sql.catalyst.TableIdentifier

// Global temp view
val db = spark.sharedState.globalTempViewManager.database
// Make the example reproducible (and so "replace")
spark.range(1).createOrReplaceGlobalTempView("gv1")
val gv1 = TableIdentifier(table = "gv1", database = Some(db))
val plan = c.lookupRelation(gv1)
scala> println(plan.numberedTreeString)
00 SubqueryAlias gv1
01 +- Range (0, 1, step=1, splits=Some(8))

val metastore = spark.sharedState.externalCatalog

// Regular table
val db = spark.catalog.currentDatabase
metastore.dropTable(db, table = "t1", ignoreIfNotExists = true, purge = true)
sql("CREATE TABLE t1 (id LONG) USING parquet")
val t1 = TableIdentifier(table = "t1", database = Some(db))
val plan = c.lookupRelation(t1)
scala> println(plan.numberedTreeString)
00 'SubqueryAlias t1
01 +- 'UnresolvedCatalogRelation `default`.`t1`, org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe

// Regular view (not temporary view!)
// Make the example reproducible
metastore.dropTable(db, table = "v1", ignoreIfNotExists = true, purge = true)
import org.apache.spark.sql.catalyst.catalog.{CatalogStorageFormat, CatalogTable, CatalogTableType}
val v1 = TableIdentifier(table = "v1", database = Some(db))
import org.apache.spark.sql.types.StructType
val schema = new StructType().add($"id".long)
val storage = CatalogStorageFormat(locationUri = None, inputFormat = None, outputFormat = None, serde = None, compressed = false, properties = Map())
val tableDef = CatalogTable(
  identifier = v1,
  tableType = CatalogTableType.VIEW,
  storage,
  schema,
  viewText = Some("SELECT 1") /** Required or RuntimeException reported */)
metastore.createTable(tableDef, ignoreIfExists = false)
val plan = c.lookupRelation(v1)
scala> println(plan.numberedTreeString)
00 'SubqueryAlias v1
01 +- View (`default`.`v1`, [id#77L])
02    +- 'Project [unresolvedalias(1, None)]
03       +- OneRowRelation

// Temporary view
spark.range(1).createOrReplaceTempView("v2")
val v2 = TableIdentifier(table = "v2", database = None)
val plan = c.lookupRelation(v2)
scala> println(plan.numberedTreeString)
00 SubqueryAlias v2
01 +- Range (0, 1, step=1, splits=Some(8))
```

## <span id="getTempViewOrPermanentTableMetadata"> Retrieving Table Metadata

```scala
getTempViewOrPermanentTableMetadata(
  name: TableIdentifier): CatalogTable
```

`getTempViewOrPermanentTableMetadata` branches off based on the database (in the given `TableIdentifier`).

When a database name is not specified, `getTempViewOrPermanentTableMetadata` [finds a local temporary view](#getTempView) and creates a [CatalogTable](CatalogTable.md) (with `VIEW` [table type](CatalogTable.md#tableType) and an undefined [storage](CatalogTable.md#storage)) or [retrieves the table metadata from an external catalog](#getTableMetadata).

With the database name of the [GlobalTempViewManager](GlobalTempViewManager.md), `getTempViewOrPermanentTableMetadata` requests [GlobalTempViewManager](#globalTempViewManager) for the [global view definition](GlobalTempViewManager.md#get) and creates a [CatalogTable](CatalogTable.md) (with the [name](GlobalTempViewManager.md#database) of `GlobalTempViewManager` in [table identifier](CatalogTable.md#identifier), `VIEW` [table type](CatalogTable.md#tableType) and an undefined [storage](CatalogTable.md#storage)) or reports a `NoSuchTableException`.

With the database name not of `GlobalTempViewManager`, `getTempViewOrPermanentTableMetadata` simply [retrieves the table metadata from an external catalog](#getTableMetadata).
