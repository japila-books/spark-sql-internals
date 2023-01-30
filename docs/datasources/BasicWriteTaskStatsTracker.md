# BasicWriteTaskStatsTracker

`BasicWriteTaskStatsTracker` is a [WriteTaskStatsTracker](WriteTaskStatsTracker.md).

## Creating Instance

`BasicWriteTaskStatsTracker` takes the following to be created:

* <span id="hadoopConf"> Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html)
* <span id="taskCommitTimeMetric"> Task Commit Time [SQLMetric](../SQLMetric.md)

`BasicWriteTaskStatsTracker` is created when:

* `BasicWriteJobStatsTracker` is requested for a [new WriteTaskStatsTracker instance](BasicWriteJobStatsTracker.md#newTaskInstance)

## <span id="submittedFiles"> submittedFiles

`BasicWriteTaskStatsTracker` uses `submittedFiles` registry of the [file paths added](#newFile) (_written out to_).

The `submittedFiles` registry is used to [updateFileStats](#updateFileStats) when [getFinalStats](#getFinalStats).

A file path is removed when `BasicWriteTaskStatsTracker` is requested to [closeFile](#closeFile).

All the file paths are removed in [getFinalStats](#getFinalStats).

## <span id="updateFileStats"> updateFileStats

```scala
updateFileStats(
  filePath: String): Unit
```

`updateFileStats` [gets the size](#getFileSize) of the given `filePath`.

If the file length is found, it is added to the [numBytes](#numBytes) registry with the [numFiles](#numFiles) incremented.

## <span id="newFile"> Processing New File Notification

```scala
newFile(
  filePath: String): Unit
```

`newFile` adds the given `filePath` to the [submittedFiles](#submittedFiles) registry and increments the [numSubmittedFiles](#numSubmittedFiles) counter.

`newFile` is part of the [WriteTaskStatsTracker](WriteTaskStatsTracker.md#newFile) abstraction.

## <span id="getFinalStats"> Final WriteTaskStats

```scala
getFinalStats(
  taskCommitTime: Long): WriteTaskStats
```

`getFinalStats` [updateFileStats](#updateFileStats) for every [submittedFiles](#submittedFiles) that are then cleared up.

`getFinalStats` sets the output metrics (of the current Spark task) as follows:

* `bytesWritten` to be [numBytes](#numBytes)
* `recordsWritten` to be [numRows](#numRows)

`getFinalStats` prints out the following INFO message when the [numSubmittedFiles](#numSubmittedFiles) is different from the [numFiles](#numFiles):

```text
Expected [numSubmittedFiles] files, but only saw $numFiles.
This could be due to the output format not writing empty files,
or files being not immediately visible in the filesystem.
```

`getFinalStats` adds the given `taskCommitTime` to the [taskCommitTimeMetric](#taskCommitTimeMetric) if defined.

In the end, creates a new [BasicWriteTaskStats](BasicWriteTaskStats.md) with the [partitions](#partitions), [numFiles](#numFiles), [numBytes](#numBytes), and [numRows](#numRows).

---

`getFinalStats` is part of the [WriteTaskStatsTracker](WriteTaskStatsTracker.md#getFinalStats) abstraction.

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.BasicWriteTaskStatsTracker` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.datasources.BasicWriteTaskStatsTracker=ALL
```

Refer to [Logging](../spark-logging.md).
