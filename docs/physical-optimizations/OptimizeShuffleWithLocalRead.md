---
title: OptimizeShuffleWithLocalRead
---

# OptimizeShuffleWithLocalRead Adaptive Physical Optimization

`OptimizeShuffleWithLocalRead` is a [physical optimization](AQEShuffleReadRule.md) in [Adaptive Query Execution](../adaptive-query-execution/index.md).

`OptimizeShuffleWithLocalRead` can be turned on and off using [spark.sql.adaptive.localShuffleReader.enabled](../configuration-properties.md#spark.sql.adaptive.localShuffleReader.enabled) configuration property.

## isSupported { #isSupported }

```scala
isSupported(
  shuffle: ShuffleExchangeLike): Boolean
```

`isSupported` is `true` when the following all hold:

* The [outputPartitioning](../physical-operators/SparkPlan.md#outputPartitioning) of the given [ShuffleExchangeLike](../physical-operators/ShuffleExchangeLike.md) is not `SinglePartition`
* The [shuffleOrigin](../physical-operators/ShuffleExchangeLike.md#shuffleOrigin) of the given [ShuffleExchangeLike](../physical-operators/ShuffleExchangeLike.md) is [supported](#supportedShuffleOrigins)

`isSupported` is part of the [AQEShuffleReadRule](AQEShuffleReadRule.md#isSupported) abstraction.

## Executing Rule { #apply }

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` is a noop (and simply returns the given [SparkPlan](../physical-operators/SparkPlan.md)) with [spark.sql.adaptive.localShuffleReader.enabled](../configuration-properties.md#spark.sql.adaptive.localShuffleReader.enabled) disabled.

With [canUseLocalShuffleRead](#canUseLocalShuffleRead) `apply` [createLocalRead](#createLocalRead). Otherwise, `apply` [createProbeSideLocalRead](#createProbeSideLocalRead).

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

### canUseLocalShuffleRead { #canUseLocalShuffleRead }

```scala
canUseLocalShuffleRead(
  plan: SparkPlan): Boolean
```

`canUseLocalShuffleRead` is `true` when one of the following holds:

1. The given [SparkPlan](../physical-operators/SparkPlan.md) is a [ShuffleQueryStageExec](../physical-operators/ShuffleQueryStageExec.md) with the [MapOutputStatistics](../physical-operators/ShuffleQueryStageExec.md#mapStats) available and the [ShuffleExchangeLike](../physical-operators/ShuffleQueryStageExec.md#shuffle) is [supported](#isSupported)

1. The given [SparkPlan](../physical-operators/SparkPlan.md) is a [AQEShuffleReadExec](../physical-operators/AQEShuffleReadExec.md) with a [ShuffleQueryStageExec](../physical-operators/ShuffleQueryStageExec.md) with the above requirements met (the [MapOutputStatistics](../physical-operators/ShuffleQueryStageExec.md#mapStats) is available and the [ShuffleExchangeLike](../physical-operators/ShuffleQueryStageExec.md#shuffle) is [supported](#isSupported)) and the [shuffleOrigin](../physical-operators/ShuffleExchangeLike.md#shuffleOrigin) of the `ShuffleExchangeLike` is [ENSURE_REQUIREMENTS](../physical-operators/ShuffleOrigin.md#ENSURE_REQUIREMENTS)

`canUseLocalShuffleRead` is `false` otherwise.

### createLocalRead { #createLocalRead }

```scala
createLocalRead(
  plan: SparkPlan): AQEShuffleReadExec
```

`createLocalRead` branches off based on the type of the given [physical operator](../physical-operators/SparkPlan.md) and creates a new [AQEShuffleReadExec](../physical-operators/AQEShuffleReadExec.md) (with or without _advisory parallelism_ specified to [determine ShufflePartitionSpecs](#getPartitionSpecs)):

* For [AQEShuffleReadExec](../physical-operators/AQEShuffleReadExec.md)s with a [ShuffleQueryStageExec](../physical-operators/ShuffleQueryStageExec.md) leaf physical operator, the [advisory parallelism](#getPartitionSpecs) is the size of the [ShufflePartitionSpec](../physical-operators/AQEShuffleReadExec.md#partitionSpecs)

* For [ShuffleQueryStageExec](../physical-operators/ShuffleQueryStageExec.md)s, the [advisory parallelism](#getPartitionSpecs) is undefined

### createProbeSideLocalRead { #createProbeSideLocalRead }

```scala
createProbeSideLocalRead(
  plan: SparkPlan): SparkPlan
```

`createProbeSideLocalRead`...FIXME

### getPartitionSpecs { #getPartitionSpecs }

```scala
getPartitionSpecs(
  shuffleStage: ShuffleQueryStageExec,
  advisoryParallelism: Option[Int]): Seq[ShufflePartitionSpec]
```

`createProbeSideLocalRead`...FIXME

## Supported ShuffleOrigins { #supportedShuffleOrigins }

??? note "AQEShuffleReadRule"

    ```scala
    supportedShuffleOrigins: Seq[ShuffleOrigin]
    ```

    `supportedShuffleOrigins` is part of the [AQEShuffleReadRule](AQEShuffleReadRule.md#supportedShuffleOrigins) abstraction.

`supportedShuffleOrigins` is a collection of the following [ShuffleOrigin](../physical-operators/ShuffleOrigin.md)s:

* [ENSURE_REQUIREMENTS](../physical-operators/ShuffleOrigin.md#ENSURE_REQUIREMENTS)
* [REBALANCE_PARTITIONS_BY_NONE](../physical-operators/ShuffleOrigin.md#REBALANCE_PARTITIONS_BY_NONE)
