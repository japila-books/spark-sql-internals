# CleanupDynamicPruningFilters Logical Optimization

`CleanupDynamicPruningFilters` is a logical optimization for [Dynamic Partition Pruning](../dynamic-partition-pruning/index.md).

`CleanupDynamicPruningFilters` is a `Rule[LogicalPlan]` (a [Catalyst Rule](../catalyst/Rule.md) for [logical operators](../logical-operators/LogicalPlan.md)).

`CleanupDynamicPruningFilters` is part of the [Cleanup filters that cannot be pushed down](../SparkOptimizer.md#cleanup-filters-that-cannot-be-pushed-down) batch of the [SparkOptimizer](../SparkOptimizer.md#defaultBatches).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

---

!!! note "spark.sql.optimizer.dynamicPartitionPruning.enabled"
    `apply` is a _noop_ (does nothing and returns the given [LogicalPlan](../logical-operators/LogicalPlan.md)) when executed with [spark.sql.optimizer.dynamicPartitionPruning.enabled](../configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.enabled) configuration property disabled.

`apply` finds logical operators with the following tree patterns:

* [DYNAMIC_PRUNING_EXPRESSION](../catalyst/TreePattern.md#DYNAMIC_PRUNING_EXPRESSION)
* [DYNAMIC_PRUNING_SUBQUERY](../catalyst/TreePattern.md#DYNAMIC_PRUNING_SUBQUERY)

`apply` transforms the given [logical plan](../logical-operators/LogicalPlan.md) as follows:

* For [LogicalRelation](../logical-operators/LogicalRelation.md) logical operators over [HadoopFsRelation](../connectors/HadoopFsRelation.md)s, `apply` [removeUnnecessaryDynamicPruningSubquery](#removeUnnecessaryDynamicPruningSubquery)

* For [HiveTableRelation](../hive/HiveTableRelation.md) logical operators, `apply` [removeUnnecessaryDynamicPruningSubquery](#removeUnnecessaryDynamicPruningSubquery)

* For [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) logical operators, `apply` [removeUnnecessaryDynamicPruningSubquery](#removeUnnecessaryDynamicPruningSubquery)

* `DynamicPruning` predicate expressions in `Filter` logical operators are replaced with `true` literals (_cleaned up_)
