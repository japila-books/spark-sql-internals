# AdaptiveSparkPlanExec Physical Operator

`AdaptiveSparkPlanExec` is a [leaf physical operator](SparkPlan.md#LeafExecNode).

## Creating Instance

`AdaptiveSparkPlanExec` takes the following to be created:

* <span id="initialPlan"> Initial [SparkPlan](SparkPlan.md)
* <span id="context"> `AdaptiveExecutionContext`
* <span id="preprocessingRules"> Preprocessing [physical rules](../catalyst/Rule.md) (`Seq[Rule[SparkPlan]]`)
* <span id="isSubquery"> `isSubquery` flag

`AdaptiveSparkPlanExec` is created when [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md) physical optimisation is executed.

## <span id="currentPhysicalPlan"> Current Physical Query Plan

```scala
currentPhysicalPlan: SparkPlan
```

`currentPhysicalPlan` is a [physical operator](SparkPlan.md) that...FIXME

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

## <span id="doExecute"> doExecute

```scala
doExecute(): RDD[InternalRow]
```

doExecute...FIXME

doExecute is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

## <span id="executeCollect"> executeCollect

```scala
executeCollect(): Array[InternalRow]
```

executeCollect...FIXME

executeCollect is part of the [SparkPlan](SparkPlan.md#executeCollect) abstraction.

## <span id="executeTail"> executeTail

```scala
executeTail(
  n: Int): Array[InternalRow]
```

executeTail...FIXME

executeTail is part of the [SparkPlan](SparkPlan.md#executeTail) abstraction.

## <span id="executeTake"> executeTake

```scala
executeTake(
  n: Int): Array[InternalRow]
```

executeTake...FIXME

executeTake is part of the [SparkPlan](SparkPlan.md#executeTake) abstraction.

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

## getFinalPhysicalPlan

```scala
getFinalPhysicalPlan(): SparkPlan
```

`getFinalPhysicalPlan`...FIXME

`getFinalPhysicalPlan` is used when `AdaptiveSparkPlanExec` physical operator is requested to [executeCollect](#executeCollect), [executeTake](#executeTake), [executeTail](#executeTail) and [doExecute](#doExecute).

## createQueryStages

```scala
createQueryStages(
  plan: SparkPlan): CreateStageResult
```

`createQueryStages`...FIXME

`createQueryStages` is used when `AdaptiveSparkPlanExec` physical operator is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan).

## newQueryStage

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

## reuseQueryStage

```scala
reuseQueryStage(
  existing: QueryStageExec,
  exchange: Exchange): QueryStageExec
```

`reuseQueryStage`...FIXME

`reuseQueryStage` is used when `AdaptiveSparkPlanExec` physical operator is requested to [createQueryStages](#createQueryStages).

## cleanUpAndThrowException

```scala
cleanUpAndThrowException(
  errors: Seq[Throwable],
  earlyFailedStage: Option[Int]): Unit
```

`cleanUpAndThrowException`...FIXME

`cleanUpAndThrowException` is used when `AdaptiveSparkPlanExec` physical operator is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan) (and materialization of new stages fails).

## reOptimize

```scala
reOptimize(
  logicalPlan: LogicalPlan): (SparkPlan, LogicalPlan)
```

`reOptimize`...FIXME

`reOptimize` is used when `AdaptiveSparkPlanExec` physical operator is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan) (and materialization of new stages fails).

## <span id="applyPhysicalRules"> Executing Physical Rules

```scala
applyPhysicalRules(
  plan: SparkPlan,
  rules: Seq[Rule[SparkPlan]]): SparkPlan
```

`applyPhysicalRules`...FIXME

`applyPhysicalRules` is used when:

* `AdaptiveSparkPlanExec` physical operator is created (and initializes [currentPhysicalPlan](#currentPhysicalPlan)), is requested to [getFinalPhysicalPlan](#getFinalPhysicalPlan), [newQueryStage](#newQueryStage), [reOptimize](#reOptimize)

* [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md) physical optimization is executed
