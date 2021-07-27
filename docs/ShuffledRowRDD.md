# ShuffledRowRDD

`ShuffledRowRDD` is an `RDD` ([Spark Core]({{ book.spark_core }}/rdd/RDD)) of [InternalRow](InternalRow.md)s (`RDD[InternalRow]`) for execution of [CollectLimitExec](physical-operators/CollectLimitExec.md), [CustomShuffleReaderExec](physical-operators/CustomShuffleReaderExec.md), [ShuffleExchangeExec](physical-operators/ShuffleExchangeExec.md) and [TakeOrderedAndProjectExec](physical-operators/TakeOrderedAndProjectExec.md) physical operators.

!!! note
    `ShuffledRowRDD` is similar to `ShuffledRDD` ([Spark Core]({{ book.spark_core }}/rdd/ShuffledRDD)), with the difference of the type of the values to process, i.e. [InternalRow](InternalRow.md) and `(K, C)` key-value pairs, respectively.

## Creating Instance

`ShuffledRowRDD` takes the following to be created:

* <span id="dependency"> `ShuffleDependency[Int, InternalRow, InternalRow]` ([Spark Core]({{ book.spark_core }}/rdd/ShuffleDependency))
* <span id="metrics"> [SQLMetric](physical-operators/SQLMetric.md)s by name (`Map[String, SQLMetric]`)
* [Partition Specs](#partitionSpecs) (`Array[ShufflePartitionSpec]`)

When created, `ShuffledRowRDD` uses the [spark.sql.adaptive.fetchShuffleBlocksInBatch](configuration-properties.md#spark.sql.adaptive.fetchShuffleBlocksInBatch) configuration property to set the **__fetch_continuous_blocks_in_batch_enabled** local property to `true`.

`ShuffledRowRDD` is created when:

* [CollectLimitExec](physical-operators/CollectLimitExec.md), [ShuffleExchangeExec](physical-operators/ShuffleExchangeExec.md) and [TakeOrderedAndProjectExec](physical-operators/TakeOrderedAndProjectExec.md) physical operators are executed
* `ShuffleExchangeExec` is requested for a [shuffle RDD](physical-operators/ShuffleExchangeExec.md#getShuffleRDD) (for [CustomShuffleReaderExec](physical-operators/CustomShuffleReaderExec.md))

## <span id="compute"> Computing Partition

```scala
compute(
  split: Partition,
  context: TaskContext): Iterator[InternalRow]
```

`compute` is part of `RDD` ([Spark Core]({{ book.spark_core }}/rdd/RDD#compute)) abstraction.

`compute` requests the given `TaskContext` ([Spark Core]({{ book.spark_core }}/scheduler/TaskContext)) for the `TaskMetrics` ([Spark Core]({{ book.spark_core }}/executor/TaskMetrics)) that are in turn requested for a `TempShuffleReadMetrics`.

`compute` creates a `SQLShuffleReadMetricsReporter` (with the `TempShuffleReadMetrics` and the [SQL Metrics](#metrics)).

`compute` assumes that the given `Partition` ([Spark Core]({{ book.spark_core }}/rdd/Partition)) is a `ShuffledRowRDDPartition` and requests it for the `ShufflePartitionSpec`.

`compute` requests the `ShuffleManager` ([Spark Core]({{ book.spark_core }}/shuffle/ShuffleManager)) for a `ShuffleReader` ([Spark Core]({{ book.spark_core }}/shuffle/ShuffleReader)) based on the type of `ShufflePartitionSpec`:

1. `CoalescedPartitionSpec`
1. `PartialReducerPartitionSpec`
1. `PartialMapperPartitionSpec`

In the end, `compute` requests the `ShuffleReader` to read combined records (`Iterator[Product2[Int, InternalRow]]`) and takes out `InternalRow`s only.

## <span id="partitionSpecs"> Partition Specs

`ShuffledRowRDD` can be given a **Partition Specs** when [created](#creating-instance).

When not given, it is assumed to use as many `CoalescedPartitionSpec`s as the number of partitions of [ShuffleDependency](#dependency) (based on the `Partitioner`).

## <span id="getDependencies"> RDD Dependencies

```scala
getDependencies: Seq[Dependency[_]]
```

`getDependencies` is part of `RDD` ([Spark Core]({{ book.spark_core }}/rdd/RDD#getDependencies)) abstraction.

A single-element collection with `ShuffleDependency[Int, InternalRow, InternalRow]`.

## <span id="partitioner"> Partitioner

```scala
partitioner: Option[Partitioner]
```

`partitioner` is part of `RDD` ([Spark Core]({{ book.spark_core }}/rdd/RDD#partitioner)) abstraction.

`partitioner` is `CoalescedPartitioner` when the following all hold:

1. [Partition Specs](#partitionSpecs) are all `CoalescedPartitionSpec`
1. The `startReducerIndex`s of the `CoalescedPartitionSpec`s are all unique

Otherwise, `partitioner` is undefined (`None`).

## <span id="getPartitions"> Partitions

```scala
getPartitions: Array[Partition]
```

`getPartitions` is part of `RDD` ([Spark Core]({{ book.spark_core }}/rdd/RDD#getPartitions)) abstraction.

`getPartitions`...FIXME

## <span id="getPreferredLocations"> Preferred Locations of Partition

```scala
getPreferredLocations(
  partition: Partition): Seq[String]
```

`getPreferredLocations` is part of `RDD` ([Spark Core]({{ book.spark_core }}/rdd/RDD#getPreferredLocations)) abstraction.

`getPreferredLocations`...FIXME

## <span id="clearDependencies"> Clearing Dependencies

```scala
clearDependencies(): Unit
```

`clearDependencies` is part of `RDD` ([Spark Core]({{ book.spark_core }}/rdd/RDD#clearDependencies)) abstraction.

`clearDependencies` simply requests the parent RDD to `clearDependencies` followed by clear the given [dependency](#dependency) (i.e. set to `null`).
