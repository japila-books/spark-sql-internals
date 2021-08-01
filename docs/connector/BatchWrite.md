# BatchWrite

`BatchWrite` is an [abstraction](#contract) of [writers](#implementations) to a batch data source.

## Contract

### <span id="abort"> Aborting Write

```java
void abort(
  WriterCommitMessage[] messages)
```

Used when:

* `V2TableWriteExec` physical command is requested to [writeWithV2](../physical-operators/V2TableWriteExec.md#writeWithV2)

### <span id="commit"> Committing Write

```java
void commit(
  WriterCommitMessage[] messages)
```

Used when:

* `V2TableWriteExec` physical command is requested to [writeWithV2](../physical-operators/V2TableWriteExec.md#writeWithV2)

### <span id="createBatchWriterFactory"> Creating DataWriterFactory

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

Used when:

* `V2TableWriteExec` physical command is requested to [writeWithV2](../physical-operators/V2TableWriteExec.md#writeWithV2)

### <span id="useCommitCoordinator"> useCommitCoordinator

```java
boolean useCommitCoordinator()
```

Default: `true`

Used when:

* `V2TableWriteExec` physical command is requested to [writeWithV2](../physical-operators/V2TableWriteExec.md#writeWithV2)

## Implementations

* [FileBatchWrite](../FileBatchWrite.md)
* [KafkaBatchWrite](../datasources/kafka/KafkaBatchWrite.md)
* MicroBatchWrite ([Spark Structured Streaming]({{ book.structured_streaming }}/micro-batch-execution/MicroBatchWriter))
* [NoopBatchWrite](../datasources/noop/NoopBatchWrite.md)
