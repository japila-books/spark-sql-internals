# V2TableWriteExec Unary Physical Commands

`V2TableWriteExec` is an [extension](#contract) of the [V2CommandExec](V2CommandExec.md) abstraction for [unary physical commands](#implementations) that [writeWithV2](#writeWithV2).

## Contract

### <span id="query"> Physical Query Plan

```scala
query: SparkPlan
```

[SparkPlan](SparkPlan.md) for the data to be written out

## Implementations

* [TableWriteExecHelper](TableWriteExecHelper.md)
* [V2ExistingTableWriteExec](V2ExistingTableWriteExec.md)
* [WriteToDataSourceV2Exec](WriteToDataSourceV2Exec.md)

## <span id="writeWithV2"> writeWithV2

```scala
writeWithV2(
  batchWrite: BatchWrite): Seq[InternalRow]
```

`writeWithV2` requests the [physical query plan](#query) to [execute](SparkPlan.md#execute) (that gives a `RDD[InternalRow]`).

`writeWithV2` requests the given `BatchWrite` for a [DataWriterFactory](../connector/BatchWrite.md#createBatchWriterFactory).

`writeWithV2` prints out the following INFO message to the logs:

```text
Start processing data source write support: [batchWrite]. The input RDD has [n] partitions.
```

`writeWithV2` runs a Spark job ([Spark Core]({{ book.spark_core }}/SparkContext#runJob)) with the [DataWritingSparkTask](../DataWritingSparkTask.md#run) for every partition. `writeWithV2` requests the `BatchWrite` to [onDataWriterCommit](../connector/BatchWrite.md#onDataWriterCommit) (with the result `WriterCommitMessage`) after every partition has been processed successfully.

`writeWithV2` prints out the following INFO message to the logs:

```text
Data source write support [batchWrite] is committing.
```

`writeWithV2` requests the `BatchWrite` to [commit](../connector/BatchWrite.md#commit) (with all the result `WriterCommitMessage`s).

`writeWithV2` prints out the following INFO message to the logs:

```text
Data source write support [batchWrite] committed.
```

In the end, `writeWithV2` returns no `InternalRow`s.

`writeWithV2` is used when:

* `WriteToDataSourceV2Exec` is [executed](WriteToDataSourceV2Exec.md#run)
* `V2ExistingTableWriteExec` is [executed](V2ExistingTableWriteExec.md#run)
* `TableWriteExecHelper` is requested to [writeToTable](TableWriteExecHelper.md#writeToTable)
