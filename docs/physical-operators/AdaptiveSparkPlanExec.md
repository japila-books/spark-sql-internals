# AdaptiveSparkPlanExec Physical Operator

`AdaptiveSparkPlanExec` is a [leaf physical operator](SparkPlan.md#LeafExecNode) for [Adaptive Query Execution](../new-and-noteworthy/adaptive-query-execution.md).

## Creating Instance

`AdaptiveSparkPlanExec` takes the following to be created:

* <span id="initialPlan"> Initial [physical query plan](SparkPlan.md)
* <span id="context"> [AdaptiveExecutionContext](../physical-optimizations/AdaptiveExecutionContext.md)
* <span id="preprocessingRules"> [Preprocessing physical rules](../catalyst/Rule.md)
* <span id="isSubquery"> `isSubquery` flag

`AdaptiveSparkPlanExec` is created when [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md) physical optimisation is executed.

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

`getFinalPhysicalPlan`...FIXME

`getFinalPhysicalPlan` is used when `AdaptiveSparkPlanExec` physical operator is requested to [executeCollect](#executeCollect), [executeTake](#executeTake), [executeTail](#executeTail) and [execute](#doExecute).

## <span id="currentPhysicalPlan"> Current Optimized Physical Query Plan

```scala
currentPhysicalPlan: SparkPlan
```

`currentPhysicalPlan` is a [physical query plan](SparkPlan.md) that `AdaptiveSparkPlanExec` operator creates right when [created](#creating-instance).

`currentPhysicalPlan` is the [initial physical query plan](#initialPlan) after [applying](#applyPhysicalRules) the [queryStagePreparationRules](#queryStagePreparationRules).

## <span id="queryStagePreparationRules"> QueryStage Preparation Rules

```scala
queryStagePreparationRules: Seq[Rule[SparkPlan]]
```

`queryStagePreparationRules` is a single-rule collection of [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization.

`queryStagePreparationRules` is used when `AdaptiveSparkPlanExec` operator is requested for the [current physical plan](#currentPhysicalPlan) and [reOptimize](#reOptimize).

## <span id="queryStageOptimizerRules"> QueryStage Optimizer Rules

```scala
queryStageOptimizerRules: Seq[Rule[SparkPlan]]
```

`AdaptiveSparkPlanExec` defines the following physical optimization rules:

* ReuseAdaptiveSubquery
* [CoalesceShufflePartitions](../physical-optimizations/CoalesceShufflePartitions.md)
* OptimizeSkewedJoin
* OptimizeLocalShuffleReader
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

## <span id="createQueryStages"> createQueryStages

```scala
createQueryStages(
  plan: SparkPlan): CreateStageResult
```

`createQueryStages`...FIXME

`createQueryStages` is used when `AdaptiveSparkPlanExec` physical operator is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan).

## <span id="newQueryStage"> newQueryStage

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

`newQueryStage` is used when `AdaptiveSparkPlanExec` is requested to [createQueryStages](#createQueryStages).

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

Internally, `reOptimize` requests the given [logical query plan](../logical-operators/LogicalPlan.md) to [invalidateStatsCache](../spark-sql-LogicalPlanStats.md#invalidateStatsCache) and requests the [local logical optimizer](#optimizer) to generate an optimized logical query plan.

`reOptimize` requests the [query planner](../SparkPlanner.md) (bound to the [AdaptiveExecutionContext](#context)) to [plan the optimized logical query plan](../execution-planning-strategies/SparkStrategies.md#plan) (and generate a physical query plan).

`reOptimize` [creates an optimized physical query plan](#applyPhysicalRules) using [preprocessing](#preprocessingRules) and [preparation](#queryStagePreparationRules) rules.

`reOptimize` is used when `AdaptiveSparkPlanExec` physical operator is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan) (and materialization of new stages fails).

## <span id="optimizer"> Local Logical Optimizer

```scala
optimizer: RuleExecutor[LogicalPlan]
```

`optimizer` is a [RuleExecutor](../catalyst/RuleExecutor.md) to transform [logical query plans](../logical-operators/LogicalPlan.md).

`optimizer` has a single **Demote BroadcastHashJoin** rule batch with [DemoteBroadcastHashJoin](../logical-optimizations/DemoteBroadcastHashJoin.md) logical optimization only.

`optimizer` is used when `AdaptiveSparkPlanExec` physical operator is requested to [re-optimize a logical query plan](#reOptimize).

## <span id="applyPhysicalRules"> Executing Physical Rules

```scala
applyPhysicalRules(
  plan: SparkPlan,
  rules: Seq[Rule[SparkPlan]]): SparkPlan
```

`applyPhysicalRules` simply applies (_executes_) the given rules to the given [physical query plan](SparkPlan.md).

`applyPhysicalRules` is used when:

* `AdaptiveSparkPlanExec` physical operator is created (and initializes [currentPhysicalPlan](#currentPhysicalPlan)), is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan), [newQueryStage](#newQueryStage), [reOptimize](#reOptimize)

* [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md) physical optimization is executed

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

## <span id="logOnLevel"> logOnLevel Internal Method

```scala
logOnLevel: ( => String) => Unit
```

`logOnLevel` uses [spark.sql.adaptive.logLevel](../spark-sql-properties.md#spark.sql.adaptive.logLevel) configuration property for the logging level and prints out the given message to the logs.

`logOnLevel` is used when `AdaptiveSparkPlanExec` physical operator is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan) and [finalPlanUpdate](#finalPlanUpdate).

## <span id="isFinalPlan"> isFinalPlan Internal Flag

```scala
isFinalPlan: Boolean = false
```

`isFinalPlan` is an internal flag to avoid expensive [getFinalPhysicalPlan](#getFinalPhysicalPlan) (and return the [current optimized physical query plan](#currentPhysicalPlan) immediately)

`isFinalPlan` is disabled by default and turned on at the end of [getFinalPhysicalPlan](#getFinalPhysicalPlan).

`isFinalPlan` is used when `AdaptiveSparkPlanExec` physical operator is requested for [stringArgs](#stringArgs).

## <span id="replaceWithQueryStagesInLogicalPlan"> replaceWithQueryStagesInLogicalPlan Internal Method

```scala
replaceWithQueryStagesInLogicalPlan(
  plan: LogicalPlan,
  stagesToReplace: Seq[QueryStageExec]): LogicalPlan
```

`replaceWithQueryStagesInLogicalPlan`...FIXME

`replaceWithQueryStagesInLogicalPlan` is used when `AdaptiveSparkPlanExec` physical operator is requested for a [final physical plan](#getFinalPhysicalPlan).
