# ApplyColumnarRulesAndInsertTransitions Physical Optimization

`ApplyColumnarRulesAndInsertTransitions` is a physical query plan optimization.

`ApplyColumnarRulesAndInsertTransitions` is a [Catalyst rule](../catalyst/Rule.md) for transforming [physical plans](../physical-operators/SparkPlan.md) (`Rule[SparkPlan]`).

## Creating Instance

`ApplyColumnarRulesAndInsertTransitions` takes the following to be created:

* <span id="conf"> [SQLConf](../SQLConf.md)
* <span id="columnarRules"> [ColumnarRule](../ColumnarRule.md)s

`ApplyColumnarRulesAndInsertTransitions` is created when:

* `QueryExecution` utility is requested for [preparations optimizations](../QueryExecution.md#preparations)
* [AdaptiveSparkPlanExec](../adaptive-query-execution/AdaptiveSparkPlanExec.md) physical operator is requested for [adaptive optimization](../adaptive-query-execution/AdaptiveSparkPlanExec.md#queryStageOptimizerRules)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

## <span id="insertTransitions"> Inserting ColumnarToRowExec Transitions

```scala
insertTransitions(
  plan: SparkPlan): SparkPlan
```

`insertTransitions` simply creates a [ColumnarToRowExec](../physical-operators/ColumnarToRowExec.md) physical operator for the given [SparkPlan](../physical-operators/SparkPlan.md) that [supportsColumnar](../physical-operators/SparkPlan.md#supportsColumnar). The child of the `ColumnarToRowExec` operator is created using [insertRowToColumnar](#insertRowToColumnar).

## <span id="insertRowToColumnar"> Inserting RowToColumnarExec Transitions

```scala
insertRowToColumnar(
  plan: SparkPlan): SparkPlan
```

`insertRowToColumnar` simply creates a `RowToColumnarExec` physical operator for the given [SparkPlan](../physical-operators/SparkPlan.md) that does not [supportsColumnar](../physical-operators/SparkPlan.md#supportsColumnar). The child of the `RowToColumnarExec` operator is created using [insertTransitions](#insertTransitions). Otherwise, `insertRowToColumnar` requests the operator for child operators and [insertRowToColumnar](#insertRowToColumnar).
