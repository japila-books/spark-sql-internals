# SessionCatalog &mdash; Session-Scoped Registry of Relational Entities

`SessionCatalog` is a catalog of relational entities in [SparkSession](SparkSession.md#catalog) (e.g. databases, tables, views, partitions, and functions).

`SessionCatalog` is used to create [Logical Analyzer](Analyzer.md#catalog) and [SparkOptimizer](SparkOptimizer.md#catalog) (_among other things_).

## Creating Instance

SessionCatalog takes the following to be created:

* <span id="externalCatalogBuilder"> Function to create an [ExternalCatalog](ExternalCatalog.md)
* <span id="globalTempViewManagerBuilder"> Function to create a [GlobalTempViewManager](spark-sql-GlobalTempViewManager.md)
* <span id="functionRegistry"> [FunctionRegistry](spark-sql-FunctionRegistry.md)
* <span id="conf"> [SQLConf](SQLConf.md)
* <span id="hadoopConf"> Hadoop Configuration
* <span id="parser"> [ParserInterface](sql/ParserInterface.md)
* <span id="functionResourceLoader"> `FunctionResourceLoader`

![SessionCatalog and Spark SQL Services](images/spark-sql-SessionCatalog.png)

`SessionCatalog` is created (and cached for later usage) when `BaseSessionStateBuilder` is requested for [one](BaseSessionStateBuilder.md#catalog).

## Accessing SessionCatalog

`SessionCatalog` is available through [SessionState](SessionState.md#catalog) (of a [SparkSession](SparkSession.md#sessionState)).

```
scala> :type spark
org.apache.spark.sql.SparkSession

scala> :type spark.sessionState.catalog
org.apache.spark.sql.catalyst.catalog.SessionCatalog
```

## ExternalCatalog

`SessionCatalog` uses an [ExternalCatalog](ExternalCatalog.md) for the metadata of permanent entities (i.e. [tables](#getTableMetadata)).

`SessionCatalog` is in fact a layer over ExternalCatalog in a [SparkSession](SparkSession.md#sessionState) which allows for different metastores (i.e. `in-memory` or [hive](hive/HiveSessionCatalog.md)) to be used.

## requireTableExists

```scala
requireTableExists(
  name: TableIdentifier): Unit
```

`requireTableExists`...FIXME

`requireTableExists` is used when...FIXME

## databaseExists

```scala
databaseExists(
  db: String): Boolean
```

`databaseExists`...FIXME

`databaseExists` is used when...FIXME

=== [[listTables]] `listTables` Method

[source, scala]
----
listTables(db: String): Seq[TableIdentifier] // <1>
listTables(db: String, pattern: String): Seq[TableIdentifier]
----
<1> Uses `"*"` as the pattern

`listTables`...FIXME

[NOTE]
====
`listTables` is used when:

* `ShowTablesCommand` logical command is requested to <<spark-sql-LogicalPlan-ShowTablesCommand.md#run, run>>

* `SessionCatalog` is requested to <<reset, reset>> (for testing)

* `CatalogImpl` is requested to [listTables](CatalogImpl.md#listTables) (for testing)
====

=== [[isTemporaryTable]] Checking Whether Table Is Temporary View -- `isTemporaryTable` Method

[source, scala]
----
isTemporaryTable(name: TableIdentifier): Boolean
----

`isTemporaryTable`...FIXME

NOTE: `isTemporaryTable` is used when...FIXME

=== [[alterPartitions]] `alterPartitions` Method

[source, scala]
----
alterPartitions(tableName: TableIdentifier, parts: Seq[CatalogTablePartition]): Unit
----

`alterPartitions`...FIXME

NOTE: `alterPartitions` is used when...FIXME

=== [[listPartitions]] `listPartitions` Method

[source, scala]
----
listPartitions(
  tableName: TableIdentifier,
  partialSpec: Option[TablePartitionSpec] = None): Seq[CatalogTablePartition]
----

`listPartitions`...FIXME

NOTE: `listPartitions` is used when...FIXME

=== [[listPartitionsByFilter]] `listPartitionsByFilter` Method

[source, scala]
----
listPartitionsByFilter(
  tableName: TableIdentifier,
  predicates: Seq[Expression]): Seq[CatalogTablePartition]
----

`listPartitionsByFilter`...FIXME

NOTE: `listPartitionsByFilter` is used when...FIXME

=== [[alterTable]] `alterTable` Method

[source, scala]
----
alterTable(tableDefinition: CatalogTable): Unit
----

`alterTable`...FIXME

NOTE: `alterTable` is used when `AlterTableSetPropertiesCommand`, `AlterTableUnsetPropertiesCommand`, `AlterTableChangeColumnCommand`, `AlterTableSerDePropertiesCommand`, [AlterTableRecoverPartitionsCommand](logical-operators/AlterTableRecoverPartitionsCommand.md), `AlterTableSetLocationCommand`, spark-sql-LogicalPlan-AlterViewAsCommand.md#run[AlterViewAsCommand] (for spark-sql-LogicalPlan-AlterViewAsCommand.md#alterPermanentView[permanent views]) logical commands are executed.

=== [[alterTableStats]] Altering Table Statistics in Metastore (and Invalidating Internal Cache) -- `alterTableStats` Method

[source, scala]
----
alterTableStats(identifier: TableIdentifier, newStats: Option[CatalogStatistics]): Unit
----

`alterTableStats` requests <<externalCatalog, ExternalCatalog>> to [alter the statistics of the table](ExternalCatalog.md#alterTableStats) (per `identifier`) followed by <<refreshTable, invalidating the table relation cache>>.

`alterTableStats` reports a `NoSuchDatabaseException` if the <<databaseExists, database does not exist>>.

`alterTableStats` reports a `NoSuchTableException` if the <<tableExists, table does not exist>>.

[NOTE]
====
`alterTableStats` is used when the following logical commands are executed:

* spark-sql-LogicalPlan-AnalyzeTableCommand.md#run[AnalyzeTableCommand], spark-sql-LogicalPlan-AnalyzeColumnCommand.md#run[AnalyzeColumnCommand], `AlterTableAddPartitionCommand`, `TruncateTableCommand`

* (*indirectly* through `CommandUtils` when requested for spark-sql-CommandUtils.md#updateTableStats[updating existing table statistics]) hive/InsertIntoHiveTable.md[InsertIntoHiveTable], spark-sql-LogicalPlan-InsertIntoHadoopFsRelationCommand.md#run[InsertIntoHadoopFsRelationCommand], `AlterTableDropPartitionCommand`, `AlterTableSetLocationCommand` and `LoadDataCommand`
====

=== [[tableExists]] `tableExists` Method

[source, scala]
----
tableExists(
  name: TableIdentifier): Boolean
----

`tableExists` requests the <<externalCatalog, ExternalCatalog>> to [check out whether the table exists or not](ExternalCatalog.md#tableExists).

`tableExists` assumes <<currentDb, default>> database unless defined in the input `TableIdentifier`.

NOTE: `tableExists` is used when...FIXME

=== [[functionExists]] `functionExists` Method

[source, scala]
----
functionExists(name: FunctionIdentifier): Boolean
----

`functionExists`...FIXME

`functionExists` is used in:

* [LookupFunctions](logical-analysis-rules/LookupFunctions.md) logical rule (to make sure that spark-sql-Expression-UnresolvedFunction.md[UnresolvedFunction] can be resolved, i.e. is registered with `SessionCatalog`)

* `CatalogImpl` to [check if a function exists in a database](CatalogImpl.md#functionExists)

* ...

=== [[listFunctions]] `listFunctions` Method

[source, scala]
----
listFunctions(
  db: String): Seq[(FunctionIdentifier, String)]
listFunctions(
  db: String,
  pattern: String): Seq[(FunctionIdentifier, String)]
----

`listFunctions`...FIXME

NOTE: `listFunctions` is used when...FIXME

=== [[refreshTable]] Invalidating Table Relation Cache (aka Refreshing Table) -- `refreshTable` Method

[source, scala]
----
refreshTable(name: TableIdentifier): Unit
----

`refreshTable`...FIXME

NOTE: `refreshTable` is used when...FIXME

=== [[loadFunctionResources]] `loadFunctionResources` Method

[source, scala]
----
loadFunctionResources(resources: Seq[FunctionResource]): Unit
----

`loadFunctionResources`...FIXME

NOTE: `loadFunctionResources` is used when...FIXME

=== [[alterTempViewDefinition]] Altering (Updating) Temporary View (Logical Plan) -- `alterTempViewDefinition` Method

[source, scala]
----
alterTempViewDefinition(name: TableIdentifier, viewDefinition: LogicalPlan): Boolean
----

`alterTempViewDefinition` alters the temporary view by <<createTempView, updating an in-memory temporary table>> (when a database is not specified and the table has already been registered) or a global temporary table (when a database is specified and it is for global temporary tables).

NOTE: "Temporary table" and "temporary view" are synonyms.

`alterTempViewDefinition` returns `true` when an update could be executed and finished successfully.

NOTE: `alterTempViewDefinition` is used exclusively when `AlterViewAsCommand` logical command is <<spark-sql-LogicalPlan-AlterViewAsCommand.md#run, executed>>.

=== [[createTempView]] Creating (Registering) Or Replacing Local Temporary View -- `createTempView` Method

[source, scala]
----
createTempView(
  name: String,
  tableDefinition: LogicalPlan,
  overrideIfExists: Boolean): Unit
----

`createTempView`...FIXME

NOTE: `createTempView` is used when...FIXME

=== [[createGlobalTempView]] Creating (Registering) Or Replacing Global Temporary View -- `createGlobalTempView` Method

[source, scala]
----
createGlobalTempView(
  name: String,
  viewDefinition: LogicalPlan,
  overrideIfExists: Boolean): Unit
----

`createGlobalTempView` simply requests the <<globalTempViewManager, GlobalTempViewManager>> to spark-sql-GlobalTempViewManager.md#create[register a global temporary view].

[NOTE]
====
`createGlobalTempView` is used when:

* spark-sql-LogicalPlan-CreateViewCommand.md[CreateViewCommand] logical command is executed (for a global temporary view, i.e. when the spark-sql-LogicalPlan-CreateViewCommand.md#viewType[view type] is spark-sql-LogicalPlan-CreateViewCommand.md#GlobalTempView[GlobalTempView])

* spark-sql-LogicalPlan-CreateTempViewUsing.md[CreateTempViewUsing] logical command is executed (for a global temporary view, i.e. when the spark-sql-LogicalPlan-CreateTempViewUsing.md#global[global] flag is enabled)
====

## Creating Table

```
createTable(
  tableDefinition: CatalogTable,
  ignoreIfExists: Boolean): Unit
```

`createTable`...FIXME

NOTE: `createTable` is used when...FIXME

## Finding Function by Name (Using FunctionRegistry)

```scala
lookupFunction(
  name: FunctionIdentifier,
  children: Seq[Expression]): Expression
```

`lookupFunction` finds a function by `name`.

For a function with no database defined that exists in <<functionRegistry, FunctionRegistry>>, `lookupFunction` requests `FunctionRegistry` to spark-sql-FunctionRegistry.md#lookupFunction[find the function] (by its unqualified name, i.e. with no database).

If the `name` function has the database defined or does not exist in `FunctionRegistry`, `lookupFunction` uses the fully-qualified function `name` to check if the function exists in <<functionRegistry, FunctionRegistry>> (by its fully-qualified name, i.e. with a database).

For other cases, `lookupFunction` requests <<externalCatalog, ExternalCatalog>> to find the function and <<loadFunctionResources, loads its resources>>. It then <<createTempFunction, creates a corresponding temporary function>> and spark-sql-FunctionRegistry.md#lookupFunction[looks up the function] again.

`lookupFunction` is used when:

* [ResolveFunctions](logical-analysis-rules/ResolveFunctions.md) logical resolution rule executed (and resolves <<spark-sql-Expression-UnresolvedGenerator.md#, UnresolvedGenerator>> or <<spark-sql-Expression-UnresolvedFunction.md#, UnresolvedFunction>> expressions)

* `HiveSessionCatalog` is requested to hive/HiveSessionCatalog.md#lookupFunction0[lookupFunction0]

=== [[lookupRelation]] Finding Relation (Table or View) in Catalogs -- `lookupRelation` Method

[source, scala]
----
lookupRelation(name: TableIdentifier): LogicalPlan
----

`lookupRelation` finds the `name` table in the catalogs (i.e. <<globalTempViewManager, GlobalTempViewManager>>, <<externalCatalog, ExternalCatalog>> or <<tempViews, registry of temporary views>>) and gives a `SubqueryAlias` per table type.

[source, scala]
----
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
----

Internally, `lookupRelation` looks up the `name` table using:

. <<globalTempViewManager, GlobalTempViewManager>> when the database name of the table matches the spark-sql-GlobalTempViewManager.md#database[name] of `GlobalTempViewManager`

a. Gives `SubqueryAlias` or reports a `NoSuchTableException`

. <<externalCatalog, ExternalCatalog>> when the database name of the table is specified explicitly or the <<tempViews, registry of temporary views>> does not contain the table

a. Gives `SubqueryAlias` with `View` when the table is a view (aka _temporary table_)

b. Gives `SubqueryAlias` with `UnresolvedCatalogRelation` otherwise

. The <<tempViews, registry of temporary views>>

a. Gives `SubqueryAlias` with the logical plan per the table as registered in the <<tempViews, registry of temporary views>>

NOTE: `lookupRelation` considers *default* to be the name of the database if the `name` table does not specify the database explicitly.

`lookupRelation` is used when:

* `DescribeTableCommand` logical command is <<spark-sql-LogicalPlan-DescribeTableCommand.md#run, executed>>

* `ResolveRelations` logical evaluation rule is requested to [lookupTableFromCatalog](logical-analysis-rules/ResolveRelations.md#lookupTableFromCatalog)

=== [[getTableMetadata]] Retrieving Table Metadata from External Catalog (Metastore) -- `getTableMetadata` Method

[source, scala]
----
getTableMetadata(name: TableIdentifier): CatalogTable
----

`getTableMetadata` simply requests <<externalCatalog, external catalog>> (metastore) for the [table metadata](ExternalCatalog.md#getTable).

Before requesting the external metastore, `getTableMetadata` makes sure that the <<requireDbExists, database>> and <<requireTableExists, table>> (of the input `TableIdentifier`) both exist. If either does not exist, `getTableMetadata` reports a `NoSuchDatabaseException` or `NoSuchTableException`, respectively.

=== [[getTempViewOrPermanentTableMetadata]] Retrieving Table Metadata -- `getTempViewOrPermanentTableMetadata` Method

[source, scala]
----
getTempViewOrPermanentTableMetadata(name: TableIdentifier): CatalogTable
----

Internally, `getTempViewOrPermanentTableMetadata` branches off per database.

When a database name is not specified, `getTempViewOrPermanentTableMetadata` <<getTempView, finds a local temporary view>> and creates a spark-sql-CatalogTable.md#creating-instance[CatalogTable] (with `VIEW` spark-sql-CatalogTable.md#tableType[table type] and an undefined spark-sql-CatalogTable.md#storage[storage]) or <<getTableMetadata, retrieves the table metadata from an external catalog>>.

With the database name of the spark-sql-GlobalTempViewManager.md[GlobalTempViewManager], `getTempViewOrPermanentTableMetadata` requests <<globalTempViewManager, GlobalTempViewManager>> for the spark-sql-GlobalTempViewManager.md#get[global view definition] and creates a spark-sql-CatalogTable.md#creating-instance[CatalogTable] (with the spark-sql-GlobalTempViewManager.md#database[name] of `GlobalTempViewManager` in spark-sql-CatalogTable.md#identifier[table identifier], `VIEW` spark-sql-CatalogTable.md#tableType[table type] and an undefined spark-sql-CatalogTable.md#storage[storage]) or reports a `NoSuchTableException`.

With the database name not of `GlobalTempViewManager`, `getTempViewOrPermanentTableMetadata` simply <<getTableMetadata, retrieves the table metadata from an external catalog>>.

[NOTE]
====
`getTempViewOrPermanentTableMetadata` is used when:

* `CatalogImpl` is requested for [converting TableIdentifier to Table](CatalogImpl.md#makeTable), [listing the columns of a table (as Dataset)](CatalogImpl.md#listColumns) and [refreshing a table](CatalogImpl.md#refreshTable) (i.e. the analyzed logical plan of the table query and re-caching it)

* `AlterTableAddColumnsCommand`, `CreateTableLikeCommand`, spark-sql-LogicalPlan-DescribeColumnCommand.md#run[DescribeColumnCommand], `ShowColumnsCommand` and <<spark-sql-LogicalPlan-ShowTablesCommand.md#run, ShowTablesCommand>> logical commands are requested to run (executed)
====

=== [[requireDbExists]] Reporting NoSuchDatabaseException When Specified Database Does Not Exist -- `requireDbExists` Internal Method

[source, scala]
----
requireDbExists(db: String): Unit
----

`requireDbExists` reports a `NoSuchDatabaseException` if the <<databaseExists, specified database does not exist>>. Otherwise, `requireDbExists` does nothing.

=== [[reset]] `reset` Method

[source, scala]
----
reset(): Unit
----

`reset`...FIXME

NOTE: `reset` is used exclusively in the Spark SQL internal tests.

=== [[dropGlobalTempView]] Dropping Global Temporary View -- `dropGlobalTempView` Method

[source, scala]
----
dropGlobalTempView(name: String): Boolean
----

`dropGlobalTempView` simply requests the <<globalTempViewManager, GlobalTempViewManager>> to <<spark-sql-GlobalTempViewManager.md#remove, remove>> the `name` global temporary view.

NOTE: `dropGlobalTempView` is used when...FIXME

=== [[dropTable]] Dropping Table -- `dropTable` Method

[source, scala]
----
dropTable(
  name: TableIdentifier,
  ignoreIfNotExists: Boolean,
  purge: Boolean): Unit
----

`dropTable`...FIXME

[NOTE]
====
`dropTable` is used when:

* `CreateViewCommand` logical command is <<spark-sql-LogicalPlan-CreateViewCommand.md#run, executed>>

* `DropTableCommand` logical command is <<spark-sql-LogicalPlan-DropTableCommand.md#run, executed>>

* `DataFrameWriter` is requested to <<spark-sql-DataFrameWriter.md#saveAsTable, save a DataFrame to a table>> (with `Overwrite` save mode)

* hive/CreateHiveTableAsSelectCommand.md[CreateHiveTableAsSelectCommand] logical command is executed

* `SessionCatalog` is requested to <<reset, reset>>
====

=== [[getGlobalTempView]] Looking Up Global Temporary View by Name -- `getGlobalTempView` Method

[source, scala]
----
getGlobalTempView(
  name: String): Option[LogicalPlan]
----

`getGlobalTempView` requests the <<globalTempViewManager, GlobalTempViewManager>> for the spark-sql-GlobalTempViewManager.md#get[temporary view definition by the input name].

`getGlobalTempView` is used when `CatalogImpl` is requested to [dropGlobalTempView](CatalogImpl.md#dropGlobalTempView).

=== [[registerFunction]] `registerFunction` Method

[source, scala]
----
registerFunction(
  funcDefinition: CatalogFunction,
  overrideIfExists: Boolean,
  functionBuilder: Option[FunctionBuilder] = None): Unit
----

`registerFunction`...FIXME

[NOTE]
====
`registerFunction` is used when:

* `SessionCatalog` is requested to <<lookupFunction, lookupFunction>>

* `HiveSessionCatalog` is requested to hive/HiveSessionCatalog.md#lookupFunction0[lookupFunction0]

* `CreateFunctionCommand` logical command is executed
====

=== [[lookupFunctionInfo]] `lookupFunctionInfo` Method

[source, scala]
----
lookupFunctionInfo(name: FunctionIdentifier): ExpressionInfo
----

`lookupFunctionInfo`...FIXME

NOTE: `lookupFunctionInfo` is used when...FIXME

=== [[alterTableDataSchema]] `alterTableDataSchema` Method

[source, scala]
----
alterTableDataSchema(
  identifier: TableIdentifier,
  newDataSchema: StructType): Unit
----

`alterTableDataSchema`...FIXME

NOTE: `alterTableDataSchema` is used when...FIXME

=== [[getCachedTable]] `getCachedTable` Method

[source, scala]
----
getCachedTable(
  key: QualifiedTableName): LogicalPlan
----

`getCachedTable`...FIXME

NOTE: `getCachedTable` is used when...FIXME

## Internal Properties

### currentDb

currentDb is...FIXME

### tableRelationCache

tableRelationCache is a cache of fully-qualified table names to spark-sql-LogicalPlan.md[table relation plans] (i.e. `LogicalPlan`).

Used when `SessionCatalog` <<refreshTable, refreshes a table>>

### tempViews

tempViews is a registry of temporary views (i.e. non-global temporary tables)

Used when `SessionCatalog` <<refreshTable, refreshes a table>>
