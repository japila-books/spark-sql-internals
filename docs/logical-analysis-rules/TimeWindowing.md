# TimeWindowing Logical Resolution Rule

`TimeWindowing` is a [logical resolution rule](../Analyzer.md#batches) that <<apply, FIXME>> in a logical query plan.

`TimeWindowing` is part of the [Resolution](../Analyzer.md#Resolution) fixed-point batch in the standard batches of the [Logical Analyzer](../Analyzer.md).

`TimeWindowing` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

=== [[apply]] Executing Rule

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

`apply`...FIXME

`apply` is part of [Rule](../catalyst/Rule.md#apply) abstraction.
