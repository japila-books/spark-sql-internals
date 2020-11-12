# SupportsWrite

`SupportsWrite` is an [extension](#contract) of the [Table](Table.md) abstraction for [tables](#implementations) that are [writable](#newWriteBuilder).

## Contract

### <span id="newWriteBuilder"> newWriteBuilder

```java
WriteBuilder newWriteBuilder(
  LogicalWriteInfo info)
```

Creates a [WriteBuilder](WriteBuilder.md) for writing (batch and streaming)

Used when:

* `V1FallbackWriters` physical operator is requested to [newWriteBuilder](../physical-operators/V1FallbackWriters.md#newWriteBuilder)
* [CreateTableAsSelectExec](../physical-operators/CreateTableAsSelectExec.md), [ReplaceTableAsSelectExec](../physical-operators/ReplaceTableAsSelectExec.md) physical commands are executed
* `BatchWriteHelper` physical operator is requested to [newWriteBuilder](../physical-operators/BatchWriteHelper.md#newWriteBuilder)
* `AtomicTableWriteExec` physical command is requested to [writeToStagedTable](../physical-operators/AtomicTableWriteExec.md#writeToStagedTable)
* `StreamExecution` stream execution engine (Spark Structured Streaming) is requested to `createStreamingWrite`

## Implementations

* ConsoleTable (Spark Structured Streaming)
* [FileTable](FileTable.md)
* ForeachWriterTable (Spark Structured Streaming)
* [KafkaTable](../datasources/kafka/KafkaTable.md)
* MemorySink (Spark Structured Streaming)
* [NoopTable](../datasources/noop/NoopTable.md)
