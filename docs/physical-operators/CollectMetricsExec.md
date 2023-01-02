# CollectMetricsExec Physical Operator

`CollectMetricsExec` is a [unary physical operator](UnaryExecNode.md).

## Creating Instance

`CollectMetricsExec` takes the following to be created:

* <span id="name"> Name
* <span id="metricExpressions"> Metric [NamedExpression](../expressions/NamedExpression.md)s
* <span id="child"> Child [physical operator](SparkPlan.md)

`CollectMetricsExec` is created when [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (and plans a [CollectMetrics](../logical-operators/CollectMetrics.md) logical operator).

## <span id="accumulator"> Collected metrics Accumulator

`CollectMetricsExec` registers an [AggregatingAccumulator](../AggregatingAccumulator.md) under the name **Collected metrics**.

`AggregatingAccumulator` is created with the [metric expressions](#metricExpressions) and the [output attributes](../catalyst/QueryPlan.md#output) of the [child](#child) physical operator.

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

---

`doExecute` resets the [Collected metrics Accumulator](#accumulator).

`doExecute` requests the [child](#child) physical operator to [execute](SparkPlan.md#execute) and uses `RDD.mapPartitions` operator for the following:

* A new per-partition [AggregatingAccumulator](#accumulator) (called `updater`) is requested to [copyAndReset](../AggregatingAccumulator.md#copyAndReset)
* The value of the accumulator is published only when a task is completed
* For every row, the per-partition `AggregatingAccumulator` is requested to add it (that updates [ImperativeAggregate](../expressions/ImperativeAggregate.md)s and [TypedImperativeAggregate](../expressions/TypedImperativeAggregate.md)s)
