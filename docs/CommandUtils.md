# CommandUtils &mdash; Utilities for Table Statistics

`CommandUtils` is a helper class that logical commands use to manage table statistics.

## <span id="analyzeTable"> analyzeTable

```scala
analyzeTable(
  sparkSession: SparkSession,
  tableIdent: TableIdentifier,
  noScan: Boolean): Unit
```

`analyzeTable` requests the [SessionCatalog](SessionState.md#catalog) for the [table metadata](SessionCatalog.md#getTableMetadata).

`analyzeTable` branches off based on the type of the table: a view and the other types.

For `CatalogTableType.VIEW`s, `analyzeTable` requests the [CacheManager](SharedState.md#cacheManager) to [lookupCachedData](CacheManager.md#lookupCachedData). If available and the given `noScan` flag is disabled, `analyzeTable` requests the table to `count` the number of rows (that materializes the underlying columnar RDD).

For other types, `analyzeTable` [calculateTotalSize](CommandUtils.md#calculateTotalSize) for the table. With the given `noScan` flag disabled, `analyzeTable` creates a `DataFrame` for the table and `count`s the number of rows (that triggers a Spark job). In case the table stats have changed, `analyzeTable` requests the [SessionCatalog](SessionState.md#catalog) to [alterTableStats](SessionCatalog.md#alterTableStats).

`analyzeTable` is used when:

* [AnalyzeTableCommand](logical-operators/AnalyzeTableCommand.md) and `AnalyzeTablesCommand` logical commands are executed

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.command.CommandUtils` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.command.CommandUtils=ALL
```

Refer to [Logging](spark-logging.md).

## Review Me

## <span id="updateTableStats"> Updating Existing Table Statistics

```scala
updateTableStats(
  sparkSession: SparkSession,
  table: CatalogTable): Unit
```

`updateTableStats` updates the table statistics of the input [CatalogTable](CatalogTable.md) (only if the [statistics are available](CatalogTable.md#stats) in the metastore already).

`updateTableStats` requests `SessionCatalog` to [alterTableStats](SessionCatalog.md#alterTableStats) with the <<calculateTotalSize, current total size>> (when [spark.sql.statistics.size.autoUpdate.enabled](configuration-properties.md#spark.sql.statistics.size.autoUpdate.enabled) property is turned on) or empty statistics (that effectively removes the recorded statistics completely).

!!! important
    `updateTableStats` uses [spark.sql.statistics.size.autoUpdate.enabled](configuration-properties.md#spark.sql.statistics.size.autoUpdate.enabled) property to auto-update table statistics and can be expensive (and slow down data change commands) if the total number of files of a table is very large.

!!! note
    `updateTableStats` uses `SparkSession` to access the current SparkSession.md#sessionState[SessionState] that it then uses to access the session-scoped SessionState.md#catalog[SessionCatalog].

`updateTableStats` is used when:

* [InsertIntoHiveTable](hive/InsertIntoHiveTable.md), [InsertIntoHadoopFsRelationCommand](logical-operators/InsertIntoHadoopFsRelationCommand.md), `AlterTableDropPartitionCommand`, `AlterTableSetLocationCommand` and `LoadDataCommand` commands are executed

## <span id="calculateTotalSize"> Calculating Total Size of Table (with Partitions)

```scala
calculateTotalSize(
  sessionState: SessionState,
  catalogTable: CatalogTable): BigInt
```

`calculateTotalSize` <<calculateLocationSize, calculates total file size>> for the entire input [CatalogTable](CatalogTable.md) (when it has no partitions defined) or all its [partitions](SessionCatalog.md#listPartitions) (through the session-scoped [SessionCatalog](SessionCatalog.md)).

NOTE: `calculateTotalSize` uses the input `SessionState` to access the SessionState.md#catalog[SessionCatalog].

`calculateTotalSize` is used when:

* [AnalyzeColumnCommand](logical-operators/AnalyzeColumnCommand.md) and [AnalyzeTableCommand](logical-operators/AnalyzeTableCommand.md) commands are executed

* `CommandUtils` is requested to [update existing table statistics](#updateTableStats) (when [InsertIntoHiveTable](hive/InsertIntoHiveTable.md), [InsertIntoHadoopFsRelationCommand](logical-operators/InsertIntoHadoopFsRelationCommand.md), `AlterTableDropPartitionCommand`, `AlterTableSetLocationCommand` and `LoadDataCommand` commands are executed)

## <span id="calculateLocationSize"> Calculating Total File Size Under Path

```scala
calculateLocationSize(
  sessionState: SessionState,
  identifier: TableIdentifier,
  locationUri: Option[URI]): Long
```

`calculateLocationSize` reads `hive.exec.stagingdir` configuration property for the staging directory (with `.hive-staging` being the default).

You should see the following INFO message in the logs:

```text
Starting to calculate the total file size under path [locationUri].
```

`calculateLocationSize` calculates the sum of the length of all the files under the input `locationUri`.

!!! note
    `calculateLocationSize` uses Hadoop's [FileSystem.getFileStatus]({{ hadoop.api }}/org/apache/hadoop/fs/FileSystem.html#getFileStatus-org.apache.hadoop.fs.Path-) and [FileStatus.getLen]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html#getLen--) to access the file and the length of the file (in bytes), respectively.

In the end, you should see the following INFO message in the logs:

```text
It took [durationInMs] ms to calculate the total file size under path [locationUri].
```

`calculateLocationSize` is used when:

* [AnalyzePartitionCommand](logical-operators/AnalyzePartitionCommand.md) and `AlterTableAddPartitionCommand` commands are executed

* `CommandUtils` is requested for [total size of a table or its partitions](#calculateTotalSize)
