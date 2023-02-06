# PartitionPruning Logical Optimization

`PartitionPruning` is a logical optimization for [Dynamic Partition Pruning](../dynamic-partition-pruning/index.md).

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

`prune` skips [Join](../logical-operators/Join.md) logical operators (leaves unmodified) when either left or right child operators are `Filter`s with [DynamicPruningSubquery](../expressions/DynamicPruningSubquery.md) condition.

`prune` transforms [Join](../logical-operators/Join.md) operators with [EqualTo](../expressions/EqualTo.md) join conditions.

??? note "FIXME More Work Needed"
    `prune` needs more love and would benefit from more insight on how it works.

## <span id="getFilterableTableScan"> getFilterableTableScan

```scala
getFilterableTableScan(
  a: Expression,
  plan: LogicalPlan): Option[LogicalPlan]
```

`getFilterableTableScan` [findExpressionAndTrackLineageDown](#findExpressionAndTrackLineageDown) (that finds a [LeafNode](../logical-operators/LeafNode.md) with the [output](../catalyst/QueryPlan.md#output) schema that includes all the [Attribute](../expressions/Attribute.md) references of the given [Expression](../expressions/Expression.md)).

!!! note "Leaf Nodes"
    `getFilterableTableScan` is only interested in the following [leaf logical operators](../logical-operators/LeafNode.md):

    * [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) over `SupportsRuntimeFiltering` scans
    * [HiveTableRelation](../hive/HiveTableRelation.md)
    * [LogicalRelation](../logical-operators/LogicalRelation.md) over [HadoopFsRelation](../datasources/HadoopFsRelation.md)

`getFilterableTableScan`...FIXME

### <span id="getFilterableTableScan-LogicalRelation"> LogicalRelation over (Partitioned) HadoopFsRelation

For [LogicalRelation](../logical-operators/LogicalRelation.md) with (the [relation](../logical-operators/LogicalRelation.md#relation) that is) a partitioned [HadoopFsRelation](../datasources/HadoopFsRelation.md), `getFilterableTableScan` checks if the [references](../expressions/Expression.md#references) (of the given [Expression](../expressions/Expression.md)) are all among the [partition columns](../datasources/HadoopFsRelation.md#partitionSchema).

If so, `getFilterableTableScan` returns the `LogicalRelation` with the partitioned `HadoopFsRelation`.

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

## <span id="insertPredicate"> insertPredicate

```scala
insertPredicate(
  pruningKey: Expression,
  pruningPlan: LogicalPlan,
  filteringKey: Expression,
  filteringPlan: LogicalPlan,
  joinKeys: Seq[Expression],
  partScan: LogicalPlan): LogicalPlan
```

`insertPredicate`...FIXME

## <span id="pruningHasBenefit"> pruningHasBenefit

```scala
pruningHasBenefit(
  partExpr: Expression,
  partPlan: LogicalPlan,
  otherExpr: Expression,
  otherPlan: LogicalPlan): Boolean
```

!!! note
    `pruningHasBenefit` uses [Column Statistics](../logical-operators/Statistics.md#attributeStats) (for the [number of distinct values](../cost-based-optimization/ColumnStat.md#distinctCount)), if available and [spark.sql.optimizer.dynamicPartitionPruning.useStats](../configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.useStats) is enabled.

`pruningHasBenefit`...FIXME
