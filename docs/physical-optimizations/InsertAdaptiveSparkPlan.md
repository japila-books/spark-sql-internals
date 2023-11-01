---
title: InsertAdaptiveSparkPlan
---

# InsertAdaptiveSparkPlan Physical Optimization

`InsertAdaptiveSparkPlan` is a physical query plan optimization in [Adaptive Query Execution](../adaptive-query-execution/index.md) that [inserts AdaptiveSparkPlanExec operators](#apply).

`InsertAdaptiveSparkPlan` is a [Rule](../catalyst/Rule.md) to transform a [SparkPlan](../physical-operators/SparkPlan.md) (`Rule[SparkPlan]`).

## Creating Instance

`InsertAdaptiveSparkPlan` takes the following to be created:

* [AdaptiveExecutionContext](#adaptiveExecutionContext)

`InsertAdaptiveSparkPlan` is created when:

* `QueryExecution` is requested for [physical preparations rules](../QueryExecution.md#preparations)

### <span id="adaptiveExecutionContext"> AdaptiveExecutionContext

`InsertAdaptiveSparkPlan` is given an [AdaptiveExecutionContext](../adaptive-query-execution/AdaptiveExecutionContext.md) when [created](#creating-instance).

The `AdaptiveExecutionContext` is used to create an [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md#context) physical operator (for a plan) when [executed](#applyInternal).

## <span id="shouldApplyAQE"> Adaptive Requirements

```scala
shouldApplyAQE(
  plan: SparkPlan,
  isSubquery: Boolean): Boolean
```

`shouldApplyAQE` returns `true` when one of the following conditions holds:

1. [spark.sql.adaptive.forceApply](../configuration-properties.md#spark.sql.adaptive.forceApply) configuration property is enabled
1. The given `isSubquery` flag is `true` (a shortcut to continue since the input plan is from a sub-query and it was already decided to apply AQE for the main query)
1. The given [SparkPlan](../physical-operators/SparkPlan.md) contains one of the following physical operators:
    1. [Exchange](../physical-operators/Exchange.md)
    1. Operators with an [UnspecifiedDistribution](../physical-operators/Distribution.md#UnspecifiedDistribution) among the [requiredChildDistribution](../physical-operators/SparkPlan.md#requiredChildDistribution) (and the query may need to add exchanges)
    1. Operators with [SubqueryExpression](../expressions/SubqueryExpression.md)

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

`applyInternal` returns the given [SparkPlan](../physical-operators/SparkPlan.md) unmodified when one of the following holds:

1. [spark.sql.adaptive.enabled](../configuration-properties.md#spark.sql.adaptive.enabled) configuration property is disabled (`false`)
1. The given `SparkPlan` is either [ExecutedCommandExec](../physical-operators/ExecutedCommandExec.md) or `CommandResultExec`

`applyInternal` skips processing the following parent physical operators and [handles](#apply) the children:

* [DataWritingCommandExec](../physical-operators/DataWritingCommandExec.md)
* [V2CommandExec](../physical-operators/V2CommandExec.md)

For all the other `SparkPlan`s, `applyInternal` checks out [shouldApplyAQE condition](#shouldApplyAQE). If holds, `applyInternal` [checks out whether the physical plan supports Adaptive Query Execution or not](#supportAdaptive).

### Physical Plans Supporting Adaptive Query Execution

`applyInternal` creates a new [PlanAdaptiveSubqueries](PlanAdaptiveSubqueries.md) optimization (with [subquery expressions](#buildSubqueryMap)) and [executes](../physical-operators/AdaptiveSparkPlanExec.md#applyPhysicalRules) it on the given `SparkPlan`.

`applyInternal` prints out the following DEBUG message to the logs:

```text
Adaptive execution enabled for plan: [plan]
```

In the end, `applyInternal` creates an [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md) physical operator with the new pre-processed `SparkPlan`.

In case of `SubqueryAdaptiveNotSupportedException`, `applyInternal` prints out the WARN message and returns the given physical plan.

```text
spark.sql.adaptive.enabled is enabled but is not supported for sub-query: [subquery].
```

### Unsupported Physical Plans

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

`buildSubqueryMap` finds [ScalarSubquery](../expressions/ScalarSubquery.md) and [ListQuery](../expressions/ListQuery.md) (in [InSubquery](../expressions/InSubquery.md)) expressions (unique by expression ID to reuse the execution plan from another sub-query) in the given [physical query plan](../physical-operators/SparkPlan.md).

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

`verifyAdaptivePlan` throws a `SubqueryAdaptiveNotSupportedException` when the given [SparkPlan](../physical-operators/SparkPlan.md) is not a [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md).

### <span id="supportAdaptive"> supportAdaptive Condition

```scala
supportAdaptive(
  plan: SparkPlan): Boolean
```

`supportAdaptive` returns `true` when the given [SparkPlan](../physical-operators/SparkPlan.md) and the children have all [logical operator linked](../physical-operators/SparkPlan.md#logicalLink) that [are not streaming](../logical-operators/LogicalPlan.md#isStreaming).

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.adaptive.InsertAdaptiveSparkPlan` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
logger.InsertAdaptiveSparkPlan.name = org.apache.spark.sql.execution.adaptive.InsertAdaptiveSparkPlan
logger.InsertAdaptiveSparkPlan.level = all
```

Refer to [Logging](../spark-logging.md).
