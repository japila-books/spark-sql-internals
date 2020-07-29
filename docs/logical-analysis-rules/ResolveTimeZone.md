# ResolveTimeZone Logical Resolution Rule

`ResolveTimeZone` is a logical resolution rule that the spark-sql-Analyzer.md#ResolveRelations[logical query plan analyzer] uses to <<apply, FIXME>>.

Technically, `ResolveTimeZone` is just a catalyst/Rule.md[Catalyst rule] for transforming spark-sql-LogicalPlan.md[logical plans], i.e. `Rule[LogicalPlan]`.

`ResolveTimeZone` is part of spark-sql-Analyzer.md#Resolution[Resolution] fixed-point batch of rules.

=== [[apply]] Applying ResolveTimeZone to Logical Plan -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of catalyst/Rule.md#apply[Rule Contract] to apply a rule to a spark-sql-LogicalPlan.md[logical plan].

`apply`...FIXME
