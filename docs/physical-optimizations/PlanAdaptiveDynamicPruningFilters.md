---
title: PlanAdaptiveDynamicPruningFilters
---

# PlanAdaptiveDynamicPruningFilters Physical Optimization

`PlanAdaptiveDynamicPruningFilters` is a physical optimization in [Adaptive Query Execution](../adaptive-query-execution/index.md).

`PlanAdaptiveDynamicPruningFilters` is a [Catalyst Rule](../catalyst/Rule.md) for transforming [physical plans](../physical-operators/SparkPlan.md) (`Rule[SparkPlan]`).

## Creating Instance

`PlanAdaptiveDynamicPruningFilters` takes the following to be created:

* <span id="rootPlan"> Root [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md)

`PlanAdaptiveDynamicPruningFilters` is created when:

* `AdaptiveSparkPlanExec` leaf physical operator is requested for the [adaptive optimizations](../physical-operators/AdaptiveSparkPlanExec.md#queryStageOptimizerRules)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

---

`apply` is disabled (and simply returns the given [SparkPlan](../physical-operators/SparkPlan.md) unchanged) when the [spark.sql.optimizer.dynamicPartitionPruning.enabled](../configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.enabled) is disabled.

`apply` requests the given `SparkPlan` to [transformAllExpressionsWithPruning](../catalyst/QueryPlan.md#transformAllExpressionsWithPruning) in [QueryPlan](../catalyst/QueryPlan.md)s with the [DYNAMIC_PRUNING_EXPRESSION](../catalyst/TreePattern.md#DYNAMIC_PRUNING_EXPRESSION) and [IN_SUBQUERY_EXEC](../catalyst/TreePattern.md#IN_SUBQUERY_EXEC) tree patterns:

* [DynamicPruningExpression](../expressions/DynamicPruningExpression.md)s with [InSubqueryExec](../expressions/InSubqueryExec.md) expressions with [SubqueryAdaptiveBroadcastExec](../physical-operators/BaseSubqueryExec.md#SubqueryAdaptiveBroadcastExec)s with [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md) leaf physical operators

In the end, `apply` creates a new [DynamicPruningExpression](../expressions/DynamicPruningExpression.md) unary expression (with a [InSubqueryExec](../expressions/InSubqueryExec.md) or [TrueLiteral](../expressions/Literal.md#TrueLiteral)).
