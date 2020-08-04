# CleanupDynamicPruningFilters Logical Optimization

`CleanupDynamicPruningFilters` is a logical optimization for [Dynamic Partition Pruning](../new-and-noteworthy/dynamic-partition-pruning.md).

`CleanupDynamicPruningFilters` removes `DynamicPruning` predicate expressions in [Filter](../logical-operators/Filter.md) logical operators.

`CleanupDynamicPruningFilters` is a `Rule[LogicalPlan]` (a [rule](../catalyst/Rule.md) for [logical operators](../logical-operators/LogicalPlan.md)).

`CleanupDynamicPruningFilters` is part of the [Cleanup filters that cannot be pushed down](../SparkOptimizer.md#cleanup-filters-that-cannot-be-pushed-down) batch of the [SparkOptimizer](../SparkOptimizer.md).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` does nothing when the [spark.sql.optimizer.dynamicPartitionPruning.enabled](../spark-sql-properties.md#spark.sql.optimizer.dynamicPartitionPruning.enabled) configuration property is disabled (`false`).

`apply` transforms the given [logical plan](../logical-operators/LogicalPlan.md) as follows:

* [LogicalRelation](../logical-operators/LogicalRelation.md) logical operators with [HadoopFsRelation](../spark-sql-BaseRelation-HadoopFsRelation.md) are left unmodified (_pass through_)

* `DynamicPruning` predicate expressions in [Filter](../logical-operators/Filter.md) logical operators are replaced with `true` literals (_cleaned up_)

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
