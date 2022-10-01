# ObjectAggregationIterator

`ObjectAggregationIterator` is an [AggregationIterator](AggregationIterator.md) for [ObjectHashAggregateExec](ObjectHashAggregateExec.md) physical operator.

## Creating Instance

`ObjectAggregationIterator` takes the following to be created:

* <span id="partIndex"> Partition ID
* <span id="outputAttributes"> Output [Attribute](../expressions/Attribute.md)s (unused)
* <span id="groupingExpressions"> Grouping [NamedExpression](../expressions/NamedExpression.md)s
* <span id="aggregateExpressions"> [AggregateExpression](../expressions/AggregateExpression.md)s
* <span id="aggregateAttributes"> Aggregate [Attribute](../expressions/Attribute.md)s
* <span id="initialInputBufferOffset"> Initial input buffer offset
* <span id="resultExpressions"> Result [NamedExpression](../expressions/NamedExpression.md)s
* <span id="newMutableProjection"> Function to create a new `MutableProjection` given expressions and attributes (`(Seq[Expression], Seq[Attribute]) => MutableProjection`)
* <span id="originalInputAttributes"> Original Input [Attribute](../expressions/Attribute.md)s
* <span id="inputRows"> Input [InternalRow](../InternalRow.md)s
* <span id="fallbackCountThreshold"> [spark.sql.objectHashAggregate.sortBased.fallbackThreshold](../configuration-properties.md#spark.sql.objectHashAggregate.sortBased.fallbackThreshold)
* <span id="numOutputRows"> [numOutputRows](ObjectHashAggregateExec.md#numOutputRows) metric
* <span id="spillSize"> [spillSize](ObjectHashAggregateExec.md#spillSize) metric
* <span id="numTasksFallBacked"> [numTasksFallBacked](ObjectHashAggregateExec.md#numTasksFallBacked) metric

While being created, `ObjectAggregationIterator` starts [processing input rows](#processInputs).

`ObjectAggregationIterator` is created when:

* `ObjectHashAggregateExec` physical operator is requested to [doExecute](ObjectHashAggregateExec.md#doExecute)

## <span id="outputForEmptyGroupingKeyWithoutInput"> outputForEmptyGroupingKeyWithoutInput

```scala
outputForEmptyGroupingKeyWithoutInput(): UnsafeRow
```

`outputForEmptyGroupingKeyWithoutInput`...FIXME

---

`outputForEmptyGroupingKeyWithoutInput` is used when:

* `ObjectHashAggregateExec` physical operator is [executed](ObjectHashAggregateExec.md#doExecute) (with no input rows and no [groupingExpressions](ObjectHashAggregateExec.md#groupingExpressions))

## <span id="processInputs"> Processing Input Rows

```scala
processInputs(): Unit
```

`processInputs` creates an [ObjectAggregationMap](ObjectAggregationMap.md).

For no [groupingExpressions](#groupingExpressions), `processInputs` uses the [groupingProjection](AggregationIterator.md#groupingProjection) to generate a grouping key (for `null` row) and [finds the aggregation buffer](#getAggregationBufferByKey) that is used to [process](AggregationIterator.md#processRow) all input rows (of a partition).

Otherwise, `processInputs` uses the [sortBased](#sortBased) flag to determine whether to use the `ObjectAggregationMap` or switch to a `SortBasedAggregator`.

`processInputs` uses the [groupingProjection](AggregationIterator.md#groupingProjection) to generate a grouping key for an input row and [finds the aggregation buffer](#getAggregationBufferByKey) that is used to [process](AggregationIterator.md#processRow) the row (of a partition). `processInputs` continues processing input rows until there are no more rows available or the size of the `ObjectAggregationMap` reaches [spark.sql.objectHashAggregate.sortBased.fallbackThreshold](#fallbackCountThreshold).

When the size of the `ObjectAggregationMap` reaches [spark.sql.objectHashAggregate.sortBased.fallbackThreshold](#fallbackCountThreshold) and there are still input rows in the partition, `processInputs` prints out the following INFO message to the logs, turns the [sortBased](#sortBased) flag on and increments the [numTasksFallBacked](#numTasksFallBacked) metric.

```text
Aggregation hash map size [size] reaches threshold capacity ([fallbackCountThreshold] entries),
spilling and falling back to sort based aggregation.
You may change the threshold by adjusting the option spark.sql.objectHashAggregate.sortBased.fallbackThreshold
```

For sort-based aggregation (the [sortBased](#sortBased) flag is enabled), `processInputs` requests the `ObjectAggregationMap` to [dumpToExternalSorter](ObjectAggregationMap.md#dumpToExternalSorter) and create a `KVSorterIterator`. `processInputs` creates a `SortBasedAggregator`, uses the [groupingProjection](AggregationIterator.md#groupingProjection) to generate a grouping key for every input row and adds them to the `SortBasedAggregator`.

In the end, `processInputs` creates the [aggBufferIterator](#aggBufferIterator) (from the `ObjectAggregationMap` or `SortBasedAggregator` based on the [sortBased](#sortBased) flag).

---

`processInputs` is used when:

* `ObjectAggregationIterator` is [created](#creating-instance)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.aggregate.ObjectAggregationIterator` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.aggregate.ObjectAggregationIterator=ALL
```

Refer to [Logging](../spark-logging.md).
