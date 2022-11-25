# BaseDynamicPartitionDataWriter

`BaseDynamicPartitionDataWriter` is an [extension](#contract) of the [FileFormatDataWriter](FileFormatDataWriter.md) abstraction for [dynamic partition writers](#implementations).

## Implementations

* [DynamicPartitionDataConcurrentWriter](DynamicPartitionDataConcurrentWriter.md)
* [DynamicPartitionDataSingleWriter](DynamicPartitionDataSingleWriter.md)

## Creating Instance

`BaseDynamicPartitionDataWriter` takes the following to be created:

* <span id="description"> `WriteJobDescription`
* <span id="taskAttemptContext"> `TaskAttemptContext` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/mapreduce/TaskAttemptContext.html))
* <span id="committer"> `FileCommitProtocol` ([Spark Core]({{ book.spark_core }}/FileCommitProtocol))
* <span id="customMetrics"> Custom [SQLMetric](../physical-operators/SQLMetric.md)s

!!! note "Abstract Class"
    `BaseDynamicPartitionDataWriter` is an abstract class and cannot be created directly. It is created indirectly for the [concrete BaseDynamicPartitionDataWriters](#implementations).

## <span id="renewCurrentWriter"> renewCurrentWriter

```scala
renewCurrentWriter(
  partitionValues: Option[InternalRow],
  bucketId: Option[Int],
  closeCurrentWriter: Boolean): Unit
```

`renewCurrentWriter`...FIXME

---

`renewCurrentWriter` is used when:

* `BaseDynamicPartitionDataWriter` is requested to [renewCurrentWriterIfTooManyRecords](#renewCurrentWriterIfTooManyRecords)
* `DynamicPartitionDataSingleWriter` is requested to [write a record](DynamicPartitionDataSingleWriter.md#write)
* `DynamicPartitionDataConcurrentWriter` is requested to [setupCurrentWriterUsingMap](DynamicPartitionDataConcurrentWriter.md#setupCurrentWriterUsingMap)

### <span id="getPartitionPath"> getPartitionPath

```scala
getPartitionPath: InternalRow => String
```

??? note "Lazy Value"
    `getPartitionPath` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`getPartitionPath`...FIXME

### <span id="partitionPathExpression"> partitionPathExpression

```scala
partitionPathExpression: Expression
```

??? note "Lazy Value"
    `partitionPathExpression` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`partitionPathExpression`...FIXME
