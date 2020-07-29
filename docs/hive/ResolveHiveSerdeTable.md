# ResolveHiveSerdeTable Logical Resolution Rule

`ResolveHiveSerdeTable` is a logical resolution rule (i.e. `Rule[LogicalPlan]`) that the [Hive-specific logical query plan analyzer](HiveSessionStateBuilder.md#analyzer) uses to <<apply, resolve the metadata of a hive table for CreateTable logical operators>>.

`ResolveHiveSerdeTable` is part of [additional rules](../Analyzer.md#extendedResolutionRules) in [Resolution](../Analyzer.md#Resolution) fixed-point batch of rules.

=== [[apply]] Applying ResolveHiveSerdeTable Rule to Logical Plan -- `apply` Method

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of ../catalyst/Rule.md#apply[Rule Contract] to apply a rule to a ../spark-sql-LogicalPlan.md[logical plan].

`apply`...FIXME
