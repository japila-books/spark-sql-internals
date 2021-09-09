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

`mapStats` assumes that the [resultOption](QueryStageExec.md#resultOption) (with the `MapOutputStatistics`) is already available or throws an `AssertionError`:

```text
assertion failed: ShuffleQueryStageExec should already be ready
```

`mapStats` takes a `MapOutputStatistics` from the [resultOption](QueryStageExec.md#resultOption).

`mapStats` is used when:

* `AQEShuffleReadExec` unary physical operator is requested for the [partitionDataSizes](AQEShuffleReadExec.md#partitionDataSizes)
* [DynamicJoinSelection](DynamicJoinSelection.md) adaptive optimization is executed (and [selectJoinStrategy](DynamicJoinSelection.md#selectJoinStrategy))
* [OptimizeShuffleWithLocalRead](OptimizeShuffleWithLocalRead.md) adaptive physical optimization is executed (and [canUseLocalShuffleRead](OptimizeShuffleWithLocalRead.md#canUseLocalShuffleRead))
* [CoalesceShufflePartitions](CoalesceShufflePartitions.md), [OptimizeSkewedJoin](OptimizeSkewedJoin.md) and [OptimizeSkewInRebalancePartitions](OptimizeSkewInRebalancePartitions.md) adaptive physical optimizations are executed
