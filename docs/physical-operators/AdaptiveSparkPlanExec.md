# AdaptiveSparkPlanExec Leaf Physical Operator

`AdaptiveSparkPlanExec` is a [leaf physical operator](SparkPlan.md#LeafExecNode) for [Adaptive Query Execution](../adaptive-query-execution/index.md).

## Creating Instance

`AdaptiveSparkPlanExec` takes the following to be created:

* [Input Physical Plan](#inputPlan)
* <span id="context"> [AdaptiveExecutionContext](../adaptive-query-execution/AdaptiveExecutionContext.md)
* <span id="preprocessingRules"> Preprocessing physical rules ([Rule](../catalyst/Rule.md)s of [SparkPlan](SparkPlan.md))
* <span id="isSubquery"> `isSubquery` flag
* <span id="supportsColumnar"> `supportsColumnar` flag (default: `false`)

`AdaptiveSparkPlanExec` is created when:

* [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md) physical optimization is executed

### <span id="inputPlan"> Input Physical Plan

`AdaptiveSparkPlanExec` is given a [SparkPlan](SparkPlan.md) when [created](#creating-instance).

The `SparkPlan` is determined when [PlanAdaptiveDynamicPruningFilters](../physical-optimizations/PlanAdaptiveDynamicPruningFilters.md) adaptive physical optimization is executed and can be one of the following:

* [BroadcastExchangeExec](BroadcastExchangeExec.md) physical operator (with [spark.sql.exchange.reuse](../configuration-properties.md#spark.sql.exchange.reuse) configuration property enabled)
* Planned [Aggregate](../logical-operators/Aggregate.md) logical operator (otherwise)

The `SparkPlan` is used for the following:

* [requiredDistribution](#requiredDistribution), [initialPlan](#initialPlan), [output](#output), [doCanonicalize](#doCanonicalize), [getFinalPhysicalPlan](#getFinalPhysicalPlan), [hashCode](#hashCode) and [equals](#equals)

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` [takes the final physical plan](#getFinalPhysicalPlan) to [execute it](SparkPlan.md#execute) (that generates an `RDD[InternalRow]` that will be the return value).

`doExecute` triggers [finalPlanUpdate](#finalPlanUpdate) (unless done already).

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

## <span id="doExecuteColumnar"> doExecuteColumnar

```scala
doExecuteColumnar(): RDD[ColumnarBatch]
```

`doExecuteColumnar` [withFinalPlanUpdate](#withFinalPlanUpdate) to [executeColumnar](SparkPlan.md#executeColumnar) (that generates a `RDD` of [ColumnarBatch](../ColumnarBatch.md)s to be returned at the end).

`doExecuteColumnar` is part of the [SparkPlan](SparkPlan.md#doExecuteColumnar) abstraction.

## <span id="doExecuteBroadcast"> doExecuteBroadcast

```scala
doExecuteBroadcast[T](): broadcast.Broadcast[T]
```

`doExecuteBroadcast` [withFinalPlanUpdate](#withFinalPlanUpdate) to [doExecuteBroadcast](SparkPlan.md#doExecuteBroadcast) (that generates a `Broadcast` variable to be returned at the end).

`doExecuteBroadcast` asserts that the final physical plan is a [BroadcastQueryStageExec](BroadcastQueryStageExec.md).

`doExecuteBroadcast` is part of the [SparkPlan](SparkPlan.md#doExecuteBroadcast) abstraction.

## Specialized Execution Paths

### <span id="executeCollect"> collect

```scala
executeCollect(): Array[InternalRow]
```

`executeCollect`...FIXME

`executeCollect` is part of the [SparkPlan](SparkPlan.md#executeCollect) abstraction.

### <span id="executeTail"> tail

```scala
executeTail(
  n: Int): Array[InternalRow]
```

`executeTail`...FIXME

`executeTail` is part of the [SparkPlan](SparkPlan.md#executeTail) abstraction.

### <span id="executeTake"> take

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
    `getFinalPhysicalPlan` uses the [isFinalPlan](#isFinalPlan) internal flag (and an [optimized physical query plan](#currentPhysicalPlan)) to short-circuit (_skip_) the whole expensive computation.

`getFinalPhysicalPlan` is used when:

* `AdaptiveSparkPlanExec` physical operator is requested to [withFinalPlanUpdate](#withFinalPlanUpdate)

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

`createQueryStages` checks if the given [SparkPlan](SparkPlan.md) is one of the following:

1. [Exchange](Exchange.md) unary physical operator
1. [QueryStageExec](QueryStageExec.md) leaf physical operator
1. Others

The most interesting case is when the given `SparkPlan` is an [Exchange](Exchange.md) unary physical operator.

### <span id="reuseQueryStage"> reuseQueryStage

```scala
reuseQueryStage(
  existing: QueryStageExec,
  exchange: Exchange): QueryStageExec
```

`reuseQueryStage` requests the given [QueryStageExec](QueryStageExec.md) to [newReuseInstance](QueryStageExec.md#newReuseInstance) (with the [currentStageId](#currentStageId)).

`reuseQueryStage` increments the [currentStageId](#currentStageId).

`reuseQueryStage` [setLogicalLinkForNewQueryStage](#setLogicalLinkForNewQueryStage).

### <span id="newQueryStage"> Creating QueryStageExec for Exchange

```scala
newQueryStage(
  e: Exchange): QueryStageExec
```

`newQueryStage` creates a new [QueryStageExec](QueryStageExec.md) physical operator based on the type of the given [Exchange](Exchange.md) physical operator.

Exchange | QueryStageExec
---------|---------
 [ShuffleExchangeLike](ShuffleExchangeLike.md) | [ShuffleQueryStageExec](ShuffleQueryStageExec.md)
 [BroadcastExchangeLike](BroadcastExchangeLike.md) | [BroadcastQueryStageExec](BroadcastQueryStageExec.md)

---

`newQueryStage` [creates an optimized physical query plan](#applyPhysicalRules) for the [child physical plan](UnaryExecNode.md#child) of the given [Exchange](Exchange.md). `newQueryStage` uses the [adaptive optimizations](#queryStageOptimizerRules), the [PlanChangeLogger](#planChangeLogger) and **AQE Query Stage Optimization** batch name.

`newQueryStage` creates a new [QueryStageExec](QueryStageExec.md) physical operator for the given `Exchange` operator (using the [currentStageId](#currentStageId) for the ID).

After [applyPhysicalRules](#applyPhysicalRules) for the child operator, `newQueryStage` [creates an optimized physical query plan](#applyPhysicalRules) for the [Exchange](Exchange.md) itself (with the new optimized physical query plan for the child). `newQueryStage` uses the [post-stage-creation optimizations](#postStageCreationRules), the [PlanChangeLogger](#planChangeLogger) and **AQE Post Stage Creation** batch name.

`newQueryStage` increments the [currentStageId](#currentStageId) counter.

`newQueryStage` [associates the new query stage operator](#setLogicalLinkForNewQueryStage) with the `Exchange` physical operator.

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

`queryStageOptimizerRules` is the following adaptive optimizations (physical optimization rules):

* [PlanAdaptiveDynamicPruningFilters](../physical-optimizations/PlanAdaptiveDynamicPruningFilters.md)
* [ReuseAdaptiveSubquery](../physical-optimizations/ReuseAdaptiveSubquery.md)
* [OptimizeSkewedJoin](../physical-optimizations/OptimizeSkewedJoin.md)
* [OptimizeSkewInRebalancePartitions](../physical-optimizations/OptimizeSkewInRebalancePartitions.md)
* [CoalesceShufflePartitions](../physical-optimizations/CoalesceShufflePartitions.md)
* [OptimizeShuffleWithLocalRead](../physical-optimizations/OptimizeShuffleWithLocalRead.md)

`queryStageOptimizerRules` is used when:

* `AdaptiveSparkPlanExec` is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan) and [newQueryStage](#newQueryStage)

## <span id="postStageCreationRules"> Post-Stage-Creation Adaptive Optimizations

```scala
postStageCreationRules: Seq[Rule[SparkPlan]]
```

`postStageCreationRules` is the following adaptive optimizations (physical optimization rules):

* [ApplyColumnarRulesAndInsertTransitions](../physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md)
* [CollapseCodegenStages](../physical-optimizations/CollapseCodegenStages.md)

`postStageCreationRules` is used when:

* `AdaptiveSparkPlanExec` is requested to [finalStageOptimizerRules](#finalStageOptimizerRules) and [newQueryStage](#newQueryStage)

## <span id="generateTreeString"> Text Representation

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

## <span id="optimizer"> Adaptive Logical Optimizer

```scala
optimizer: AQEOptimizer
```

`AdaptiveSparkPlanExec` creates an [AQEOptimizer](../adaptive-query-execution/AQEOptimizer.md) (while [created](#creating-instance)) for [re-optimizing a logical query plan](#reOptimize).

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

## <span id="isFinalPlan"> isFinalPlan Flag

```scala
isFinalPlan: Boolean
```

`isFinalPlan` is an internal flag to avoid expensive [getFinalPhysicalPlan](#getFinalPhysicalPlan) (and return the [current optimized physical query plan](#currentPhysicalPlan) immediately).

`isFinalPlan` is off (`false`) by default. It is turned on at the end of [getFinalPhysicalPlan](#getFinalPhysicalPlan).

`isFinalPlan` is also used when:

* `AdaptiveSparkPlanExec` is requested for [stringArgs](#stringArgs) and [generateTreeString](#generateTreeString)

## <span id="initialPlan"> Initial Plan

```scala
initialPlan: SparkPlan
```

`AdaptiveSparkPlanExec` initializes `initialPlan` value when [created](#creating-instance).

`initialPlan` is a [SparkPlan](SparkPlan.md) after [applying](#applyPhysicalRules) the [queryStagePreparationRules](#queryStagePreparationRules) to the [inputPlan](#inputPlan) (with the [planChangeLogger](#planChangeLogger) and **AQE Preparations** batch name).

`initialPlan` is the [currentPhysicalPlan](#currentPhysicalPlan) when `AdaptiveSparkPlanExec` is [created](#creating-instance).

`isFinalPlan` is used when:

* `AdaptiveSparkPlanExec` is requested for a [text representation](#generateTreeString)
* `ExplainUtils` utility is used to [process a query plan](../ExplainUtils.md#processPlan)

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
  rules: Seq[Rule[SparkPlan]],
  loggerAndBatchName: Option[(PlanChangeLogger[SparkPlan], String)] = None): SparkPlan
```

By default (with no `loggerAndBatchName` given) `applyPhysicalRules` applies (_executes_) the given rules to the given [physical query plan](SparkPlan.md).

With `loggerAndBatchName` specified, `applyPhysicalRules` executes the rules and, for every rule, requests the [PlanChangeLogger](../catalyst/PlanChangeLogger.md) to [logRule](../catalyst/PlanChangeLogger.md#logRule). In the end, `applyPhysicalRules` requests the `PlanChangeLogger` to [logBatch](../catalyst/PlanChangeLogger.md#logBatch).

`applyPhysicalRules` is used when:

* `AdaptiveSparkPlanExec` physical operator is created (and initializes the [initialPlan](#initialPlan)), is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan), [newQueryStage](#newQueryStage), [reOptimize](#reOptimize)
* [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md) physical optimization is executed

## <span id="withFinalPlanUpdate"> withFinalPlanUpdate

```scala
withFinalPlanUpdate[T](
  fun: SparkPlan => T): T
```

`withFinalPlanUpdate` executes the given `fun` with the [final physical plan](#getFinalPhysicalPlan) and returns the result (of type `T`). In the end, `withFinalPlanUpdate` [finalPlanUpdate](#finalPlanUpdate).

`withFinalPlanUpdate` is used when:

* `AdaptiveSparkPlanExec` is requested to [executeCollect](#executeCollect), [executeTake](#executeTake), [executeTail](#executeTail), [doExecute](#doExecute), [doExecuteColumnar](#doExecuteColumnar) and [doExecuteBroadcast](#doExecuteBroadcast)

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
