# PruneFileSourcePartitions Logical Optimization

`PruneFileSourcePartitions` is the only logical optimization rule in the link:spark-sql-SparkOptimizer.adoc#prune-file-source-table-partitions[Prune File Source Table Partitions] batch of the link:spark-sql-SparkOptimizer.adoc[SparkOptimizer].

`PruneFileSourcePartitions` <<apply, transforms a logical query plan>> into a link:spark-sql-LogicalPlan-Project.adoc[Project] operator with a link:spark-sql-LogicalPlan-Filter.adoc[Filter] logical operator over a "pruned" `LogicalRelation` with the link:spark-sql-BaseRelation-HadoopFsRelation.adoc[HadoopFsRelation] of a Hive partitioned table (with a link:PrunedInMemoryFileIndex.adoc[PrunedInMemoryFileIndex]).

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

`apply` link:spark-sql-PhysicalOperation.adoc#unapply[destructures the input logical plan] into a tuple of projection and filter expressions together with a leaf logical operator.

`apply` transforms link:spark-sql-LogicalPlan-LogicalRelation.adoc[LogicalRelations] with a link:spark-sql-BaseRelation-HadoopFsRelation.adoc[HadoopFsRelation] and a link:CatalogFileIndex.adoc[CatalogFileIndex] (i.e. for Hive tables) when there are filter expressions defined and the Hive table is partitioned.

`apply` resolves partition column references (by requesting the logical operator to link:spark-sql-LogicalPlan.adoc#resolve[resolve partition column attributes to concrete references in the query plan]) and excludes link:spark-sql-Expression-SubqueryExpression.adoc#hasSubquery[subquery expressions].

If there are no predicates (filter expressions) left for partition pruning, `apply` simply does nothing more and returns the input logical query untouched.

With predicates left for partition pruning, `apply` requests the link:CatalogFileIndex.adoc[CatalogFileIndex] for the link:CatalogFileIndex.adoc#filterPartitions[partitions by the predicate expressions] (that gives a link:PrunedInMemoryFileIndex.adoc[PrunedInMemoryFileIndex] for a partitioned table).

`apply` replaces the link:spark-sql-BaseRelation-HadoopFsRelation.adoc#location[FileIndex] in the link:spark-sql-BaseRelation-HadoopFsRelation.adoc[HadoopFsRelation] with the `PrunedInMemoryFileIndex` and the link:spark-sql-CatalogStatistics.adoc#sizeInBytes[total size] statistic to the link:PartitioningAwareFileIndex.adoc#sizeInBytes[PrunedInMemoryFileIndex's].

In the end, `apply` creates a link:spark-sql-LogicalPlan-Filter.adoc[Filter] logical operator (with the "pruned" `LogicalRelation` as a child operator and all the filter predicate expressions combined together with `And` expression) and makes it a child operator of a link:spark-sql-LogicalPlan-Project.adoc[Project] operator.

`apply` is part of the [Rule](../spark-sql-catalyst-Rule.md#apply) abstraction.
