# ShuffleQueryStageExec Adaptive Leaf Physical Operator

`ShuffleQueryStageExec` is a [QueryStageExec](QueryStageExec.md) with either a [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) or a [ReusedExchangeExec](../physical-operators/ReusedExchangeExec.md) child operators.

## Creating Instance

`ShuffleQueryStageExec` takes the following to be created:

* <span id="id"> ID
* <span id="plan"> [Physical operator](../physical-operators/SparkPlan.md)

`ShuffleQueryStageExec` is created when:

* [AdaptiveSparkPlanExec](AdaptiveSparkPlanExec.md) physical operator is requested to [newQueryStage](AdaptiveSparkPlanExec.md#newQueryStage) (for a [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md))

* `ShuffleQueryStageExec` physical operator is requested to [newReuseInstance](#newReuseInstance)

## <span id="shuffle"> ShuffleExchangeLike

```scala
shuffle: ShuffleExchangeLike
```

`ShuffleQueryStageExec` initializes the `shuffle` internal registry when [created](#creating-instance).

`ShuffleQueryStageExec` assumes that the given [physical operator](#plan) is either a [ShuffleExchangeLike](../physical-operators/ShuffleExchangeLike.md) or a [ReusedExchangeExec](../physical-operators/ReusedExchangeExec.md) and extracts the `ShuffleExchangeLike`.

If not, `ShuffleQueryStageExec` throws an `IllegalStateException`:

```text
wrong plan for shuffle stage:
[tree]
```

`shuffle` is used when:

* `AQEShuffleReadExec` unary physical operator is requested for the [shuffleRDD](AQEShuffleReadExec.md#shuffleRDD)
* [CoalesceShufflePartitions](CoalesceShufflePartitions.md) physical optimization is executed
* [OptimizeShuffleWithLocalRead](OptimizeShuffleWithLocalRead.md) physical optimization is executed
* [OptimizeSkewedJoin](OptimizeSkewedJoin.md) physical optimization is executed
* [OptimizeSkewInRebalancePartitions](OptimizeSkewInRebalancePartitions.md) physical optimization is executed
* `ShuffleQueryStageExec` leaf physical operator is requested for the [shuffle MapOutputStatistics](#shuffleFuture), [newReuseInstance](#newReuseInstance) and [getRuntimeStatistics](#getRuntimeStatistics)

## <span id="shuffleFuture"> Shuffle MapOutputStatistics Future

```scala
shuffleFuture: Future[MapOutputStatistics]
```

`shuffleFuture` requests the [ShuffleExchangeLike](#shuffle) to [submit a shuffle job](../physical-operators/ShuffleExchangeLike.md#submitShuffleJob)

??? note "Lazy Value"
    `shuffleFuture` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`shuffleFuture` is used when:

* `ShuffleQueryStageExec` is requested to [materialize](#doMaterialize) and [cancel](#cancel)

## <span id="doMaterialize"> Materializing

```scala
doMaterialize(): Future[Any]
```

`doMaterialize` returns the [Shuffle MapOutputStatistics Future](#shuffleFuture).

`doMaterialize` is part of the [QueryStageExec](QueryStageExec.md#doMaterialize) abstraction.

## <span id="cancel"> Cancelling

```scala
cancel(): Unit
```

`cancel` cancels the [Shuffle MapOutputStatistics Future](#shuffleFuture) (unless already completed).

`cancel` is part of the [QueryStageExec](QueryStageExec.md#cancel) abstraction.

## <span id="newReuseInstance"> newReuseInstance

```scala
newReuseInstance(
  newStageId: Int,
  newOutput: Seq[Attribute]): QueryStageExec
```

`newReuseInstance` is...FIXME

`newReuseInstance` is part of the [QueryStageExec](QueryStageExec.md#newReuseInstance) abstraction.

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
