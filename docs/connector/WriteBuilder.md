# WriteBuilder

`WriteBuilder` is an [abstraction](#contract) of [write builders](#implementations) for [batch](#buildForBatch) and [streaming](#buildForStreaming).

## Contract

### <span id="buildForBatch"> BatchWrite

```java
BatchWrite buildForBatch()
```

[BatchWrite](BatchWrite.md) for writing data to a batch source

Used when:

* [CreateTableAsSelectExec](../physical-operators/CreateTableAsSelectExec.md), `ReplaceTableAsSelectExec`, `AppendDataExec`, [OverwriteByExpressionExec](../physical-operators/OverwriteByExpressionExec.md), `OverwritePartitionsDynamicExec`, [AtomicTableWriteExec](../physical-operators/AtomicTableWriteExec.md) physical commands are executed

### <span id="buildForStreaming"> StreamingWrite

```java
StreamingWrite buildForStreaming()
```

`StreamingWrite` for writing data to a streaming source

Used when:

* `StreamExecution` stream execution engine ([Spark Structured Streaming]({{ book.structured_streaming }}/StreamExecution)) is requested to `createStreamingWrite`

## Implementations

* ConsoleTable (Spark Structured Streaming)
* ForeachWriterTable (Spark Structured Streaming)
* [KafkaTable](../datasources/kafka/KafkaTable.md)
* MemorySink (Spark Structured Streaming)
* [FileWriteBuilder](../FileWriteBuilder.md)
* [NoopWriteBuilder](../datasources/noop/NoopWriteBuilder.md)
* [SupportsDynamicOverwrite](SupportsDynamicOverwrite.md)
* [SupportsOverwrite](SupportsOverwrite.md)
* [SupportsStreamingUpdate](SupportsStreamingUpdate.md)
* [SupportsTruncate](SupportsTruncate.md)
* [V1WriteBuilder](V1WriteBuilder.md)
