title: CommandUtils

# CommandUtils -- Utilities for Table Statistics

`CommandUtils` is a helper class that logical commands, e.g. `InsertInto*`, `AlterTable*Command`, `LoadDataCommand`, and CBO's `Analyze*`, use to manage table statistics.

`CommandUtils` defines the following utilities:

* <<calculateTotalSize, Calculating Total Size of Table or Its Partitions>>
* <<calculateLocationSize, Calculating Total File Size Under Path>>
* <<compareAndGetNewStats, Creating CatalogStatistics with Current Statistics>>
* <<updateTableStats, Updating Existing Table Statistics>>

[[logging]]
[TIP]
====
Enable `INFO` logging level for `org.apache.spark.sql.execution.command.CommandUtils` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.execution.command.CommandUtils=INFO
```

Refer to spark-logging.md[Logging].
====

=== [[updateTableStats]] Updating Existing Table Statistics -- `updateTableStats` Method

[source, scala]
----
updateTableStats(sparkSession: SparkSession, table: CatalogTable): Unit
----

`updateTableStats` updates the table statistics of the input spark-sql-CatalogTable.md[CatalogTable] (only if the spark-sql-CatalogTable.md#stats[statistics are available] in the metastore already).

`updateTableStats` requests `SessionCatalog` to spark-sql-SessionCatalog.md#alterTableStats[alterTableStats] with the <<calculateTotalSize, current total size>> (when spark-sql-properties.md#spark.sql.statistics.size.autoUpdate.enabled[spark.sql.statistics.size.autoUpdate.enabled] property is turned on) or empty statistics (that effectively removes the recorded statistics completely).

IMPORTANT: `updateTableStats` uses spark-sql-properties.md#spark.sql.statistics.size.autoUpdate.enabled[spark.sql.statistics.size.autoUpdate.enabled] property to auto-update table statistics and can be expensive (and slow down data change commands) if the total number of files of a table is very large.

NOTE: `updateTableStats` uses `SparkSession` to access the current SparkSession.md#sessionState[SessionState] that it then uses to access the session-scoped SessionState.md#catalog[SessionCatalog].

NOTE: `updateTableStats` is used when hive/InsertIntoHiveTable.md[InsertIntoHiveTable], <<spark-sql-LogicalPlan-InsertIntoHadoopFsRelationCommand.md#, InsertIntoHadoopFsRelationCommand>>, `AlterTableDropPartitionCommand`, `AlterTableSetLocationCommand` and `LoadDataCommand` commands are executed.

=== [[calculateTotalSize]] Calculating Total Size of Table (with Partitions) -- `calculateTotalSize` Method

[source, scala]
----
calculateTotalSize(sessionState: SessionState, catalogTable: CatalogTable): BigInt
----

`calculateTotalSize` <<calculateLocationSize, calculates total file size>> for the entire input spark-sql-CatalogTable.md[CatalogTable] (when it has no partitions defined) or all its spark-sql-SessionCatalog.md#listPartitions[partitions] (through the session-scoped spark-sql-SessionCatalog.md[SessionCatalog]).

NOTE: `calculateTotalSize` uses the input `SessionState` to access the SessionState.md#catalog[SessionCatalog].

[NOTE]
====
`calculateTotalSize` is used when:

* <<spark-sql-LogicalPlan-AnalyzeColumnCommand.md#, AnalyzeColumnCommand>> and <<spark-sql-LogicalPlan-AnalyzeTableCommand.md#, AnalyzeTableCommand>> commands are executed

* `CommandUtils` is requested to <<updateTableStats, update existing table statistics>> (when hive/InsertIntoHiveTable.md[InsertIntoHiveTable], <<spark-sql-LogicalPlan-InsertIntoHadoopFsRelationCommand.md#, InsertIntoHadoopFsRelationCommand>>, `AlterTableDropPartitionCommand`, `AlterTableSetLocationCommand` and `LoadDataCommand` commands are executed)
====

=== [[calculateLocationSize]] Calculating Total File Size Under Path -- `calculateLocationSize` Method

[source, scala]
----
calculateLocationSize(
  sessionState: SessionState,
  identifier: TableIdentifier,
  locationUri: Option[URI]): Long
----

`calculateLocationSize` reads `hive.exec.stagingdir` configuration property for the staging directory (with `.hive-staging` being the default).

You should see the following INFO message in the logs:

```
INFO CommandUtils: Starting to calculate the total file size under path [locationUri].
```

`calculateLocationSize` calculates the sum of the length of all the files under the input `locationUri`.

NOTE: `calculateLocationSize` uses Hadoop's ++https://hadoop.apache.org/docs/current/api/org/apache/hadoop/fs/FileSystem.html#getFileStatus-org.apache.hadoop.fs.Path-++[FileSystem.getFileStatus] and ++https://hadoop.apache.org/docs/current/api/org/apache/hadoop/fs/FileStatus.html#getLen--++[FileStatus.getLen] to access a file and the length of the file (in bytes), respectively.

In the end, you should see the following INFO message in the logs:

```
INFO CommandUtils: It took [durationInMs] ms to calculate the total file size under path [locationUri].
```

[NOTE]
====
`calculateLocationSize` is used when:

* spark-sql-LogicalPlan-AnalyzePartitionCommand.md#run[AnalyzePartitionCommand] and spark-sql-LogicalPlan-RunnableCommand.md#AlterTableAddPartitionCommand[AlterTableAddPartitionCommand] commands are executed

* `CommandUtils` is requested for <<calculateTotalSize, total size of a table or its partitions>>
====

=== [[compareAndGetNewStats]] Creating CatalogStatistics with Current Statistics -- `compareAndGetNewStats` Method

[source, scala]
----
compareAndGetNewStats(
  oldStats: Option[CatalogStatistics],
  newTotalSize: BigInt,
  newRowCount: Option[BigInt]): Option[CatalogStatistics]
----

`compareAndGetNewStats` spark-sql-CatalogStatistics.md#creating-instance[creates] a new `CatalogStatistics` with the input `newTotalSize` and `newRowCount` only when they are different from the `oldStats`.

NOTE: `compareAndGetNewStats` is used when spark-sql-LogicalPlan-AnalyzePartitionCommand.md#run[AnalyzePartitionCommand] and spark-sql-LogicalPlan-AnalyzeTableCommand.md#run[AnalyzeTableCommand] are executed.
