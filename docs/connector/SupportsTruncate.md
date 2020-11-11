# SupportsTruncate

`SupportsTruncate` is an [extension](#contract) of the [WriteBuilder](WriteBuilder.md) abstraction for [tables](#implementations) that support [truncation](#truncate).

## Contract

### <span id="truncate"> Truncation

```java
WriteBuilder truncate()
```

[WriteBuilder](WriteBuilder.md) that can replace all existing data with data committed in the write

Used when:

* [OverwriteByExpressionExec](../physical-operators/OverwriteByExpressionExec.md) and `OverwriteByExpressionExecV1` physical operators are executed
* `StreamExecution` stream execution engine (Spark Structured Streaming) is requested to `createStreamingWrite`

## Implementations

* ConsoleTable (Spark Structured Streaming)
* ForeachWriterTable (Spark Structured Streaming)
* [KafkaTable](../datasources/kafka/KafkaTable.md)
* MemorySink (Spark Structured Streaming)
* [NoopWriteBuilder](../datasources/noop/NoopWriteBuilder.md)
* [SupportsOverwrite](SupportsOverwrite.md)
