---
title: HiveTableScans
---

# HiveTableScans Execution Planning Strategy

`HiveTableScans` is an [execution planning strategy](../execution-planning-strategies/SparkStrategy.md) (of [Hive-specific SparkPlanner](HiveSessionStateBuilder.md#planner)) that <<apply, replaces HiveTableRelation logical operators with HiveTableScanExec physical operators>>.

=== [[apply]] Planning Logical Plan for Execution -- `apply` Method

[source, scala]
----
apply(
  plan: LogicalPlan): Seq[SparkPlan]
----

`apply` converts (_destructures_) the input ../spark-sql-LogicalPlan.md[logical query plan] into projection expressions, predicate expressions, and a HiveTableRelation.md[HiveTableRelation].

`apply` requests the `HiveTableRelation` for the HiveTableRelation.md#partitionCols[partition columns] and filters the predicates to find so-called pruning predicates (that are expressions with no references and among the partition columns).

In the end, `apply` creates a "partial" HiveTableScanExec.md[HiveTableScanExec] physical operator (with the `HiveTableRelation` and the pruning predicates only) and [pruneFilterProject](../SparkPlanner.md#pruneFilterProject).

`apply` is part of [GenericStrategy](../catalyst/GenericStrategy.md#apply) abstraction.
