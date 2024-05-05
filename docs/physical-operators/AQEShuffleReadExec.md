---
title: AQEShuffleReadExec
---

# AQEShuffleReadExec Physical Operator

`AQEShuffleReadExec` is a [unary physical operator](UnaryExecNode.md) in [Adaptive Query Execution](../adaptive-query-execution/index.md).

## Creating Instance

`AQEShuffleReadExec` takes the following to be created:

* [Child physical operator](#child)
* <span id="partitionSpecs"> `ShufflePartitionSpec`s (requires at least one partition)

`AQEShuffleReadExec` is created when the following adaptive physical optimizations are executed:

* [CoalesceShufflePartitions](../physical-optimizations/CoalesceShufflePartitions.md#updateShuffleReads)
* [OptimizeShuffleWithLocalRead](../physical-optimizations/OptimizeShuffleWithLocalRead.md#createLocalRead)
* [OptimizeSkewedJoin](../physical-optimizations/OptimizeSkewedJoin.md#tryOptimizeJoinChildren)
* [OptimizeSkewInRebalancePartitions](../physical-optimizations/OptimizeSkewInRebalancePartitions.md#tryOptimizeSkewedPartitions)

## <span id="metrics"> Performance Metrics

`metrics` is part of the [SparkPlan](SparkPlan.md#metrics) abstraction.

---

`metrics` is defined only when the [shuffleStage](#shuffleStage) is defined.

??? note "Lazy Value"
    `metrics` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

### <span id="numCoalescedPartitions"> number of coalesced partitions

Only when [hasCoalescedPartition](#hasCoalescedPartition)

### <span id="numPartitions"> number of partitions

### <span id="numSkewedSplits"> number of skewed partition splits

Only when [hasSkewedPartition](#hasSkewedPartition)

### <span id="numSkewedPartitions"> number of skewed partitions

Only when [hasSkewedPartition](#hasSkewedPartition)

### <span id="partitionDataSize"> partition data size

Only when non-[isLocalRead](#isLocalRead)

## <span id="child"><span id="shuffleStage"> Child ShuffleQueryStageExec

```scala
shuffleStage: Option[ShuffleQueryStageExec]
```

`AQEShuffleReadExec` is given a child [physical operator](SparkPlan.md) when [created](#creating-instance).

When requested for a [ShuffleQueryStageExec](ShuffleQueryStageExec.md), `AQEShuffleReadExec` returns the child physical operator (if that is its type or returns `None`).

`shuffleStage` is used when:

* `AQEShuffleReadExec` is requested for the [partitionDataSizes](#partitionDataSizes), the [performance metrics](#metrics) and the [shuffleRDD](#shuffleRDD)

## <span id="shuffleRDD"> Shuffle RDD

```scala
shuffleRDD: RDD[_]
```

`shuffleRDD` [updates the performance metrics](#sendDriverMetrics) and requests the [shuffleStage](#shuffleStage) for the [ShuffleExchangeLike](#shuffle) that in turn is requested for the [shuffle RDD](ShuffleExchangeLike.md#getShuffleRDD) (with the [ShufflePartitionSpecs](#partitionSpecs)).

??? note "Lazy Value"
    `shuffleRDD` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`shuffleRDD` is used when:

* `AQEShuffleReadExec` operator is requested to [doExecute](#doExecute) and [doExecuteColumnar](#doExecuteColumnar)

### <span id="sendDriverMetrics"> Updating Performance Metrics

```scala
sendDriverMetrics(): Unit
```

`sendDriverMetrics` posts a `SparkListenerDriverAccumUpdates` (with the query execution id and performance metrics).

### <span id="partitionDataSizes"> Partition Data Sizes

```scala
partitionDataSizes: Option[Seq[Long]]
```

`partitionDataSizes`...FIXME

??? note "Lazy Value"
    `partitionDataSizes` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

---

`doExecute` returns the [Shuffle RDD](#shuffleRDD).

## <span id="doExecuteColumnar"> Columnar Execution

```scala
doExecuteColumnar(): RDD[ColumnarBatch]
```

`doExecuteColumnar` is part of the [SparkPlan](SparkPlan.md#doExecuteColumnar) abstraction.

---

`doExecuteColumnar` returns the [Shuffle RDD](#shuffleRDD).

## <span id="stringArgs"> Node Arguments

```scala
stringArgs: Iterator[Any]
```

`stringArgs` is part of the [TreeNode](../catalyst/TreeNode.md#stringArgs) abstraction.

---

`stringArgs` is one of the following:

* `local` when [isLocalRead](#isLocalRead)
* `coalesced and skewed` when [hasCoalescedPartition](#hasCoalescedPartition) and [hasSkewedPartition](#hasSkewedPartition)
* `coalesced` when [hasCoalescedPartition](#hasCoalescedPartition)
* `skewed` when [hasSkewedPartition](#hasSkewedPartition)

## <span id="isLocalRead"> isLocalRead

```scala
isLocalRead: Boolean
```

`isLocalRead` indicates whether either `PartialMapperPartitionSpec` or `CoalescedMapperPartitionSpec` are among the [partition specs](#partitionSpecs) or not.

---

`isLocalRead` is used when:

* `AQEShuffleReadExec` is requested for the [node arguments](#stringArgs), the [partition data sizes](#partitionDataSizes) and the [performance metrics](#metrics)

## <span id="isCoalescedRead"> isCoalescedRead

```scala
isCoalescedRead: Boolean
```

`isCoalescedRead` indicates **coalesced shuffle read** and is whether the [partition specs](#partitionSpecs) are all `CoalescedPartitionSpec`s pair-wise (with the `endReducerIndex` and `startReducerIndex` being adjacent) or not.

---

`isCoalescedRead` is used when:

* `AQEShuffleReadExec` is requested for the [outputPartitioning](#outputPartitioning)

## <span id="hasCoalescedPartition"> hasCoalescedPartition

```scala
hasCoalescedPartition: Boolean
```

`hasCoalescedPartition` is `true` when there is a [CoalescedSpec](#isCoalescedSpec) among the [ShufflePartitionSpecs](#partitionSpecs).

---

`hasCoalescedPartition` is used when:

* `AQEShuffleReadExec` is requested for the [stringArgs](#stringArgs), [sendDriverMetrics](#sendDriverMetrics), and [metrics](#metrics)

## <span id="isCoalescedSpec"> isCoalescedSpec

```scala
isCoalescedSpec(
  spec: ShufflePartitionSpec)
```

`isCoalescedSpec` is `true` when the given `ShufflePartitionSpec` is one of the following:

* `CoalescedPartitionSpec` (with both `startReducerIndex` and `endReducerIndex` as `0`s)
* `CoalescedPartitionSpec` with `endReducerIndex` larger than `startReducerIndex`

Otherwise, `isCoalescedSpec` is `false`.

---

`isCoalescedSpec` is used when:

* `AQEShuffleReadExec` is requested to [hasCoalescedPartition](#hasCoalescedPartition) and [sendDriverMetrics](#sendDriverMetrics)
