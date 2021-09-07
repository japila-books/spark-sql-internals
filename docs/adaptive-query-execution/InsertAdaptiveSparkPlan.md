# InsertAdaptiveSparkPlan Physical Optimization

`InsertAdaptiveSparkPlan` is a [physical query plan optimization](../catalyst/Rule.md) (`Rule[SparkPlan]`) that [re-optimizes a physical query plan](#apply) in the middle of query execution, based on accurate runtime statistics.

## <span id="shouldApplyAQE"> Adaptive Requirements

```scala
shouldApplyAQE(
  plan: SparkPlan,
  isSubquery: Boolean): Boolean
```

`shouldApplyAQE` is `true` when one of the following conditions holds:

1. [spark.sql.adaptive.forceApply](../configuration-properties.md#spark.sql.adaptive.forceApply) configuration property is enabled
1. The given `isSubquery` flag is enabled (a shortcut to continue since the input plan is from a sub-query and it was already decided to apply AQE for the main query)
1. The given [physical query plan](../physical-operators/SparkPlan.md) uses a physical operator that matches or is the following:
    1. [Exchange](../physical-operators/Exchange.md)
    1. There is a [UnspecifiedDistribution](../physical-operators/Distribution.md#UnspecifiedDistribution) among the [requiredChildDistribution](../physical-operators/SparkPlan.md#requiredChildDistribution) of the operator (and the query may need to add exchanges)
    1. Contains [SubqueryExpression](../expressions/SubqueryExpression.md)

## Creating Instance

`InsertAdaptiveSparkPlan` takes the following to be created:

* <span id="adaptiveExecutionContext"> [AdaptiveExecutionContext](../adaptive-query-execution/AdaptiveExecutionContext.md)

`InsertAdaptiveSparkPlan` is created when:

* `QueryExecution` is requested for [physical preparations rules](../QueryExecution.md#preparations)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` [applyInternal](#applyInternal) with the given [SparkPlan](../physical-operators/SparkPlan.md) and `isSubquery` flag disabled (`false`).

## <span id="applyInternal"> applyInternal

```scala
applyInternal(
  plan: SparkPlan,
  isSubquery: Boolean): SparkPlan
```

`applyInternal` returns the given [physical plan](../physical-operators/SparkPlan.md) "untouched" when [spark.sql.adaptive.enabled](../configuration-properties.md#spark.sql.adaptive.enabled) is disabled.

`applyInternal` skips [ExecutedCommandExec](../physical-operators/ExecutedCommandExec.md) leaf operators (and simply returns the given [physical plan](../physical-operators/SparkPlan.md) "untouched").

For [DataWritingCommandExec](../physical-operators/DataWritingCommandExec.md) unary operators, `applyInternal` handles the child recursively.

For [V2CommandExec](../physical-operators/V2CommandExec.md) operators, `applyInternal` handles the children recursively.

For all other operators for which [shouldApplyAQE predicate](#shouldApplyAQE) holds, `applyInternal` branches off based on [whether the physical plan supports Adaptive Query Execution or not](#supportAdaptive).

### Supported Query Plans

`applyInternal` creates a new [PlanAdaptiveSubqueries](PlanAdaptiveSubqueries.md) optimization (with [subquery expressions](#buildSubqueryMap)) and [applies](AdaptiveSparkPlanExec.md#applyPhysicalRules) it to the plan.

`applyInternal` prints out the following DEBUG message to the logs:

```text
Adaptive execution enabled for plan: [plan]
```

In the end, `applyInternal` creates an [AdaptiveSparkPlanExec](AdaptiveSparkPlanExec.md) physical operator with the new pre-processed physical query plan.

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

`applyInternal` is used by `InsertAdaptiveSparkPlan` when requested for the following:

* [Execute](#apply) (with the `isSubquery` flag disabled)
* [Compile a subquery](#compileSubquery) (with the `isSubquery` flag enabled)

### <span id="buildSubqueryMap"> Collecting Subquery Expressions

```scala
buildSubqueryMap(
  plan: SparkPlan): Map[Long, SubqueryExec]
```

`buildSubqueryMap` finds [ScalarSubquery](../expressions/ScalarSubquery) and [ListQuery](../expressions/ListQuery.md) (in [InSubquery](../expressions/InSubquery.md)) expressions (unique by expression ID to reuse the execution plan from another sub-query) in the given [physical query plan](../physical-operators/SparkPlan.md).

For every `ScalarSubquery` and `ListQuery` expressions, `buildSubqueryMap` [compileSubquery](#compileSubquery), [verifyAdaptivePlan](#verifyAdaptivePlan) and registers a new [SubqueryExec](../physical-operators/SubqueryExec.md) operator.

### <span id="compileSubquery"> compileSubquery

```scala
compileSubquery(
  plan: LogicalPlan): SparkPlan
```

`compileSubquery` requests the session-bound [SparkPlanner](../SparkPlanner.md) (from the [AdaptiveExecutionContext](#adaptiveExecutionContext)) to [plan](../execution-planning-strategies/SparkStrategies.md#plan) the given [LogicalPlan](../logical-operators/LogicalPlan.md) (that produces a [SparkPlan](../physical-operators/SparkPlan.md)).

In the end, `compileSubquery` [applyInternal](#applyInternal) with `isSubquery` flag turned on.

### <span id="verifyAdaptivePlan"> Enforcing AdaptiveSparkPlanExec

```scala
verifyAdaptivePlan(
  plan: SparkPlan,
  logicalPlan: LogicalPlan): Unit
```

`verifyAdaptivePlan` throws a `SubqueryAdaptiveNotSupportedException` when the given [SparkPlan](../physical-operators/SparkPlan.md) is not a [AdaptiveSparkPlanExec](AdaptiveSparkPlanExec.md).

## supportAdaptive Predicate

<span id="supportAdaptive">
```scala
supportAdaptive(
  plan: SparkPlan): Boolean
```

`supportAdaptive` is `true` when the given [physical operator](../physical-operators/SparkPlan.md) (including its children) has a [logical operator linked](../physical-operators/SparkPlan.md#logicalLink) that is neither streaming nor has [DynamicPruningSubquery](../expressions/DynamicPruningSubquery.md) expressions.

`supportAdaptive` is used when `InsertAdaptiveSparkPlan` physical optimization is [executed](#applyInternal).

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.adaptive.InsertAdaptiveSparkPlan` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.adaptive.InsertAdaptiveSparkPlan=ALL
```

Refer to [Logging](../spark-logging.md).
