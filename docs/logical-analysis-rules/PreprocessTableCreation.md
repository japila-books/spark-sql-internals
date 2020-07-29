# PreprocessTableCreation PostHoc Logical Resolution Rule

`PreprocessTableCreation` is a <<spark-sql-Analyzer.md#postHocResolutionRules, posthoc logical resolution rule>> that <<apply, resolves a logical query plan>> with <<spark-sql-LogicalPlan-CreateTable.md#, CreateTable>> logical operators.

`PreprocessTableCreation` is part of the <<spark-sql-Analyzer.md#Post-Hoc-Resolution, Post-Hoc Resolution>> once-executed batch of the hive/HiveSessionStateBuilder.md#analyzer[Hive-specific] and the <<BaseSessionStateBuilder.md#analyzer, default>> logical analyzers.

`PreprocessTableCreation` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[[sparkSession]]
[[creating-instance]]
`PreprocessTableCreation` takes a <<SparkSession.md#, SparkSession>> when created.

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply`...FIXME

`apply` is part of the [Rule](catalyst/Rule.md#apply) abstraction.
