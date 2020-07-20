# HiveTableScans Execution Planning Strategy

`HiveTableScans` is an link:../spark-sql-SparkStrategy.adoc[execution planning strategy] (of link:HiveSessionStateBuilder.adoc#planner[Hive-specific SparkPlanner]) that <<apply, replaces HiveTableRelation logical operators with HiveTableScanExec physical operators>>.

=== [[apply]] Planning Logical Plan for Execution -- `apply` Method

[source, scala]
----
apply(
  plan: LogicalPlan): Seq[SparkPlan]
----

NOTE: `apply` is part of link:../catalyst/GenericStrategy.md#apply[GenericStrategy Contract] to plan a logical query plan for execution (i.e. generate a collection of link:../SparkPlan.md[SparkPlans] for a given link:../spark-sql-LogicalPlan.adoc[logical plan]).

`apply` converts (_destructures_) the input link:../spark-sql-LogicalPlan.adoc[logical query plan] into projection expressions, predicate expressions, and a link:HiveTableRelation.adoc[HiveTableRelation].

`apply` requests the `HiveTableRelation` for the link:HiveTableRelation.adoc#partitionCols[partition columns] and filters the predicates to find so-called pruning predicates (that are expressions with no references and among the partition columns).

In the end, `apply` creates a "partial" link:HiveTableScanExec.adoc[HiveTableScanExec] physical operator (with the `HiveTableRelation` and the pruning predicates only) and link:../spark-sql-SparkPlanner.adoc#pruneFilterProject[pruneFilterProject].
