# BatchScanExec Physical Operator

`BatchScanExec` is a [leaf physical operator](DataSourceV2ScanExecBase.md).

## Creating Instance

`BatchScanExec` takes the following to be created:

* <span id="output"> Output Schema ([AttributeReference](../expressions/AttributeReference.md)s)
* <span id="scan"> [Scan](../connector/Scan.md)

`BatchScanExec` is created when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (for physical operators with [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) relations)

## <span id="batch"> Batch

```scala
batch: Batch
```

`batch` requests the [Scan](#scan) to [toBatch](../connector/Scan.md#toBatch).

`batch` is used when:

* `BatchScanExec` is requested for [partitions](#partitions) and [readerFactory](#readerFactory)

## <span id="inputRDD"> Input RDD

```scala
inputRDD: RDD[InternalRow]
```

`inputRDD` is part of the [DataSourceV2ScanExecBase](DataSourceV2ScanExecBase.md#inputRDD) abstraction.

`inputRDD` creates a [DataSourceRDD](../DataSourceRDD.md).

## <span id="partitions"> InputPartitions

```scala
partitions: Seq[InputPartition]
```

`partitions` is part of the [DataSourceV2ScanExecBase](DataSourceV2ScanExecBase.md#partitions) abstraction.

`partitions`...FIXME

## <span id="readerFactory"> PartitionReaderFactory

```scala
readerFactory: PartitionReaderFactory
```

`readerFactory` is part of the [DataSourceV2ScanExecBase](DataSourceV2ScanExecBase.md#readerFactory) abstraction.

`readerFactory` requests the [Batch](#batch) to [createReaderFactory](../connector/Batch.md#createReaderFactory).
