# BatchScanExec Physical Operator

`BatchScanExec` is a [DataSourceV2ScanExecBase](DataSourceV2ScanExecBase.md) leaf physical operator for scanning a batch of data from a [data source v2](#scan).

## Creating Instance

`BatchScanExec` takes the following to be created:

* <span id="output"> Output Schema (`AttributeReference`s)
* <span id="scan"> [Scan](../connector/Scan.md)
* <span id="runtimeFilters"> Runtime Filters [Expression](../expressions/Expression.md)s
* <span id="keyGroupedPartitioning"> Key Grouped Partitioning (`Option[Seq[Expression]]`, default: `None`)

`BatchScanExec` is created when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (for physical operators with a [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) relation)

## <span id="batch"> Batch

```scala
batch: Batch
```

`batch` requests the [Scan](#scan) for a [physical representation for batch query](../connector/Scan.md#toBatch).

---

`batch` is used when:

* `BatchScanExec` is requested for [partitions](#partitions) and [readerFactory](#readerFactory)

## <span id="inputRDD"> Input RDD

```scala
inputRDD: RDD[InternalRow]
```

`inputRDD` is part of the [DataSourceV2ScanExecBase](DataSourceV2ScanExecBase.md#inputRDD) abstraction.

---

For no [filteredPartitions](#filteredPartitions) and the [outputPartitioning](DataSourceV2ScanExecBase.md#outputPartitioning) to be `SinglePartition`, `inputRDD` creates an empty `RDD[InternalRow]` with 1 partition.

Otherwise, `inputRDD` creates a [DataSourceRDD](../DataSourceRDD.md) as follows:

DataSourceRDD's Attribute | Value
--------------------------|------
 [InputPartitions](../DataSourceRDD.md#inputPartitions) | [filteredPartitions](#filteredPartitions)
 [PartitionReaderFactory](../DataSourceRDD.md#partitionReaderFactory) | [readerFactory](#readerFactory)
 [columnarReads](../DataSourceRDD.md#columnarReads) | [supportsColumnar](DataSourceV2ScanExecBase.md#supportsColumnar)
 [Custom Metrics](../DataSourceRDD.md#customMetrics) | [customMetrics](DataSourceV2ScanExecBase.md#customMetrics)

### <span id="filteredPartitions"> Filtered Input Partitions

```scala
filteredPartitions: Seq[Seq[InputPartition]]
```

??? note "Lazy Value"
    `filteredPartitions` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

For non-empty [runtimeFilters](#runtimeFilters), `filteredPartitions`...FIXME

Otherwise, `filteredPartitions` is the [partitions](DataSourceV2ScanExecBase.md#partitions) (that _usually_ is the [input partitions](#inputPartitions) of this `BatchScanExec`).

## <span id="inputPartitions"> Input Partitions

```scala
inputPartitions: Seq[InputPartition]
```

`inputPartitions` is part of the [DataSourceV2ScanExecBase](DataSourceV2ScanExecBase.md#inputPartitions) abstraction.

---

`inputPartitions` requests the [Batch](#batch) to [plan input partitions](../connector/Batch.md#planInputPartitions).

## <span id="readerFactory"> PartitionReaderFactory

```scala
readerFactory: PartitionReaderFactory
```

`readerFactory` is part of the [DataSourceV2ScanExecBase](DataSourceV2ScanExecBase.md#readerFactory) abstraction.

---

`readerFactory` requests the [Batch](#batch) to [createReaderFactory](../connector/Batch.md#createReaderFactory).
