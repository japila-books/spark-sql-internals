# ResolveHiveSerdeTable Logical Resolution Rule

`ResolveHiveSerdeTable` is a logical resolution rule (i.e. `Rule[LogicalPlan]`) that the HiveSessionStateBuilder.md#analyzer[Hive-specific logical query plan analyzer] uses to <<apply, resolve the metadata of a hive table for CreateTable logical operators>>.

`ResolveHiveSerdeTable` is part of ../spark-sql-Analyzer.md#extendedResolutionRules[additional rules] in ../spark-sql-Analyzer.md#Resolution[Resolution] fixed-point batch of rules.

[source, scala]
----
// FIXME Example of ResolveHiveSerdeTable
----

=== [[apply]] Applying ResolveHiveSerdeTable Rule to Logical Plan -- `apply` Method

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of ../catalyst/Rule.md#apply[Rule Contract] to apply a rule to a ../spark-sql-LogicalPlan.md[logical plan].

`apply`...FIXME
