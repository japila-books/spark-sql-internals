# ReuseAdaptiveSubquery Physical Optimization

`ReuseAdaptiveSubquery` is a physical query plan optimization in [Adaptive Query Execution](index.md).

`ReuseAdaptiveSubquery` is a [Catalyst Rule](../catalyst/Rule.md) for transforming [physical plans](../physical-operators/SparkPlan.md) (`Rule[SparkPlan]`).

## Creating Instance

`ReuseAdaptiveSubquery` takes the following to be created:

* <span id="reuseMap"> [Subquery Cache](AdaptiveExecutionContext.md#subqueryCache)

`ReuseAdaptiveSubquery` is created when:

* `AdaptiveSparkPlanExec` leaf physical operator is requested for the [adaptive optimizations](AdaptiveSparkPlanExec.md#queryStageOptimizerRules)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` is disabled (and returns the given [SparkPlan](../physical-operators/SparkPlan.md)) when the [spark.sql.execution.reuseSubquery](../configuration-properties.md#spark.sql.execution.reuseSubquery) configuration property is `false`.

`apply` requests the given `SparkPlan` to [transformAllExpressionsWithPruning](../catalyst/QueryPlan.md#transformAllExpressionsWithPruning) with tree nodes with [PLAN_EXPRESSION](../catalyst/TreePattern.md#PLAN_EXPRESSION) tree pattern:

* For a [ExecSubqueryExpression](../expressions/ExecSubqueryExpression.md) expression, `apply` replaces the [plan](../expressions/PlanExpression.md#plan) with a new [ReusedSubqueryExec](../physical-operators/ReusedSubqueryExec.md) physical operator with a cached plan if found in the [cache](#reuseMap).

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
