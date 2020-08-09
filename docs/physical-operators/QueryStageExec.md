# QueryStageExec Leaf Physical Operators

`QueryStageExec` is an [extension](#contract) of the [LeafExecNode](SparkPlan.md#LeafExecNode) abstraction for [leaf physical operators](#implementations).

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

## <span id="computeStats"> computeStats

```scala
computeStats(): Option[Statistics]
```

`computeStats`...FIXME

`computeStats` is used when...FIXME

## materialize

```scala
materialize(): Future[Any]
```

`materialize`...FIXME

`materialize` is used when `AdaptiveSparkPlanExec` physical operator is requested to [getFinalPhysicalPlan](AdaptiveSparkPlanExec.md#getFinalPhysicalPlan).
