# PartitionPruning Logical Optimization

`PartitionPruning` is a logical optimization for [Dynamic Partition Pruning](../new-and-noteworthy/dynamic-partition-pruning.md).

`PartitionPruning` is a `Rule[LogicalPlan]` (a [rule](../catalyst/Rule.md) for [logical operators](../logical-operators/LogicalPlan.md)).

`PartitionPruning` is part of the [PartitionPruning](../SparkOptimizer.md#PartitionPruning) batch of the [SparkOptimizer](../SparkOptimizer.md#defaultBatches).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

For `Subquery` operators that are `correlated`, `apply` simply does nothing and gives it back unmodified.

`apply` does nothing when the [spark.sql.optimizer.dynamicPartitionPruning.enabled](../spark-sql-properties.md#spark.sql.optimizer.dynamicPartitionPruning.enabled) configuration property is disabled (`false`).

For all other cases, `apply` applies [prune](#prune) optimization.

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

## <span id="prune"> prune Internal Method

```scala
prune(
  plan: LogicalPlan): LogicalPlan
```

`prune` transforms up all logical operators in the given [logical query plan](../logical-operators/LogicalPlan.md).

`prune` leaves [Join](../logical-operators/Join.md) operators unmodified when either operators are [Filter](../logical-operators/Filter.md)s with [DynamicPruningSubquery](../expressions/DynamicPruningSubquery.md) condition.

`prune` transforms [Join](../logical-operators/Join.md) operators of the following "shape":

1. The join condition is defined and of type `EqualTo` (`=`)

1. Any expressions are attributes of a [LogicalRelation](../logical-operators/LogicalRelation.md) over a [HadoopFsRelation](../spark-sql-BaseRelation-HadoopFsRelation.md)

1. The join type is one of `Inner`, `LeftSemi`, `RightOuter`, `LeftOuter`

??? note "More Work Needed"
    `prune` needs more love and would benefit from more insight on how it works.

`prune` is used when `PartitionPruning` is [executed](#apply).
