---
title: PreprocessTableCreation
---

# PreprocessTableCreation PostHoc Logical Resolution Rule

`PreprocessTableCreation` is a [posthoc logical resolution rule](../Analyzer.md#postHocResolutionRules) that <<apply, resolves a logical query plan>> with <<CreateTable.md#, CreateTable>> logical operators.

`PreprocessTableCreation` is part of the [Post-Hoc Resolution](../Analyzer.md#Post-Hoc-Resolution) once-executed batch of the [Hive-specific](../hive/HiveSessionStateBuilder.md#analyzer) and the [default](../BaseSessionStateBuilder.md#analyzer) logical analyzers.

`PreprocessTableCreation` is simply a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md), i.e. `Rule[LogicalPlan]`.

[[sparkSession]]
[[creating-instance]]
`PreprocessTableCreation` takes a <<SparkSession.md#, SparkSession>> when created.

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
