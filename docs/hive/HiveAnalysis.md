# HiveAnalysis PostHoc Logical Resolution Rule

`HiveAnalysis` is a HiveSessionStateBuilder.md#postHocResolutionRules[logical posthoc resolution rule] that the HiveSessionStateBuilder.md#analyzer[Hive-specific logical query plan analyzer] uses to <<apply, FIXME>>.

Technically, `HiveAnalysis` is a ../catalyst/Rule.md[Catalyst rule] for transforming ../spark-sql-LogicalPlan.md[logical plans], i.e. `Rule[LogicalPlan]`.
