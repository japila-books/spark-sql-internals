---
title: OptimizeSkewInRebalancePartitions
---

# OptimizeSkewInRebalancePartitions Adaptive Physical Optimization

`OptimizeSkewInRebalancePartitions` is a [physical optimization](AQEShuffleReadRule.md) in [Adaptive Query Execution](../adaptive-query-execution/index.md).

`OptimizeSkewInRebalancePartitions` can be turned on and off using [spark.sql.adaptive.optimizeSkewsInRebalancePartitions.enabled](../configuration-properties.md#spark.sql.adaptive.optimizeSkewsInRebalancePartitions.enabled) configuration property.

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` works with [ShuffleQueryStageExec](../physical-operators/ShuffleQueryStageExec.md) leaf physical operators only (with the [ShuffleExchangeLike](../physical-operators/ShuffleQueryStageExec.md#shuffle)s that are [supported](#isSupported)).

`apply` [tryOptimizeSkewedPartitions](#tryOptimizeSkewedPartitions) of the `ShuffleQueryStageExec`.

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

### <span id="tryOptimizeSkewedPartitions"> tryOptimizeSkewedPartitions

```scala
tryOptimizeSkewedPartitions(
  shuffle: ShuffleQueryStageExec): SparkPlan
```

`tryOptimizeSkewedPartitions`...FIXME
