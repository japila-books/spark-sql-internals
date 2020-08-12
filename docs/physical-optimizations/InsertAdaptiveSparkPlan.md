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

## <span id="applyInternal"> applyInternal

```scala
applyInternal(
  plan: SparkPlan,
  isSubquery: Boolean): SparkPlan
```

`applyInternal` ignores [ExecutedCommandExec](../physical-operators/ExecutedCommandExec.md) leaf operators.

For [DataWritingCommandExec](../physical-operators/DataWritingCommandExec.md) unary operators, `applyInternal` handles the child.

For [V2CommandExec](../physical-operators/V2CommandExec.md) unary operators, `applyInternal` handles the children.

For operators that [shouldApplyAQE](#shouldApplyAQE), `applyInternal` branches based on [whether the physical plan supports Adaptive Query Execution or not](#supportAdaptive).

### Supported Query Plans

For a physical query plan that supports Adaptive Query Execution, `applyInternal` tries to optimize the plan.

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

For a physical query plan that does not support Adaptive Query Execution, `applyInternal` simply prints out the WARN message and returns the given physical plan.

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

## <span id="shouldApplyAQE"> shouldApplyAQE

```scala
shouldApplyAQE(
  plan: SparkPlan,
  isSubquery: Boolean): Boolean
```

`shouldApplyAQE`...FIXME

`shouldApplyAQE` is used when `InsertAdaptiveSparkPlan` physical optimization is [executed](#applyInternal).

## <span id="supportAdaptive"> supportAdaptive

```scala
supportAdaptive(
  plan: SparkPlan): Boolean
```

`supportAdaptive`...FIXME

`supportAdaptive` is used when `InsertAdaptiveSparkPlan` physical optimization is [executed](#applyInternal).
