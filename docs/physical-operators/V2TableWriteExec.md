---
title: V2TableWriteExec
---

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
* `WriteToDataSourceV2Exec` ([Spark Structured Streaming]({{ book.structured_streaming }}/WriteToDataSourceV2Exec))

## <span id="writeWithV2"> writeWithV2

```scala
writeWithV2(
  batchWrite: BatchWrite): Seq[InternalRow]
```

`writeWithV2` requests the [physical query plan](#query) to [execute](SparkPlan.md#execute) (and produce a `RDD[InternalRow]`).

`writeWithV2` requests the given [BatchWrite](../connector/BatchWrite.md) to [create a DataWriterFactory](../connector/BatchWrite.md#createBatchWriterFactory) (with the number of partitions of the `RDD`)

`writeWithV2` prints out the following INFO message to the logs:

```text
Start processing data source write support: [batchWrite]. The input RDD has [n] partitions.
```

`writeWithV2` runs a Spark job ([Spark Core]({{ book.spark_core }}/SparkContext#runJob)) with the [DataWritingSparkTask](../connectors/DataWritingSparkTask.md#run) for every partition. `writeWithV2` requests the `BatchWrite` to [onDataWriterCommit](../connector/BatchWrite.md#onDataWriterCommit) (with the result `WriterCommitMessage`) after every partition has been processed successfully.

`writeWithV2` prints out the following INFO message to the logs:

```text
Data source write support [batchWrite] is committing.
```

`writeWithV2` requests the `BatchWrite` to [commit](../connector/BatchWrite.md#commit) (with all the result `WriterCommitMessage`s).

`writeWithV2` prints out the following INFO message to the logs:

```text
Data source write support [batchWrite] committed.
```

In the end, `writeWithV2` returns an empty collection (of `InternalRow`s).

---

`writeWithV2` is used when:

* `TableWriteExecHelper` is requested to [writeToTable](TableWriteExecHelper.md#writeToTable)
* `V2ExistingTableWriteExec` is [executed](V2ExistingTableWriteExec.md#run)
* `WriteToDataSourceV2Exec` ([Spark Structured Streaming]({{ book.structured_streaming }}/WriteToDataSourceV2Exec)) is executed

## Logging

`V2TableWriteExec` is a Scala trait and logging is configured using the logger of the [implementations](#implementations).
