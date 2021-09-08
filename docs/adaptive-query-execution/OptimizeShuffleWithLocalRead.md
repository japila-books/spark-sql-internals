# OptimizeShuffleWithLocalRead Adaptive Physical Optimization

`OptimizeShuffleWithLocalRead` is a [AQEShuffleReadRule](AQEShuffleReadRule.md).

`OptimizeShuffleWithLocalRead` can be turned on and off using [spark.sql.adaptive.localShuffleReader.enabled](../configuration-properties.md#spark.sql.adaptive.localShuffleReader.enabled).

## <span id="supportedShuffleOrigins"> Supported ShuffleOrigins

```scala
supportedShuffleOrigins: Seq[ShuffleOrigin]
```

`supportedShuffleOrigins` is the following [ShuffleOrigin](ShuffleOrigin.md)s:

* [ENSURE_REQUIREMENTS](ShuffleOrigin.md#ENSURE_REQUIREMENTS)
* [REBALANCE_PARTITIONS_BY_NONE](ShuffleOrigin.md#REBALANCE_PARTITIONS_BY_NONE)

`supportedShuffleOrigins` is part of the [AQEShuffleReadRule](AQEShuffleReadRule.md#supportedShuffleOrigins) abstraction.

## <span id="isSupported"> isSupported

```scala
isSupported(
  shuffle: ShuffleExchangeLike): Boolean
```

`isSupported` is `true` when the following all hold:

* The [outputPartitioning](../physical-operators/SparkPlan.md#outputPartitioning) of the given [ShuffleExchangeLike](../physical-operators/ShuffleExchangeLike.md) is not `SinglePartition`
* The [shuffleOrigin](ShuffleExchangeLike.md#shuffleOrigin) of the given [ShuffleExchangeLike](../physical-operators/ShuffleExchangeLike.md) is [supported](#supportedShuffleOrigins)

`isSupported` is part of the [AQEShuffleReadRule](AQEShuffleReadRule.md#isSupported) abstraction.

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` is a noop (and simply returns the given [SparkPlan](../physical-operators/SparkPlan.md)) with [spark.sql.adaptive.localShuffleReader.enabled](../configuration-properties.md#spark.sql.adaptive.localShuffleReader.enabled) disabled.

With [canUseLocalShuffleRead](#canUseLocalShuffleRead) `apply` [createLocalRead](#createLocalRead). Otherwise, `apply` [createProbeSideLocalRead](#createProbeSideLocalRead).

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

### <span id="canUseLocalShuffleRead"> canUseLocalShuffleRead

```scala
canUseLocalShuffleRead(
  plan: SparkPlan): Boolean
```

`canUseLocalShuffleRead` is `true` when one of the following holds:

1. The given [SparkPlan](../physical-operators/SparkPlan.md) is a [ShuffleQueryStageExec](ShuffleQueryStageExec.md) with the [MapOutputStatistics](ShuffleQueryStageExec.md#mapStats) available and the [ShuffleExchangeLike](ShuffleQueryStageExec.md#shuffle) is [supported](#isSupported)

1. The given [SparkPlan](../physical-operators/SparkPlan.md) is a [AQEShuffleReadExec](AQEShuffleReadExec.md) with a [ShuffleQueryStageExec](ShuffleQueryStageExec.md) with the above requirements met (the [MapOutputStatistics](ShuffleQueryStageExec.md#mapStats) is available and the [ShuffleExchangeLike](ShuffleQueryStageExec.md#shuffle) is [supported](#isSupported)) and the [shuffleOrigin](../physical-operators/ShuffleExchangeLike.md#shuffleOrigin) of the `ShuffleExchangeLike` is [ENSURE_REQUIREMENTS](ShuffleOrigin.md#ENSURE_REQUIREMENTS)

`canUseLocalShuffleRead` is `false` otherwise.

### <span id="createLocalRead"> createLocalRead

```scala
createLocalRead(
  plan: SparkPlan): AQEShuffleReadExec
```

`createLocalRead`...FIXME

### <span id="createProbeSideLocalRead"> createProbeSideLocalRead

```scala
createProbeSideLocalRead(
  plan: SparkPlan): SparkPlan
```

`createProbeSideLocalRead`...FIXME
