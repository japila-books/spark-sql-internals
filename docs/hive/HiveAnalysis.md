# HiveAnalysis PostHoc Logical Resolution Rule

`HiveAnalysis` is a HiveSessionStateBuilder.md#postHocResolutionRules[logical posthoc resolution rule] that the HiveSessionStateBuilder.md#analyzer[Hive-specific logical query plan analyzer] uses to <<apply, FIXME>>.

Technically, `HiveAnalysis` is a ../catalyst/Rule.md[Catalyst rule] for transforming ../spark-sql-LogicalPlan.md[logical plans], i.e. `Rule[LogicalPlan]`.

[source, scala]
----
// FIXME Example of HiveAnalysis
----

=== [[apply]] Applying HiveAnalysis Rule to Logical Plan (Executing HiveAnalysis) -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of ../catalyst/Rule.md#apply[Rule Contract] to apply a rule to a ../spark-sql-LogicalPlan.md[logical plan].

`apply`...FIXME
