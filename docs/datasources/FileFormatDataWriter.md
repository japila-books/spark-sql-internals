# FileFormatDataWriter

`FileFormatDataWriter` is an [extension](#contract) of the [DataWriter](../connector/DataWriter.md) abstraction for [data writers](#implementations) (of [InternalRow](../InternalRow.md)s).

## Contract

### <span id="write"> Writing Record Out

```scala
write(
  record: InternalRow): Unit
```

Used when:

* `FileFormatDataWriter` is requested to [writeWithMetrics](#writeWithMetrics)

## Implementations

* `BaseDynamicPartitionDataWriter`
* `EmptyDirectoryDataWriter`
* [SingleDirectoryDataWriter](SingleDirectoryDataWriter.md)

## Creating Instance

`FileFormatDataWriter` takes the following to be created:

* <span id=""description"> `WriteJobDescription`
* <span id=""taskAttemptContext"> `TaskAttemptContext` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/mapreduce/TaskAttemptContext.html))
* <span id=""committer"> `FileCommitProtocol` ([Spark Core]({{ book.spark_core }}/FileCommitProtocol))
* <span id=""customMetrics"> Custom [SQLMetric](../physical-operators/SQLMetric.md)s by name (`Map[String, SQLMetric]`)

!!! note "Abstract Class"
    `FileFormatDataWriter` is an abstract class and cannot be created directly. It is created indirectly for the [concrete FileFormatDataWriters](#implementations).

## <span id="writeWithMetrics"> writeWithMetrics

```scala
writeWithMetrics(
  record: InternalRow,
  count: Long): Unit
```

`writeWithMetrics` updates the [CustomTaskMetrics](../connector/DataWriter.md#currentMetricsValues) with the [customMetrics](#customMetrics) and [writes out the given InternalRow](#write).

`writeWithMetrics` is used when:

* `FileFormatDataWriter` is requested to [write out (a collection of) records](#writeWithIterator)

## <span id="writeWithIterator"> Writing Out (Collection of) Records

```scala
writeWithIterator(
  iterator: Iterator[InternalRow]): Unit
```

`writeWithIterator`...FIXME

`writeWithIterator` is used when:

* `FileFormatWriter` utility is used to [write data out in a single Spark task](FileFormatWriter.md#executeTask)
