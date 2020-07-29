# DetermineTableStats Logical PostHoc Resolution Rule -- Computing Total Size Table Statistic for HiveTableRelations

`DetermineTableStats` is a HiveSessionStateBuilder.md#postHocResolutionRules[logical posthoc resolution rule] that the HiveSessionStateBuilder.md#analyzer[Hive-specific logical query plan analyzer] uses to <<apply, compute total size table statistic for HiveTableRelations with no statistics>>.

Technically, `DetermineTableStats` is a ../catalyst/Rule.md[Catalyst rule] for transforming ../spark-sql-LogicalPlan.md[logical plans], i.e. `Rule[LogicalPlan]`.

=== [[apply]] `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of ../catalyst/Rule.md#apply[Rule Contract] to apply a rule to a ../spark-sql-LogicalPlan.md[logical plan] (aka _execute a rule_).

`apply`...FIXME
