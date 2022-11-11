# SupportsStreamingUpdate

`SupportsStreamingUpdate` is an [extension](#contract) of the [WriteBuilder](WriteBuilder.md) abstraction for [tables](#implementations) that support [streaming update](#update).

## Contract

### <span id="update"> Streaming Update

```scala
update(): WriteBuilder
```

[WriteBuilder](WriteBuilder.md)

Used when:

* `StreamExecution` stream execution engine (Spark Structured Streaming) is requested to `createStreamingWrite`

## Implementations

* ConsoleTable
* ForeachWriterTable
* [KafkaTable](../kafka/KafkaTable.md)
* MemorySink
* [NoopWriteBuilder](../datasources/noop/NoopWriteBuilder.md)
