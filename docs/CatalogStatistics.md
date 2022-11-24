# CatalogStatistics

`CatalogStatistics` are table and partition statistics that are stored in an [external catalog](ExternalCatalog.md).

## Creating Instance

`CatalogStatistics` takes the following to be created:

* <span id="sizeInBytes"> Physical **total size** (in bytes)
* <span id="rowCount"> Estimated **number of rows** (_row count_)
* <span id="colStats"> **Column statistics** (column names and their `CatalogColumnStat`s)

`CatalogStatistics` is created when:

* [AnalyzeColumnCommand](logical-operators/AnalyzeColumnCommand.md#analyzeColumnInCatalog) and `AlterTableAddPartitionCommand` logical commands are executed (and store statistics in [ExternalCatalog](ExternalCatalog.md))
* `CommandUtils` utility is used to [updating existing table statistics](CommandUtils.md#updateTableStats) and [current statistics (if changed)](CommandUtils.md#compareAndGetNewStats)
* `HiveExternalCatalog` is requested to [convert properties to Spark statistics](hive/HiveExternalCatalog.md#statsFromProperties)
* `HiveClientImpl` utility is used to [readHiveStats](hive/HiveClientImpl.md#readHiveStats)
* `PruneHiveTablePartitions` is requested to `updateTableMeta`
* [PruneFileSourcePartitions](logical-optimizations/PruneFileSourcePartitions.md) logical optimization is executed

## CatalogStatistics and Statistics

`CatalogStatistics` are a "subset" of the statistics in [Statistics](logical-operators/Statistics.md) (as there are no concepts of [attributes](logical-operators/Statistics.md#attributeStats) and [broadcast hint](logical-operators/Statistics.md#hints) in metastore).

`CatalogStatistics` are often stored in a Hive metastore and are referred as **Hive statistics** while `Statistics` are the **Spark statistics**.

## <span id="simpleString"> Readable Textual Representation

```scala
simpleString: String
```

`simpleString` is the following text (with the [sizeInBytes](#sizeInBytes) and the optional [rowCount](#rowCount) if defined):

```text
[sizeInBytes] bytes, [rowCount] rows
```

```text
scala> :type stats
Option[org.apache.spark.sql.catalyst.catalog.CatalogStatistics]

scala> stats.map(_.simpleString).foreach(println)
714 bytes, 2 rows
```

`simpleString` is used when:

* `CatalogTablePartition` is requested to [toLinkedHashMap](CatalogTablePartition.md#toLinkedHashMap)
* `CatalogTable` is requested to [toLinkedHashMap](CatalogTable.md#toLinkedHashMap)

## <span id="toPlanStats"> Converting Metastore Statistics to Spark Statistics

```scala
toPlanStats(
  planOutput: Seq[Attribute],
  cboEnabled: Boolean): Statistics
```

`toPlanStats` converts the table statistics (from an external metastore) to [Spark statistics](logical-operators/Statistics.md).

With [cost-based optimization](cost-based-optimization/index.md) enabled and [row count](#rowCount) statistics available, `toPlanStats` creates a [Statistics](logical-operators/Statistics.md) with the estimated total (output) size, [row count](#rowCount) and column statistics.

Otherwise (when [cost-based optimization](cost-based-optimization/index.md) is disabled), `toPlanStats` creates a [Statistics](logical-operators/Statistics.md) with just the mandatory [sizeInBytes](#sizeInBytes).

!!! note
    `toPlanStats` does the reverse of [HiveExternalCatalog.statsToProperties](hive/HiveExternalCatalog.md#statsToProperties).

---

`toPlanStats` is used when:

* [HiveTableRelation](hive/HiveTableRelation.md#computeStats) and [LogicalRelation](logical-operators/LogicalRelation.md#computeStats) are requested for statistics

## Demo

```text
scala> :type spark.sessionState.catalog
org.apache.spark.sql.catalyst.catalog.SessionCatalog
```

```scala
// Using higher-level interface to access CatalogStatistics
// Make sure that you ran ANALYZE TABLE (as described above)
val db = spark.catalog.currentDatabase
val tableName = "t1"
val metadata = spark.sharedState.externalCatalog.getTable(db, tableName)
val stats = metadata.stats
```

```text
scala> :type stats
Option[org.apache.spark.sql.catalyst.catalog.CatalogStatistics]
```

```scala
val tid = spark.sessionState.sqlParser.parseTableIdentifier(tableName)
val metadata = spark.sessionState.catalog.getTempViewOrPermanentTableMetadata(tid)
val stats = metadata.stats
```

```text
scala> :type stats
Option[org.apache.spark.sql.catalyst.catalog.CatalogStatistics]
```
