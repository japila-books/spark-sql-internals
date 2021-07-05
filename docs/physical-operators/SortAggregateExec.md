# SortAggregateExec Aggregate Physical Operator

`SortAggregateExec` is an [aggregate unary physical operator](BaseAggregateExec.md) for **sort-based aggregation**.

## Creating Instance

`SortAggregateExec` takes the following to be created:

* <span id="requiredChildDistributionExpressions"> (optional) Required Child Distribution [Expression](../expressions/Expression.md)s
* <span id="groupingExpressions"> Grouping [NamedExpression](../expressions/NamedExpression.md)s
* <span id="aggregateExpressions"> [AggregateExpression](../expressions/AggregateExpression.md)s
* <span id="aggregateAttributes"> Aggregate [Attribute](../expressions/Attribute.md)s
* <span id="initialInputBufferOffset"> Initial Input Buffer Offset
* <span id="resultExpressions"> Result [NamedExpression](../expressions/NamedExpression.md)s
* <span id="child"> Child [Physical Operator](SparkPlan.md)

`SortAggregateExec` is created when:

* `AggUtils` utility is used to [create a physical operator for aggregation](../AggUtils.md#createAggregate)

## <span id="metrics"> Performance Metrics

Key             | Name (in web UI)
----------------|--------------------------
numOutputRows   | number of output rows

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute`...FIXME
