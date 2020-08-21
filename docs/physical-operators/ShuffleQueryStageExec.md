# ShuffleQueryStageExec Physical Operator

`ShuffleQueryStageExec` is a [QueryStageExec](QueryStageExec.md) with [ShuffleExchangeExec](ShuffleExchangeExec.md) or [ReusedExchangeExec](ReusedExchangeExec.md) child operators.

## Creating Instance

`ShuffleQueryStageExec` takes the following to be created:

* <span id="id"> ID
* <span id="plan"> [Physical Operator](SparkPlan.md) ([ShuffleExchangeExec](ShuffleExchangeExec.md) or [ReusedExchangeExec](ReusedExchangeExec.md))

`ShuffleQueryStageExec` is created when:

* [AdaptiveSparkPlanExec](AdaptiveSparkPlanExec.md) physical operator is requested to [newQueryStage](AdaptiveSparkPlanExec.md#newQueryStage) (for a [ShuffleExchangeExec](ShuffleExchangeExec.md))

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

* [DemoteBroadcastHashJoin](../logical-optimizations/DemoteBroadcastHashJoin.md) logical optimization is executed
* [CoalesceShufflePartitions](../physical-optimizations/CoalesceShufflePartitions.md) and [OptimizeSkewedJoin](../physical-optimizations/OptimizeSkewedJoin.md) adaptive physical optimizations are executed
