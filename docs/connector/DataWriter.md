# DataWriter

`DataWriter` is an [abstraction](#contract) of [data writers](#implementations) (of data of type `T`).

## Contract

### Aborting Write { #abort }

```java
void abort()
```

See:

* [KafkaDataWriter](../kafka/KafkaDataWriter.md#abort)

Used when:

* `FileFormatWriter` utility is used to [executeTask](../files/FileFormatWriter.md#executeTask)
* `DataWritingSparkTask` utility is used to [process a partition](../connectors/DataWritingSparkTask.md#run)
* `ContinuousWriteRDD` (Spark Structured Streaming) is requested to `compute` a partition

### Committing Successful Write { #commit }

```java
WriterCommitMessage commit()
```

See:

* [KafkaDataWriter](../kafka/KafkaDataWriter.md#commit)

Used when:

* `DataWritingSparkTask` utility is used to [process a partition](../connectors/DataWritingSparkTask.md#run)
* `ContinuousWriteRDD` (Spark Structured Streaming) is requested to `compute` a partition

### currentMetricsValues { #currentMetricsValues }

```java
CustomTaskMetric[] currentMetricsValues()
```

See:

* [KafkaDataWriter](../kafka/KafkaDataWriter.md#currentMetricsValues)

Used when:

* `FileFormatWriter` utility is used to [executeTask](../files/FileFormatWriter.md#executeTask)
* `DataWritingSparkTask` utility is used to [process a partition](../connectors/DataWritingSparkTask.md#run)
* `ContinuousWriteRDD` (Spark Structured Streaming) is requested to `compute` a partition

### Writing Out Record { #write }

```java
void write(
  T record)
```

See:

* [KafkaDataWriter](../kafka/KafkaDataWriter.md#write)

Used when:

* `DataWritingSparkTask` is requested to [write a record out](../connectors/DataWritingSparkTask.md#write)
* `ContinuousWriteRDD` ([Spark Structured Streaming]({{ book.structured_streaming }}/ContinuousWriteRDD)) is requested to `compute` a partition

## Implementations

* [FileFormatDataWriter](../files/FileFormatDataWriter.md)
* [KafkaDataWriter](../kafka/KafkaDataWriter.md)
* _others_
