# PruneFileSourcePartitions Logical Optimization

`PruneFileSourcePartitions` is the only logical optimization rule in the [Prune File Source Table Partitions](../SparkOptimizer.md#prune-file-source-table-partitions) batch of the [SparkOptimizer](../SparkOptimizer.md).

`PruneFileSourcePartitions` <<apply, transforms a logical query plan>> into a Project.md[Project] operator with a `Filter` logical operator over a "pruned" `LogicalRelation` with the [HadoopFsRelation](../files/HadoopFsRelation.md) of a Hive partitioned table (with a PrunedInMemoryFileIndex.md[PrunedInMemoryFileIndex]).

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

`apply` PhysicalOperation.md#unapply[destructures the input logical plan] into a tuple of projection and filter expressions together with a leaf logical operator.

`apply` transforms LogicalRelation.md[LogicalRelations] with a [HadoopFsRelation](../files/HadoopFsRelation.md) and a [CatalogFileIndex](../files/CatalogFileIndex.md) (i.e. for Hive tables) when there are filter expressions defined and the Hive table is partitioned.

`apply` resolves partition column references (by requesting the logical operator to spark-sql-LogicalPlan.md#resolve[resolve partition column attributes to concrete references in the query plan]) and excludes spark-sql-Expression-SubqueryExpression.md#hasSubquery[subquery expressions].

If there are no predicates (filter expressions) left for partition pruning, `apply` simply does nothing more and returns the input logical query untouched.

With predicates left for partition pruning, `apply` requests the [CatalogFileIndex](../files/CatalogFileIndex.md) for the [partitions by the predicate expressions](../files/CatalogFileIndex.md#filterPartitions) (that gives a [PrunedInMemoryFileIndex](../files/PrunedInMemoryFileIndex.md) for a partitioned table).

`apply` replaces the [FileIndex](../files/HadoopFsRelation.md#location) in the [HadoopFsRelation](../files/HadoopFsRelation.md) with the `PrunedInMemoryFileIndex` and the CatalogStatistics.md#sizeInBytes[total size] statistic to the PartitioningAwareFileIndex.md#sizeInBytes[PrunedInMemoryFileIndex's].

In the end, `apply` creates a `Filter` logical operator (with the "pruned" `LogicalRelation` as a child operator and all the filter predicate expressions combined together with `And` expression) and makes it a child operator of a Project.md[Project] operator.

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
