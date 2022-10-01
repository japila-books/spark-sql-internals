# ObjectAggregationIterator

`ObjectAggregationIterator` is an [AggregationIterator](AggregationIterator.md) for [ObjectHashAggregateExec](physical-operators/ObjectHashAggregateExec.md) physical operator.

## Creating Instance

`ObjectAggregationIterator` takes the following to be created:

* <span id="partIndex"> Partition ID
* <span id="outputAttributes"> Output [Attribute](expressions/Attribute.md)s (unused)
* <span id="groupingExpressions"> Grouping [NamedExpression](expressions/NamedExpression.md)s
* <span id="aggregateExpressions"> [AggregateExpression](expressions/AggregateExpression.md)s
* <span id="aggregateAttributes"> Aggregate [Attribute](expressions/Attribute.md)s
* <span id="initialInputBufferOffset"> Initial input buffer offset
* <span id="resultExpressions"> Result [NamedExpression](expressions/NamedExpression.md)s
* <span id="newMutableProjection"> Function to create a new `MutableProjection` given expressions and attributes (`(Seq[Expression], Seq[Attribute]) => MutableProjection`)
* <span id="originalInputAttributes"> Original Input [Attribute](expressions/Attribute.md)s
* <span id="inputRows"> Input [InternalRow](InternalRow.md)s
* <span id="fallbackCountThreshold"> [spark.sql.objectHashAggregate.sortBased.fallbackThreshold](configuration-properties.md#spark.sql.objectHashAggregate.sortBased.fallbackThreshold)
* <span id="numOutputRows"> `numOutputRows` [SQLMetric](physical-operators/SQLMetric.md)

`ObjectAggregationIterator` is created when:

* `ObjectHashAggregateExec` physical operator is requested to [doExecute](physical-operators/ObjectHashAggregateExec.md#doExecute)
