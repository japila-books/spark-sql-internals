# FileFormatWriter Utility

`FileFormatWriter` utility is used to [write out query result](#write) for the following:

* Hive-related [InsertIntoHiveDirCommand](hive/InsertIntoHiveDirCommand.md) and [InsertIntoHiveTable](hive/InsertIntoHiveTable.md) logical commands (via [SaveAsHiveFile.saveAsHiveFile](hive/SaveAsHiveFile.md#saveAsHiveFile))
* [InsertIntoHadoopFsRelationCommand](logical-operators/InsertIntoHadoopFsRelationCommand.md) logical command
* `FileStreamSink` ([Spark Structured Streaming]({{ book.structured_streaming }}/datasources/file/FileStreamSink#addBatch)) is requested to write out a micro-batch

## <span id="write"> Writing Out Query Result

```scala
write(
  sparkSession: SparkSession,
  plan: SparkPlan,
  fileFormat: FileFormat,
  committer: FileCommitProtocol,
  outputSpec: OutputSpec,
  hadoopConf: Configuration,
  partitionColumns: Seq[Attribute],
  bucketSpec: Option[BucketSpec],
  statsTrackers: Seq[WriteJobStatsTracker],
  options: Map[String, String]): Set[String]
```

`write` creates a Hadoop [Job]({{ hadoop.api }}/org/apache/hadoop/mapreduce/Job.html) instance (with the given Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html)) and uses the following job output classes:

* `Void` for keys

* `InternalRow` for values

`write` sets the output directory (for the map-reduce job) to be the `outputPath` of the given `OutputSpec`.

<span id="write-outputWriterFactory">
`write` requests the given `FileFormat` to [prepareWrite](datasources/FileFormat.md#prepareWrite).

<span id="write-description">
`write` creates a `WriteJobDescription` with the following:

* `maxRecordsPerFile` based on the `maxRecordsPerFile` option (from the given options) if available or [spark.sql.files.maxRecordsPerFile](configuration-properties.md#spark.sql.files.maxRecordsPerFile)

* `timeZoneId` based on the `timeZone` option (from the given options) if available or [spark.sql.session.timeZone](configuration-properties.md#spark.sql.session.timeZone)

`write` requests the given `FileCommitProtocol` committer to `setupJob`.

<span id="write-rdd">
`write` executes the given [SparkPlan](physical-operators/SparkPlan.md) (and generates an RDD). The execution can be directly on the given physical operator if ordering matches the requirements or uses [SortExec](physical-operators/SortExec.md) physical operator (with `global` flag off).

<span id="write-runJob">
`write` runs a Spark job (action) on the [RDD](#write-rdd) with [executeTask](#executeTask) as the partition function. The result task handler simply requests the given `FileCommitProtocol` committer to `onTaskCommit` (with the `TaskCommitMessage` of a `WriteTaskResult`) and saves the `WriteTaskResult`.

<span id="write-commitJob">
`write` requests the given `FileCommitProtocol` committer to `commitJob` (with the Hadoop `Job` instance and the `TaskCommitMessage` of all write tasks).

`write` prints out the following INFO message to the logs:

```text
Write Job [uuid] committed.
```

<span id="write-processStats">
`write` [processStats](#processStats).

`write` prints out the following INFO message to the logs:

```text
Finished processing stats for write job [uuid].
```

In the end, `write` returns all the partition paths that were updated during this write job.

`write` is used when:

* [InsertIntoHadoopFsRelationCommand](logical-operators/InsertIntoHadoopFsRelationCommand.md) logical command is executed
* `SaveAsHiveFile` is requested to [saveAsHiveFile](hive/SaveAsHiveFile.md#saveAsHiveFile) (when [InsertIntoHiveDirCommand](hive/InsertIntoHiveDirCommand.md) and [InsertIntoHiveTable](hive/InsertIntoHiveTable.md) logical commands are executed)
* ([Spark Structured Streaming]({{ book.structured_streaming }}/datasources/file/FileStreamSink#addBatch)) `FileStreamSink` is requested to write out a micro-batch

### <span id="write-Throwable"> write And Throwables

In case of any `Throwable`, `write` prints out the following ERROR message to the logs:

```text
Aborting job [uuid].
```

<span id="write-abortJob">
`write` requests the given `FileCommitProtocol` committer to `abortJob` (with the Hadoop `Job` instance).

In the end, `write` throws a `SparkException`.

### <span id="executeTask"> Writing Data Out In Single Spark Task

```scala
executeTask(
  description: WriteJobDescription,
  jobIdInstant: Long,
  sparkStageId: Int,
  sparkPartitionId: Int,
  sparkAttemptNumber: Int,
  committer: FileCommitProtocol,
  iterator: Iterator[InternalRow]): WriteTaskResult
```

`executeTask`...FIXME

### <span id="processStats"> Processing Write Job Statistics

```scala
processStats(
  statsTrackers: Seq[WriteJobStatsTracker],
  statsPerTask: Seq[Seq[WriteTaskStats]],
  jobCommitDuration: Long): Unit
```

`processStats` requests every [WriteJobStatsTracker](WriteJobStatsTracker.md) to [processStats](WriteJobStatsTracker.md#processStats) (for respective [WriteTaskStats](WriteTaskStats.md) in the given `statsPerTask`).

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.FileFormatWriter` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.datasources.FileFormatWriter=ALL
```

Refer to [Logging](spark-logging.md).
