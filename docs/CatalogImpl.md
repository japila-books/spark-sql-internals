# CatalogImpl

`CatalogImpl` is a [Catalog](Catalog.md).

![CatalogImpl uses SessionCatalog (through SparkSession)](images/spark-sql-CatalogImpl.png)

## Creating Instance

`CatalogImpl` takes the following to be created:

* <span id="sparkSession"> [SparkSession](SparkSession.md)

`CatalogImpl` is created when:

* `SparkSession` is requested for the [Catalog](SparkSession.md#catalog)

## <span id="getTable"> getTable

??? note "Signature"

    ```scala
    getTable(
      tableName: String): Table
    getTable(
      dbName: String,
      tableName: String): Table
    ```

    `getTable` is part of the [Catalog](Catalog.md#getTable) abstraction.

---

`getTable`...FIXME

## <span id="makeTable"> Looking Up Table

```scala
makeTable(
  catalog: TableCatalog,
  ident: Identifier): Option[Table]
```

`makeTable`...FIXME

---

`makeTable` is used when:

* `CatalogImpl` is requested to [listTables](#listTables) and [getTable](#getTable)

### <span id="loadTable"> loadTable

```scala
loadTable(
  catalog: TableCatalog,
  ident: Identifier): Option[Table]
```

`loadTable`...FIXME

<!---
## Review Me

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

`createExternalTable` creates an external table `tableName` from the given `path` and returns the corresponding [DataFrame](DataFrame.md).

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

`createExternalTable` parses `tableName` into `TableIdentifier` (using sql/SparkSqlParser.md[SparkSqlParser]). It creates a [CatalogTable](CatalogTable.md) and then SessionState.md#executePlan[executes] (by [toRDD](QueryExecution.md#toRdd)) a CreateTable.md[CreateTable] logical plan. The result [DataFrame](DataFrame.md) is a `Dataset[Row]` with the [QueryExecution](QueryExecution.md) after executing SubqueryAlias.md[SubqueryAlias] logical plan and [RowEncoder](RowEncoder.md).

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

=== [[makeDataset]] Creating Dataset from DefinedByConstructorParams Data -- `makeDataset` Method

[source, scala]
----
makeDataset[T <: DefinedByConstructorParams](
  data: Seq[T],
  sparkSession: SparkSession): Dataset[T]
----

`makeDataset` creates an [ExpressionEncoder](ExpressionEncoder.md#apply) (from [DefinedByConstructorParams](ExpressionEncoder.md#DefinedByConstructorParams)) and [encodes](ExpressionEncoder.md#toRow) elements of the input `data` to [internal binary rows](InternalRow.md).

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
-->
