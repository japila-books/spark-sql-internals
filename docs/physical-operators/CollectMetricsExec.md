# CollectMetricsExec Physical Operator

`CollectMetricsExec` is a [unary physical operator](UnaryExecNode.md).

## Creating Instance

`CollectMetricsExec` takes the following to be created:

* <span id="name"> Name
* <span id="metricExpressions"> Metric [NamedExpression](../expressions/NamedExpression.md)s
* <span id="child"> Child [physical operator](SparkPlan.md)

`CollectMetricsExec` is created when [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (and plans a [CollectMetrics](../logical-operators/CollectMetrics.md) logical operator).

## <span id="accumulator"> Collected metrics Accumulator

`CollectMetricsExec` registers an `AggregatingAccumulator` accumulator under the name **Collected metrics**.

`AggregatingAccumulator` is created for the [metric expressions](#metricExpressions) and the [child](#child) physical operator's [output attributes](../catalyst/QueryPlan.md#output).

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` resets the [Collected metrics Accumulator](#accumulator).

`doExecute` requests the [child](#child) physical operator to [execute](SparkPlan.md#execute) and `RDD.mapPartitions` so that:

* A new per-partition `AggregatingAccumulator` (called `updater`) is requested to `copyAndReset`
* The value of the accumulator is published only when a task is completed
* For every row, the per-partition `AggregatingAccumulator` is requested to add it (that updates [ImperativeAggregate](../expressions/ImperativeAggregate.md)s and [TypedImperativeAggregate](../expressions/TypedImperativeAggregate.md)s)

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.
