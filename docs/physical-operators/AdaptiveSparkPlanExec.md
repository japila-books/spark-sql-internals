# AdaptiveSparkPlanExec Physical Operator

`AdaptiveSparkPlanExec` is a [leaf physical operator](SparkPlan.md#LeafExecNode) for [Adaptive Query Execution](../adaptive-query-execution/index.md).

## Creating Instance

`AdaptiveSparkPlanExec` takes the following to be created:

* <span id="inputPlan"> [SparkPlan](SparkPlan.md)
* <span id="context"> [AdaptiveExecutionContext](../adaptive-query-execution/AdaptiveExecutionContext.md)
* <span id="preprocessingRules"> [Preprocessing physical rules](../catalyst/Rule.md)
* <span id="isSubquery"> `isSubquery` flag

`AdaptiveSparkPlanExec` is created when:

* [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md) physical optimisation is executed

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` [getFinalPhysicalPlan](#getFinalPhysicalPlan) and requests it to [execute](SparkPlan.md#execute) (that generates a `RDD[InternalRow]` that will be the return value).

`doExecute` triggers [finalPlanUpdate](#finalPlanUpdate) (unless done already).

`doExecute` returns the `RDD[InternalRow]`.

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

## <span id="executeCollect"> Executing for Collect Operator

```scala
executeCollect(): Array[InternalRow]
```

`executeCollect`...FIXME

`executeCollect` is part of the [SparkPlan](SparkPlan.md#executeCollect) abstraction.

## <span id="executeTail"> Executing for Tail Operator

```scala
executeTail(
  n: Int): Array[InternalRow]
```

`executeTail`...FIXME

`executeTail` is part of the [SparkPlan](SparkPlan.md#executeTail) abstraction.

## <span id="executeTake"> Executing for Take Operator

```scala
executeTake(
  n: Int): Array[InternalRow]
```

`executeTake`...FIXME

`executeTake` is part of the [SparkPlan](SparkPlan.md#executeTake) abstraction.

## <span id="getFinalPhysicalPlan"> Final Physical Query Plan

```scala
getFinalPhysicalPlan(): SparkPlan
```

!!! note
    `getFinalPhysicalPlan` uses the [isFinalPlan](#isFinalPlan) internal flag (and an [optimized physical query plan](#currentPhysicalPlan)) to short-circuit (_skip_) the whole computation.

### <span id="getFinalPhysicalPlan-createQueryStages"> Step 1. createQueryStages

`getFinalPhysicalPlan` [createQueryStages](#createQueryStages) with the [currentPhysicalPlan](#currentPhysicalPlan).

### <span id="getFinalPhysicalPlan-while-allChildStagesMaterialized"> Step 2. Until allChildStagesMaterialized

`getFinalPhysicalPlan` executes the following until `allChildStagesMaterialized`.

### <span id="getFinalPhysicalPlan-while-allChildStagesMaterialized-newStages"> Step 2.1 New QueryStageExecs

`getFinalPhysicalPlan` does the following when there are new stages to be processed:

* FIXME

### <span id="getFinalPhysicalPlan-while-allChildStagesMaterialized-StageMaterializationEvents"> Step 2.2 StageMaterializationEvents

`getFinalPhysicalPlan` executes the following until `allChildStagesMaterialized`:

* FIXME

### <span id="getFinalPhysicalPlan-while-allChildStagesMaterialized-errors"> Step 2.3 Errors

In case of errors, `getFinalPhysicalPlan` [cleanUpAndThrowException](#cleanUpAndThrowException).

### <span id="getFinalPhysicalPlan-while-allChildStagesMaterialized-replaceWithQueryStagesInLogicalPlan"> Step 2.4 replaceWithQueryStagesInLogicalPlan

`getFinalPhysicalPlan` [replaceWithQueryStagesInLogicalPlan](#replaceWithQueryStagesInLogicalPlan) with the `currentLogicalPlan` and the `stagesToReplace`.

### <span id="getFinalPhysicalPlan-while-allChildStagesMaterialized-reOptimize"> Step 2.5 reOptimize

`getFinalPhysicalPlan` [reOptimize](#reOptimize) the new logical plan.

### <span id="getFinalPhysicalPlan-while-allChildStagesMaterialized-evaluateCost"> Step 2.6 Evaluating Cost

`getFinalPhysicalPlan` requests the [SimpleCostEvaluator](#costEvaluator) to [evaluateCost](../adaptive-query-execution/SimpleCostEvaluator.md#evaluateCost) of the [currentPhysicalPlan](#currentPhysicalPlan) and the new `newPhysicalPlan`.

### <span id="getFinalPhysicalPlan-while-allChildStagesMaterialized-plan-changed"> Step 2.7 Adopting New Physical Plan

`getFinalPhysicalPlan` adopts the new plan if the cost is less than the [currentPhysicalPlan](#currentPhysicalPlan) or the costs are equal but the physical plans are different (likely better).

`getFinalPhysicalPlan` prints out the following message to the logs (using the [logOnLevel](#logOnLevel)):

```text
Plan changed from [currentPhysicalPlan] to [newPhysicalPlan]
```

`getFinalPhysicalPlan` [cleanUpTempTags](#cleanUpTempTags) with the `newPhysicalPlan`.

`getFinalPhysicalPlan` saves the `newPhysicalPlan` as the [currentPhysicalPlan](#currentPhysicalPlan) (alongside the `currentLogicalPlan` with the `newLogicalPlan`).

`getFinalPhysicalPlan` resets the `stagesToReplace`.

### <span id="getFinalPhysicalPlan-while-allChildStagesMaterialized-createQueryStages"> Step 2.8 createQueryStages

`getFinalPhysicalPlan` [createQueryStages](#createQueryStages) for the [currentPhysicalPlan](#currentPhysicalPlan) (that [may have changed](#getFinalPhysicalPlan-plan-changed)).

### <span id="getFinalPhysicalPlan-applyPhysicalRules"> Step 3. applyPhysicalRules

`getFinalPhysicalPlan` [applyPhysicalRules](#applyPhysicalRules) on the final plan (with the [finalStageOptimizerRules](#finalStageOptimizerRules), the [planChangeLogger](#planChangeLogger) and **AQE Final Query Stage Optimization** name).

`getFinalPhysicalPlan` turns the [isFinalPlan](#isFinalPlan) internal flag on.

### <span id="getFinalPhysicalPlan-usage"> Usage

`getFinalPhysicalPlan` is used when:

* `AdaptiveSparkPlanExec` physical operator is requested to [executeCollect](#executeCollect), [executeTake](#executeTake), [executeTail](#executeTail) and [execute](#doExecute)

### <span id="finalStageOptimizerRules"> finalStageOptimizerRules

```scala
finalStageOptimizerRules: Seq[Rule[SparkPlan]]
```

`finalStageOptimizerRules`...FIXME

### <span id="createQueryStages"> createQueryStages

```scala
createQueryStages(
  plan: SparkPlan): CreateStageResult
```

`createQueryStages`...FIXME

### <span id="newQueryStage"> newQueryStage

```scala
newQueryStage(
  e: Exchange): QueryStageExec
```

`newQueryStage` [creates an optimized physical query plan](#applyPhysicalRules) for the child physical plan of the given [Exchange](Exchange.md) (using the [queryStageOptimizerRules](#queryStageOptimizerRules)).

`newQueryStage` creates a [QueryStageExec](QueryStageExec.md) physical operator for the given `Exchange` with the child physical plan as the optimized physical query plan:

* For [ShuffleExchangeExec](ShuffleExchangeExec.md), `newQueryStage` creates a [ShuffleQueryStageExec](ShuffleQueryStageExec.md) (with the [currentStageId](#currentStageId) counter and the `ShuffleExchangeExec` with the optimized plan as the child).

* For [BroadcastExchangeExec](BroadcastExchangeExec.md), `newQueryStage` creates a [BroadcastQueryStageExec](BroadcastQueryStageExec.md) (with the [currentStageId](#currentStageId) counter and the `BroadcastExchangeExec` with the optimized plan as the child).

`newQueryStage` increments the [currentStageId](#currentStageId) counter.

`newQueryStage` [setLogicalLinkForNewQueryStage](#setLogicalLinkForNewQueryStage) for the `QueryStageExec` physical operator.

In the end, `newQueryStage` returns the `QueryStageExec` physical operator.

## <span id="currentPhysicalPlan"><span id="executedPlan"> Optimized Physical Query Plan

`AdaptiveSparkPlanExec` uses `currentPhysicalPlan` internal registry for an optimized [physical query plan](SparkPlan.md) (that is available as `executedPlan` method).

Initially, when `AdaptiveSparkPlanExec` operator is [created](#creating-instance), `currentPhysicalPlan` is the [initialPlan](#initialPlan).

`currentPhysicalPlan` may change in [getFinalPhysicalPlan](#getFinalPhysicalPlan) until the [isFinalPlan](#isFinalPlan) internal flag is on.

## <span id="queryStagePreparationRules"> QueryStage Preparation Rules

```scala
queryStagePreparationRules: Seq[Rule[SparkPlan]]
```

`queryStagePreparationRules` is a single-rule collection of [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization.

`queryStagePreparationRules` is used when `AdaptiveSparkPlanExec` operator is requested for the [current physical plan](#currentPhysicalPlan) and [reOptimize](#reOptimize).

## <span id="queryStageOptimizerRules"> Adaptive Optimizations

```scala
queryStageOptimizerRules: Seq[Rule[SparkPlan]]
```

`AdaptiveSparkPlanExec` uses the following adaptive optimizations (physical optimization rules):

* [ReuseAdaptiveSubquery](../physical-optimizations/ReuseAdaptiveSubquery.md)
* [CoalesceShufflePartitions](../physical-optimizations/CoalesceShufflePartitions.md)
* [OptimizeSkewedJoin](../physical-optimizations/OptimizeSkewedJoin.md)
* [OptimizeLocalShuffleReader](../physical-optimizations/OptimizeLocalShuffleReader.md)
* [ApplyColumnarRulesAndInsertTransitions](../physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md)
* [CollapseCodegenStages](../physical-optimizations/CollapseCodegenStages.md)

`queryStageOptimizerRules` is used when `AdaptiveSparkPlanExec` is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan) and [newQueryStage](#newQueryStage).

## <span id="generateTreeString"> generateTreeString

```scala
generateTreeString(
  depth: Int,
  lastChildren: Seq[Boolean],
  append: String => Unit,
  verbose: Boolean,
  prefix: String = "",
  addSuffix: Boolean = false,
  maxFields: Int,
  printNodeId: Boolean): Unit
```

`generateTreeString`...FIXME

`generateTreeString` is part of the [TreeNode](../catalyst/TreeNode.md#generateTreeString) abstraction.

## <span id="reuseQueryStage"> reuseQueryStage

```scala
reuseQueryStage(
  existing: QueryStageExec,
  exchange: Exchange): QueryStageExec
```

`reuseQueryStage`...FIXME

`reuseQueryStage` is used when `AdaptiveSparkPlanExec` physical operator is requested to [createQueryStages](#createQueryStages).

## <span id="cleanUpAndThrowException"> cleanUpAndThrowException

```scala
cleanUpAndThrowException(
  errors: Seq[Throwable],
  earlyFailedStage: Option[Int]): Unit
```

`cleanUpAndThrowException`...FIXME

`cleanUpAndThrowException` is used when `AdaptiveSparkPlanExec` physical operator is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan) (and materialization of new stages fails).

## <span id="reOptimize"> Re-Optimizing Logical Query Plan

```scala
reOptimize(
  logicalPlan: LogicalPlan): (SparkPlan, LogicalPlan)
```

`reOptimize` gives optimized physical and logical query plans for the given [logical query plan](../logical-operators/LogicalPlan.md).

Internally, `reOptimize` requests the given [logical query plan](../logical-operators/LogicalPlan.md) to [invalidateStatsCache](../logical-operators/LogicalPlanStats.md#invalidateStatsCache) and requests the [local logical optimizer](#optimizer) to generate an optimized logical query plan.

`reOptimize` requests the [query planner](../SparkPlanner.md) (bound to the [AdaptiveExecutionContext](#context)) to [plan the optimized logical query plan](../execution-planning-strategies/SparkStrategies.md#plan) (and generate a physical query plan).

`reOptimize` [creates an optimized physical query plan](#applyPhysicalRules) using [preprocessing](#preprocessingRules) and [preparation](#queryStagePreparationRules) rules.

`reOptimize` is used when `AdaptiveSparkPlanExec` physical operator is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan) (and materialization of new stages fails).

## <span id="optimizer"> Logical Adaptive Optimizer

```scala
optimizer: RuleExecutor[LogicalPlan]
```

`optimizer` is a [RuleExecutor](../catalyst/RuleExecutor.md) to transform [logical query plans](../logical-operators/LogicalPlan.md).

`optimizer` has a single **Demote BroadcastHashJoin** rule batch with [DemoteBroadcastHashJoin](../logical-optimizations/DemoteBroadcastHashJoin.md) logical optimization only.

`optimizer` is used when `AdaptiveSparkPlanExec` physical operator is requested to [re-optimize a logical query plan](#reOptimize).

## <span id="executionContext"> QueryStageCreator Thread Pool

```scala
executionContext: ExecutionContext
```

`executionContext` is an `ExecutionContext` that is used when:

* `AdaptiveSparkPlanExec` operator is requested for a [getFinalPhysicalPlan](#getFinalPhysicalPlan) (to [materialize QueryStageExec operators](QueryStageExec.md#materialize) asynchronously)

* [BroadcastQueryStageExec](BroadcastQueryStageExec.md) operator is requested for [materializeWithTimeout](BroadcastQueryStageExec.md#materializeWithTimeout)

## <span id="finalPlanUpdate"> finalPlanUpdate Lazy Value

```scala
finalPlanUpdate: Unit
```

??? note "lazy value"
    `finalPlanUpdate` is a Scala lazy value which is computed once when accessed and cached afterwards.

`finalPlanUpdate`...FIXME

In the end, `finalPlanUpdate` [prints out](#logOnLevel) the following message to the logs:

```text
Final plan: [currentPhysicalPlan]
```

`finalPlanUpdate` is used when `AdaptiveSparkPlanExec` physical operator is requested to [executeCollect](#executeCollect), [executeTake](#executeTake), [executeTail](#executeTail) and [doExecute](#doExecute).

## <span id="isFinalPlan"> isFinalPlan Internal Flag

```scala
isFinalPlan: Boolean = false
```

`isFinalPlan` is an internal flag to avoid expensive [getFinalPhysicalPlan](#getFinalPhysicalPlan) (and return the [current optimized physical query plan](#currentPhysicalPlan) immediately)

`isFinalPlan` is disabled by default and turned on at the end of [getFinalPhysicalPlan](#getFinalPhysicalPlan).

`isFinalPlan` is also used when:

* `AdaptiveSparkPlanExec` is requested for [stringArgs](#stringArgs)

## <span id="initialPlan"> Initial Physical Plan and AQE Preparations

```scala
initialPlan: SparkPlan
```

`AdaptiveSparkPlanExec` defines an `initialPlan` internal registry for a [physical query plan](SparkPlan.md) when [created](#creating-instance).

`initialPlan` is a [physical query plan](SparkPlan.md) after [executing](#applyPhysicalRules) the [queryStagePreparationRules](#queryStagePreparationRules) on the [inputPlan](#inputPlan) (with the [planChangeLogger](#planChangeLogger) and **AQE Preparations** name).

`initialPlan` is an internal flag to avoid expensive [getFinalPhysicalPlan](#getFinalPhysicalPlan) (and return the [current optimized physical query plan](#currentPhysicalPlan) immediately)

`initialPlan` is disabled by default and turned on at the end of [getFinalPhysicalPlan](#getFinalPhysicalPlan).

`initialPlan` is also used when:

* `AdaptiveSparkPlanExec` is requested for [stringArgs](#stringArgs)

## <span id="replaceWithQueryStagesInLogicalPlan"> replaceWithQueryStagesInLogicalPlan

```scala
replaceWithQueryStagesInLogicalPlan(
  plan: LogicalPlan,
  stagesToReplace: Seq[QueryStageExec]): LogicalPlan
```

`replaceWithQueryStagesInLogicalPlan`...FIXME

`replaceWithQueryStagesInLogicalPlan` is used when `AdaptiveSparkPlanExec` physical operator is requested for a [final physical plan](#getFinalPhysicalPlan).

## <span id="applyPhysicalRules"> Executing Physical Rules

```scala
applyPhysicalRules(
  plan: SparkPlan,
  rules: Seq[Rule[SparkPlan]]): SparkPlan
```

`applyPhysicalRules` simply applies (_executes_) the given rules to the given [physical query plan](SparkPlan.md).

`applyPhysicalRules` is used when:

* `AdaptiveSparkPlanExec` physical operator is created (and initializes the [initialPlan](#initialPlan)), is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan), [newQueryStage](#newQueryStage), [reOptimize](#reOptimize)
* [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md) physical optimization is executed

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.adaptive.AdaptiveSparkPlanExec` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.adaptive.AdaptiveSparkPlanExec=ALL
```

Refer to [Logging](../spark-logging.md).

### <span id="planChangeLogger"> PlanChangeLogger

`AdaptiveSparkPlanExec` uses a [PlanChangeLogger](../catalyst/PlanChangeLogger.md) for the following:

* [initialPlan](#initialPlan) (`batchName`: **AQE Preparations**)
* [getFinalPhysicalPlan](#getFinalPhysicalPlan) (`batchName`: **AQE Final Query Stage Optimization**)
* [newQueryStage](#newQueryStage) (`batchName`: **AQE Query Stage Optimization** and **AQE Post Stage Creation**)
* [reOptimize](#reOptimize) (`batchName`: **AQE Replanning**)

### <span id="logOnLevel"> logOnLevel

```scala
logOnLevel: (=> String) => Unit
```

`logOnLevel` uses the internal [spark.sql.adaptive.logLevel](../configuration-properties.md#spark.sql.adaptive.logLevel) configuration property for the logging level and prints out the given message to the logs (at the log level).

`logOnLevel` is used when:

* `AdaptiveSparkPlanExec` physical operator is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan) and [finalPlanUpdate](#finalPlanUpdate)
