# FileWriterFactory

`FileWriterFactory` is a [DataWriterFactory](connector/DataWriterFactory.md) of [FileBatchWrite](FileBatchWrite.md)s.

## Creating Instance

`FileWriterFactory` takes the following to be created:

* <span id="description"> `WriteJobDescription`
* <span id="committer"> `FileCommitProtocol` ([Spark Core]({{ book.spark_core }}/FileCommitProtocol))

`FileWriterFactory` is created when:

* `FileBatchWrite` is requested for a [DataWriterFactory](FileBatchWrite.md#createBatchWriterFactory)

## <span id="createWriter"> Creating DataWriter

```scala
createWriter(
  partitionId: Int,
  realTaskId: Long): DataWriter[InternalRow]
```

`createWriter` [creates a TaskAttemptContext](#createTaskAttemptContext).

`createWriter` requests the [FileCommitProtocol](#committer) to `setupTask` (with the `TaskAttemptContext`).

For a non-partitioned write job (i.e., no partition columns in the [WriteJobDescription](#description)), `createWriter` creates a [SingleDirectoryDataWriter](SingleDirectoryDataWriter.md). Otherwise, `createWriter` creates a `DynamicPartitionDataSingleWriter`.

---

`createWriter` is part of the [DataWriterFactory](connector/DataWriterFactory.md#createWriter) abstraction.

### <span id="createTaskAttemptContext"> Creating Hadoop TaskAttemptContext

```scala
createTaskAttemptContext(
  partitionId: Int): TaskAttemptContextImpl
```

`createTaskAttemptContext` creates a Hadoop [JobID]({{ hadoop.api }}/org/apache/hadoop/mapred/JobID.html).

`createTaskAttemptContext` creates a Hadoop [TaskID]({{ hadoop.api }}/org/apache/hadoop/mapreduce/TaskID.html) (for the `JobID` and the given `partitionId` as `TaskType.MAP` type).

`createTaskAttemptContext` creates a Hadoop [TaskAttemptID]({{ hadoop.api }}/org/apache/hadoop/mapreduce/TaskAttemptID.html) (for the `TaskID`).

`createTaskAttemptContext` uses the Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html) (from the [WriteJobDescription](#description)) to set the following properties:

Name     | Value
---------|---------
mapreduce.job.id | the `JobID`
mapreduce.task.id | the `TaskID`
mapreduce.task.attempt.id | the `TaskAttemptID`
mapreduce.task.ismap | `true`
mapreduce.task.partition | `0`

In the end, `createTaskAttemptContext` creates a new Hadoop [TaskAttemptContextImpl]({{ hadoop.api }}/org/apache/hadoop/mapreduce/task/TaskAttemptContext.html) (with the `Configuration` and the `TaskAttemptID`).
