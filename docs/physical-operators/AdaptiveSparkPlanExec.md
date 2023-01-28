# AdaptiveSparkPlanExec Leaf Physical Operator

`AdaptiveSparkPlanExec` is a [leaf physical operator](SparkPlan.md#LeafExecNode) for [Adaptive Query Execution](../adaptive-query-execution/index.md).

## Creating Instance

`AdaptiveSparkPlanExec` takes the following to be created:

* [Input Physical Plan](#inputPlan)
* [AdaptiveExecutionContext](#context)
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

### <span id="context"> AdaptiveExecutionContext

`AdaptiveSparkPlanExec` is given an [AdaptiveExecutionContext](../adaptive-query-execution/AdaptiveExecutionContext.md) when [created](#creating-instance).

### <span id="optimizer"> Adaptive Logical Optimizer

```scala
optimizer: AQEOptimizer
```

`AdaptiveSparkPlanExec` creates an [AQEOptimizer](../adaptive-query-execution/AQEOptimizer.md) (when [created](#creating-instance)) that is used when requested to [re-optimize a logical query plan](#reOptimize).

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

---

`doExecute` [takes the final physical plan](#getFinalPhysicalPlan) to [execute it](SparkPlan.md#execute) (that generates an `RDD[InternalRow]` that will be the return value).

`doExecute` triggers [finalPlanUpdate](#finalPlanUpdate) (unless done already).

## <span id="doExecuteColumnar"> doExecuteColumnar

```scala
doExecuteColumnar(): RDD[ColumnarBatch]
```

`doExecuteColumnar` is part of the [SparkPlan](SparkPlan.md#doExecuteColumnar) abstraction.

---

`doExecuteColumnar` [withFinalPlanUpdate](#withFinalPlanUpdate) to [executeColumnar](SparkPlan.md#executeColumnar) (that generates a `RDD` of [ColumnarBatch](../ColumnarBatch.md)s to be returned at the end).

## <span id="doExecuteBroadcast"> doExecuteBroadcast

```scala
doExecuteBroadcast[T](): broadcast.Broadcast[T]
```

`doExecuteBroadcast` is part of the [SparkPlan](SparkPlan.md#doExecuteBroadcast) abstraction.

---

`doExecuteBroadcast` [withFinalPlanUpdate](#withFinalPlanUpdate) to [doExecuteBroadcast](SparkPlan.md#doExecuteBroadcast) (that generates a `Broadcast` variable to be returned at the end).

`doExecuteBroadcast` asserts that the final physical plan is a [BroadcastQueryStageExec](BroadcastQueryStageExec.md).

## Specialized Execution Paths

### <span id="executeCollect"> collect

```scala
executeCollect(): Array[InternalRow]
```

`executeCollect` is part of the [SparkPlan](SparkPlan.md#executeCollect) abstraction.

---

`executeCollect`...FIXME

### <span id="executeTail"> tail

```scala
executeTail(
  n: Int): Array[InternalRow]
```

`executeTail` is part of the [SparkPlan](SparkPlan.md#executeTail) abstraction.

---

`executeTail`...FIXME

### <span id="executeTake"> take

```scala
executeTake(
  n: Int): Array[InternalRow]
```

`executeTake` is part of the [SparkPlan](SparkPlan.md#executeTake) abstraction.

---

`executeTake`...FIXME

## <span id="getFinalPhysicalPlan"> Adaptively-Optimized Physical Query Plan

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

```scala
var currentPhysicalPlan: SparkPlan
```

`AdaptiveSparkPlanExec` uses `currentPhysicalPlan` internal registry for an optimized [SparkPlan](SparkPlan.md).

`currentPhysicalPlan` is initialized to be the [initialPlan](#initialPlan) when `AdaptiveSparkPlanExec` operator is [created](#creating-instance),

`currentPhysicalPlan` may change in [getFinalPhysicalPlan](#getFinalPhysicalPlan) until the [isFinalPlan](#isFinalPlan) internal flag is on.

`currentPhysicalPlan` is available using [executedPlan](#executedPlan) method.

### executedPlan

```scala
executedPlan: SparkPlan
```

`executedPlan` returns the [current physical query plan](#currentPhysicalPlan).

---

`executedPlan` is used when:

* `ExplainUtils` is requested to [generateOperatorIDs](../ExplainUtils.md#generateOperatorIDs), [collectOperatorsWithID](../ExplainUtils.md#collectOperatorsWithID), [generateWholeStageCodegenIds](../ExplainUtils.md#generateWholeStageCodegenIds), [getSubqueries](../ExplainUtils.md#getSubqueries), [removeTags](../ExplainUtils.md#removeTags)
* `SparkPlanInfo` is requested to `fromSparkPlan` (for `SparkListenerSQLExecutionStart` and `SparkListenerSQLAdaptiveExecutionUpdate` events)
* `AdaptiveSparkPlanExec` is requested to [reset metrics](#resetMetrics)
* `AdaptiveSparkPlanHelper` is requested to `allChildren` and `stripAQEPlan`
* `PlanAdaptiveDynamicPruningFilters` is [executed](../physical-optimizations/PlanAdaptiveDynamicPruningFilters.md#apply)
* `debug` package object is requested to `codegenStringSeq`

## <span id="resetMetrics"> Resetting Metrics

```scala
resetMetrics(): Unit
```

`resetMetrics` is part of the [SparkPlan](SparkPlan.md#resetMetrics) abstraction.

---

`resetMetrics` requests [all the metrics](SparkPlan.md#metrics) to [reset](../SQLMetric.md#reset).

In the end, `resetMetrics` requests the [executed query plan](#executedPlan) to [resetMetrics](SparkPlan.md#resetMetrics).

## <span id="queryStagePreparationRules"> QueryStage Preparation Rules

```scala
queryStagePreparationRules: Seq[Rule[SparkPlan]]
```

`queryStagePreparationRules` is a single-rule collection of [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization.

`queryStagePreparationRules` is used when `AdaptiveSparkPlanExec` operator is requested for the [current physical plan](#currentPhysicalPlan) and [reOptimize](#reOptimize).

## <span id="optimizeQueryStage"> optimizeQueryStage

```scala
optimizeQueryStage(
  plan: SparkPlan,
  isFinalStage: Boolean): SparkPlan
```

!!! note "isFinalStage"
    The given `isFinalStage` can be as follows:

    * `true` when requested for an [adaptively-optimized physical query plan](#getFinalPhysicalPlan)
    * `false` when requested to [create a new QueryStageExec for an Exchange](#newQueryStage)

`optimizeQueryStage` executes (_applies_) the [queryStageOptimizerRules](#queryStageOptimizerRules) to the given [SparkPlan](SparkPlan.md).
While applying optimizations (_executing rules_), `optimizeQueryStage` requests the [PlanChangeLogger](#planChangeLogger) to [log plan changes (by a rule)](../catalyst/PlanChangeLogger.md#logRule) with the [name](../catalyst/Rule.md#ruleName) of the rule that has just been executed.

!!! note "AQEShuffleReadRule"
    `optimizeQueryStage` is _sensitive_ to [AQEShuffleReadRule](../physical-optimizations/AQEShuffleReadRule.md) physical optimization and does a validation so it does not break distribution requirement of the query plan.

`optimizeQueryStage` requests the [PlanChangeLogger](#planChangeLogger) to [log plan changes by the entire rule batch](../catalyst/PlanChangeLogger.md#logBatch) with the following batch name:

```text
AQE Query Stage Optimization
```

---

`optimizeQueryStage` is used when:

* `AdaptiveSparkPlanExec` is requested for an [adaptively-optimized physical query plan](#getFinalPhysicalPlan) and to [create a new QueryStageExec for an Exchange](#newQueryStage)

## <span id="queryStageOptimizerRules"> Adaptive Optimizations

```scala
queryStageOptimizerRules: Seq[Rule[SparkPlan]]
```

`queryStageOptimizerRules` is the following adaptive optimizations (physical optimization rules):

* [PlanAdaptiveDynamicPruningFilters](../physical-optimizations/PlanAdaptiveDynamicPruningFilters.md)
* [ReuseAdaptiveSubquery](../physical-optimizations/ReuseAdaptiveSubquery.md)
* [OptimizeSkewInRebalancePartitions](../physical-optimizations/OptimizeSkewInRebalancePartitions.md)
* [CoalesceShufflePartitions](../physical-optimizations/CoalesceShufflePartitions.md)
* [OptimizeShuffleWithLocalRead](../physical-optimizations/OptimizeShuffleWithLocalRead.md)

---

`queryStageOptimizerRules` is used when:

* `AdaptiveSparkPlanExec` is requested to [optimizeQueryStage](#optimizeQueryStage)

## <span id="postStageCreationRules"> Post-Stage-Creation Adaptive Optimizations

```scala
postStageCreationRules: Seq[Rule[SparkPlan]]
```

`postStageCreationRules` is the following adaptive optimizations (physical optimization rules):

* [ApplyColumnarRulesAndInsertTransitions](../physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md)
* [CollapseCodegenStages](../physical-optimizations/CollapseCodegenStages.md)

`postStageCreationRules` is used when:

* `AdaptiveSparkPlanExec` is requested to [finalStageOptimizerRules](#finalStageOptimizerRules) and [newQueryStage](#newQueryStage)

## <span id="generateTreeString"> Generating Text Representation

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

`generateTreeString` is part of the [TreeNode](../catalyst/TreeNode.md#generateTreeString) abstraction.

---

`generateTreeString`...FIXME

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

`reOptimize` returns a newly-optimized physical query plan with a newly-optimized logical query plan for the given [logical query plan](../logical-operators/LogicalPlan.md).

---

`reOptimize` requests the given [LogicalPlan](../logical-operators/LogicalPlan.md) to [invalidate statistics cache](../logical-operators/LogicalPlanStats.md#invalidateStatsCache).

`reOptimize` requests the [Adaptive Logical Optimizer](#optimizer) to [execute](../catalyst/RuleExecutor.md#execute) (and generate an optimized logical query plan).

`reOptimize` requests the [Spark Query Planner](../SparkPlanner.md) (bound to the [AdaptiveExecutionContext](#context)) to [plan the optimized logical query plan](../execution-planning-strategies/SparkStrategies.md#plan) (and generate a physical query plan).

`reOptimize` [executes physical optimizations](#applyPhysicalRules) using [preprocessing](#preprocessingRules) and [preparation](#queryStagePreparationRules) rules (and generates an optimized physical query plan).

---

`reOptimize` is used when:

* `AdaptiveSparkPlanExec` physical operator is requested for an [adaptively-optimized physical query plan](#getFinalPhysicalPlan)

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

## <span id="isFinalPlan"> isFinalPlan (Available Already)

```scala
isFinalPlan: Boolean
```

`isFinalPlan` is an internal flag that is used to skip (_short-circuit_) the [expensive process of producing an adaptively-optimized physical query plan](#getFinalPhysicalPlan) (and immediately return the [one that has already been prepared](#currentPhysicalPlan)).

`isFinalPlan` is disabled (`false`) when `AdaptiveSparkPlanExec` is [created](#creating-instance). It is enabled right after an [adaptively-optimized physical query plan has once been prepared](#getFinalPhysicalPlan).

`isFinalPlan` is also used for reporting when `AdaptiveSparkPlanExec` is requested for the following:

* [String arguments](#stringArgs)
* [Generate a text representation](#generateTreeString)

## <span id="stringArgs"> String Arguments

```scala
stringArgs: Iterator[Any]
```

`stringArgs` is part of the [TreeNode](../catalyst/TreeNode.md#stringArgs) abstraction.

---

`stringArgs` is the following (with the [isFinalPlan](#isFinalPlan) flag):

```text
isFinalPlan=[isFinalPlan]
```

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
