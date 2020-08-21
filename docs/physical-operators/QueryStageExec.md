# QueryStageExec Leaf Physical Operators

`QueryStageExec` is an [extension](#contract) of the [LeafExecNode](SparkPlan.md#LeafExecNode) abstraction for [query stage operators](#implementations).

## Contract

### <span id="cancel"> cancel

```scala
cancel(): Unit
```

Cancels the stage materialization if in progress; otherwise does nothing.

Used when `AdaptiveSparkPlanExec` physical operator is requested to [cleanUpAndThrowException](AdaptiveSparkPlanExec.md#cleanUpAndThrowException)

### <span id="doMaterialize"> doMaterialize

```scala
doMaterialize(): Future[Any]
```

Used when `QueryStageExec` is requested to [materialize](#materialize)

### id

```scala
id: Int
```

Unique ID

Used when [CoalesceShufflePartitions](../physical-optimizations/CoalesceShufflePartitions.md) adaptive physical optimization is executed

### <span id="newReuseInstance"> newReuseInstance

```scala
newReuseInstance(
  newStageId: Int,
  newOutput: Seq[Attribute]): QueryStageExec
```

Used when `AdaptiveSparkPlanExec` physical operator is requested to [reuseQueryStage](AdaptiveSparkPlanExec.md#reuseQueryStage)

### <span id="plan"> plan

```scala
plan: SparkPlan
```

"Child" [physical operator](SparkPlan.md) (but `QueryStageExec` is a [LeafExecNode](SparkPlan.md#LeafExecNode) and has got no children)

Used when...FIXME

## Implementations

* <span id="BroadcastQueryStageExec"> [BroadcastQueryStageExec](BroadcastQueryStageExec.md)
* <span id="ShuffleQueryStageExec"> [ShuffleQueryStageExec](ShuffleQueryStageExec.md)

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

## <span id="resultOption"> resultOption Internal Registry

```scala
resultOption: Option[Any] = None
```

`resultOption` is the result of [materializing](#materialize) the `QueryStageExec` operator:

* [MapOutputStatistics](ShuffleQueryStageExec.md#mapStats) for [ShuffleQueryStageExec](ShuffleQueryStageExec.md)
* [Broadcast variable](BroadcastQueryStageExec.md#materializeWithTimeout) for [BroadcastQueryStageExec](BroadcastQueryStageExec.md)

`resultOption` is `None` by default.

`resultOption` is set a value when `AdaptiveSparkPlanExec` physical operator is requested for the [final physical query plan](AdaptiveSparkPlanExec.md#getFinalPhysicalPlan)

`resultOption` is used when:

* `AdaptiveSparkPlanExec` operator is requested to [createQueryStages](AdaptiveSparkPlanExec.md#createQueryStages) (for a `QueryStageExec`)
* `QueryStageExec` operator is requested to [compute statistics](#computeStats)
* `ShuffleQueryStageExec` operator is requested for [MapOutputStatistics](ShuffleQueryStageExec.md#mapStats)
* [DemoteBroadcastHashJoin](../logical-optimizations/DemoteBroadcastHashJoin.md) logical optimization is executed

## <span id="computeStats"> Computing Statistics

```scala
computeStats(): Option[Statistics]
```

`computeStats` uses the [resultOption](#resultOption) to access the underlying [ReusedExchangeExec](ReusedExchangeExec.md) or [Exchange](Exchange.md) physical operators.

If available, `computeStats` creates [Statistics](../spark-sql-Statistics.md) with the [sizeInBytes](../spark-sql-Statistics.md#sizeInBytes) as the **dataSize** [performance metric](SparkPlan.md#metrics) of the physical operator.

Otherwise, `computeStats` returns no statistics.

`computeStats` is used when [LogicalQueryStage](../logical-operators/LogicalQueryStage.md) logical operator is requested for the [stats](../logical-operators/LogicalQueryStage.md#computeStats).

## <span id="materialize"> Materializing Query Stage

```scala
materialize(): Future[Any]
```

`materialize` [prepares the query stage operator for execution](SparkPlan.md#executeQuery) followed by [doMaterialize](#doMaterialize).

!!! note
    `materialize` is a final method and cannot be overriden.

`materialize` is used when `AdaptiveSparkPlanExec` physical operator is requested to [getFinalPhysicalPlan](AdaptiveSparkPlanExec.md#getFinalPhysicalPlan).
