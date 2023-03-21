# ReplaceHashWithSortAgg Physical Optimization

`ReplaceHashWithSortAgg` is a physical optimization (`Rule[SparkPlan]`) to [replace Hash Aggregate operators with grouping keys with SortAggregateExec operators](#replaceHashAgg).

`ReplaceHashWithSortAgg` can be enabled using [spark.sql.execution.replaceHashWithSortAgg](../configuration-properties.md#spark.sql.execution.replaceHashWithSortAgg) configuration property.

`ReplaceHashWithSortAgg` is part of the following optimizations:

* [preparations](../QueryExecution.md#preparations)
* [queryStagePreparationRules](../physical-operators/AdaptiveSparkPlanExec.md#queryStagePreparationRules)

## <span id="apply"> Executing Rule

??? note "Signature"

    ```scala
    apply(
      plan: SparkPlan): SparkPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

!!! note "Noop when spark.sql.execution.replaceHashWithSortAgg disabled"
    `apply` does nothing when [spark.sql.execution.replaceHashWithSortAgg](../configuration-properties.md#spark.sql.execution.replaceHashWithSortAgg) is disabled.

`apply` [replaceHashAgg](#replaceHashAgg).

## <span id="replaceHashAgg"> replaceHashAgg

```scala
replaceHashAgg(
  plan: SparkPlan): SparkPlan
```

`replaceHashAgg` finds [BaseAggregateExec](../physical-operators/BaseAggregateExec.md) physical operators that are [Hash Aggregate operators with grouping keys](#isHashBasedAggWithKeys) and [converts them to SortAggregateExec](../physical-operators/BaseAggregateExec.md#toSortAggregate) when either is met:

1. The child operator is again a [Hash Aggregate operator with grouping keys](../physical-operators/BaseAggregateExec.md) with [isPartialAgg](#isPartialAgg) and [ordering is satisfied](../expressions/SortOrder.md#orderingSatisfies)
1. [Ordering is satisfied](../expressions/SortOrder.md#orderingSatisfies)

## <span id="isHashBasedAggWithKeys"> isHashBasedAggWithKeys

```scala
isHashBasedAggWithKeys(
  agg: BaseAggregateExec): Boolean
```

`isHashBasedAggWithKeys` is positive (`true`) when the given [BaseAggregateExec](../physical-operators/BaseAggregateExec.md) is as follows:

1. It is either [HashAggregateExec](../physical-operators/HashAggregateExec.md) or [ObjectHashAggregateExec](../physical-operators/ObjectHashAggregateExec.md)
1. It has got [grouping keys](../physical-operators/BaseAggregateExec.md#groupingExpressions)

## <span id="isPartialAgg"> isPartialAgg

```scala
isPartialAgg(
  partialAgg: BaseAggregateExec,
  finalAgg: BaseAggregateExec): Boolean
```

`isPartialAgg` is positive (`true`) when...FIXME
