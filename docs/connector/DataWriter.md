# DataWriter

`DataWriter` is an [abstraction](#contract) of [data writers](#implementations) (of data of type `T`).

## Contract

### <span id="abort"> Aborting Write

```java
void abort()
```

Used when:

* `FileFormatWriter` utility is used to [executeTask](../datasources/FileFormatWriter.md#executeTask)
* `DataWritingSparkTask` utility is used to [process a partition](../datasources/DataWritingSparkTask.md#run)
* `ContinuousWriteRDD` (Spark Structured Streaming) is requested to `compute` a partition

### <span id="commit"> Committing Successful Write

```java
WriterCommitMessage commit()
```

Used when:

* `DataWritingSparkTask` utility is used to [process a partition](../datasources/DataWritingSparkTask.md#run)
* `ContinuousWriteRDD` (Spark Structured Streaming) is requested to `compute` a partition

### <span id="currentMetricsValues"> currentMetricsValues

```java
CustomTaskMetric[] currentMetricsValues()
```

Used when:

* `FileFormatWriter` utility is used to [executeTask](../datasources/FileFormatWriter.md#executeTask)
* `DataWritingSparkTask` utility is used to [process a partition](../datasources/DataWritingSparkTask.md#run)
* `ContinuousWriteRDD` (Spark Structured Streaming) is requested to `compute` a partition

### <span id="write"> Writing Out Record

```java
void write(
  T record)
```

Used when:

* `DataWritingSparkTask` utility is used to [process a partition](../datasources/DataWritingSparkTask.md#run)
* `ContinuousWriteRDD` ([Spark Structured Streaming]({{ book.structured_streaming }}/ContinuousWriteRDD)) is requested to `compute` a partition

## Implementations

* [FileFormatDataWriter](../datasources/FileFormatDataWriter.md)
* `ForeachDataWriter` (Spark Structured Streaming)
* `KafkaDataWriter`
* `MemoryDataWriter` (Spark Structured Streaming)
* `NoopWriter`
* `PackedRowDataWriter` (Spark Structured Streaming)
