# SessionCatalog &mdash; Session-Scoped Registry of Relational Entities

`SessionCatalog` is a catalog of relational entities in [SparkSession](spark-sql-SparkSession.md#catalog) (e.g. databases, tables, views, partitions, and functions).

`SessionCatalog` is used to create [Analyzer](spark-sql-Analyzer.adoc#catalog) and [SparkOptimizer](spark-sql-SparkOptimizer.adoc#catalog) (_among other things_).

## Creating Instance

SessionCatalog takes the following to be created:

* <span id="externalCatalogBuilder" /> Function to create an [ExternalCatalog](spark-sql-ExternalCatalog.md)
* <span id="globalTempViewManagerBuilder" /> Function to create a [GlobalTempViewManager](spark-sql-GlobalTempViewManager.md)
* <span id="functionRegistry" /> [FunctionRegistry](spark-sql-FunctionRegistry.md)
* <span id="conf" /> [SQLConf](spark-sql-SQLConf.md)
* <span id="hadoopConf" /> Hadoop Configuration
* <span id="parser" /> [ParserInterface](sql/ParserInterface.md)
* <span id="functionResourceLoader" /> `FunctionResourceLoader`

![SessionCatalog and Spark SQL Services](images/spark-sql-SessionCatalog.png)

`SessionCatalog` is created (and cached for later usage) when `BaseSessionStateBuilder` is requested for [one](spark-sql-BaseSessionStateBuilder.md#catalog).

## Accessing SessionCatalog

`SessionCatalog` is available through [SessionState](spark-sql-SessionState.md#catalog) (of a [SparkSession](spark-sql-SparkSession.md#sessionState)).

```
scala> :type spark
org.apache.spark.sql.SparkSession

scala> :type spark.sessionState.catalog
org.apache.spark.sql.catalyst.catalog.SessionCatalog
```

## ExternalCatalog

`SessionCatalog` uses an [ExternalCatalog](spark-sql-ExternalCatalog.md) for the metadata of permanent entities (i.e. [tables](#getTableMetadata)).

`SessionCatalog` is in fact a layer over ExternalCatalog in a [SparkSession](spark-sql-SparkSession.adoc#sessionState) which allows for different metastores (i.e. `in-memory` or [hive](hive/HiveSessionCatalog.md)) to be used.

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

* `ShowTablesCommand` logical command is requested to <<spark-sql-LogicalPlan-ShowTablesCommand.adoc#run, run>>

* `SessionCatalog` is requested to <<reset, reset>> (for testing)

* `CatalogImpl` is requested to <<spark-sql-CatalogImpl.adoc#listTables, listTables>> (for testing)
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

NOTE: `alterTable` is used when `AlterTableSetPropertiesCommand`, `AlterTableUnsetPropertiesCommand`, `AlterTableChangeColumnCommand`, `AlterTableSerDePropertiesCommand`, `AlterTableRecoverPartitionsCommand`, `AlterTableSetLocationCommand`, link:spark-sql-LogicalPlan-AlterViewAsCommand.adoc#run[AlterViewAsCommand] (for link:spark-sql-LogicalPlan-AlterViewAsCommand.adoc#alterPermanentView[permanent views]) logical commands are executed.

=== [[alterTableStats]] Altering Table Statistics in Metastore (and Invalidating Internal Cache) -- `alterTableStats` Method

[source, scala]
----
alterTableStats(identifier: TableIdentifier, newStats: Option[CatalogStatistics]): Unit
----

`alterTableStats` requests <<externalCatalog, ExternalCatalog>> to link:spark-sql-ExternalCatalog.adoc#alterTableStats[alter the statistics of the table] (per `identifier`) followed by <<refreshTable, invalidating the table relation cache>>.

`alterTableStats` reports a `NoSuchDatabaseException` if the <<databaseExists, database does not exist>>.

`alterTableStats` reports a `NoSuchTableException` if the <<tableExists, table does not exist>>.

[NOTE]
====
`alterTableStats` is used when the following logical commands are executed:

* link:spark-sql-LogicalPlan-AnalyzeTableCommand.adoc#run[AnalyzeTableCommand], link:spark-sql-LogicalPlan-AnalyzeColumnCommand.adoc#run[AnalyzeColumnCommand], `AlterTableAddPartitionCommand`, `TruncateTableCommand`

* (*indirectly* through `CommandUtils` when requested for link:spark-sql-CommandUtils.adoc#updateTableStats[updating existing table statistics]) link:hive/InsertIntoHiveTable.adoc[InsertIntoHiveTable], link:spark-sql-LogicalPlan-InsertIntoHadoopFsRelationCommand.adoc#run[InsertIntoHadoopFsRelationCommand], `AlterTableDropPartitionCommand`, `AlterTableSetLocationCommand` and `LoadDataCommand`
====

=== [[tableExists]] `tableExists` Method

[source, scala]
----
tableExists(
  name: TableIdentifier): Boolean
----

`tableExists` requests the <<externalCatalog, ExternalCatalog>> to link:../spark-sql-ExternalCatalog.adoc#tableExists[check out whether the table exists or not].

`tableExists` assumes <<currentDb, default>> database unless defined in the input `TableIdentifier`.

NOTE: `tableExists` is used when...FIXME

=== [[functionExists]] `functionExists` Method

[source, scala]
----
functionExists(name: FunctionIdentifier): Boolean
----

`functionExists`...FIXME

[NOTE]
====
`functionExists` is used in:

* link:spark-sql-Analyzer-LookupFunctions.adoc[LookupFunctions] logical rule (to make sure that link:spark-sql-Expression-UnresolvedFunction.adoc[UnresolvedFunction] can be resolved, i.e. is registered with `SessionCatalog`)

* `CatalogImpl` to link:spark-sql-CatalogImpl.adoc#functionExists[check if a function exists in a database]

* ...
====

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

NOTE: `alterTempViewDefinition` is used exclusively when `AlterViewAsCommand` logical command is <<spark-sql-LogicalPlan-AlterViewAsCommand.adoc#run, executed>>.

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

`createGlobalTempView` simply requests the <<globalTempViewManager, GlobalTempViewManager>> to link:spark-sql-GlobalTempViewManager.adoc#create[register a global temporary view].

[NOTE]
====
`createGlobalTempView` is used when:

* link:spark-sql-LogicalPlan-CreateViewCommand.adoc[CreateViewCommand] logical command is executed (for a global temporary view, i.e. when the link:spark-sql-LogicalPlan-CreateViewCommand.adoc#viewType[view type] is link:spark-sql-LogicalPlan-CreateViewCommand.adoc#GlobalTempView[GlobalTempView])

* link:spark-sql-LogicalPlan-CreateTempViewUsing.adoc[CreateTempViewUsing] logical command is executed (for a global temporary view, i.e. when the link:spark-sql-LogicalPlan-CreateTempViewUsing.adoc#global[global] flag is enabled)
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

For a function with no database defined that exists in <<functionRegistry, FunctionRegistry>>, `lookupFunction` requests `FunctionRegistry` to link:spark-sql-FunctionRegistry.adoc#lookupFunction[find the function] (by its unqualified name, i.e. with no database).

If the `name` function has the database defined or does not exist in `FunctionRegistry`, `lookupFunction` uses the fully-qualified function `name` to check if the function exists in <<functionRegistry, FunctionRegistry>> (by its fully-qualified name, i.e. with a database).

For other cases, `lookupFunction` requests <<externalCatalog, ExternalCatalog>> to find the function and <<loadFunctionResources, loads its resources>>. It then <<createTempFunction, creates a corresponding temporary function>> and link:spark-sql-FunctionRegistry.adoc#lookupFunction[looks up the function] again.

[NOTE]
====
`lookupFunction` is used when:

* `ResolveFunctions` logical resolution rule is <<spark-sql-Analyzer-ResolveFunctions.adoc#apply, executed>> (and resolves <<spark-sql-Expression-UnresolvedGenerator.adoc#, UnresolvedGenerator>> or <<spark-sql-Expression-UnresolvedFunction.adoc#, UnresolvedFunction>> expressions)

* `HiveSessionCatalog` is requested to link:hive/HiveSessionCatalog.adoc#lookupFunction0[lookupFunction0]
====

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

. <<globalTempViewManager, GlobalTempViewManager>> when the database name of the table matches the link:spark-sql-GlobalTempViewManager.adoc#database[name] of `GlobalTempViewManager`

a. Gives `SubqueryAlias` or reports a `NoSuchTableException`

. <<externalCatalog, ExternalCatalog>> when the database name of the table is specified explicitly or the <<tempViews, registry of temporary views>> does not contain the table

a. Gives `SubqueryAlias` with `View` when the table is a view (aka _temporary table_)

b. Gives `SubqueryAlias` with `UnresolvedCatalogRelation` otherwise

. The <<tempViews, registry of temporary views>>

a. Gives `SubqueryAlias` with the logical plan per the table as registered in the <<tempViews, registry of temporary views>>

NOTE: `lookupRelation` considers *default* to be the name of the database if the `name` table does not specify the database explicitly.

[NOTE]
====
`lookupRelation` is used when:

* `DescribeTableCommand` logical command is <<spark-sql-LogicalPlan-DescribeTableCommand.adoc#run, executed>>

* `ResolveRelations` logical evaluation rule is requested to <<spark-sql-Analyzer-ResolveRelations.adoc#lookupTableFromCatalog, lookupTableFromCatalog>>
====

=== [[getTableMetadata]] Retrieving Table Metadata from External Catalog (Metastore) -- `getTableMetadata` Method

[source, scala]
----
getTableMetadata(name: TableIdentifier): CatalogTable
----

`getTableMetadata` simply requests <<externalCatalog, external catalog>> (metastore) for the link:spark-sql-ExternalCatalog.adoc#getTable[table metadata].

Before requesting the external metastore, `getTableMetadata` makes sure that the <<requireDbExists, database>> and <<requireTableExists, table>> (of the input `TableIdentifier`) both exist. If either does not exist, `getTableMetadata` reports a `NoSuchDatabaseException` or `NoSuchTableException`, respectively.

=== [[getTempViewOrPermanentTableMetadata]] Retrieving Table Metadata -- `getTempViewOrPermanentTableMetadata` Method

[source, scala]
----
getTempViewOrPermanentTableMetadata(name: TableIdentifier): CatalogTable
----

Internally, `getTempViewOrPermanentTableMetadata` branches off per database.

When a database name is not specified, `getTempViewOrPermanentTableMetadata` <<getTempView, finds a local temporary view>> and creates a link:spark-sql-CatalogTable.adoc#creating-instance[CatalogTable] (with `VIEW` link:spark-sql-CatalogTable.adoc#tableType[table type] and an undefined link:spark-sql-CatalogTable.adoc#storage[storage]) or <<getTableMetadata, retrieves the table metadata from an external catalog>>.

With the database name of the link:spark-sql-GlobalTempViewManager.adoc[GlobalTempViewManager], `getTempViewOrPermanentTableMetadata` requests <<globalTempViewManager, GlobalTempViewManager>> for the link:spark-sql-GlobalTempViewManager.adoc#get[global view definition] and creates a link:spark-sql-CatalogTable.adoc#creating-instance[CatalogTable] (with the link:spark-sql-GlobalTempViewManager.adoc#database[name] of `GlobalTempViewManager` in link:spark-sql-CatalogTable.adoc#identifier[table identifier], `VIEW` link:spark-sql-CatalogTable.adoc#tableType[table type] and an undefined link:spark-sql-CatalogTable.adoc#storage[storage]) or reports a `NoSuchTableException`.

With the database name not of `GlobalTempViewManager`, `getTempViewOrPermanentTableMetadata` simply <<getTableMetadata, retrieves the table metadata from an external catalog>>.

[NOTE]
====
`getTempViewOrPermanentTableMetadata` is used when:

* `CatalogImpl` is requested for link:spark-sql-CatalogImpl.adoc#makeTable[converting TableIdentifier to Table], link:spark-sql-CatalogImpl.adoc#listColumns[listing the columns of a table (as Dataset)] and link:spark-sql-CatalogImpl.adoc#refreshTable[refreshing a table] (i.e. the analyzed logical plan of the table query and re-caching it)

* `AlterTableAddColumnsCommand`, `CreateTableLikeCommand`, link:spark-sql-LogicalPlan-DescribeColumnCommand.adoc#run[DescribeColumnCommand], `ShowColumnsCommand` and <<spark-sql-LogicalPlan-ShowTablesCommand.adoc#run, ShowTablesCommand>> logical commands are requested to run (executed)
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

`dropGlobalTempView` simply requests the <<globalTempViewManager, GlobalTempViewManager>> to <<spark-sql-GlobalTempViewManager.adoc#remove, remove>> the `name` global temporary view.

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

* `CreateViewCommand` logical command is <<spark-sql-LogicalPlan-CreateViewCommand.adoc#run, executed>>

* `DropTableCommand` logical command is <<spark-sql-LogicalPlan-DropTableCommand.adoc#run, executed>>

* `DataFrameWriter` is requested to <<spark-sql-DataFrameWriter.adoc#saveAsTable, save a DataFrame to a table>> (with `Overwrite` save mode)

* link:hive/CreateHiveTableAsSelectCommand.adoc[CreateHiveTableAsSelectCommand] logical command is executed

* `SessionCatalog` is requested to <<reset, reset>>
====

=== [[getGlobalTempView]] Looking Up Global Temporary View by Name -- `getGlobalTempView` Method

[source, scala]
----
getGlobalTempView(
  name: String): Option[LogicalPlan]
----

`getGlobalTempView` requests the <<globalTempViewManager, GlobalTempViewManager>> for the link:spark-sql-GlobalTempViewManager.adoc#get[temporary view definition by the input name].

NOTE: `getGlobalTempView` is used when `CatalogImpl` is requested to link:spark-sql-CatalogImpl.adoc#dropGlobalTempView[dropGlobalTempView].

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

* `HiveSessionCatalog` is requested to link:hive/HiveSessionCatalog.adoc#lookupFunction0[lookupFunction0]

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

tableRelationCache is a cache of fully-qualified table names to link:spark-sql-LogicalPlan.adoc[table relation plans] (i.e. `LogicalPlan`).

Used when `SessionCatalog` <<refreshTable, refreshes a table>>

### tempViews

tempViews is a registry of temporary views (i.e. non-global temporary tables)

Used when `SessionCatalog` <<refreshTable, refreshes a table>>
