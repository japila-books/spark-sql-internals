# CleanupAliases Logical Analysis Rule

`CleanupAliases` is a <<spark-sql-Analyzer.md#batches, logical analysis rule>> that <<apply, transforms a logical query plan>> with...FIXME

`CleanupAliases` is part of the <<spark-sql-Analyzer.md#Cleanup, Cleanup>> fixed-point batch in the standard batches of the <<spark-sql-Analyzer.md#, Analyzer>>.

`CleanupAliases` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[source, scala]
----
// FIXME: DEMO
----

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply`...FIXME

`apply` is part of the [Rule](catalyst/Rule.md#apply) abstraction.
