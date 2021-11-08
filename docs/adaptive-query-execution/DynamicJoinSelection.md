# DynamicJoinSelection Logical Optimization

`DynamicJoinSelection` is a logical optimization in [Adaptive Query Execution](index.md) to [transform Join logical operators](#apply) with [JoinHint](../JoinHint.md)s.

`DynamicJoinSelection` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

## Demo (FIXME)

```text
import org.apache.spark.sql.catalyst.dsl.plans._
val t1 = table("t1")
val t2 = table("t2")
val plan = t1.join(t2)
```

```text
import org.apache.spark.sql.execution.adaptive.DynamicJoinSelection
val newPlan = DynamicJoinSelection(plan)
```

## Creating Instance

`DynamicJoinSelection` takes no arguments to be created.

`DynamicJoinSelection` is created when:

* `AQEOptimizer` is requested for the [default batches](AQEOptimizer.md#defaultBatches) (of adaptive optimizations)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` traverses the given [LogicalPlan](../logical-operators/LogicalPlan.md) down (the tree) and rewrites [Join](../logical-operators/Join.md) logical operators as follows:

1. If there is no [JoinStrategyHint](../JoinStrategyHint.md) defined for the [left side](../JoinHint.md#leftHint), `apply` [selects the JoinStrategy](#selectJoinStrategy) for the left operator.

1. If there is no [JoinStrategyHint](../JoinStrategyHint.md) defined for the [right side](../JoinHint.md#rightHint), `apply` [selects the JoinStrategy](#selectJoinStrategy) for the right operator.

1. `apply` associates the new [JoinHint](../JoinHint.md) with the `Join` logical operator

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

## <span id="selectJoinStrategy"> selectJoinStrategy

```scala
selectJoinStrategy(
  plan: LogicalPlan): Option[JoinStrategyHint]
```

`selectJoinStrategy` works only with [LogicalQueryStage](LogicalQueryStage.md)s of [ShuffleQueryStageExec](ShuffleQueryStageExec.md)s that are [materialized](QueryStageExec.md#isMaterialized) and have [mapStats](ShuffleQueryStageExec.md#mapStats) defined (and returns `None` otherwise).

`selectJoinStrategy` selects a [JoinStrategyHint](../JoinStrategyHint.md) based on [shouldDemoteBroadcastHashJoin](#shouldDemoteBroadcastHashJoin) and [preferShuffledHashJoin](#preferShuffledHashJoin) with the [mapStats](ShuffleQueryStageExec.md#mapStats).

demoteBroadcastHash | preferShuffleHash | JoinStrategyHint
--------------------|-------------------|-----------------
 `true`             | `true`            | [SHUFFLE_HASH](../JoinStrategyHint.md#SHUFFLE_HASH)
 `true`             | `false`           | [NO_BROADCAST_HASH](../JoinStrategyHint.md#NO_BROADCAST_HASH)
 `false`            | `true`            | [PREFER_SHUFFLE_HASH](../JoinStrategyHint.md#PREFER_SHUFFLE_HASH)
 `false`            | `false`           | `None` (undefined)

### <span id="preferShuffledHashJoin"> preferShuffledHashJoin

```scala
preferShuffledHashJoin(
  mapStats: MapOutputStatistics): Boolean
```

`preferShuffledHashJoin` holds (`true`) when all of the following hold:

1. [spark.sql.adaptive.advisoryPartitionSizeInBytes](../configuration-properties.md#spark.sql.adaptive.advisoryPartitionSizeInBytes) is at most [spark.sql.adaptive.maxShuffledHashJoinLocalMapThreshold](../configuration-properties.md#spark.sql.adaptive.maxShuffledHashJoinLocalMapThreshold)
1. Approximate number of output bytes (`bytesByPartitionId`) of every map output partition of the given `MapOutputStatistics` is at most [spark.sql.adaptive.maxShuffledHashJoinLocalMapThreshold](../configuration-properties.md#spark.sql.adaptive.maxShuffledHashJoinLocalMapThreshold)
