# DynamicJoinSelection Adaptive Logical Optimization

`DynamicJoinSelection` is a logical optimization in [Adaptive Query Execution](../adaptive-query-execution/index.md) to [transform Join logical operators](#apply) with [JoinHint](../JoinHint.md)s.

`DynamicJoinSelection` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

## Creating Instance

`DynamicJoinSelection` takes no arguments to be created.

`DynamicJoinSelection` is created when:

* `AQEOptimizer` is requested for the [default batches](../adaptive-query-execution/AQEOptimizer.md#defaultBatches) (of adaptive optimizations)

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

`selectJoinStrategy` works only with [LogicalQueryStage](../logical-operators/LogicalQueryStage.md)s of [ShuffleQueryStageExec](../physical-operators/ShuffleQueryStageExec.md)s that are [materialized](../physical-operators/QueryStageExec.md#isMaterialized) and have [mapStats](../physical-operators/ShuffleQueryStageExec.md#mapStats) defined (and returns `None` otherwise).

`selectJoinStrategy` selects a [JoinStrategyHint](../JoinStrategyHint.md) based on [shouldDemoteBroadcastHashJoin](#shouldDemoteBroadcastHashJoin) and [preferShuffledHashJoin](#preferShuffledHashJoin) with the [mapStats](../physical-operators/ShuffleQueryStageExec.md#mapStats).

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

`preferShuffledHashJoin` takes a `MapOutputStatistics` ([Apache Spark]({{ book.spark_core }}/scheduler/MapOutputStatistics)) and holds (`true`) when all of the following hold:

1. [spark.sql.adaptive.advisoryPartitionSizeInBytes](../configuration-properties.md#spark.sql.adaptive.advisoryPartitionSizeInBytes) is at most [spark.sql.adaptive.maxShuffledHashJoinLocalMapThreshold](../configuration-properties.md#spark.sql.adaptive.maxShuffledHashJoinLocalMapThreshold)
1. Approximate number of output bytes (`bytesByPartitionId`) of every map output partition of the given `MapOutputStatistics` is at most [spark.sql.adaptive.maxShuffledHashJoinLocalMapThreshold](../configuration-properties.md#spark.sql.adaptive.maxShuffledHashJoinLocalMapThreshold)

### <span id="shouldDemoteBroadcastHashJoin"> shouldDemoteBroadcastHashJoin

```scala
shouldDemoteBroadcastHashJoin(
  mapStats: MapOutputStatistics): Boolean
```

`shouldDemoteBroadcastHashJoin` takes a `MapOutputStatistics` ([Apache Spark]({{ book.spark_core }}/scheduler/MapOutputStatistics)) and holds (`true`) when all of the following hold:

1. There is at least 1 partition with data (based on the `bytesByPartitionId` collection of the given `MapOutputStatistics`)
1. The ratio of the non-empty partitions to all partitions is below [spark.sql.adaptive.nonEmptyPartitionRatioForBroadcastJoin](../configuration-properties.md#spark.sql.adaptive.nonEmptyPartitionRatioForBroadcastJoin) configuration property

## Demo

```scala
// :paste -raw
package org.apache.spark.japila

import org.apache.spark.MapOutputStatistics

import org.apache.spark.sql.execution.SparkPlan
import org.apache.spark.sql.execution.adaptive.ShuffleQueryStageExec

class MyShuffleQueryStageExec(
    override val id: Int,
    override val plan: SparkPlan,
    override val _canonicalized: SparkPlan) extends ShuffleQueryStageExec(id, plan, _canonicalized) {

  override def isMaterialized: Boolean = true

  override def mapStats: Option[MapOutputStatistics] = {
    val shuffleId = 0
    // must be smaller than conf.nonEmptyPartitionRatioForBroadcastJoin
    val bytesByPartitionId = Array[Long](1, 0, 0, 0, 0, 0)
    Some(new MapOutputStatistics(shuffleId, bytesByPartitionId))
  }
}
```

```scala
import org.apache.spark.sql.catalyst.dsl.plans._
val logicalPlan = table("t1")

import org.apache.spark.sql.execution.exchange.ShuffleExchangeExec
import org.apache.spark.sql.catalyst.plans.physical.RoundRobinPartitioning
import org.apache.spark.sql.execution.exchange.ENSURE_REQUIREMENTS
import org.apache.spark.sql.execution.PlanLater

import org.apache.spark.sql.catalyst.dsl.plans._
val child = PlanLater(table("t2"))

val shuffleExec = ShuffleExchangeExec(RoundRobinPartitioning(10), child, ENSURE_REQUIREMENTS)

import org.apache.spark.japila.MyShuffleQueryStageExec
val stage = new MyShuffleQueryStageExec(id = 0, plan = shuffleExec, _canonicalized = shuffleExec)

assert(stage.isMaterialized,
  "DynamicJoinSelection expects materialized ShuffleQueryStageExecs")
assert(stage.mapStats.isDefined,
  "DynamicJoinSelection expects ShuffleQueryStageExecs with MapOutputStatistics")

import org.apache.spark.sql.catalyst.plans.logical.JoinHint
import org.apache.spark.sql.catalyst.plans.Inner
import org.apache.spark.sql.catalyst.plans.logical.Join
import org.apache.spark.sql.execution.adaptive.LogicalQueryStage

val left = LogicalQueryStage(logicalPlan, physicalPlan = stage)
val right = LogicalQueryStage(logicalPlan, physicalPlan = stage)

val plan = Join(left, right, joinType = Inner, condition = None, hint = JoinHint.NONE)

import org.apache.spark.sql.execution.adaptive.DynamicJoinSelection
val newPlan = DynamicJoinSelection(plan)
```

```text
scala> println(newPlan.numberedTreeString)
00 Join Inner, leftHint=(strategy=no_broadcast_hash), rightHint=(strategy=no_broadcast_hash)
01 :- LogicalQueryStage 'UnresolvedRelation [t1], [], false, MyShuffleQueryStage 0
02 +- LogicalQueryStage 'UnresolvedRelation [t1], [], false, MyShuffleQueryStage 0
```

```scala
// cf. DynamicJoinSelection.shouldDemoteBroadcastHashJoin
val mapStats = stage.mapStats.get
val conf = spark.sessionState.conf
```
