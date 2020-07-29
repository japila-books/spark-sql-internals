# CleanupAliases Logical Analysis Rule

`CleanupAliases` is a [logical analysis rule](../Analyzer.md#batches) that <<apply, transforms a logical query plan>> with...FIXME

`CleanupAliases` is part of the [Cleanup](../Analyzer.md#Cleanup) fixed-point batch in the standard batches of the [Logical Analyzer](../Analyzer.md).

`CleanupAliases` is simply a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md), i.e. `Rule[LogicalPlan]`.

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply`...FIXME

`apply` is part of the [Rule](catalyst/Rule.md#apply) abstraction.
