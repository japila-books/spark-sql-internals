---
title: PlanDynamicPruningFilters
---

# PlanDynamicPruningFilters Physical Optimization

`PlanDynamicPruningFilters` is a physical optimization and part of the default [physical optimizations (preparations)](../QueryExecution.md#preparations).

`PlanDynamicPruningFilters` transforms [DynamicPruningSubquery](../expressions/DynamicPruningSubquery.md) expressions into [DynamicPruningExpression](../expressions/DynamicPruningExpression.md) expressions.

`PlanDynamicPruningFilters` is a noop when [spark.sql.optimizer.dynamicPartitionPruning.enabled](../configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.enabled) configuration property is disabled (`false`).

`PlanDynamicPruningFilters` is a [Catalyst Rule](../catalyst/Rule.md) for transforming [physical operators](../physical-operators/SparkPlan.md) (`Rule[SparkPlan]`).

## Creating Instance

`PlanDynamicPruningFilters` takes the following to be created:

* <span id="sparkSession"> [SparkSession](../SparkSession.md)

`PlanDynamicPruningFilters` is created when `QueryExecution` utility is requested for [physical query optimizations](../QueryExecution.md#preparations).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` transforms a `DynamicPruningSubquery` expression as follows:

1. Uses `QueryExecution.createSparkPlan` utility to plan the [Build Logical Query](../expressions/DynamicPruningSubquery.md#buildQuery) (of the `DynamicPruningSubquery`)

1. Finds whether to reuse an Exchange (based on [spark.sql.exchange.reuse](../configuration-properties.md#spark.sql.exchange.reuse) configuration property _and other checks_)

1. Creates a [DynamicPruningExpression](../expressions/DynamicPruningExpression.md) expression

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
