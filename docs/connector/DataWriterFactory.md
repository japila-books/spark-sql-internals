# DataWriterFactory

`DataWriterFactory` is an [abstraction](#contract) of [DataWriter factories](#implementations).

`DataWriterFactory` is `Serializable`.

## Contract

### <span id="createWriter"> Creating DataWriter

```java
DataWriter<InternalRow> createWriter(
  int partitionId,
  long taskId)
```

Creates a [DataWriter](DataWriter.md) (for the given `partitionId` and `taskId`)

Used when:

* `DataWritingSparkTask` is requested to [run](../connectors/DataWritingSparkTask.md#run)

## Implementations

* [FileWriterFactory](../connectors/FileWriterFactory.md)
* `KafkaBatchWriterFactory`
* `MemoryWriterFactory` (Spark Structured Streaming)
* `MicroBatchWriterFactory` (Spark Structured Streaming)
* `NoopWriterFactory`
