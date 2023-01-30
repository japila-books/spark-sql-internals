# FileBatchWrite

`FileBatchWrite` is a [BatchWrite](../connector/BatchWrite.md) that uses the given [FileCommitProtocol](#committer) to coordinate a [writing job](#job) ([abort](#abort) or [commit](#commit)).

## Creating Instance

`FileBatchWrite` takes the following to be created:

* <span id="job"> Hadoop [Job]({{ hadoop.api }}/org/apache/hadoop/mapreduce/Job.html)
* <span id="description"> `WriteJobDescription`
* <span id="committer"> `FileCommitProtocol` ([Spark Core]({{ book.spark_core }}/FileCommitProtocol))

`FileBatchWrite` is created when:

* `FileWrite` is requested for a [BatchWrite](FileWrite.md#toBatch)

## <span id="abort"> Aborting Write Job

```scala
abort(
  messages: Array[WriterCommitMessage]): Unit
```

`abort` requests the [FileCommitProtocol](#committer) to abort the [Job](#job).

`abort` is part of the [BatchWrite](../connector/BatchWrite.md#abort) abstraction.

## <span id="commit"> Committing Write Job

```scala
commit(
  messages: Array[WriterCommitMessage]): Unit
```

`commit` prints out the following INFO message to the logs:

```text
Start to commit write Job [uuid].
```

`commit` requests the [FileCommitProtocol](#committer) to commit the [Job](#job) (with the `WriteTaskResult` extracted from the given `WriterCommitMessage`s). `commit` measures the commit duration.

`commit` prints out the following INFO message to the logs:

```text
Write Job [uuid] committed. Elapsed time: [duration] ms.
```

`commit` [handles the statistics of this write job](FileFormatWriter.md#processStats).

In the end, `commit` prints out the following INFO message to the logs:

```text
Finished processing stats for write job [uuid].
```

---

`commit` is part of the [BatchWrite](../connector/BatchWrite.md#commit) abstraction.

## <span id="createBatchWriterFactory"> Creating Batch DataWriterFactory

```scala
createBatchWriterFactory(
  info: PhysicalWriteInfo): DataWriterFactory
```

`createBatchWriterFactory` creates a new [FileWriterFactory](FileWriterFactory.md).

`createBatchWriterFactory` is part of the [BatchWrite](../connector/BatchWrite.md#createBatchWriterFactory) abstraction.

## <span id="useCommitCoordinator"> useCommitCoordinator

```scala
useCommitCoordinator(): Boolean
```

`FileBatchWrite` does not require a Commit Coordinator (and returns `false`).

`useCommitCoordinator` is part of the [BatchWrite](../connector/BatchWrite.md#useCommitCoordinator) abstraction.

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.v2.FileBatchWrite` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.datasources.v2.FileBatchWrite=ALL
```

Refer to [Logging](../spark-logging.md).
