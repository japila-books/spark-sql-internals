---
title: CollectMetrics
---

# CollectMetrics Logical Operator

`CollectMetrics` is a [unary logical operator](LogicalPlan.md#UnaryNode) that represents [Dataset.observe](../spark-sql-dataset-operators.md#observe) operator (in the [logical query plan](LogicalPlan.md)).

## Creating Instance

`CollectMetrics` takes the following to be created:

* <span id="name"> Name
* <span id="metricExpressions"> Metric [NamedExpression](../expressions/NamedExpression.md)s
* <span id="child"> Child [logical operator](LogicalPlan.md)

`CollectMetrics` is created when [Dataset.observe](../spark-sql-dataset-operators.md#observe) operator is used.

## Execution Planning

`CollectMetrics` is planned as [CollectMetricsExec](../physical-operators/CollectMetricsExec.md) physical operator.

## Demo

```text
// TIP: Use AggregateExpressions
val q = spark
  .range(0, 5, 1, numPartitions = 1)
  .observe(name = "myMetric", expr = count('id))
val plan = q.queryExecution.logical

scala> println(plan.numberedTreeString)
00 'CollectMetrics myMetric, [count('id) AS count(id)#46]
01 +- Range (0, 5, step=1, splits=Some(1))
```
