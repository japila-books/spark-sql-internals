# ShuffleQueryStageExec Leaf Physical Operator

`ShuffleQueryStageExec` is a [QueryStageExec](QueryStageExec.md) with [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) or [ReusedExchangeExec](../physical-operators/ReusedExchangeExec.md) child operators.

## Creating Instance

`ShuffleQueryStageExec` takes the following to be created:

* <span id="id"> ID
* <span id="plan"> [Physical Operator](../physical-operators/SparkPlan.md) ([ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) or [ReusedExchangeExec](../physical-operators/ReusedExchangeExec.md))

`ShuffleQueryStageExec` is created when:

* [AdaptiveSparkPlanExec](AdaptiveSparkPlanExec.md) physical operator is requested to [newQueryStage](AdaptiveSparkPlanExec.md#newQueryStage) (for a [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md))

* `ShuffleQueryStageExec` physical operator is requested to [newReuseInstance](#newReuseInstance)

## <span id="newReuseInstance"> newReuseInstance

```scala
newReuseInstance(
  newStageId: Int,
  newOutput: Seq[Attribute]): QueryStageExec
```

`newReuseInstance` is...FIXME

`newReuseInstance` is part of the [QueryStageExec](QueryStageExec.md) abstraction.

## <span id="mapStats"> MapOutputStatistics

```scala
mapStats: Option[MapOutputStatistics]
```

`mapStats` takes a `MapOutputStatistics` from the [resultOption](QueryStageExec.md#resultOption).

`mapStats` throws an `AssertionError` when the [resultOption](QueryStageExec.md#resultOption) is not available:

```text
assertion failed: ShuffleQueryStageExec should already be ready
```

`mapStats` is used when:

* [DemoteBroadcastHashJoin](DemoteBroadcastHashJoin.md) logical optimization is executed
* [CoalesceShufflePartitions](CoalesceShufflePartitions.md) and [OptimizeSkewedJoin](OptimizeSkewedJoin.md) adaptive physical optimizations are executed
