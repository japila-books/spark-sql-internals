# AdaptiveSparkPlanExec Physical Operator

`AdaptiveSparkPlanExec` is a [leaf physical operator](SparkPlan.md#LeafExecNode).

## Creating Instance

`AdaptiveSparkPlanExec` takes the following to be created:

* <span id="initialPlan"> Initial [SparkPlan](SparkPlan.md)
* <span id="context"> `AdaptiveExecutionContext`
* <span id="preprocessingRules"> Preprocessing [physical rules](../catalyst/Rule.md) (`Seq[Rule[SparkPlan]]`)
* <span id="isSubquery"> `isSubquery` flag

`AdaptiveSparkPlanExec` is created when [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md) physical optimisation is executed.

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

## <span id="getFinalPhysicalPlan"> getFinalPhysicalPlan

```scala
getFinalPhysicalPlan(): SparkPlan
```

`getFinalPhysicalPlan`...FIXME

`getFinalPhysicalPlan` is used when `AdaptiveSparkPlanExec` physical operator is requested to [executeCollect](#executeCollect), [executeTake](#executeTake), [executeTail](#executeTail) and [doExecute](#doExecute).

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

`newQueryStage`...FIXME

`newQueryStage` is used when...FIXME

## <span id="reuseQueryStage"> reuseQueryStage

```scala
reuseQueryStage(
  existing: QueryStageExec,
  exchange: Exchange): QueryStageExec
```

`reuseQueryStage`...FIXME

`reuseQueryStage` is used when `AdaptiveSparkPlanExec` physical operator is requested to [createQueryStages](#createQueryStages).
