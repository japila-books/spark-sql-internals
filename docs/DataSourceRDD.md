# DataSourceRDD

`DataSourceRDD` is an RDD of [InternalRow](InternalRow.md)s (`RDD[InternalRow]`) that acts as a thin adapter between Spark SQL's [DataSource V2](new-and-noteworthy/datasource-v2.md) and Spark Core's RDD API.

`DataSourceRDD` is used as an [input RDD](physical-operators/DataSourceV2ScanExecBase.md#inputRDD) of the following physical operators:

* [BatchScanExec](physical-operators/BatchScanExec.md#inputRDD)
* `MicroBatchScanExec` ([Spark Structured Streaming]({{ book.structured_streaming }}/physical-operators/MicroBatchScanExec#inputRDD))

`DataSourceRDD` uses [DataSourceRDDPartition](DataSourceRDDPartition.md) for the [partitions](#getPartitions) (that is a mere wrapper of the [InputPartitions](#inputPartitions)).

## Creating Instance

`DataSourceRDD` takes the following to be created:

* <span id="sc"> `SparkContext` ([Spark Core]({{ book.spark_core }}/SparkContext))
* [InputPartitions](#inputPartitions)
* <span id="partitionReaderFactory"> [PartitionReaderFactory](connector/PartitionReaderFactory.md)
* [columnarReads](#columnarReads) flag
* <span id="customMetrics"> Custom [SQLMetric](SQLMetric.md)s

`DataSourceRDD` is created when:

* `BatchScanExec` physical operator is requested for an [input RDD](physical-operators/BatchScanExec.md#inputRDD)
* `MicroBatchScanExec` ([Spark Structured Streaming]({{ book.structured_streaming }}/physical-operators/MicroBatchScanExec)) physical operator is requested for an `inputRDD`

### <span id="inputPartitions"> InputPartitions

```scala
inputPartitions: Seq[Seq[InputPartition]]
```

`DataSourceRDD` is given a collection of [InputPartition](connector/InputPartition.md)s when [created](#creating-instance).

The `InputPartition`s are used to [create RDD partitions](#getPartitions) (one for every element in the `inputPartitions` collection)

!!! note
    Number of RDD partitions is exactly the number of elements in the `inputPartitions` collection.

The `InputPartition`s are the [filtered partitions](physical-operators/BatchScanExec.md#filteredPartitions) in [BatchScanExec](physical-operators/BatchScanExec.md).

### <span id="columnarReads"> columnarReads

`DataSourceRDD` is given `columnarReads` flag when [created](#creating-instance).

`columnarReads` is used to determine the type of scan (row-based or columnar) when [computing a partition](#compute).

`columnarReads` is enabled (using [supportsColumnar](physical-operators/DataSourceV2ScanExecBase.md#supportsColumnar)) when the [PartitionReaderFactory](physical-operators/DataSourceV2ScanExecBase.md#readerFactory) can [support columnar scans](connector/PartitionReaderFactory.md#supportColumnarReads).

## <span id="getPartitions"> RDD Partitions

```scala
getPartitions: Array[Partition]
```

`getPartitions` is part of `RDD` ([Spark Core]({{ book.spark_core }}/rdd/RDD#getPartitions)) abstraction.

---

`getPartitions` creates a [DataSourceRDDPartition](DataSourceRDDPartition.md) for every [InputPartition](#inputPartitions).

## <span id="getPreferredLocations"> Preferred Locations For Partition

```scala
getPreferredLocations(
    split: Partition): Seq[String]
```

`getPreferredLocations` is part of `RDD` ([Spark Core]({{ book.spark_core }}/rdd/RDD#getPreferredLocations)) abstraction.

---

`getPreferredLocations` assumes that the given `split` partition is a [DataSourceRDDPartition](DataSourceRDDPartition.md).

`getPreferredLocations` requests the given [DataSourceRDDPartition](DataSourceRDDPartition.md) for the [InputPartition](DataSourceRDDPartition.md#inputPartition) that is then requested for the [preferred locations](connector/InputPartition.md#preferredLocations).

## <span id="compute"> Computing Partition

```scala
compute(
  split: Partition,
  context: TaskContext): Iterator[T]
```

`compute` is part of `RDD` ([Spark Core]({{ book.spark_core }}/rdd/RDD#compute)) abstraction.

---

`compute`...FIXME
