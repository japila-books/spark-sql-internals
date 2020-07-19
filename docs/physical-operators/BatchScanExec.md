# BatchScanExec Physical Operator

`BatchScanExec` is a [leaf physical operator](DataSourceV2ScanExecBase.md).

## Creating Instance

`BatchScanExec` takes the following to be created:

* <span id="output"> Output schema (`Seq[AttributeReference]`)
* <span id="scan"> [Scan](../connector/Scan.md)

`BatchScanExec` is created when `DataSourceV2Strategy` execution planning strategy is [executed](../execution-planning-strategies/DataSourceV2Strategy.md#apply) (for physical operators with `DataSourceV2ScanRelation` relations).

## <span id="batch"> batch

```scala
batch: Batch
```

`batch` requests the [Scan](#scan) to [toBatch](../connector/Scan.md#toBatch).

`batch` is used when requested for [partitions](#partitions) and [readerFactory](#readerFactory).

## <span id="inputRDD"> inputRDD

```scala
inputRDD: RDD[InternalRow]
```

`inputRDD` creates a [DataSourceRDD](../DataSourceRDD.md).

`inputRDD` is part of the [DataSourceV2ScanExecBase](DataSourceV2ScanExecBase.md#inputRDD) abstraction.

## <span id="partitions"> partitions

```scala
partitions: Seq[InputPartition]
```

`partitions`...FIXME

`partitions` is part of the [DataSourceV2ScanExecBase](DataSourceV2ScanExecBase.md#partitions) abstraction.

## <span id="readerFactory"> readerFactory

```scala
readerFactory: Seq[InputPartition]
```

`readerFactory`...FIXME

`readerFactory` is part of the [DataSourceV2ScanExecBase](DataSourceV2ScanExecBase.md#readerFactory) abstraction.
