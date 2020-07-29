# ResolveTimeZone Logical Resolution Rule

`ResolveTimeZone` is a logical resolution rule that the [logical query plan analyzer](../Analyzer.md#ResolveRelations) uses to <<apply, FIXME>>.

`ResolveTimeZone` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md), i.e. `Rule[LogicalPlan]`.

`ResolveTimeZone` is part of [Resolution](../Analyzer.md#Resolution) fixed-point batch of rules.

=== [[apply]] Applying ResolveTimeZone to Logical Plan -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of catalyst/Rule.md#apply[Rule Contract] to apply a rule to a spark-sql-LogicalPlan.md[logical plan].

`apply`...FIXME
