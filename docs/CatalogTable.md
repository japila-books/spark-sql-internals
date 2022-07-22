# CatalogTable

`CatalogTable` is the specification (_metadata_) of a table managed by [SessionCatalog](SessionCatalog.md).

## Creating Instance

`CatalogTable` takes the following to be created:

* <span id="identifier"> `TableIdentifier`
* [Table type](#tableType)
* <span id="storage"> [CatalogStorageFormat](CatalogStorageFormat.md)
* <span id="schema"> Schema ([StructType](types/StructType.md))
* <span id="provider"> Name of the table provider
* <span id="partitionColumnNames"> Partition Columns
* [Bucketing specification](#bucketSpec)
* <span id="owner"> Owner
* <span id="createTime"> Created Time
* <span id="lastAccessTime"> Last access time
* <span id="createVersion"> Created By version
* <span id="properties"> Table Properties
* [Table statistics](#stats)
* <span id="viewText"> View Text
* <span id="comment"> Comment
* <span id="unsupportedFeatures"> Unsupported Features (`Seq[String]`)
* <span id="tracksPartitionsInCatalog"> `tracksPartitionsInCatalog` flag (default: `false`)
* <span id="schemaPreservesCase"> `schemaPreservesCase` flag (default: `true`)
* <span id="ignoredProperties"> Ignored properties
* <span id="viewOriginalText"> View Original Text

`CatalogTable` is created when:

* `HiveClientImpl` is requested to [convertHiveTableToCatalogTable](hive/HiveClientImpl.md#convertHiveTableToCatalogTable)
* [InsertIntoHiveDirCommand](hive/InsertIntoHiveDirCommand.md) is executed
* `DataFrameWriter` is requested to [create a table](DataFrameWriter.md#createTable)
* `ResolveSessionCatalog` logical resolution rule is requested to [buildCatalogTable](logical-analysis-rules/ResolveSessionCatalog.md#buildCatalogTable)
* `CreateTableLikeCommand` is executed
* `CreateViewCommand` is requested to [prepareTable](logical-operators/CreateViewCommand.md#prepareTable)
* `ViewHelper` utility is used to `prepareTemporaryView` and `prepareTemporaryViewStoringAnalyzedPlan`
* `V2SessionCatalog` is requested to [createTable](V2SessionCatalog.md#createTable)
* `CatalogImpl` is requested to [createTable](CatalogImpl.md#createTable)

## <span id="bucketSpec"> Bucketing Specification

```scala
bucketSpec: Option[BucketSpec] = None
```

`CatalogTable` can be given a [BucketSpec](BucketSpec.md) when [created](#creating-instance). It is undefined (`None`) by default.

`BucketSpec` is given (using [getBucketSpecFromTableProperties](hive/HiveExternalCatalog.md#getBucketSpecFromTableProperties) from a Hive metastore) when:

* `HiveExternalCatalog` is requested to [restoreHiveSerdeTable](hive/HiveExternalCatalog.md#restoreHiveSerdeTable) and [restoreDataSourceTable](hive/HiveExternalCatalog.md#restoreDataSourceTable)
* `HiveClientImpl` is requested to [convertHiveTableToCatalogTable](hive/HiveClientImpl.md#convertHiveTableToCatalogTable)

`BucketSpec` is given when:

* `DataFrameWriter` is requested to [create a table](DataFrameWriter.md#createTable) (with [getBucketSpec](DataFrameWriter.md#getBucketSpec))
* `ResolveSessionCatalog` logical resolution rule is requested to [buildCatalogTable](logical-analysis-rules/ResolveSessionCatalog.md#buildCatalogTable)
* `CreateTableLikeCommand` is executed (with a bucketed table)
* `PreprocessTableCreation` logical resolution rule is requested to [normalizeCatalogTable](logical-analysis-rules/PreprocessTableCreation.md#normalizeCatalogTable)
* `V2SessionCatalog` is requested to [create a table](V2SessionCatalog.md#createTable)

`BucketSpec` is used when:

* `CatalogTable` is requested to [toLinkedHashMap](#toLinkedHashMap)
* `V1Table` is requested for the [partitioning](connector/V1Table.md#partitioning)
* [CreateDataSourceTableCommand](logical-operators/CreateDataSourceTableCommand.md) is executed
* [CreateDataSourceTableAsSelectCommand](logical-operators/CreateDataSourceTableAsSelectCommand.md) is requested to [saveDataIntoTable](logical-operators/CreateDataSourceTableAsSelectCommand.md#saveDataIntoTable)
* _others_

!!! note
    1. Use [DescribeTableCommand](logical-operators/DescribeTableCommand.md) to review `BucketSpec`
    1. Use [ShowCreateTableCommand](logical-operators/ShowCreateTableCommand.md) to review the Spark DDL syntax
    1. Use [Catalog.listColumns](CatalogImpl.md#listColumns) to list all columns (incl. bucketing columns)

## <span id="tableType"><span id="CatalogTableType"> Table Type

`CatalogTable` is given a `CatalogTableType` when [created](#creating-instance):

* `EXTERNAL` for external tables ([EXTERNAL_TABLE](hive/HiveClientImpl.md#getTableOption) in Hive)
* `MANAGED` for managed tables ([MANAGED_TABLE](hive/HiveClientImpl.md#getTableOption) in Hive)
* `VIEW` for views ([VIRTUAL_VIEW](hive/HiveClientImpl.md#getTableOption) in Hive)

`CatalogTableType` is included when a `TreeNode` is requested for a [JSON representation](catalyst/TreeNode.md#shouldConvertToJson) for...FIXME

## <span id="stats"> Table Statistics

```scala
stats: Option[CatalogStatistics] = None
```

`CatalogTable` can be given a [CatalogStatistics](CatalogStatistics.md) when [created](#creating-instance). It is undefined (`None`) by default.

### Review Me

You manage a table metadata using the [Catalog](Catalog.md) interface. Among the management tasks is to get the <<stats, statistics>> of a table (that are used for [cost-based query optimization](cost-based-optimization.md)).

```text
scala> t1Metadata.stats.foreach(println)
CatalogStatistics(714,Some(2),Map(p1 -> ColumnStat(2,Some(0),Some(1),0,4,4,None), id -> ColumnStat(2,Some(0),Some(1),0,4,4,None)))

scala> t1Metadata.stats.map(_.simpleString).foreach(println)
714 bytes, 2 rows
```

CAUTION: FIXME When are stats specified? What if there are not?

Unless <<stats, CatalogStatistics>> are available in a table metadata (in a catalog) for a non-streaming [file data source table](datasources/FileFormat.md), `DataSource` [creates](DataSource.md#resolveRelation) a `HadoopFsRelation` with the table size specified by [spark.sql.defaultSizeInBytes](configuration-properties.md#spark.sql.defaultSizeInBytes) internal property (default: `Long.MaxValue`) for query planning of joins (and possibly to auto broadcast the table).

Internally, Spark alters table statistics using [ExternalCatalog.doAlterTableStats](ExternalCatalog.md#doAlterTableStats).

Unless <<stats, CatalogStatistics>> are available in a table metadata (in a catalog) for `HiveTableRelation` (and `hive` provider) `DetermineTableStats` logical resolution rule can compute the table size using HDFS (if [spark.sql.statistics.fallBackToHdfs](configuration-properties.md#spark.sql.statistics.fallBackToHdfs) property is turned on) or assume [spark.sql.defaultSizeInBytes](configuration-properties.md#spark.sql.defaultSizeInBytes) (that effectively disables table broadcasting).

When requested to hive/HiveClientImpl.md#getTableOption[look up a table in a metastore], `HiveClientImpl` hive/HiveClientImpl.md#readHiveStats[reads table or partition statistics directly from a Hive metastore].

You can use AnalyzeColumnCommand.md[AnalyzeColumnCommand], AnalyzePartitionCommand.md[AnalyzePartitionCommand], AnalyzeTableCommand.md[AnalyzeTableCommand] commands to record statistics in a catalog.

The table statistics can be [automatically updated](CommandUtils.md#updateTableStats) (after executing commands like `AlterTableAddPartitionCommand`) when [spark.sql.statistics.size.autoUpdate.enabled](configuration-properties.md#spark.sql.statistics.size.autoUpdate.enabled) property is turned on.

You can use `DESCRIBE` SQL command to show the histogram of a column if stored in a catalog.

## Demo: Accessing Table Metadata

### Catalog

```scala
val q = spark.catalog.listTables.filter($"name" === "t1")
```

```text
scala> q.show
+----+--------+-----------+---------+-----------+
|name|database|description|tableType|isTemporary|
+----+--------+-----------+---------+-----------+
|  t1| default|       null|  MANAGED|      false|
+----+--------+-----------+---------+-----------+
```

### SessionCatalog

```scala
import org.apache.spark.sql.catalyst.catalog.SessionCatalog
val sessionCatalog = spark.sessionState.catalog
assert(sessionCatalog.isInstanceOf[SessionCatalog])
```

```scala
val t1Tid = spark.sessionState.sqlParser.parseTableIdentifier("t1")
val t1Metadata = sessionCatalog.getTempViewOrPermanentTableMetadata(t1Tid)
```

```scala
import org.apache.spark.sql.catalyst.catalog.CatalogTable
assert(t1Metadata.isInstanceOf[CatalogTable])
```
