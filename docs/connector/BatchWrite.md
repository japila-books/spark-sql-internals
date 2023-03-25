# BatchWrite

`BatchWrite` is an [abstraction](#contract) of [writers](#implementations) to a batch data source.

## Contract

### <span id="abort"> Aborting Write Job

```java
void abort(
  WriterCommitMessage[] messages)
```

Used when:

* `V2TableWriteExec` physical command is requested to [writeWithV2](../physical-operators/V2TableWriteExec.md#writeWithV2)

### <span id="commit"> Committing Write Job

```java
void commit(
  WriterCommitMessage[] messages)
```

Used when:

* `V2TableWriteExec` physical command is requested to [writeWithV2](../physical-operators/V2TableWriteExec.md#writeWithV2)

### <span id="createBatchWriterFactory"> Creating Batch DataWriterFactory

```java
DataWriterFactory createBatchWriterFactory(
  PhysicalWriteInfo info)
```

Used when:

* `V2TableWriteExec` physical command is requested to [writeWithV2](../physical-operators/V2TableWriteExec.md#writeWithV2)

### <span id="onDataWriterCommit"> onDataWriterCommit

```java
void onDataWriterCommit(
  WriterCommitMessage message)
```

`onDataWriterCommit` does nothing by default (_noop_).

Used when:

* `V2TableWriteExec` physical command is requested to [writeWithV2](../physical-operators/V2TableWriteExec.md#writeWithV2)

### <span id="useCommitCoordinator"> useCommitCoordinator

```java
boolean useCommitCoordinator()
```

Controls whether this writer requires a Commit Coordinator to coordinate writing tasks (and ensure that at most one task for each partition commits).

Default: `true`

Used when:

* `V2TableWriteExec` physical command is requested to [writeWithV2](../physical-operators/V2TableWriteExec.md#writeWithV2)

## Implementations

* [FileBatchWrite](../connectors/FileBatchWrite.md)
* [KafkaBatchWrite](../kafka/KafkaBatchWrite.md)
* MicroBatchWrite ([Spark Structured Streaming]({{ book.structured_streaming }}/micro-batch-execution/MicroBatchWriter))
* [NoopBatchWrite](../noop/NoopBatchWrite.md)
