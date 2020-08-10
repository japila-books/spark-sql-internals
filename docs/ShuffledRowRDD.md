# ShuffledRowRDD

`ShuffledRowRDD` is an `RDD` of [internal binary rows](spark-sql-InternalRow.md) (`RDD[InternalRow]`) for execution of [CollectLimitExec](physical-operators/CollectLimitExec.md), [CustomShuffleReaderExec](physical-operators/CustomShuffleReaderExec.md), [ShuffleExchangeExec](physical-operators/ShuffleExchangeExec.md) and [TakeOrderedAndProjectExec](physical-operators/TakeOrderedAndProjectExec.md) physical operators.

!!! note
    `ShuffledRowRDD` is similar to Spark Core's `ShuffledRDD`, with the difference of the type of the values to process, i.e. [InternalRow](spark-sql-InternalRow.md) and `(K, C)` key-value pairs, respectively.

## Creating Instance

`ShuffledRowRDD` takes the following to be created:

* <span id="dependency"> Spark Core's `ShuffleDependency[Int, InternalRow, InternalRow]`
* <span id="metrics"> [SQLMetric](physical-operators/SQLMetric.md)s by name (`Map[String, SQLMetric]`)
* [Optional Partition Specs](#partitionSpecs) (`Array[ShufflePartitionSpec]`)

When created, `ShuffledRowRDD` reads the [spark.sql.adaptive.fetchShuffleBlocksInBatch](spark-sql-properties.md#spark.sql.adaptive.fetchShuffleBlocksInBatch) configuration property, and when enabled, sets the **__fetch_continuous_blocks_in_batch_enabled** local property to `true`.

`ShuffledRowRDD` is created when [CollectLimitExec](physical-operators/CollectLimitExec.md), [CustomShuffleReaderExec](physical-operators/CustomShuffleReaderExec.md), [ShuffleExchangeExec](physical-operators/ShuffleExchangeExec.md) and [TakeOrderedAndProjectExec](physical-operators/TakeOrderedAndProjectExec.md) physical operators are executed.

## <span id="partitionSpecs"> Optional Partition Specs

`ShuffledRowRDD` is given an **Optional Partition Specs** when [created](#creating-instance).

When not given, it is assumed to use as many `CoalescedPartitionSpec`s as the number of partitions of [ShuffleDependency](#dependency) (based on the `Partitioner`).

## <span id="getDependencies"> RDD Dependencies

```scala
getDependencies: Seq[Dependency[_]]
```

A single-element collection with `ShuffleDependency[Int, InternalRow, InternalRow]`.

`getDependencies` is part of Spark Core's `RDD` abstraction.

## Partitioner

```scala
partitioner: Option[Partitioner]
```

`CoalescedPartitioner` (with the `Partitioner` of the `dependency`)

`partitioner` is part of Spark Core's `RDD` abstraction.

## <span id="getPartitions"> Partitions

```scala
getPartitions: Array[Partition]
```

`getPartitions`...FIXME

`getPartitions` is part of Spark Core's `RDD` abstraction.

## <span id="compute"> Computing Partition

```scala
compute(
  split: Partition,
  context: TaskContext): Iterator[InternalRow]
```

`compute`...FIXME

`compute` is part of Spark Core's `RDD` abstraction.

## <span id="getPreferredLocations"> Preferred Locations of Partition

```scala
getPreferredLocations(
  partition: Partition): Seq[String]
```

`getPreferredLocations`...FIXME

`getPreferredLocations` is part of Spark Core's `RDD` abstraction.

## <span id="clearDependencies"> Clearing Dependencies

```scala
clearDependencies(): Unit
```

`clearDependencies` simply requests the parent RDD to `clearDependencies` followed by clear the given <<dependency, dependency>> (i.e. set to `null`).

`clearDependencies` is part of Spark Core's `RDD` abstraction.
