# QueryStageExec Leaf Physical Operators

`QueryStageExec` is an [extension](#contract) of the [LeafExecNode](../physical-operators/SparkPlan.md#LeafExecNode) abstraction for [leaf physical operators](#implementations) for [Adaptive Query Execution](index.md).

## Contract

### <span id="cancel"> Cancelling

```scala
cancel(): Unit
```

Cancels the stage materialization if in progress; otherwise does nothing.

Used when:

* `AdaptiveSparkPlanExec` physical operator is requested to [cleanUpAndThrowException](AdaptiveSparkPlanExec.md#cleanUpAndThrowException)

### <span id="doMaterialize"> Materializing

```scala
doMaterialize(): Future[Any]
```

Used when:

* `QueryStageExec` is requested to [materialize](#materialize)

### <span id="getRuntimeStatistics"> Runtime Statistics

```scala
getRuntimeStatistics: Statistics
```

[Statistics](../logical-operators/Statistics.md) after stage materialization

Used when:

* `QueryStageExec` is requested to [computeStats](#computeStats)

### <span id="id"> Unique ID

```scala
id: Int
```

Used when:

* [CoalesceShufflePartitions](../physical-optimizations/CoalesceShufflePartitions.md) adaptive physical optimization is executed

### <span id="newReuseInstance"> newReuseInstance

```scala
newReuseInstance(
  newStageId: Int,
  newOutput: Seq[Attribute]): QueryStageExec
```

Used when:

* `AdaptiveSparkPlanExec` physical operator is requested to [reuseQueryStage](AdaptiveSparkPlanExec.md#reuseQueryStage)

### <span id="plan"> Physical Query Plan

```scala
plan: SparkPlan
```

The [sub-tree](../physical-operators/SparkPlan.md) of the main query plan of this query stage (that acts like a child operator, but `QueryStageExec` is a [LeafExecNode](../physical-operators/SparkPlan.md#LeafExecNode) and has no children)

## Implementations

* <span id="BroadcastQueryStageExec"> [BroadcastQueryStageExec](BroadcastQueryStageExec.md)
* <span id="ShuffleQueryStageExec"> [ShuffleQueryStageExec](ShuffleQueryStageExec.md)

## <span id="resultOption"><span id="_resultOption"> Result

```scala
_resultOption: AtomicReference[Option[Any]]
```

`QueryStageExec` uses a `_resultOption` transient volatile internal variable (of type [AtomicReference]({{ java.api }}/java.base/java/util/concurrent/atomic/AtomicReference.html)) for the result of a successful [materialization](#materialize) of the `QueryStageExec` operator (when preparing for query execution):

* [Broadcast variable](BroadcastQueryStageExec.md#materializeWithTimeout) (_broadcasting data_) for [BroadcastQueryStageExec](BroadcastQueryStageExec.md)
* [MapOutputStatistics](ShuffleQueryStageExec.md#mapStats) (_submitting map stages_) for [ShuffleQueryStageExec](ShuffleQueryStageExec.md)

`_resultOption` is available using `resultOption` method. As `AtomicReference` is mutable that is enough to change the value.

`_resultOption` is set when `AdaptiveSparkPlanExec` physical operator is requested for the [final physical plan](AdaptiveSparkPlanExec.md#getFinalPhysicalPlan).

`resultOption` is used when:

* `AdaptiveSparkPlanExec` operator is requested to [createQueryStages](AdaptiveSparkPlanExec.md#createQueryStages)
* `QueryStageExec` operator is requested for the [statistics](#computeStats)
* `ShuffleQueryStageExec` operator is requested for the [MapOutputStatistics](ShuffleQueryStageExec.md#mapStats)
* [DemoteBroadcastHashJoin](DemoteBroadcastHashJoin.md) and [EliminateJoinToEmptyRelation](EliminateJoinToEmptyRelation.md) logical optimizations are executed

## <span id="computeStats"> Computing Statistics

```scala
computeStats(): Option[Statistics]
```

`computeStats` uses the [resultOption](#resultOption) to access the underlying [ReusedExchangeExec](../physical-operators/ReusedExchangeExec.md) or [Exchange](../physical-operators/Exchange.md) physical operators.

If available, `computeStats` creates [Statistics](../logical-operators/Statistics.md) with the [sizeInBytes](../logical-operators/Statistics.md#sizeInBytes) as the **dataSize** [performance metric](../physical-operators/SparkPlan.md#metrics) of the physical operator.

Otherwise, `computeStats` returns no statistics.

`computeStats` is used when [LogicalQueryStage](../adaptive-query-execution/LogicalQueryStage.md) logical operator is requested for the [stats](../adaptive-query-execution/LogicalQueryStage.md#computeStats).

## <span id="materialize"> Materializing Query Stage

```scala
materialize(): Future[Any]
```

`materialize` [prepares the operator for execution](../physical-operators/SparkPlan.md#executeQuery) followed by [doMaterialize](#doMaterialize).

!!! note
    `materialize` is a final method and cannot be overriden.

`materialize` is used when `AdaptiveSparkPlanExec` physical operator is requested to [getFinalPhysicalPlan](AdaptiveSparkPlanExec.md#getFinalPhysicalPlan).

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
  printNodeId: Boolean,
  indent: Int = 0): Unit
```

`generateTreeString` is part of the [TreeNode](../catalyst/TreeNode.md#generateTreeString) abstraction.

`generateTreeString` [generateTreeString](../catalyst/TreeNode.md#generateTreeString) (the default) followed by another [generateTreeString](../catalyst/TreeNode.md#generateTreeString) (with the depth incremented).
