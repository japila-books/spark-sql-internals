# CatalogImpl

`CatalogImpl` is the spark-sql-Catalog.md[Catalog] in Spark SQL that...FIXME

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

NOTE: `createTable` is part of spark-sql-Catalog.md#createTable[Catalog Contract] to...FIXME.

`createTable`...FIXME

=== [[getTable]] `getTable` Method

[source, scala]
----
getTable(tableName: String): Table
getTable(dbName: String, tableName: String): Table
----

NOTE: `getTable` is part of spark-sql-Catalog.md#getTable[Catalog Contract] to...FIXME.

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

NOTE: `getFunction` is part of spark-sql-Catalog.md#getFunction[Catalog Contract] to...FIXME.

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

NOTE: `functionExists` is part of spark-sql-Catalog.md#functionExists[Catalog Contract] to...FIXME.

`functionExists`...FIXME

=== [[cacheTable]] Caching Table or View In-Memory -- `cacheTable` Method

[source, scala]
----
cacheTable(tableName: String): Unit
----

Internally, `cacheTable` first SparkSession.md#table[creates a DataFrame for the table] followed by requesting `CacheManager` to spark-sql-CacheManager.md#cacheQuery[cache it].

NOTE: `cacheTable` uses the SparkSession.md#sharedState[session-scoped SharedState] to access the `CacheManager`.

NOTE: `cacheTable` is part of spark-sql-Catalog.md#contract[Catalog contract].

=== [[clearCache]] Removing All Cached Tables From In-Memory Cache -- `clearCache` Method

[source, scala]
----
clearCache(): Unit
----

`clearCache` requests `CacheManager` to spark-sql-CacheManager.md#clearCache[remove all cached tables from in-memory cache].

NOTE: `clearCache` is part of spark-sql-Catalog.md#contract[Catalog contract].

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

The `source` input parameter is the name of the data source provider for the table, e.g. parquet, json, text. If not specified, `createExternalTable` uses spark-sql-properties.md#spark.sql.sources.default[spark.sql.sources.default] setting to know the data source format.

NOTE: `source` input parameter must not be `hive` as it leads to a `AnalysisException`.

`createExternalTable` sets the mandatory `path` option when specified explicitly in the input parameter list.

`createExternalTable` parses `tableName` into `TableIdentifier` (using spark-sql-SparkSqlParser.md[SparkSqlParser]). It creates a spark-sql-CatalogTable.md[CatalogTable] and then SessionState.md#executePlan[executes] (by spark-sql-QueryExecution.md#toRdd[toRDD]) a spark-sql-LogicalPlan-CreateTable.md[CreateTable] logical plan. The result spark-sql-DataFrame.md[DataFrame] is a `Dataset[Row]` with the spark-sql-QueryExecution.md[QueryExecution] after executing spark-sql-LogicalPlan-SubqueryAlias.md[SubqueryAlias] logical plan and spark-sql-RowEncoder.md[RowEncoder].

.CatalogImpl.createExternalTable
image::images/spark-sql-CatalogImpl-createExternalTable.png[align="center"]

NOTE: `createExternalTable` is part of spark-sql-Catalog.md#contract[Catalog contract].

=== [[listTables]] Listing Tables in Database (as Dataset) -- `listTables` Method

[source, scala]
----
listTables(): Dataset[Table]
listTables(dbName: String): Dataset[Table]
----

NOTE: `listTables` is part of spark-sql-Catalog.md#listTables[Catalog Contract] to get a list of tables in the specified database.

Internally, `listTables` requests <<sessionCatalog, SessionCatalog>> to spark-sql-SessionCatalog.md#listTables[list all tables] in the specified `dbName` database and <<makeTable, converts them to Tables>>.

In the end, `listTables` <<makeDataset, creates a Dataset>> with the tables.

=== [[listColumns]] Listing Columns of Table (as Dataset) -- `listColumns` Method

[source, scala]
----
listColumns(tableName: String): Dataset[Column]
listColumns(dbName: String, tableName: String): Dataset[Column]
----

NOTE: `listColumns` is part of spark-sql-Catalog.md#listColumns[Catalog Contract] to...FIXME.

`listColumns` requests <<sessionCatalog, SessionCatalog>> for the spark-sql-SessionCatalog.md#getTempViewOrPermanentTableMetadata[table metadata].

`listColumns` takes the spark-sql-CatalogTable.md#schema[schema] from the table metadata and creates a `Column` for every field (with the optional comment as the description).

In the end, `listColumns` <<makeDataset, creates a Dataset>> with the columns.

=== [[makeTable]] Converting TableIdentifier to Table -- `makeTable` Internal Method

[source, scala]
----
makeTable(tableIdent: TableIdentifier): Table
----

`makeTable` creates a `Table` using the input `TableIdentifier` and the spark-sql-SessionCatalog.md#getTempViewOrPermanentTableMetadata[table metadata] (from the current spark-sql-SessionCatalog.md[SessionCatalog]) if available.

NOTE: `makeTable` uses <<sparkSession, SparkSession>> to access SessionState.md#sessionState[SessionState] that is then used to access SessionState.md#catalog[SessionCatalog].

NOTE: `makeTable` is used when `CatalogImpl` is requested to <<listTables, listTables>> or <<getTable, getTable>>.

=== [[makeDataset]] Creating Dataset from DefinedByConstructorParams Data -- `makeDataset` Method

[source, scala]
----
makeDataset[T <: DefinedByConstructorParams](
  data: Seq[T],
  sparkSession: SparkSession): Dataset[T]
----

`makeDataset` creates an spark-sql-ExpressionEncoder.md#apply[ExpressionEncoder] (from spark-sql-ExpressionEncoder.md#DefinedByConstructorParams[DefinedByConstructorParams]) and spark-sql-ExpressionEncoder.md#toRow[encodes] elements of the input `data` to <<spark-sql-InternalRow.md#, internal binary rows>>.

`makeDataset` then creates a spark-sql-LogicalPlan-LocalRelation.md#creating-instance[LocalRelation] logical operator. `makeDataset` requests `SessionState` to SessionState.md#executePlan[execute the plan] and spark-sql-Dataset.md#creating-instance[creates] the result `Dataset`.

NOTE: `makeDataset` is used when `CatalogImpl` is requested to <<listDatabases, list databases>>, <<listTables, tables>>, <<listFunctions, functions>> and <<listColumns, columns>>

=== [[refreshTable]] Refreshing Analyzed Logical Plan of Table Query and Re-Caching It -- `refreshTable` Method

[source, scala]
----
refreshTable(tableName: String): Unit
----

NOTE: `refreshTable` is part of spark-sql-Catalog.md#refreshTable[Catalog Contract] to...FIXME.

`refreshTable` requests `SessionState` for the SessionState.md#sqlParser[SQL parser] to spark-sql-ParserInterface.md#parseTableIdentifier[parse a TableIdentifier given the table name].

NOTE: `refreshTable` uses <<sparkSession, SparkSession>> to access the SparkSession.md#sessionState[SessionState].

`refreshTable` requests <<sessionCatalog, SessionCatalog>> for the spark-sql-SessionCatalog.md#getTempViewOrPermanentTableMetadata[table metadata].

`refreshTable` then SparkSession.md#table[creates a DataFrame for the table name].

For a temporary or persistent `VIEW` table, `refreshTable` requests the spark-sql-QueryExecution.md#analyzed[analyzed] logical plan of the DataFrame (for the table) to spark-sql-LogicalPlan.md#refresh[refresh] itself.

For other types of table, `refreshTable` requests <<sessionCatalog, SessionCatalog>> for spark-sql-SessionCatalog.md#refreshTable[refreshing the table metadata] (i.e. invalidating the table).

If the table <<isCached, has been cached>>, `refreshTable` requests `CacheManager` to spark-sql-CacheManager.md#uncacheQuery[uncache] and spark-sql-CacheManager.md#cacheQuery[cache] the table `DataFrame` again.

NOTE: `refreshTable` uses <<sparkSession, SparkSession>> to access the SparkSession.md#sharedState[SharedState] that is used to access SharedState.md#cacheManager[CacheManager].

=== [[refreshByPath]] `refreshByPath` Method

[source, scala]
----
refreshByPath(resourcePath: String): Unit
----

NOTE: `refreshByPath` is part of spark-sql-Catalog.md#refreshByPath[Catalog Contract] to...FIXME.

`refreshByPath`...FIXME

=== [[dropGlobalTempView]] `dropGlobalTempView` Method

[source, scala]
----
dropGlobalTempView(
  viewName: String): Boolean
----

NOTE: `dropGlobalTempView` is part of spark-sql-Catalog.md#dropGlobalTempView[Catalog] contract].

`dropGlobalTempView`...FIXME

=== [[listColumns-internal]] `listColumns` Internal Method

[source, scala]
----
listColumns(tableIdentifier: TableIdentifier): Dataset[Column]
----

`listColumns`...FIXME

NOTE: `listColumns` is used exclusively when `CatalogImpl` is requested to <<listColumns, listColumns>>.
