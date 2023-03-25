# Write

`Write` is an [abstraction](#contract) of [writers](#implementations).

## Contract

### <span id="description"> Description

```java
String description()
```

Defaults to the name of this `Write` class

Used when:

* `Write` is requested to [toBatch](#toBatch) and [toStreaming](#toStreaming) (for reporting purposes)

### <span id="supportedCustomMetrics"> Supported CustomMetrics

```java
CustomMetric[] supportedCustomMetrics()
```

Defaults to no [CustomMetric](CustomMetric.md)s

Used when:

* `V2ExistingTableWriteExec` is requested for [customMetrics](../physical-operators/V2ExistingTableWriteExec.md#customMetrics)
* `StreamExecution` ([Spark Structured Streaming]({{ book.structured_streaming }}/StreamExecution)) is requested for a `StreamingWrite`

### <span id="toBatch"> Creating BatchWrite

```java
BatchWrite toBatch()
```

`toBatch` throws an `UnsupportedOperationException` by default:

```text
[description]: Batch write is not supported
```

`toBatch` should be implemented for [Table](Table.md)s that create `Write`s that reports [BATCH_WRITE](TableCapability.md#BATCH_WRITE) support in their [capabilities](Table.md#capabilities).

Used when:

* `V2ExistingTableWriteExec` is requested to [run](../physical-operators/V2ExistingTableWriteExec.md#run)
* `TableWriteExecHelper` is requested to [writeToTable](../physical-operators/TableWriteExecHelper.md#writeToTable)

### <span id="toStreaming"> Creating StreamingWrite

```java
StreamingWrite toStreaming()
```

`toStreaming` throws an `UnsupportedOperationException` by default:

```text
[description]: Streaming write is not supported
```

`toStreaming` should be implemented for [Table](Table.md)s that create `Write`s that reports [STREAMING_WRITE](TableCapability.md#STREAMING_WRITE) support in their [capabilities](Table.md#capabilities).

Used when:

* `StreamExecution` ([Spark Structured Streaming]({{ book.structured_streaming }}/StreamExecution)) is requested for a `StreamingWrite`

## Implementations

* `ConsoleTable` (Spark Structured Streaming)
* [WriteBuilder](WriteBuilder.md)
* [FileWrite](../connectors/FileWrite.md)
* `ForeachWrite` (Spark Structured Streaming)
* [KafkaWrite](../kafka/KafkaWrite.md)
* `MemoryWrite` (Spark Structured Streaming)
* `NoopWrite`
* `RequiresDistributionAndOrdering`
* `V1Write`
