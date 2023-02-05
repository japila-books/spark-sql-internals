# PartitionPruning Logical Optimization

`PartitionPruning` is a logical optimization for [Dynamic Partition Pruning](../new-and-noteworthy/dynamic-partition-pruning.md).

`PartitionPruning` is a `Rule[LogicalPlan]` (a [Catalyst Rule](../catalyst/Rule.md) for [logical operators](../logical-operators/LogicalPlan.md)).

`PartitionPruning` is part of the [PartitionPruning](../SparkOptimizer.md#PartitionPruning) batch of the [SparkOptimizer](../SparkOptimizer.md#defaultBatches).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

---

!!! note "A no-op"
    `apply` is a _noop_ (does nothing and returns the given [LogicalPlan](../logical-operators/LogicalPlan.md)) when executed with one of the following:

    * `Subquery` operators that are `correlated`
    * [spark.sql.optimizer.dynamicPartitionPruning.enabled](../configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.enabled) configuration property is disabled

`apply` [prunes](#prune) the given [LogicalPlan](../logical-operators/LogicalPlan.md).

## <span id="prune"> prune

```scala
prune(
  plan: LogicalPlan): LogicalPlan
```

`prune` transforms up all logical operators in the given [logical query plan](../logical-operators/LogicalPlan.md).

`prune` leaves [Join](../logical-operators/Join.md) operators unmodified when either operators are `Filter`s with [DynamicPruningSubquery](../expressions/DynamicPruningSubquery.md) condition.

`prune` transforms [Join](../logical-operators/Join.md) operators of the following "shape":

1. [EqualTo](../expressions/EqualTo.md) join conditions

1. Any expressions are attributes of a [LogicalRelation](../logical-operators/LogicalRelation.md) over a [HadoopFsRelation](../datasources/HadoopFsRelation.md)

1. The join type is one of `Inner`, `LeftSemi`, `RightOuter`, `LeftOuter`

??? note "More Work Needed"
    `prune` needs more love and would benefit from more insight on how it works.

`prune` is used when `PartitionPruning` is [executed](#apply).

## <span id="getFilterableTableScan"> getFilterableTableScan

```scala
getFilterableTableScan(
  a: Expression,
  plan: LogicalPlan): Option[LogicalPlan]
```

`getFilterableTableScan`...FIXME

## <span id="hasPartitionPruningFilter"> hasPartitionPruningFilter

```scala
hasPartitionPruningFilter(
  plan: LogicalPlan): Boolean
```

!!! note
    `hasPartitionPruningFilter` is [hasSelectivePredicate](#hasSelectivePredicate) with a [streaming check](../logical-operators/LogicalPlan.md#isStreaming) to make sure it disregards streaming queries.

`hasPartitionPruningFilter` is `true` when all of the following hold true:

1. The given [LogicalPlan](../logical-operators/LogicalPlan.md) is not [streaming](../logical-operators/LogicalPlan.md#isStreaming)
1. [hasSelectivePredicate](#hasSelectivePredicate)

## <span id="hasSelectivePredicate"> hasSelectivePredicate

```scala
hasSelectivePredicate(
  plan: LogicalPlan): Boolean
```

`hasSelectivePredicate` is `true` when there is a `Filter` logical operator with a [likely-selective](../PredicateHelper.md#isLikelySelective) filter condition.
