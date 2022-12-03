# TungstenAggregationIterator

`TungstenAggregationIterator` is an [AggregationIterator](AggregationIterator.md) for [HashAggregateExec](HashAggregateExec.md) physical operator.

`TungstenAggregationIterator` prefers [hash-based aggregation before switching to sort-based one](#sortBased).

## Creating Instance

`TungstenAggregationIterator` takes the following to be created:

* <span id="partIndex"> Partition ID
* <span id="groupingExpressions"> Grouping [NamedExpression](../expressions/NamedExpression.md)s
* <span id="aggregateExpressions"> [AggregateExpression](../expressions/AggregateExpression.md)s
* <span id="aggregateAttributes"> Aggregate [Attribute](../expressions/Attribute.md)s
* <span id="initialInputBufferOffset"> Initial input buffer offset
* <span id="resultExpressions"> Result [NamedExpression](../expressions/NamedExpression.md)s
* <span id="newMutableProjection"> Function to create a new `MutableProjection` given expressions and attributes (`(Seq[Expression], Seq[Attribute]) => MutableProjection`)
* <span id="originalInputAttributes"> Original Input [Attribute](../expressions/Attribute.md)s
* <span id="inputIter"> Input Iterator of [InternalRow](../InternalRow.md)s (from a single partition of the [child](HashAggregateExec.md#child) of the [HashAggregateExec](HashAggregateExec.md) physical operator)
* <span id="testFallbackStartsAt"> (only for testing) Optional `HashAggregateExec`'s [testFallbackStartsAt](HashAggregateExec.md#testFallbackStartsAt)
* <span id="numOutputRows"> `numOutputRows` [SQLMetric](../SQLMetric.md)
* <span id="peakMemory"> `peakMemory` [SQLMetric](../SQLMetric.md)
* <span id="spillSize"> `spillSize` [SQLMetric](../SQLMetric.md)
* <span id="avgHashProbe"> `avgHashProbe` [SQLMetric](../SQLMetric.md)

`TungstenAggregationIterator` is created when:

* `HashAggregateExec` physical operator is [executed](HashAggregateExec.md#doExecute)

`TungstenAggregationIterator` starts [processing input rows](#processInputs) and pre-loads the first key-value pair from the [UnsafeFixedWidthAggregationMap](#hashMap) unless [switched to a sort-based aggregation](#sortBased).

## <span id="metrics"> Performance Metrics

When [created](#creating-instance), `TungstenAggregationIterator` gets [SQLMetric](../SQLMetric.md)s from the [HashAggregateExec](HashAggregateExec.md#metrics) aggregate physical operator being executed.

* [numOutputRows](#numOutputRows) is used when `TungstenAggregationIterator` is requested for the [next UnsafeRow](#next) (and it [has one](#hasNext))

* [peakMemory](#peakMemory), [spillSize](#spillSize) and [avgHashProbe](#avgHashProbe) are used at the [end of every task](#TaskCompletionListener) (one per partition)

The metrics are displayed as part of [HashAggregateExec](HashAggregateExec.md) aggregate physical operator (e.g. in web UI in [Details for Query](../ui/SQLTab.md#ExecutionPage)).

![HashAggregateExec in web UI (Details for Query)](../images/HashAggregateExec-webui-details-for-query.png)

## <span id="next"> Next UnsafeRow

```scala
next(): UnsafeRow
```

`next` is part of the `Iterator` ([Scala]({{ scala.api }}/scala/collection/Iterator.html#next():A)) abstraction.

---

`next`...FIXME

### <span id="processCurrentSortedGroup"> processCurrentSortedGroup

```scala
processCurrentSortedGroup(): Unit
```

`processCurrentSortedGroup`...FIXME

## <span id="hashMap"> UnsafeFixedWidthAggregationMap

When [created](#creating-instance), `TungstenAggregationIterator` creates an [UnsafeFixedWidthAggregationMap](../UnsafeFixedWidthAggregationMap.md) with the following:

* [initialAggregationBuffer](#initialAggregationBuffer)
* [Schema](../types/StructType.md#fromAttributes) built from the [attributes of the aggregation buffers](../expressions/AggregateFunction.md#aggBufferAttributes) of all the [AggregateFunctions](AggregationIterator.md#aggregateFunctions)
* [Schema](../types/StructType.md#fromAttributes) built from the [attributes](../expressions/NamedExpression.md#toAttribute) of all the [grouping expressions](#groupingExpressions)

Used when:

* `TungstenAggregationIterator` is requested for the [next UnsafeRow](#next), to [outputForEmptyGroupingKeyWithoutInput](#outputForEmptyGroupingKeyWithoutInput), [process input rows](#processInputs), to initialize the [aggregationBufferMapIterator](#aggregationBufferMapIterator) and [every time a partition has been processed](#TaskCompletionListener)

## <span id="TaskCompletionListener"> TaskCompletionListener

`TungstenAggregationIterator` registers a `TaskCompletionListener` that is executed on task completion (for every task that processes a partition).

When executed (once per partition), the `TaskCompletionListener` updates the following metrics:

* [peakMemory](#peakMemory)
* [spillSize](#spillSize)
* [avgHashProbe](#avgHashProbe)

## <span id="outputForEmptyGroupingKeyWithoutInput"> outputForEmptyGroupingKeyWithoutInput

```scala
outputForEmptyGroupingKeyWithoutInput(): UnsafeRow
```

`outputForEmptyGroupingKeyWithoutInput`...FIXME

---

`outputForEmptyGroupingKeyWithoutInput` is used when:

* `HashAggregateExec` physical operator is requested to [execute](HashAggregateExec.md#doExecute) (with no input rows and grouping expressions)

## <span id="processInputs"> Processing Input Rows

```scala
processInputs(
  fallbackStartsAt: (Int, Int)): Unit
```

`processInputs`...FIXME

---

`processInputs` is used when:

* `TungstenAggregationIterator` is [created](#creating-instance)

## <span id="sortBased"> Hash- vs Sort-Based Aggregations

```scala
sortBased: Boolean = false
```

`TungstenAggregationIterator` creates and initializes `sortBased` flag to `false` when [created](#creating-instance).

The flag is used to indicate whether `TungstenAggregationIterator` has [switched (fall back) to sort-based aggregation](#switchToSortBasedAggregation) while [processing input rows](#processInputs).

`sortBased` flag is turned on (`true`) while [switching to sort-based aggregation](#switchToSortBasedAggregation) (and the [numTasksFallBacked](#numTasksFallBacked) metric is incremented).

Switching from hash-based to sort-based aggregation happens when the [external sorter](#externalSorter) is initialized (that is used for sort-based aggregation).

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
