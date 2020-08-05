# OptimizeSubqueries Logical Optimization

`OptimizeSubqueries` is a [base logical optimization](../catalyst/Optimizer.md#batches) that <<apply, FIXME>>.

`OptimizeSubqueries` is part of the [Subquery](../catalyst/Optimizer.md#Subquery) once-executed batch in the standard batches of the [Logical Optimizer](../catalyst/Optimizer.md).

`OptimizeSubqueries` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[source, scala]
----
// FIXME Demo
----

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of the <<catalyst/Rule.md#apply, Rule Contract>> to execute (apply) a rule on a <<catalyst/TreeNode.md#, TreeNode>> (e.g. <<spark-sql-LogicalPlan.md#, LogicalPlan>>).

`apply`...FIXME
