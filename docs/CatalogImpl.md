# CatalogImpl

`CatalogImpl` is the [Catalog](Catalog.md) in Spark SQL that...FIXME

.CatalogImpl uses SessionCatalog (through SparkSession)
image::images/spark-sql-CatalogImpl.png[align="center"]

NOTE: `CatalogImpl` is in `org.apache.spark.sql.internal` package.

=== [[createTable]] Creating Table -- `createTable` Method

[source, scala]
----
createTable(
  tableName: String,
  source: String,
  schema: StructType,
  options: Map[String, String]): DataFrame
----

`createTable`...FIXME

`createTable` is part of [Catalog Contract](Catalog.md#createTable) to...FIXME.

=== [[getTable]] `getTable` Method

[source, scala]
----
getTable(tableName: String): Table
getTable(dbName: String, tableName: String): Table
----

NOTE: `getTable` is part of [Catalog Contract](Catalog.md#getTable) to...FIXME.

`getTable`...FIXME

=== [[getFunction]] `getFunction` Method

[source, scala]
----
getFunction(
  functionName: String): Function
getFunction(
  dbName: String,
  functionName: String): Function
----

NOTE: `getFunction` is part of [Catalog Contract](Catalog.md#getFunction) to...FIXME.

`getFunction`...FIXME

=== [[functionExists]] `functionExists` Method

[source, scala]
----
functionExists(
  functionName: String): Boolean
functionExists(
  dbName: String,
  functionName: String): Boolean
----

NOTE: `functionExists` is part of [Catalog Contract](Catalog.md#functionExists) to...FIXME.

`functionExists`...FIXME

=== [[cacheTable]] Caching Table or View In-Memory -- `cacheTable` Method

[source, scala]
----
cacheTable(tableName: String): Unit
----

Internally, `cacheTable` first SparkSession.md#table[creates a DataFrame for the table] followed by requesting `CacheManager` to [cache it](CacheManager.md#cacheQuery).

NOTE: `cacheTable` uses the SparkSession.md#sharedState[session-scoped SharedState] to access the `CacheManager`.

NOTE: `cacheTable` is part of [Catalog contract](Catalog.md#cacheTable).

=== [[clearCache]] Removing All Cached Tables From In-Memory Cache -- `clearCache` Method

[source, scala]
----
clearCache(): Unit
----

`clearCache` requests `CacheManager` to [remove all cached tables from in-memory cache](CacheManager.md#clearCache).

NOTE: `clearCache` is part of [Catalog contract](Catalog.md#clearCache).

=== [[createExternalTable]] Creating External Table From Path -- `createExternalTable` Method

[source, scala]
----
createExternalTable(tableName: String, path: String): DataFrame
createExternalTable(tableName: String, path: String, source: String): DataFrame
createExternalTable(
  tableName: String,
  source: String,
  options: Map[String, String]): DataFrame
createExternalTable(
  tableName: String,
  source: String,
  schema: StructType,
  options: Map[String, String]): DataFrame
----

`createExternalTable` creates an external table `tableName` from the given `path` and returns the corresponding spark-sql-DataFrame.md[DataFrame].

[source, scala]
----
import org.apache.spark.sql.SparkSession
val spark: SparkSession = ...

val readmeTable = spark.catalog.createExternalTable("readme", "README.md", "text")
readmeTable: org.apache.spark.sql.DataFrame = [value: string]

scala> spark.catalog.listTables.filter(_.name == "readme").show
+------+--------+-----------+---------+-----------+
|  name|database|description|tableType|isTemporary|
+------+--------+-----------+---------+-----------+
|readme| default|       null| EXTERNAL|      false|
+------+--------+-----------+---------+-----------+

scala> sql("select count(*) as count from readme").show(false)
+-----+
|count|
+-----+
|99   |
+-----+
----

The `source` input parameter is the name of the data source provider for the table, e.g. parquet, json, text. If not specified, `createExternalTable` uses [spark.sql.sources.default](configuration-properties.md#spark.sql.sources.default) setting to know the data source format.

NOTE: `source` input parameter must not be `hive` as it leads to a `AnalysisException`.

`createExternalTable` sets the mandatory `path` option when specified explicitly in the input parameter list.

`createExternalTable` parses `tableName` into `TableIdentifier` (using spark-sql-SparkSqlParser.md[SparkSqlParser]). It creates a [CatalogTable](CatalogTable.md) and then SessionState.md#executePlan[executes] (by [toRDD](QueryExecution.md#toRdd)) a CreateTable.md[CreateTable] logical plan. The result spark-sql-DataFrame.md[DataFrame] is a `Dataset[Row]` with the [QueryExecution](QueryExecution.md) after executing SubqueryAlias.md[SubqueryAlias] logical plan and [RowEncoder](RowEncoder.md).

.CatalogImpl.createExternalTable
image::images/spark-sql-CatalogImpl-createExternalTable.png[align="center"]

NOTE: `createExternalTable` is part of [Catalog contract](Catalog.md#createExternalTable).

=== [[listTables]] Listing Tables in Database (as Dataset) -- `listTables` Method

[source, scala]
----
listTables(): Dataset[Table]
listTables(dbName: String): Dataset[Table]
----

NOTE: `listTables` is part of [Catalog Contract](Catalog.md#listTables).

Internally, `listTables` requests <<sessionCatalog, SessionCatalog>> to [list all tables](SessionCatalog.md#listTables) in the specified `dbName` database and <<makeTable, converts them to Tables>>.

In the end, `listTables` <<makeDataset, creates a Dataset>> with the tables.

=== [[listColumns]] Listing Columns of Table (as Dataset) -- `listColumns` Method

[source, scala]
----
listColumns(tableName: String): Dataset[Column]
listColumns(dbName: String, tableName: String): Dataset[Column]
----

NOTE: `listColumns` is part of [Catalog Contract](Catalog.md#listColumns).

`listColumns` requests <<sessionCatalog, SessionCatalog>> for the [table metadata](SessionCatalog.md#getTempViewOrPermanentTableMetadata).

`listColumns` takes the [schema](CatalogTable.md#schema) from the table metadata and creates a `Column` for every field (with the optional comment as the description).

In the end, `listColumns` <<makeDataset, creates a Dataset>> with the columns.

=== [[makeTable]] Converting TableIdentifier to Table -- `makeTable` Internal Method

[source, scala]
----
makeTable(tableIdent: TableIdentifier): Table
----

`makeTable` creates a `Table` using the input `TableIdentifier` and the [table metadata](SessionCatalog.md#getTempViewOrPermanentTableMetadata) (from the current [SessionCatalog](SessionCatalog.md)) if available.

NOTE: `makeTable` uses <<sparkSession, SparkSession>> to access SessionState.md#sessionState[SessionState] that is then used to access SessionState.md#catalog[SessionCatalog].

NOTE: `makeTable` is used when `CatalogImpl` is requested to <<listTables, listTables>> or <<getTable, getTable>>.

=== [[makeDataset]] Creating Dataset from DefinedByConstructorParams Data -- `makeDataset` Method

[source, scala]
----
makeDataset[T <: DefinedByConstructorParams](
  data: Seq[T],
  sparkSession: SparkSession): Dataset[T]
----

`makeDataset` creates an spark-sql-ExpressionEncoder.md#apply[ExpressionEncoder] (from spark-sql-ExpressionEncoder.md#DefinedByConstructorParams[DefinedByConstructorParams]) and spark-sql-ExpressionEncoder.md#toRow[encodes] elements of the input `data` to [internal binary rows](InternalRow.md).

`makeDataset` then creates a LocalRelation.md#creating-instance[LocalRelation] logical operator. `makeDataset` requests `SessionState` to SessionState.md#executePlan[execute the plan] and Dataset.md#creating-instance[creates] the result `Dataset`.

NOTE: `makeDataset` is used when `CatalogImpl` is requested to <<listDatabases, list databases>>, <<listTables, tables>>, <<listFunctions, functions>> and <<listColumns, columns>>

=== [[refreshTable]] Refreshing Analyzed Logical Plan of Table Query and Re-Caching It -- `refreshTable` Method

[source, scala]
----
refreshTable(tableName: String): Unit
----

`refreshTable` requests `SessionState` for the SessionState.md#sqlParser[SQL parser] to spark-sql-ParserInterface.md#parseTableIdentifier[parse a TableIdentifier given the table name].

NOTE: `refreshTable` uses <<sparkSession, SparkSession>> to access the SparkSession.md#sessionState[SessionState].

`refreshTable` requests <<sessionCatalog, SessionCatalog>> for the [table metadata](SessionCatalog.md#getTempViewOrPermanentTableMetadata).

`refreshTable` then SparkSession.md#table[creates a DataFrame for the table name].

For a temporary or persistent `VIEW` table, `refreshTable` requests the [analyzed](QueryExecution.md#analyzed) logical plan of the DataFrame (for the table) to spark-sql-LogicalPlan.md#refresh[refresh] itself.

For other types of table, `refreshTable` requests <<sessionCatalog, SessionCatalog>> for [refreshing the table metadata](SessionCatalog.md#getTempViewOrPermanentTableMetadata) (i.e. invalidating the table).

If the table <<isCached, has been cached>>, `refreshTable` requests `CacheManager` to [uncache](CacheManager.md#uncacheQuery) and [cache](CacheManager.md#cacheQuery) the table `DataFrame` again.

NOTE: `refreshTable` uses <<sparkSession, SparkSession>> to access the SparkSession.md#sharedState[SharedState] that is used to access [CacheManager](SharedState.md#cacheManager).

`refreshTable` is part of the [Catalog](Catalog.md#refreshTable) abstraction.

=== [[refreshByPath]] `refreshByPath` Method

[source, scala]
----
refreshByPath(resourcePath: String): Unit
----

`refreshByPath`...FIXME

`refreshByPath` is part of the [Catalog](Catalog.md#refreshByPath) abstraction.

=== [[dropGlobalTempView]] `dropGlobalTempView` Method

[source, scala]
----
dropGlobalTempView(
  viewName: String): Boolean
----

`dropGlobalTempView`...FIXME

`dropGlobalTempView` is part of the [Catalog](Catalog.md#dropGlobalTempView) abstraction.

=== [[listColumns-internal]] `listColumns` Internal Method

[source, scala]
----
listColumns(tableIdentifier: TableIdentifier): Dataset[Column]
----

`listColumns`...FIXME

NOTE: `listColumns` is used exclusively when `CatalogImpl` is requested to <<listColumns, listColumns>>.
