---
title: ApplyColumnarRulesAndInsertTransitions
---

# ApplyColumnarRulesAndInsertTransitions Physical Optimization

`ApplyColumnarRulesAndInsertTransitions` is a physical query plan optimization.

`ApplyColumnarRulesAndInsertTransitions` is a [Catalyst rule](../catalyst/Rule.md) for transforming [physical plans](../physical-operators/SparkPlan.md) (`Rule[SparkPlan]`).

`ApplyColumnarRulesAndInsertTransitions` is very similar (in how it optimizes physical query plans) to [CollapseCodegenStages](../physical-optimizations/CollapseCodegenStages.md) physical optimization for [Whole-Stage Java Code Generation](../whole-stage-code-generation/index.md).

## Creating Instance

`ApplyColumnarRulesAndInsertTransitions` takes the following to be created:

* <span id="conf"> [SQLConf](../SQLConf.md)
* <span id="columnarRules"> [ColumnarRule](../ColumnarRule.md)s

`ApplyColumnarRulesAndInsertTransitions` is created when:

* `QueryExecution` utility is requested for [preparations optimizations](../QueryExecution.md#preparations)
* [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md) physical operator is requested for [adaptive optimization](../physical-operators/AdaptiveSparkPlanExec.md#queryStageOptimizerRules)

## <span id="apply"> Executing Rule

??? note "Signature"

    ```scala
    apply(
      plan: SparkPlan): SparkPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply`...FIXME

## <span id="insertTransitions"> Inserting ColumnarToRowExec Transitions

```scala
insertTransitions(
  plan: SparkPlan): SparkPlan
```

`insertTransitions` creates a [ColumnarToRowExec](../physical-operators/ColumnarToRowExec.md) physical operator for the given [SparkPlan](../physical-operators/SparkPlan.md) that [supportsColumnar](../physical-operators/SparkPlan.md#supportsColumnar). The child of the `ColumnarToRowExec` operator is created using [insertRowToColumnar](#insertRowToColumnar).

## <span id="insertRowToColumnar"> Inserting RowToColumnarExec Transitions

```scala
insertRowToColumnar(
  plan: SparkPlan): SparkPlan
```

`insertRowToColumnar` does nothing (and returns the given [SparkPlan](../physical-operators/SparkPlan.md)) when the following all happen:

1. The given physical operator [supportsColumnar](../physical-operators/SparkPlan.md#supportsColumnar)
1. The given physical operator is `RowToColumnarTransition` (e.g., [RowToColumnarExec](../physical-operators/RowToColumnarExec.md))

If the given physical operator does not [supportsColumnar](../physical-operators/SparkPlan.md#supportsColumnar), `insertRowToColumnar` creates a [RowToColumnarExec](../physical-operators/RowToColumnarExec.md) physical operator for the given [SparkPlan](../physical-operators/SparkPlan.md). The [child](../physical-operators/RowToColumnarExec.md#child) of the `RowToColumnarExec` operator is created using [insertTransitions](#insertTransitions) (with `outputsColumnar` flag disabled).

If the given physical operator does [supportsColumnar](../physical-operators/SparkPlan.md#supportsColumnar) but it is not a `RowToColumnarTransition`, `insertRowToColumnar` replaces the child operators (of the physical operator) to [insertRowToColumnar](#insertRowToColumnar) recursively.
