# TimeWindowing Logical Resolution Rule

`TimeWindowing` is a <<spark-sql-Analyzer.md#batches, logical resolution rule>> that <<apply, FIXME>> in a logical query plan.

`TimeWindowing` is part of the <<spark-sql-Analyzer.md#Resolution, Resolution>> fixed-point batch in the standard batches of the <<spark-sql-Analyzer.md#, Analyzer>>.

`TimeWindowing` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[source, scala]
----
// FIXME: DEMO
----

=== [[apply]] Executing Rule

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply`...FIXME

`apply` is part of [Rule](catalyst/Rule.md#apply) abstraction.
