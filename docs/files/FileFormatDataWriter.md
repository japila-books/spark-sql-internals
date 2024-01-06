# FileFormatDataWriter

`FileFormatDataWriter` is an [extension](#contract) of the [DataWriter](../connector/DataWriter.md) abstraction for [data writers](#implementations) (of [InternalRow](../InternalRow.md)s).

## Contract

### Writing Record Out { #write }

```scala
write(
  record: InternalRow): Unit
```

See:

* [DynamicPartitionDataConcurrentWriter](DynamicPartitionDataConcurrentWriter.md#write)
* [DynamicPartitionDataSingleWriter](DynamicPartitionDataSingleWriter.md#write)
* [SingleDirectoryDataWriter](SingleDirectoryDataWriter.md#write)

!!! note
    `write` is a concrete type variant of [DataWriter](../connector/DataWriter.md#write) (with `T` as [InternalRow](../InternalRow.md))

## Implementations

* [BaseDynamicPartitionDataWriter](BaseDynamicPartitionDataWriter.md)
* `EmptyDirectoryDataWriter`
* [SingleDirectoryDataWriter](SingleDirectoryDataWriter.md)

## Creating Instance

`FileFormatDataWriter` takes the following to be created:

* <span id="description"> `WriteJobDescription`
* <span id="taskAttemptContext"> `TaskAttemptContext` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/mapreduce/TaskAttemptContext.html))
* <span id="committer"> `FileCommitProtocol` ([Spark Core]({{ book.spark_core }}/FileCommitProtocol))
* <span id="customMetrics"> Custom [SQLMetric](../SQLMetric.md)s by name (`Map[String, SQLMetric]`)

!!! note "Abstract Class"
    `FileFormatDataWriter` is an abstract class and cannot be created directly. It is created indirectly for the [concrete FileFormatDataWriters](#implementations).

## writeWithMetrics { #writeWithMetrics }

```scala
writeWithMetrics(
  record: InternalRow,
  count: Long): Unit
```

`writeWithMetrics` updates the [CustomTaskMetrics](../connector/DataWriter.md#currentMetricsValues) with the [customMetrics](#customMetrics) and [writes out the given InternalRow](#write).

---

`writeWithMetrics` is used when:

* `FileFormatDataWriter` is requested to [write out (a collection of) records](#writeWithIterator)

## Writing Out (Collection of) Records { #writeWithIterator }

```scala
writeWithIterator(
  iterator: Iterator[InternalRow]): Unit
```

`writeWithIterator`...FIXME

---

`writeWithIterator` is used when:

* `FileFormatWriter` utility is used to [write data out in a single Spark task](FileFormatWriter.md#executeTask)

## Committing Successful Write { #commit }

??? note "DataWriter"

    ```scala
    commit(): WriteTaskResult
    ```

    `commit` is part of the [DataWriter](../connector/DataWriter.md#commit) abstraction.

`commit` [releaseResources](#releaseResources).

`commit` requests the [FileCommitProtocol](#committer) to `commitTask` (that gives a `TaskCommitMessage`).

`commit` creates a new `ExecutedWriteSummary` with the [updatedPartitions](#updatedPartitions) and the [WriteTaskStats](WriteTaskStatsTracker.md#getFinalStats) of the [WriteTaskStatsTrackers](#statsTrackers).

In the end, `commit` creates a `WriteTaskResult` (for the `TaskCommitMessage` and the `ExecutedWriteSummary`).
