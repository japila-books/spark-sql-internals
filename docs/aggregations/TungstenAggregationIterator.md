# TungstenAggregationIterator

`TungstenAggregationIterator` is an [AggregationIterator](AggregationIterator.md) for [HashAggregateExec](../physical-operators/HashAggregateExec.md) physical operator.

`TungstenAggregationIterator` starts [hash-based before switching to sort-based aggregation](#sortBased)

## Lifecycle

`TungstenAggregationIterator` is created for `HashAggregateExec` physical operator when [executed](../physical-operators/HashAggregateExec.md#doExecute) with a non-empty partition or [groupingExpressions](../physical-operators/HashAggregateExec.md#groupingExpressions) are not specified.

There is one `TungstenAggregationIterator` created per partition of `HashAggregateExec` physical operator.

`TungstenAggregationIterator` immediately initializes the internal registries:

* [Spill Size Before Execution](#spillSizeBefore)
* [Initial Aggregation Buffer](#initialAggregationBuffer)
* [UnsafeFixedWidthAggregationMap](#hashMap)
* [Sort-Based Aggregation Buffer](#sortBasedAggregationBuffer)

`TungstenAggregationIterator` immediately [starts processing input rows](#processInputs) and, if not [switched to sort-based aggregation](#sortBased), initializes the other internal registries:

* [Aggregation Buffer KVIterator](#aggregationBufferMapIterator)
* [mapIteratorHasNext](#mapIteratorHasNext)

`TungstenAggregationIterator` frees up the memory associated with [UnsafeFixedWidthAggregationMap](#hashMap) if [the map is empty](#mapIteratorHasNext).

`TungstenAggregationIterator` registers a [task completion listener](#TaskCompletionListener) that is executed at the end of this task.

`TungstenAggregationIterator` is an `Iterator[UnsafeRow]` (indirectly as a [AggregationIterator](AggregationIterator.md)) and so is a data structure that allows to iterate over a sequence of `UnsafeRow`s.
The sequence of `UnsafeRow`s is partition data.

As with any `Iterator`, `TungstenAggregationIterator` comes with the following:

* [hasNext](#hasNext) method for checking if there is a next row available
* [next](#next) method which returns the next row and advances itself

### TaskCompletionListener { #TaskCompletionListener }

`TungstenAggregationIterator` registers a `TaskCompletionListener` that is executed at the end of this task (one per partition).

When executed, the `TaskCompletionListener` updates the metrics.

 Metric | Value
--------|------
 [peakMemory](#peakMemory) | The maximum of the [getPeakMemoryUsedBytes](UnsafeFixedWidthAggregationMap.md#getPeakMemoryUsedBytes) of this [UnsafeFixedWidthAggregationMap](#hashMap) and the [getPeakMemoryUsedBytes](UnsafeKVExternalSorter.md#getPeakMemoryUsedBytes) of this [UnsafeKVExternalSorter](#externalSorter) for sort-based aggregation, if a switch happened
 [spillSize](#spillSize) |
 [avgHashProbe](#avgHashProbe) | The [getAvgHashProbesPerKey](UnsafeFixedWidthAggregationMap.md#getAvgHashProbesPerKey) of this [UnsafeFixedWidthAggregationMap](#hashMap)

The `TaskCompletionListener` requests the `TaskMetrics` ([Spark Core]({{ book.spark_core }}/executor/TaskMetrics/)) to `incPeakExecutionMemory`.

## Creating Instance

`TungstenAggregationIterator` takes the following to be created:

* <span id="partIndex"> Partition ID
* <span id="groupingExpressions"> Grouping [Named Expression](../expressions/NamedExpression.md)s
* <span id="aggregateExpressions"> [AggregateExpression](../expressions/AggregateExpression.md)s
* <span id="aggregateAttributes"> Aggregate [Attribute](../expressions/Attribute.md)s
* <span id="initialInputBufferOffset"> Initial input buffer offset
* <span id="resultExpressions"> Result [NamedExpression](../expressions/NamedExpression.md)s
* <span id="newMutableProjection"> Function to create a new `MutableProjection` given expressions and attributes (`(Seq[Expression], Seq[Attribute]) => MutableProjection`)
* <span id="originalInputAttributes"> Original Input [Attribute](../expressions/Attribute.md)s
* <span id="inputIter"> Input Iterator of [InternalRow](../InternalRow.md)s (from a single partition of the [child](../physical-operators/HashAggregateExec.md#child) of the [HashAggregateExec](../physical-operators/HashAggregateExec.md) physical operator)
* <span id="testFallbackStartsAt"> (only for testing) Optional `HashAggregateExec`'s [testFallbackStartsAt](../physical-operators/HashAggregateExec.md#testFallbackStartsAt)
* <span id="numOutputRows"> `numOutputRows` [SQLMetric](../SQLMetric.md)
* <span id="peakMemory"> `peakMemory` [SQLMetric](../SQLMetric.md)
* <span id="spillSize"> `spillSize` [SQLMetric](../SQLMetric.md)
* <span id="avgHashProbe"> `avgHashProbe` [SQLMetric](../SQLMetric.md)
* [numTasksFallBacked](#numTasksFallBacked) metric

`TungstenAggregationIterator` is created when:

* `HashAggregateExec` physical operator is [executed](../physical-operators/HashAggregateExec.md#doExecute)

`TungstenAggregationIterator` starts [processing input rows](#processInputs) and pre-loads the first key-value pair from the [UnsafeFixedWidthAggregationMap](#hashMap) unless [switched to a sort-based aggregation](#sortBased).

## <span id="metrics"> Performance Metrics

When [created](#creating-instance), `TungstenAggregationIterator` gets [SQLMetric](../SQLMetric.md)s from the [HashAggregateExec](../physical-operators/HashAggregateExec.md#metrics) aggregate physical operator being executed.

* [numOutputRows](#numOutputRows) is used when `TungstenAggregationIterator` is requested for the [next UnsafeRow](#next) (and it [has one](#hasNext))

* [peakMemory](#peakMemory), [spillSize](#spillSize) and [avgHashProbe](#avgHashProbe) are used at the [end of every task](#TaskCompletionListener) (one per partition)

The metrics are displayed as part of [HashAggregateExec](../physical-operators/HashAggregateExec.md) aggregate physical operator (e.g. in web UI in [Details for Query](../ui/SQLTab.md#ExecutionPage)).

![HashAggregateExec in web UI (Details for Query)](../images/HashAggregateExec-webui-details-for-query.png)

### number of sort fallback tasks { #numTasksFallBacked }

`TungstenAggregationIterator` is given **number of sort fallback tasks** [SQLMetric](../SQLMetric.md) when [created](#creating-instance).

The metric is [number of sort fallback tasks](../physical-operators/HashAggregateExec.md#numTasksFallBacked) metric of the owning [HashAggregateExec](../physical-operators/HashAggregateExec.md) physical operator.

The metric is incremented only when `TungstenAggregationIterator` is requested to [fall back to sort-based aggregation](#switchToSortBasedAggregation).

## Checking for Next Row Available { #hasNext }

??? note "Iterator"

    ```scala
    hasNext
    ```

    `hasNext` is part of the `Iterator` ([Scala]({{ scala.api }}/scala/collection/Iterator.html#hasNext:Boolean)) abstraction.

`hasNext` is enabled (`true`) when one of the following holds:

1. Either this `TungstenAggregationIterator` is [sort-based](#sortBased) and [sortedInputHasNewGroup](#sortedInputHasNewGroup)
1. Or this `TungstenAggregationIterator` is not [sort-based](#sortBased) and [mapIteratorHasNext](#mapIteratorHasNext)

## Next Row { #next }

??? note "Iterator"

    ```scala
    next(): UnsafeRow
    ```

    `next` is part of the `Iterator` ([Scala]({{ scala.api }}/scala/collection/Iterator.html#next():A)) abstraction.

`next`...FIXME

### processCurrentSortedGroup { #processCurrentSortedGroup }

```scala
processCurrentSortedGroup(): Unit
```

`processCurrentSortedGroup`...FIXME

## <span id="hashMap"> UnsafeFixedWidthAggregationMap

When [created](#creating-instance), `TungstenAggregationIterator` creates an [UnsafeFixedWidthAggregationMap](../aggregations/UnsafeFixedWidthAggregationMap.md) with the following:

* [initialAggregationBuffer](#initialAggregationBuffer)
* [Schema](../types/StructType.md#fromAttributes) built from the [attributes of the aggregation buffers](../expressions/AggregateFunction.md#aggBufferAttributes) of all the [AggregateFunctions](AggregationIterator.md#aggregateFunctions)
* [Schema](../types/StructType.md#fromAttributes) built from the [attributes](../expressions/NamedExpression.md#toAttribute) of all the [grouping expressions](#groupingExpressions)

Used when:

* `TungstenAggregationIterator` is requested for the [next UnsafeRow](#next), to [outputForEmptyGroupingKeyWithoutInput](#outputForEmptyGroupingKeyWithoutInput), [process input rows](#processInputs), to initialize the [aggregationBufferMapIterator](#aggregationBufferMapIterator) and [every time a partition has been processed](#TaskCompletionListener)

## <span id="outputForEmptyGroupingKeyWithoutInput"> outputForEmptyGroupingKeyWithoutInput

```scala
outputForEmptyGroupingKeyWithoutInput(): UnsafeRow
```

`outputForEmptyGroupingKeyWithoutInput`...FIXME

---

`outputForEmptyGroupingKeyWithoutInput` is used when:

* `HashAggregateExec` physical operator is requested to [execute](../physical-operators/HashAggregateExec.md#doExecute) (with no input rows and grouping expressions)

## Hash- vs Sort-Based Aggregations { #sortBased }

```scala
sortBased: Boolean = false
```

`TungstenAggregationIterator` turns `sortBased` flag off (`false`) when [created](#creating-instance).

The flag indicates whether `TungstenAggregationIterator` has [switched (fallen back) to sort-based aggregation](#switchToSortBasedAggregation) while [processing input rows](#processInputs).

`sortBased` flag is turned on (`true`) at the end of [switching to sort-based aggregation](#switchToSortBasedAggregation) (alongside incrementing [number of sort fallback tasks](#numTasksFallBacked) metric).

Switching from hash-based to sort-based aggregation happens when the [external sorter](#externalSorter) is initialized (that is used for sort-based aggregation).

## initialAggregationBuffer { #initialAggregationBuffer }

```scala
initialAggregationBuffer: UnsafeRow
```

`TungstenAggregationIterator` initializes `initialAggregationBuffer` (as a [new UnsafeRow](#createNewAggregationBuffer)) when [created](#creating-instance).

`initialAggregationBuffer` is used as the [emptyAggregationBuffer](UnsafeFixedWidthAggregationMap.md#emptyAggregationBuffer) of the [UnsafeFixedWidthAggregationMap](#hashMap).

When requested for [next row](#next) in [sortBased](#sortBased) aggregation, `TungstenAggregationIterator` copies the `initialAggregationBuffer` to the [sortBasedAggregationBuffer](#sortBasedAggregationBuffer).

When requested to [outputForEmptyGroupingKeyWithoutInput](#outputForEmptyGroupingKeyWithoutInput) with no [groupingExpressions](#groupingExpressions), `TungstenAggregationIterator` copies the `initialAggregationBuffer` to the [sortBasedAggregationBuffer](#sortBasedAggregationBuffer).

## sortBasedAggregationBuffer { #sortBasedAggregationBuffer }

```scala
sortBasedAggregationBuffer: UnsafeRow
```

`TungstenAggregationIterator` initializes `sortBasedAggregationBuffer` (as a [new UnsafeRow](#createNewAggregationBuffer)) when [created](#creating-instance).

## createNewAggregationBuffer { #createNewAggregationBuffer }

```scala
createNewAggregationBuffer(): UnsafeRow
```

`createNewAggregationBuffer` creates an [UnsafeRow](../UnsafeRow.md).

---

`createNewAggregationBuffer`...FIXME

---

`createNewAggregationBuffer` is used when:

* `TungstenAggregationIterator` is created (and creates the [initialAggregationBuffer](#initialAggregationBuffer) and [sortBasedAggregationBuffer](#sortBasedAggregationBuffer) buffers)

## Processing Input Rows { #processInputs }

```scala
processInputs(
  fallbackStartsAt: (Int, Int)): Unit
```

!!! note "Procedure"
    `processInputs` returns `Unit` (_nothing_) and whatever happens inside stays inside (just like in Las Vegas, _doesn't it?!_ 😉)

`processInputs` is used when:

* `TungstenAggregationIterator` is [created](#creating-instance)

---

`processInputs` branches off based on the [grouping expressions](#groupingExpressions), [specified](#processInputs-grouping-expressions-specified) or [not](#processInputs-no-grouping-expressions).

### Grouping Expressions Specified { #processInputs-grouping-expressions-specified }

`processInputs`...FIXME

### No Grouping Expressions { #processInputs-no-grouping-expressions }

With no [grouping expressions](#groupingExpressions), `processInputs` generates one single grouping key (an [UnsafeRow](../UnsafeRow.md)) for [all the partition rows](#inputIter). `processInputs` executes ([applies](../expressions/UnsafeProjection.md#apply)) the [grouping projection](#groupingProjection) to a `null` (_undefined_) row.

`processInputs` [looks up the aggregation buffer](UnsafeFixedWidthAggregationMap.md#getAggregationBufferFromUnsafeRow) ([UnsafeRow](../UnsafeRow.md)) in the [UnsafeFixedWidthAggregationMap](#hashMap) for the generated grouping key.

In the end, for every `InternalRow` in the [inputIter](#inputIter), `processInputs` [processRow](AggregationIterator.md#processRow) one by one (with the same aggregation buffer).

### Falling Back to Sort-Based Aggregation { #switchToSortBasedAggregation }

```scala
switchToSortBasedAggregation(): Unit
```

!!! note "Procedure"
    `switchToSortBasedAggregation` returns `Unit` (_nothing_) and whatever happens inside stays inside (just like in Las Vegas, _doesn't it?!_ 😉)

`switchToSortBasedAggregation` prints out the following INFO message to the logs:

```text
falling back to sort based aggregation.
```

`switchToSortBasedAggregation` initializes the [sortBasedProcessRow](#sortBasedProcessRow) to be [generateProcessRow](AggregationIterator.md#generateProcessRow) with the `newExpressions`, `newFunctions`, `newInputAttributes`:

* `newExpressions` is this [AggregateExpressions](#aggregateExpressions) with the [AggregateExpression](../expressions/AggregateExpression.md)s in `Partial` or `Complete` [aggregation mode](../expressions/AggregateExpression.md#mode)s changed to `PartialMerge` or `Final`, respectively
* `newFunctions` is [initializeAggregateFunctions](#initializeAggregateFunctions) with the `newExpressions` and `startingInputBufferOffset` as `0`
* `newInputAttributes` is the [inputAggBufferAttributes](../expressions/AggregateFunction.md#inputAggBufferAttributes) of the `newFunctions` aggregate functions

`switchToSortBasedAggregation` initializes the [sortedKVIterator](#sortedKVIterator) to be the [KVSorterIterator](UnsafeKVExternalSorter.md#sortedIterator) of this [UnsafeKVExternalSorter](#externalSorter).

`switchToSortBasedAggregation` pre-loads the first key-value pair from the sorted iterator (to make [hasNext](#hasNext) idempotent).
`switchToSortBasedAggregation` requests this [UnsafeKVExternalSorter](#sortedKVIterator) if there is [next element](KVSorterIterator.md#next) and stores the answer in this [sortedInputHasNewGroup](#sortedInputHasNewGroup).

With [sortedInputHasNewGroup](#sortedInputHasNewGroup) enabled (`true`), `switchToSortBasedAggregation`...FIXME

In the end, `switchToSortBasedAggregation` turns this [sortBased](#sortBased) flag on and increments [number of sort fallback tasks](#numTasksFallBacked) metric.

## mapIteratorHasNext { #mapIteratorHasNext }

```scala
var mapIteratorHasNext: Boolean = false
```

`mapIteratorHasNext` is an internal variable that starts disabled (`false`) when `TungstenAggregationIterator` is [created](#creating-instance).

`TungstenAggregationIterator` uses `mapIteratorHasNext` for hash-based aggregation (not [sort-based](#sortBased)) to indicate whether the [aggregationBufferMapIterator](#aggregationBufferMapIterator) has next key-value pair or not when:

* [Created](#creating-instance)
* Requested for [next row](#next)

`mapIteratorHasNext` is used to pre-load next key-value pair form [aggregationBufferMapIterator](#aggregationBufferMapIterator) to make [hasNext](#hasNext) idempotent.

`mapIteratorHasNext` is also used to control whether to free up the memory associated with the [UnsafeFixedWidthAggregationMap](#hashMap) when still in [hash-based](#sortBased) processing mode.

## Demo

```text
val q = spark.range(10).
  groupBy('id % 2 as "group").
  agg(sum("id") as "sum")
val execPlan = q.queryExecution.sparkPlan
scala> println(execPlan.numberedTreeString)
00 HashAggregate(keys=[(id#0L % 2)#11L], functions=[sum(id#0L)], output=[group#3L, sum#7L])
01 +- HashAggregate(keys=[(id#0L % 2) AS (id#0L % 2)#11L], functions=[partial_sum(id#0L)], output=[(id#0L % 2)#11L, sum#13L])
02    +- Range (0, 10, step=1, splits=8)

import org.apache.spark.sql.execution.aggregate.HashAggregateExec
val hashAggExec = execPlan.asInstanceOf[HashAggregateExec]
val hashAggExecRDD = hashAggExec.execute

// MapPartitionsRDD is in private[spark] scope
// Use :paste -raw for the following helper object
package org.apache.spark
object AccessPrivateSpark {
  import org.apache.spark.rdd.RDD
  def mapPartitionsRDD[T](hashAggExecRDD: RDD[T]) = {
    import org.apache.spark.rdd.MapPartitionsRDD
    hashAggExecRDD.asInstanceOf[MapPartitionsRDD[_, _]]
  }
}
// END :paste -raw

import org.apache.spark.AccessPrivateSpark
val mpRDD = AccessPrivateSpark.mapPartitionsRDD(hashAggExecRDD)
val f = mpRDD.iterator(_, _)

import org.apache.spark.sql.execution.aggregate.TungstenAggregationIterator
// FIXME How to show that TungstenAggregationIterator is used?
```

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.aggregate.TungstenAggregationIterator` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
logger.TungstenAggregationIterator.name = org.apache.spark.sql.execution.aggregate.TungstenAggregationIterator
logger.TungstenAggregationIterator.level = all
```

Refer to [Logging](../spark-logging.md).
