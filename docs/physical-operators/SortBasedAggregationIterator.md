# SortBasedAggregationIterator

`SortBasedAggregationIterator` is an [AggregationIterator](AggregationIterator.md) for [SortAggregateExec](SortAggregateExec.md) physical operator.

## Creating Instance

`SortBasedAggregationIterator` takes the following to be created:

* <span id="partIndex"> Partition ID
* <span id="groupingExpressions"> Grouping [NamedExpression](../expressions/NamedExpression.md)s
* <span id="valueAttributes"> Value [Attribute](../expressions/Attribute.md)s
* <span id="inputIterator"> Input Iterator of [InternalRow](../InternalRow.md)s
* <span id="aggregateExpressions"> [AggregateExpression](../expressions/AggregateExpression.md)s
* <span id="aggregateAttributes"> Aggregate [Attribute](../expressions/Attribute.md)s
* <span id="initialInputBufferOffset"> Initial input buffer offset
* <span id="resultExpressions"> Result [NamedExpression](../expressions/NamedExpression.md)s
* <span id="newMutableProjection"> Function to create a new `MutableProjection` given expressions and attributes (`(Seq[Expression], Seq[Attribute]) => MutableProjection`)
* <span id="numOutputRows"> `numOutputRows` [SQLMetric](../SQLMetric.md)

`SortBasedAggregationIterator` is created when:

* `SortAggregateExec` physical operator is requested to [doExecute](SortAggregateExec.md#doExecute)
