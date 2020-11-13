# DataSourceRDD

`DataSourceRDD` is a `RDD[InternalRow]` that acts as a thin adapter between Spark SQL's [DataSource V2](new-and-noteworthy/datasource-v2.md) and Spark Core's RDD API.

`DataSourceRDD` uses [DataSourceRDDPartition](DataSourceRDDPartition.md) for the [partitions](#getPartitions) (that is a mere wrapper of the [InputPartitions](#inputPartitions)).

## Creating Instance

`DataSourceRDD` takes the following to be created:

* <span id="sc"> `SparkContext`
* <span id="inputPartitions"> [InputPartition](connector/InputPartition.md)s
* <span id="partitionReaderFactory"> [PartitionReaderFactory](connector/PartitionReaderFactory.md)
* <span id="columnarReads"> `columnarReads` flag

`DataSourceRDD` is created when:

* `BatchScanExec` physical operator is requested for an [input RDD](physical-operators/BatchScanExec.md#inputRDD)

* `MicroBatchScanExec` physical operator is requested for an `inputRDD`

## <span id="getPreferredLocations"> Preferred Locations For Partition

```scala
getPreferredLocations(
    split: Partition): Seq[String]
```

`getPreferredLocations` simply requests the given `split` [DataSourceRDDPartition](DataSourceRDDPartition.md) for the [InputPartition](DataSourceRDDPartition.md#inputPartition) that in turn is requested for the [preferred locations](connector/InputPartition.md#preferredLocations).

`getPreferredLocations` is part of Spark Core's `RDD` abstraction.

## <span id="getPartitions"> RDD Partitions

```scala
getPartitions: Array[Partition]
```

`getPartitions` simply creates a [DataSourceRDDPartition](DataSourceRDDPartition.md) for every <<inputPartitions, InputPartition>>.

`getPartitions` is part of Spark Core's `RDD` abstraction.

## <span id="compute"> Computing Partition (in TaskContext)

```scala
compute(
    split: Partition,
    context: TaskContext): Iterator[T]
```

`compute`...FIXME

`compute` is part of Spark Core's `RDD` abstraction.
