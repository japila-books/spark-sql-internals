# DataWritingSparkTask Partition Processing Function

`DataWritingSparkTask` is the **partition processing function** that `WriteToDataSourceV2Exec` physical operator uses to [schedule a Spark job](physical-operators/WriteToDataSourceV2Exec.md#doExecute-runJob) when requested to [execute](physical-operators/WriteToDataSourceV2Exec.md#doExecute).

NOTE: The `DataWritingSparkTask` partition processing function is executed on executors.

[[logging]]
[TIP]
====
Enable `INFO` or `ERROR` logging levels for `org.apache.spark.sql.execution.datasources.v2.DataWritingSparkTask` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.execution.datasources.v2.DataWritingSparkTask=INFO
```

Refer to <<spark-logging.md#, Logging>>.
====

=== [[run]] Running Partition Processing Function -- `run` Method

[source, scala]
----
run(
  writeTask: DataWriterFactory[InternalRow],
  context: TaskContext,
  iter: Iterator[InternalRow],
  useCommitCoordinator: Boolean): WriterCommitMessage
----

`run` requests the given `TaskContext` for the IDs of the stage, the stage attempt, the partition, the task attempt, and how many times the task may have been attempted (default `0`).

`run` also requests the given `TaskContext` for the epoch ID (that is *streaming.sql.batchId* local property) or defaults to `0`.

`run` requests the given `DataWriterFactory` to [create a DataWriter](connector/DataWriterFactory.md#createDataWriter) (with the partition, task and epoch IDs).

For every row in the partition (in the given `Iterator[InternalRow]`), `run` requests the `DataWriter` to [write the row](connector/DataWriter.md#write).

Once all the rows have been written successfully, `run` requests the `DataWriter` to [commit the write task](connector/DataWriter.md#commit) (<<run-useCommitCoordinator-enabled, with>> or <<run-useCommitCoordinator-disabled, without>> requesting the `OutputCommitCoordinator` for authorization) that gives the final `WriterCommitMessage`.

In the end, `run` prints out the following INFO message to the logs:

```text
Committed partition [partId] (task [taskId], attempt [attemptId]stage [stageId].[stageAttempt])
```

---

In case of any errors, `run` prints out the following ERROR message to the logs:

```
Aborting commit for partition [partId] (task [taskId], attempt [attemptId]stage [stageId].[stageAttempt])
```

`run` then requests the `DataWriter` to [abort the write task](connector/DataWriter.md#abort).

In the end, `run` prints out the following ERROR message to the logs:

```
Aborted commit for partition [partId] (task [taskId], attempt [attemptId]stage [stageId].[stageAttempt])
```

NOTE: `run` is used exclusively when `WriteToDataSourceV2Exec` physical operator is requested to <<WriteToDataSourceV2Exec.md#doExecute, execute>> (and <<WriteToDataSourceV2Exec.md#doExecute-runJob, schedules a Spark job>>).

==== [[run-useCommitCoordinator-enabled]] `useCommitCoordinator` Flag Enabled

With the given `useCommitCoordinator` flag enabled, `run` requests the `SparkEnv` for the `OutputCommitCoordinator` that is then requested whether to commit the write task output or not (`canCommit`).

TIP: Read up on https://jaceklaskowski.gitbooks.io/mastering-apache-spark/spark-service-outputcommitcoordinator.html[OutputCommitCoordinator] in the https://bit.ly/mastering-apache-spark[Mastering Apache Spark].

If authorized, `run` prints out the following INFO message to the logs:

```
Commit authorized for partition [partId] (task [taskId], attempt [attemptId]stage [stageId].[stageAttempt])
```

In the end, `run` requests the `DataWriter` to [commit the write task](connector/DataWriter.md#commit).

---

If not authorized, `run` prints out the following INFO message to the logs and throws a `CommitDeniedException`.

```
Commit denied for partition [partId] (task [taskId], attempt [attemptId]stage [stageId].[stageAttempt])
```

==== [[run-useCommitCoordinator-disabled]] `useCommitCoordinator` Flag Disabled

With the given `useCommitCoordinator` flag disabled, `run` prints out the following INFO message to the logs:

```text
Writer for partition [partId] is committing.
```

In the end, `run` requests the `DataWriter` to [commit the write task](connector/DataWriter.md#commit).
