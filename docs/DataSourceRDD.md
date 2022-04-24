# DataSourceRDD

`DataSourceRDD` is a `RDD[InternalRow]` that acts as a thin adapter between Spark SQL's [DataSource V2](new-and-noteworthy/datasource-v2.md) and Spark Core's RDD API.

`DataSourceRDD` uses [DataSourceRDDPartition](DataSourceRDDPartition.md) for the [partitions](#getPartitions) (that is a mere wrapper of the [InputPartitions](#inputPartitions)).

## Creating Instance

`DataSourceRDD` takes the following to be created:

* <span id="sc"> `SparkContext`
* <span id="inputPartitions"> [InputPartition](connector/InputPartition.md)s
* <span id="partitionReaderFactory"> [PartitionReaderFactory](connector/PartitionReaderFactory.md)
* [columnarReads](#columnarReads) flag

`DataSourceRDD` is created when:

* `BatchScanExec` physical operator is requested for an [input RDD](physical-operators/BatchScanExec.md#inputRDD)
* `MicroBatchScanExec` (Spark Structured Streaming) physical operator is requested for an `inputRDD`

### <span id="columnarReads"> columnarReads Flag

`DataSourceRDD` is given `columnarReads` flag when [created](#creating-instance).

`columnarReads` is used to determine the type of scan (row-based or columnar) when [computing a partition](#compute).

`columnarReads` is enabled (using [supportsColumnar](physical-operators/DataSourceV2ScanExecBase.md#supportsColumnar)) when the [PartitionReaderFactory](physical-operators/DataSourceV2ScanExecBase.md#readerFactory) can [support columnar scans](connector/PartitionReaderFactory.md#supportColumnarReads).

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
