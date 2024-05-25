---
title: DataSourceV2ScanExecBase
---

# DataSourceV2ScanExecBase Leaf Physical Operators

`DataSourceV2ScanExecBase` is an [extension](#contract) of [LeafExecNode](SparkPlan.md#LeafExecNode) abstraction for [leaf physical operators](#implementations) that [track number of output rows](#metrics) when executed ([with](#doExecuteColumnar) or [without](#doExecute) support for [columnar reads](#supportsColumnar)).

## Contract

### Input Partitions { #inputPartitions }

```scala
partitions: Seq[InputPartition]
```

See:

* [BatchScanExec](BatchScanExec.md#partitions)

Used when:

* `DataSourceV2ScanExecBase` is requested for the [partitions](#partitions), [groupedPartitions](#groupedPartitions), [supportsColumnar](#supportsColumnar)

### Input RDD { #inputRDD }

```scala
inputRDD: RDD[InternalRow]
```

See:

* [BatchScanExec](BatchScanExec.md#inputRDD)

### Custom Partitioning Expressions { #keyGroupedPartitioning }

```scala
keyGroupedPartitioning: Option[Seq[Expression]]
```

Optional partitioning [expression](../expressions/Expression.md)s (provided by [connectors](../connector/index.md) using [SupportsReportPartitioning](../connector/SupportsReportPartitioning.md))

See:

* [BatchScanExec](BatchScanExec.md#keyGroupedPartitioning)

??? note "Spark Structured Streaming Not Supported"
    `ContinuousScanExec` and `MicroBatchScanExec` physical operators are not supported (and have `keyGroupedPartitioning` undefined (`None`)).

Used when:

* `DataSourceV2ScanExecBase` is requested to [groupedPartitions](#groupedPartitions), [groupPartitions](#groupPartitions), [outputPartitioning](#outputPartitioning)

### PartitionReaderFactory { #readerFactory }

```scala
readerFactory: PartitionReaderFactory
```

[PartitionReaderFactory](../connector/PartitionReaderFactory.md) for partition readers (of the [input partitions](#inputPartitions))

See:

* [BatchScanExec](BatchScanExec.md#readerFactory)

Used when:

* `BatchScanExec` physical operator is requested for an [input RDD](BatchScanExec.md#inputRDD)
* `ContinuousScanExec` and `MicroBatchScanExec` physical operators (Spark Structured Streaming) are requested for an `inputRDD`
* `DataSourceV2ScanExecBase` physical operator is requested to [outputPartitioning](#outputPartitioning) or [supportsColumnar](#supportsColumnar)

### Scan

```scala
scan: Scan
```

[Scan](../connector/Scan.md)

## Implementations

* [BatchScanExec](BatchScanExec.md)
* `ContinuousScanExec` ([Spark Structured Streaming]({{ book.structured_streaming }}/physical-operators/ContinuousScanExec))
* `MicroBatchScanExec` ([Spark Structured Streaming]({{ book.structured_streaming }}/physical-operators/MicroBatchScanExec))

## Executing Physical Operator { #doExecute }

??? note "SparkPlan"

    ```scala
    doExecute(): RDD[InternalRow]
    ```

    `doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute`...FIXME

## doExecuteColumnar { #doExecuteColumnar }

??? note "SparkPlan"

    ```scala
    doExecuteColumnar(): RDD[ColumnarBatch]
    ```

    `doExecuteColumnar` is part of the [SparkPlan](SparkPlan.md#doExecuteColumnar) abstraction.

`doExecuteColumnar`...FIXME

## Performance Metrics { #metrics }

??? note "SparkPlan"

    ```scala
    metrics: Map[String, SQLMetric]
    ```

    `metrics` is part of the [SparkPlan](SparkPlan.md#metrics) abstraction.

`metrics` is the following [SQLMetric](../SQLMetric.md)s with the [customMetrics](#customMetrics):

Metric Name | web UI
------------|--------
 `numOutputRows` | number of output rows

## Output Data Partitioning { #outputPartitioning }

??? note "SparkPlan"

    ```scala
    outputPartitioning: physical.Partitioning
    ```

    `outputPartitioning` is part of the [SparkPlan](SparkPlan.md#outputPartitioning) abstraction.

`outputPartitioning`...FIXME

## Output Data Ordering { #outputOrdering }

??? note "QueryPlan"

    ```scala
    outputOrdering: Seq[SortOrder]
    ```

    `outputOrdering` is part of the [QueryPlan](../catalyst/QueryPlan.md#outputOrdering) abstraction.

`outputOrdering`...FIXME

## Simple Node Description { #simpleString }

??? note "TreeNode"

    ```scala
    simpleString(
        maxFields: Int): String
    ```

    `simpleString` is part of the [TreeNode](../catalyst/TreeNode.md#simpleString) abstraction.

`simpleString`...FIXME

## supportsColumnar { #supportsColumnar }

??? note "SparkPlan"

    ```scala
    supportsColumnar: Boolean
    ```

    `supportsColumnar` is part of the [SparkPlan](SparkPlan.md#supportsColumnar) abstraction.

`supportsColumnar` is `true` if the [PartitionReaderFactory](#readerFactory) can [supportColumnarReads](../connector/PartitionReaderFactory.md#supportColumnarReads) for all the [input partitions](#inputPartitions). Otherwise, `supportsColumnar` is `false`.

---

`supportsColumnar` makes sure that either all the [input partitions](#inputPartitions) are [supportColumnarReads](../connector/PartitionReaderFactory.md#supportColumnarReads) or none, or throws an `IllegalArgumentException`:

```text
Cannot mix row-based and columnar input partitions.
```

## Custom Metrics { #customMetrics }

```scala
customMetrics: Map[String, SQLMetric]
```

??? note "Lazy Value"
    `customMetrics` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`customMetrics` requests the [Scan](#scan) for [supportedCustomMetrics](../connector/Scan.md#supportedCustomMetrics) that are then converted to [SQLMetric](../SQLMetric.md)s.

---

`customMetrics` is used when:

* `DataSourceV2ScanExecBase` is requested for the [performance metrics](#metrics)
* `BatchScanExec` is requested for the [inputRDD](BatchScanExec.md#inputRDD)
* `ContinuousScanExec` is requested for the `inputRDD`
* `MicroBatchScanExec` is requested for the `inputRDD` (that creates a [DataSourceRDD](../DataSourceRDD.md))

## verboseStringWithOperatorId { #verboseStringWithOperatorId }

??? note "QueryPlan"

    ```scala
    verboseStringWithOperatorId(): String
    ```

    `verboseStringWithOperatorId` is part of the [QueryPlan](../catalyst/QueryPlan.md#verboseStringWithOperatorId) abstraction.

`verboseStringWithOperatorId` requests the [Scan](#scan) for one of the following (`metaDataStr`):

* [Metadata](#getMetaData) when [SupportsMetadata](../connector/SupportsMetadata.md)
* [Description](../connector/Scan.md#description), otherwise

In the end, `verboseStringWithOperatorId` is as follows (based on [formattedNodeName](../catalyst/QueryPlan.md#formattedNodeName) and [output](../catalyst/QueryPlan.md#output)):

```text
[formattedNodeName]
Output: [output]
[metaDataStr]
```

## Input Partitions { #partitions }

```scala
partitions: Seq[Seq[InputPartition]]
```

`partitions`...FIXME

---

`partitions` is used when:

* `BatchScanExec` physical operator is requested to [filteredPartitions](BatchScanExec.md#filteredPartitions)
* `ContinuousScanExec` physical operator ([Spark Structured Streaming]({{ book.structured_streaming }}/physical-operators/ContinuousScanExec)) is requested for the `inputRDD`
* `MicroBatchScanExec` physical operator ([Spark Structured Streaming]({{ book.structured_streaming }}/physical-operators/MicroBatchScanExec)) is requested for the `inputRDD`

## groupedPartitions { #groupedPartitions }

```scala
groupedPartitions: Option[Seq[(InternalRow, Seq[InputPartition])]]
```

??? note "Lazy Value"
    `groupedPartitions` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`groupedPartitions` takes the [keyGroupedPartitioning](#keyGroupedPartitioning), if specified, and [group](#groupPartitions) the [input partitions](#inputPartitions).

---

`groupedPartitions` is used when:

* `DataSourceV2ScanExecBase` physical operator is requested for the [output data ordering](#outputOrdering), [output data partitioning requirements](#outputPartitioning), [partitions](#partitions)

## groupPartitions { #groupPartitions }

```scala
groupPartitions(
  inputPartitions: Seq[InputPartition],
  groupSplits: Boolean = !conf.v2BucketingPushPartValuesEnabled || !conf.v2BucketingPartiallyClusteredDistributionEnabled): Option[Seq[(InternalRow, Seq[InputPartition])]]
```

!!! note "Noop"
    `groupPartitions` does nothing (and returns `None`) when called with [spark.sql.sources.v2.bucketing.enabled](../configuration-properties.md#spark.sql.sources.v2.bucketing.enabled) disabled.

`groupPartitions`...FIXME

---

`groupPartitions` is used when:

* `BatchScanExec` physical operator is requested for the [filtered input partitions](BatchScanExec.md#filteredPartitions) and [input RDD](BatchScanExec.md#inputRDD)
* `DataSourceV2ScanExecBase` is requested for the [groupedPartitions](#groupedPartitions)
