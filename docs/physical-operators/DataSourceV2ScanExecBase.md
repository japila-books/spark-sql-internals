# DataSourceV2ScanExecBase Leaf Physical Operators

`DataSourceV2ScanExecBase` is an [extension](#contract) of [LeafExecNode](SparkPlan.md#LeafExecNode) abstraction for [leaf physical operators](#implementations) that [track number of output rows](#metrics) when executed ([with](#doExecuteColumnar) or [without](#doExecute) support for [columnar reads](#supportsColumnar)).

## Contract

### <span id="inputRDD"> Input RDD

```scala
inputRDD: RDD[InternalRow]
```

Used when...FIXME

### <span id="partitions"> InputPartitions

```scala
partitions: Seq[InputPartition]
```

Used when:

* `BatchScanExec` physical operator is requested for an [input RDD](BatchScanExec.md#inputRDD)

* `ContinuousScanExec` and `MicroBatchScanExec` physical operators (from Spark Structured Streaming) are requested for an `inputRDD`

* `DataSourceV2ScanExecBase` physical operator is requested to [outputPartitioning](#outputPartitioning) or [supportsColumnar](#supportsColumnar)

### <span id="readerFactory"> PartitionReaderFactory

```scala
readerFactory: PartitionReaderFactory
```

[PartitionReaderFactory](../connector/PartitionReaderFactory.md) for partition readers

Used when:

* `BatchScanExec` physical operator is requested for an [input RDD](BatchScanExec.md#inputRDD)

* `ContinuousScanExec` and `MicroBatchScanExec` physical operators (from Spark Structured Streaming) are requested for an `inputRDD`

* `DataSourceV2ScanExecBase` physical operator is requested to [outputPartitioning](#outputPartitioning) or [supportsColumnar](#supportsColumnar)

### <span id="scan"> Scan

```scala
scan: Scan
```

Used when...FIXME

## Implementations

* [BatchScanExec](BatchScanExec.md)
* _others_

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute`...FIXME

## <span id="doExecuteColumnar"> doExecuteColumnar

```scala
doExecuteColumnar(): RDD[ColumnarBatch]
```

`doExecuteColumnar` is part of the [SparkPlan](SparkPlan.md#doExecuteColumnar) abstraction.

`doExecuteColumnar`...FIXME

## <span id="inputRDDs"> inputRDDs

```scala
inputRDDs(): Seq[RDD[InternalRow]]
```

`inputRDDs`...FIXME

`inputRDDs` is used when...FIXME

## <span id="metrics"> Performance Metrics

```scala
metrics: Map[String, SQLMetric]
```

`metrics` is part of the [SparkPlan](SparkPlan.md#metrics) abstraction.

`metrics`...FIXME

## <span id="outputPartitioning"> Output Data Partitioning Requirements

```scala
outputPartitioning: physical.Partitioning
```

`outputPartitioning` is part of the [SparkPlan](SparkPlan.md#outputPartitioning) abstraction.

`outputPartitioning`...FIXME

## <span id="simpleString"> Simple Node Description

```scala
simpleString(
    maxFields: Int): String
```

`simpleString` is part of the [TreeNode](../catalyst/TreeNode.md#simpleString) abstraction.

`simpleString`...FIXME

## <span id="supportsColumnar"> supportsColumnar

```scala
supportsColumnar: Boolean
```

`supportsColumnar` is part of the [SparkPlan](SparkPlan.md#supportsColumnar) abstraction.

`supportsColumnar`...FIXME
