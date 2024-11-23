---
title: SessionCatalog
---

# SessionCatalog &mdash; Session-Scoped Registry of Relational Entities

`SessionCatalog` is a catalog of relational entities in [SparkSession](SparkSession.md#catalog) (e.g. databases, tables, views, partitions, and functions).

`SessionCatalog` is a [SQLConfHelper](SQLConfHelper.md).

## Creating Instance

`SessionCatalog` takes the following to be created:

* <span id="externalCatalogBuilder"> [ExternalCatalog](ExternalCatalog.md)
* <span id="globalTempViewManagerBuilder"> [GlobalTempViewManager](GlobalTempViewManager.md)
* <span id="functionRegistry"> [FunctionRegistry](FunctionRegistry.md)
* [TableFunctionRegistry](#tableFunctionRegistry)
* <span id="hadoopConf"> `Configuration` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html))
* <span id="parser"> [ParserInterface](sql/ParserInterface.md)
* <span id="functionResourceLoader"> FunctionResourceLoader
* <span id="functionExpressionBuilder"> `FunctionExpressionBuilder`
* <span id="cacheSize"> Cache Size (default: [spark.sql.filesourceTableRelationCacheSize](configuration-properties.md#spark.sql.filesourceTableRelationCacheSize))
* <span id="cacheTTL"> Cache TTL (default: [spark.sql.metadataCacheTTLSeconds](configuration-properties.md#spark.sql.metadataCacheTTLSeconds))
* <span id="defaultDatabase"> Default database name (default: [spark.sql.catalog.spark_catalog.defaultDatabase](configuration-properties.md#spark.sql.catalog.spark_catalog.defaultDatabase))

![SessionCatalog and Spark SQL Services](images/spark-sql-SessionCatalog.png)

`SessionCatalog` is created (and cached for later usage) when `BaseSessionStateBuilder` is requested for [one](BaseSessionStateBuilder.md#catalog).

### <span id="tableFunctionRegistry"> TableFunctionRegistry

`SessionCatalog` is given a [TableFunctionRegistry](TableFunctionRegistry.md) when [created](#creating-instance).

The `TableFunctionRegistry` is used in the following:

* [dropTempFunction](#dropTempFunction)
* [isRegisteredFunction](#isRegisteredFunction)
* [listBuiltinAndTempFunctions](#listBuiltinAndTempFunctions)
* [listTemporaryFunctions](#listTemporaryFunctions)
* [lookupBuiltinOrTempTableFunction](#lookupBuiltinOrTempTableFunction)
* [lookupPersistentFunction](#lookupPersistentFunction)
* [resolveBuiltinOrTempTableFunction](#resolveBuiltinOrTempTableFunction)
* [resolvePersistentTableFunction](#resolvePersistentTableFunction)
* [reset](#reset)
* [unregisterFunction](#unregisterFunction)

## Accessing SessionCatalog

`SessionCatalog` is available through [SessionState](SessionState.md#catalog) (of the owning [SparkSession](SparkSession.md#sessionState)).

```scala
val catalog = spark.sessionState.catalog
assert(catalog.isInstanceOf[org.apache.spark.sql.catalyst.catalog.SessionCatalog])
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

## <span id="lookupFunctionInfo"> lookupFunctionInfo

```scala
lookupFunctionInfo(
  name: FunctionIdentifier): ExpressionInfo
```

`lookupFunctionInfo`...FIXME

---

`lookupFunctionInfo` is used when:

* `SparkGetFunctionsOperation` (Spark Thrift Server) is requested to `runInternal`
* `CatalogImpl` is requested to [makeFunction](CatalogImpl.md#makeFunction)

## <span id="lookupBuiltinOrTempFunction"> lookupBuiltinOrTempFunction

```scala
lookupBuiltinOrTempFunction(
  name: String): Option[ExpressionInfo]
```

`lookupBuiltinOrTempFunction`...FIXME

---

`lookupBuiltinOrTempFunction` is used when:

* `ResolveFunctions` logical analysis is requested to [lookupBuiltinOrTempFunction](logical-analysis-rules/ResolveFunctions.md#lookupBuiltinOrTempFunction)
* `SessionCatalog` is requested to [lookupFunctionInfo](#lookupFunctionInfo)

## <span id="lookupBuiltinOrTempTableFunction"> lookupBuiltinOrTempTableFunction

```scala
lookupBuiltinOrTempTableFunction(
  name: String): Option[ExpressionInfo]
```

`lookupBuiltinOrTempTableFunction`...FIXME

---

`lookupBuiltinOrTempTableFunction` is used when:

* `ResolveFunctions` logical analysis is requested to [lookupBuiltinOrTempTableFunction](logical-analysis-rules/ResolveFunctions.md#lookupBuiltinOrTempTableFunction)
* `SessionCatalog` is requested to [lookupFunctionInfo](#lookupFunctionInfo)

## <span id="lookupPersistentFunction"> lookupPersistentFunction

```scala
lookupPersistentFunction(
  name: FunctionIdentifier): ExpressionInfo
```

`lookupPersistentFunction`...FIXME

---

`lookupPersistentFunction` is used when:

* `SessionCatalog` is requested to [lookupFunctionInfo](#lookupFunctionInfo)
* `V2SessionCatalog` is requested to [load a function](V2SessionCatalog.md#loadFunction)

## <span id="resolveBuiltinOrTempTableFunction"> resolveBuiltinOrTempTableFunction

```scala
resolveBuiltinOrTempTableFunction(
  name: String,
  arguments: Seq[Expression]): Option[LogicalPlan]
```

`resolveBuiltinOrTempTableFunction` [resolveBuiltinOrTempFunctionInternal](#resolveBuiltinOrTempFunctionInternal) with the [TableFunctionRegistry](#tableFunctionRegistry).

---

`resolveBuiltinOrTempTableFunction` is used when:

* [ResolveFunctions](logical-analysis-rules/ResolveFunctions.md) logical analysis rule is [executed](logical-analysis-rules/ResolveFunctions.md#resolveBuiltinOrTempTableFunction) (to resolve a [UnresolvedTableValuedFunction](logical-operators/UnresolvedTableValuedFunction.md) logical operator)
* `SessionCatalog` is requested to [lookupTableFunction](#lookupTableFunction)

## <span id="resolveBuiltinOrTempFunctionInternal"> resolveBuiltinOrTempFunctionInternal

```scala
resolveBuiltinOrTempFunctionInternal[T](
  name: String,
  arguments: Seq[Expression],
  isBuiltin: FunctionIdentifier => Boolean,
  registry: FunctionRegistryBase[T]): Option[T]
```

`resolveBuiltinOrTempFunctionInternal` creates a `FunctionIdentifier` (for the given `name`).

`resolveBuiltinOrTempFunctionInternal`...FIXME

!!! note
    `resolveBuiltinOrTempFunctionInternal` is fairly simple yet I got confused what it does actually so I marked it `FIXME`.

---

`resolveBuiltinOrTempFunctionInternal` is used when:

* `SessionCatalog` is requested to [resolveBuiltinOrTempFunction](#resolveBuiltinOrTempFunction), [resolveBuiltinOrTempTableFunction](#resolveBuiltinOrTempTableFunction)

## <span id="registerFunction"> registerFunction

```scala
registerFunction(
  funcDefinition: CatalogFunction,
  overrideIfExists: Boolean,
  functionBuilder: Option[Seq[Expression] => Expression] = None): Unit
registerFunction[T](
  funcDefinition: CatalogFunction,
  overrideIfExists: Boolean,
  registry: FunctionRegistryBase[T],
  functionBuilder: Seq[Expression] => T): Unit
```

`registerFunction`...FIXME

---

`registerFunction` is used when:

* `CreateFunctionCommand` is executed
* `RefreshFunctionCommand` is executed
* `SessionCatalog` is requested to [resolvePersistentFunctionInternal](#resolvePersistentFunctionInternal)

## Looking Up Table Metadata { #getTableMetadata }

```scala
getTableMetadata(
  name: TableIdentifier): CatalogTable
```

`getTableMetadata` [getTableRawMetadata](#getTableRawMetadata) and replaces `CharType` and `VarcharType` field types with `StringType` in the table schema, recursively.

!!! note "`CharType` and `VarcharType` Unsupported"
    The Spark SQL query engine does not support char/varchar types yet.

## getRelation { #getRelation }

```scala
getRelation(
  metadata: CatalogTable,
  options: CaseInsensitiveStringMap): LogicalPlan
```

`getRelation` creates a [LogicalPlan](logical-operators/LogicalPlan.md) with a [SubqueryAlias](logical-operators/SubqueryAlias.md) logical operator with a child logical operator based on the [table type](CatalogTable.md#tableType) of the given [CatalogTable](CatalogTable.md) metadata:

Table Type | Child Logical Operator
-|-
 `VIEW` | [fromCatalogTable](#fromCatalogTable)
 `EXTERNAL` or `MANAGED` | [UnresolvedCatalogRelation](logical-operators/UnresolvedCatalogRelation.md)

---

`getRelation` is used when:

* [ResolveRelations](logical-analysis-rules/ResolveRelations.md) logical analysis rule is executed
* `SessionCatalog` is requested to [lookupRelation](#lookupRelation)
