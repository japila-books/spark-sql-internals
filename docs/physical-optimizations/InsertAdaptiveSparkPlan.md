# InsertAdaptiveSparkPlan Physical Optimization

`InsertAdaptiveSparkPlan` is a [physical query plan optimization](../catalyst/Rule.md) (`Rule[SparkPlan]`) that [re-optimizes a physical query plan](#apply) in the middle of query execution, based on accurate runtime statistics.

!!! important
    `InsertAdaptiveSparkPlan` is disabled by default based on [spark.sql.adaptive.enabled](../spark-sql-properties.md#spark.sql.adaptive.enabled) configuration property.

## Creating Instance

`InsertAdaptiveSparkPlan` takes the following to be created:

* <span id="adaptiveExecutionContext"> [AdaptiveExecutionContext](AdaptiveExecutionContext.md)

`InsertAdaptiveSparkPlan` is created when `QueryExecution` is requested for [physical preparations rules](../QueryExecution.md#preparations).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` simply calls [applyInternal](#applyInternal) with the given [SparkPlan](../physical-operators/SparkPlan.md) and `isSubquery` flag disabled (`false`).

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

## applyInternal

<span id="applyInternal">
```scala
applyInternal(
  plan: SparkPlan,
  isSubquery: Boolean): SparkPlan
```

`applyInternal` does nothing (and simply returns the given [physical plan](../physical-operators/SparkPlan.md) "untouched") when [spark.sql.adaptive.enabled](../spark-sql-properties.md#spark.sql.adaptive.enabled) is disabled.

`applyInternal` skips [ExecutedCommandExec](../physical-operators/ExecutedCommandExec.md) leaf operators (and simply returns the given [physical plan](../physical-operators/SparkPlan.md) "untouched").

For [DataWritingCommandExec](../physical-operators/DataWritingCommandExec.md) unary operators, `applyInternal` handles the child.

For [V2CommandExec](../physical-operators/V2CommandExec.md) operators, `applyInternal` handles the children.

For all other operators for which [shouldApplyAQE predicate](#shouldApplyAQE) holds, `applyInternal` branches off based on [whether the physical plan supports Adaptive Query Execution or not](#supportAdaptive).

### Supported Query Plans

`applyInternal` [collects subquery expressions](#buildSubqueryMap) in the query plan and creates a new [PlanAdaptiveSubqueries](PlanAdaptiveSubqueries.md) optimization with them.
`applyInternal` then [executes](../physical-operators/AdaptiveSparkPlanExec.md#applyPhysicalRules) the optimization rule on the plan.
In the end, `applyInternal` creates an [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md) physical operator with the new optimized physical query plan.

`applyInternal` prints out the following DEBUG message to the logs:

```text
Adaptive execution enabled for plan: [plan]
```

In case of `SubqueryAdaptiveNotSupportedException`, `applyInternal` prints out the WARN message and returns the given physical plan.

```text
spark.sql.adaptive.enabled is enabled but is not supported for sub-query: [subquery].
```

### Unsupported Query Plans

`applyInternal` simply prints out the WARN message and returns the given physical plan.

```text
spark.sql.adaptive.enabled is enabled but is not supported for query: [plan].
```

### Usage

`applyInternal` is used when `InsertAdaptiveSparkPlan` physical optimization is [executed](#apply) (with the `isSubquery` flag disabled) and requested to [compileSubquery](#compileSubquery) (with the `isSubquery` flag enabled).

## <span id="buildSubqueryMap"> Collecting Subquery Expressions

```scala
buildSubqueryMap(
  plan: SparkPlan): Map[Long, SubqueryExec]
```

`buildSubqueryMap` finds [ScalarSubquery](../expressions/ScalarSubquery) and [ListQuery](../expressions/ListQuery.md) (in [InSubquery](../expressions/InSubquery.md)) expressions (unique by expression ID to reuse the execution plan from another sub-query) in the given [physical query plan](../physical-operators/SparkPlan.md).

For every `ScalarSubquery` and `ListQuery` expressions, `buildSubqueryMap` [compileSubquery](#compileSubquery), [verifyAdaptivePlan](#verifyAdaptivePlan) and registers a new [SubqueryExec](../physical-operators/SubqueryExec.md) operator.

`buildSubqueryMap` is used when `InsertAdaptiveSparkPlan` physical optimization is [executed](#applyInternal).

## <span id="compileSubquery"> compileSubquery

```scala
compileSubquery(
  plan: LogicalPlan): SparkPlan
```

`compileSubquery`...FIXME

`compileSubquery` is used when `InsertAdaptiveSparkPlan` physical optimization is requested to [buildSubqueryMap](#buildSubqueryMap).

## <span id="verifyAdaptivePlan"> verifyAdaptivePlan

```scala
verifyAdaptivePlan(
  plan: SparkPlan,
  logicalPlan: LogicalPlan): Unit
```

`verifyAdaptivePlan`...FIXME

`verifyAdaptivePlan` is used when `InsertAdaptiveSparkPlan` physical optimization is requested to [buildSubqueryMap](#buildSubqueryMap).

## shouldApplyAQE Predicate

<span id="shouldApplyAQE">
```scala
shouldApplyAQE(
  plan: SparkPlan,
  isSubquery: Boolean): Boolean
```

`shouldApplyAQE` is `true` when one of the following conditions holds:

1. [spark.sql.adaptive.forceApply](../spark-sql-properties.md#spark.sql.adaptive.forceApply) configuration property is enabled
1. The given `isSubquery` flag is enabled
1. The given [physical operator](../physical-operators/SparkPlan.md):

    1. Is an [Exchange](../physical-operators/Exchange.md)
    1. No [requiredChildDistribution](../physical-operators/SparkPlan.md#requiredChildDistribution) of the operator is [UnspecifiedDistribution](../physical-operators/Distribution.md#UnspecifiedDistribution)
    1. Contains [SubqueryExpression](../expressions/SubqueryExpression.md)

`shouldApplyAQE` is used when `InsertAdaptiveSparkPlan` physical optimization is [executed](#applyInternal).

## supportAdaptive Predicate

<span id="supportAdaptive">
```scala
supportAdaptive(
  plan: SparkPlan): Boolean
```

`supportAdaptive` is `true` when the given [physical operator](../physical-operators/SparkPlan.md) (including its children) has a [logical operator linked](../physical-operators/SparkPlan.md#logicalLink) that is neither streaming nor has [DynamicPruningSubquery](../expressions/DynamicPruningSubquery.md) expressions.

`supportAdaptive` is used when `InsertAdaptiveSparkPlan` physical optimization is [executed](#applyInternal).
