# DataWritingSparkTask Utility

`DataWritingSparkTask` utility defines a [partition processing function](#run) that `V2TableWriteExec` unary physical commands use to [schedule a Spark job for writing data out](physical-operators/V2TableWriteExec.md#writeWithV2).

`DataWritingSparkTask` is executed on executors.

## <span id="run"> Partition Processing Function

```scala
run(
  writerFactory: DataWriterFactory,
  context: TaskContext,
  iter: Iterator[InternalRow],
  useCommitCoordinator: Boolean,
  customMetrics: Map[String, SQLMetric]): DataWritingSparkTaskResult
```

`run` requests the [DataWriterFactory](connector/DataWriterFactory.md) for a [DataWriter](connector/DataWriterFactory.md#createWriter) (for the partition and task of the `TaskContext`).

For every [InternalRow](InternalRow.md) (in the given `iter` collection), `run` requests the `DataWriter` to [write out the InternalRow](connector/DataWriter.md#write). `run` counts all the `InternalRow`s.

After all the rows have been written out successfully, `run` requests the `DataWriter` to [commit](connector/DataWriter.md#commit) ([with](#run-useCommitCoordinator-enabled) or [without](#run-useCommitCoordinator-disabled) requesting the `OutputCommitCoordinator` for authorization) that gives the final `WriterCommitMessage`.

With `useCommitCoordinator` flag enabled, `run`...FIXME

With `useCommitCoordinator` flag disabled, `run` prints out the following INFO message to the logs and requests the `DataWriter` to [commit](connector/DataWriter.md#commit).

`run` prints out the following INFO message to the logs:

```text
Committed partition [partId] (task [taskId], attempt [attemptId], stage [stageId].[stageAttempt])
```

In the end, `run` returns a `DataWritingSparkTaskResult` with the count (of the rows written out) and the final `WriterCommitMessage`.

### Usage

`run` is used when:

* `V2TableWriteExec` unary physical command is requested to [writeWithV2](physical-operators/V2TableWriteExec.md#writeWithV2)

### <span id="run-useCommitCoordinator-enabled"> Using CommitCoordinator

With the given `useCommitCoordinator` flag enabled, `run` requests the `SparkEnv` for the `OutputCommitCoordinator` ([Spark Core]({{ book.spark_core }}/OutputCommitCoordinator)) that is asked whether to commit the write task output or not (`canCommit`).

#### Commit Authorized

If authorized, `run` prints out the following INFO message to the logs:

```text
Commit authorized for partition [partId] (task [taskId], attempt [attemptId], stage [stageId].[stageAttempt])
```

#### Commit Denied

If not authorized, `run` prints out the following INFO message to the logs and throws a `CommitDeniedException`.

```text
Commit denied for partition [partId] (task [taskId], attempt [attemptId], stage [stageId].[stageAttempt])
```

### <span id="run-useCommitCoordinator-disabled"> No CommitCoordinator

With the given `useCommitCoordinator` flag disabled, `run` prints out the following INFO message to the logs:

```text
Writer for partition [partitionId] is committing.
```

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.v2.DataWritingSparkTask` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.datasources.v2.DataWritingSparkTask=ALL
```

Refer to [Logging](spark-logging.md).
