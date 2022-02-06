# InsertAdaptiveSparkPlan Physical Optimization

`InsertAdaptiveSparkPlan` is a [physical query plan optimization](../catalyst/Rule.md) (`Rule[SparkPlan]`) that [re-optimizes a physical query plan](#apply) (in the middle of query execution, based on runtime statistics).

## Creating Instance

`InsertAdaptiveSparkPlan` takes the following to be created:

* <span id="adaptiveExecutionContext"> [AdaptiveExecutionContext](../adaptive-query-execution/AdaptiveExecutionContext.md)

`InsertAdaptiveSparkPlan` is created when:

* `QueryExecution` is requested for [physical preparations rules](../QueryExecution.md#preparations)

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

`applyInternal` returns the given [SparkPlan](../physical-operators/SparkPlan.md) unmodified when [spark.sql.adaptive.enabled](../configuration-properties.md#spark.sql.adaptive.enabled) is disabled (`false`).

`applyInternal` skips processing the following leaf physical operators (and returns the given [SparkPlan](../physical-operators/SparkPlan.md) unmodified):

* [ExecutedCommandExec](../physical-operators/ExecutedCommandExec.md)
* `CommandResultExec`

`applyInternal` leaves the following parent physical operators unmodified and [handles](#apply) the children:

* [DataWritingCommandExec](../physical-operators/DataWritingCommandExec.md)
* [V2CommandExec](../physical-operators/V2CommandExec.md)

For remaining operators for which [shouldApplyAQE predicate](#shouldApplyAQE) holds, `applyInternal` [checks out whether the physical plan supports Adaptive Query Execution or not](#supportAdaptive).

### Physical Plans Supporting Adaptive Query Execution

`applyInternal` creates a new [PlanAdaptiveSubqueries](../adaptive-query-execution/PlanAdaptiveSubqueries.md) optimization (with [subquery expressions](#buildSubqueryMap)) and [applies](../physical-operators/AdaptiveSparkPlanExec.md#applyPhysicalRules) it to the input `SparkPlan`.

`applyInternal` prints out the following DEBUG message to the logs:

```text
Adaptive execution enabled for plan: [plan]
```

In the end, `applyInternal` creates an [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md) physical operator with the new pre-processed physical query plan.

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

`buildSubqueryMap` finds [ScalarSubquery](../expressions/ScalarSubquery) and [ListQuery](../expressions/ListQuery.md) (in `InSubquery`) expressions (unique by expression ID to reuse the execution plan from another sub-query) in the given [physical query plan](../physical-operators/SparkPlan.md).

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

### <span id="supportAdaptive"> supportAdaptive Predicate

```scala
supportAdaptive(
  plan: SparkPlan): Boolean
```

`supportAdaptive` returns `true` when the given [SparkPlan](../physical-operators/SparkPlan.md) and the children have all [logical operator linked](../physical-operators/SparkPlan.md#logicalLink) that [are not streaming](../logical-operators/LogicalPlan.md#isStreaming).

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.adaptive.InsertAdaptiveSparkPlan` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.adaptive.InsertAdaptiveSparkPlan=ALL
```

Refer to [Logging](../spark-logging.md).
