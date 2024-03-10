---
title: OptimizeSkewInRebalancePartitions
---

# OptimizeSkewInRebalancePartitions Adaptive Physical Optimization

`OptimizeSkewInRebalancePartitions` is a [physical optimization](AQEShuffleReadRule.md) in [Adaptive Query Execution](../adaptive-query-execution/index.md).

`OptimizeSkewInRebalancePartitions` can be turned on and off using [spark.sql.adaptive.optimizeSkewsInRebalancePartitions.enabled](../configuration-properties.md#spark.sql.adaptive.optimizeSkewsInRebalancePartitions.enabled) configuration property.

## Executing Rule { #apply }

??? note "Rule"

    ```scala
    apply(
      plan: SparkPlan): SparkPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` works with [ShuffleQueryStageExec](../physical-operators/ShuffleQueryStageExec.md) leaf physical operators only (with the [ShuffleExchangeLike](../physical-operators/ShuffleQueryStageExec.md#shuffle)s that are [supported](#isSupported)).

`apply` [tryOptimizeSkewedPartitions](#tryOptimizeSkewedPartitions) of the `ShuffleQueryStageExec`.

### tryOptimizeSkewedPartitions { #tryOptimizeSkewedPartitions }

```scala
tryOptimizeSkewedPartitions(
  shuffle: ShuffleQueryStageExec): SparkPlan
```

`tryOptimizeSkewedPartitions`...FIXME

## Supported ShuffleOrigins { #supportedShuffleOrigins }

??? note "AQEShuffleReadRule"

    ```scala
    supportedShuffleOrigins: Seq[ShuffleOrigin]
    ```

    `supportedShuffleOrigins` is part of the [AQEShuffleReadRule](AQEShuffleReadRule.md#supportedShuffleOrigins) abstraction.

`supportedShuffleOrigins` is a collection of the following [ShuffleOrigin](../physical-operators/ShuffleOrigin.md)s:

* [REBALANCE_PARTITIONS_BY_COL](../physical-operators/ShuffleOrigin.md#REBALANCE_PARTITIONS_BY_COL)
* [REBALANCE_PARTITIONS_BY_NONE](../physical-operators/ShuffleOrigin.md#REBALANCE_PARTITIONS_BY_NONE)
