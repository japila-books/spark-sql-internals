---
title: ReuseExchangeAndSubquery
---

# ReuseExchangeAndSubquery Physical Optimization

`ReuseExchangeAndSubquery` is a physical query optimization.

`ReuseExchangeAndSubquery` is part of the [preparations](../QueryExecution.md#preparations) batch of physical query plan rules and is executed when `QueryExecution` is requested for the [optimized physical query plan](../QueryExecution.md#executedPlan).

`ReuseExchangeAndSubquery` is a [Catalyst rule](../catalyst/Rule.md) for transforming [physical query plans](../physical-operators/SparkPlan.md) (`Rule[SparkPlan]`).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` is a noop (and simply returns the given [SparkPlan](../physical-operators/SparkPlan.md) unchanged) when neither the [spark.sql.exchange.reuse](../configuration-properties.md#spark.sql.exchange.reuse) nor the [spark.sql.execution.reuseSubquery](../configuration-properties.md#spark.sql.execution.reuseSubquery) are enabled.

`apply` requests the `SparkPlan` to [transformUpWithPruning](../physical-operators/SparkPlan.md#transformUpWithPruning) any physical operator with [EXCHANGE](../catalyst/TreePattern.md#EXCHANGE) or [PLAN_EXPRESSION](../catalyst/TreePattern.md#PLAN_EXPRESSION) tree pattern:

* For an [Exchange](../physical-operators/Exchange.md) and the [spark.sql.exchange.reuse](../configuration-properties.md#spark.sql.exchange.reuse) enabled, `apply` may create a [ReusedExchangeExec](../physical-operators/ReusedExchangeExec.md) if there is a cached (found earlier) exchange.

* For other physical operators, `apply` requests the current `SparkPlan` to [transformExpressionsUpWithPruning](../physical-operators/SparkPlan.md#transformExpressionsUpWithPruning) any physical operator with [PLAN_EXPRESSION](../catalyst/TreePattern.md#PLAN_EXPRESSION) tree pattern and may create a [ReusedSubqueryExec](../physical-operators/ReusedSubqueryExec.md) for a [ExecSubqueryExpression](../expressions/ExecSubqueryExpression.md) if there is a cached (found earlier) subquery and the [spark.sql.execution.reuseSubquery](../configuration-properties.md#spark.sql.execution.reuseSubquery) is enabled

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
