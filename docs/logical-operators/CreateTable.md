---
title: CreateTable
---

# CreateTable Logical Operator

`CreateTable` is a [LogicalPlan](LogicalPlan.md).

## Analysis Phase

`CreateTable` can never be [resolved](#resolved) and is replaced with (_resolved to_) a logical command at analysis phase in the following rules:

* (for non-hive data source tables) [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) posthoc logical resolution rule to a [CreateDataSourceTableCommand](CreateDataSourceTableCommand.md) or a [CreateDataSourceTableAsSelectCommand](CreateDataSourceTableAsSelectCommand.md) logical command (based on the [query](#query) defined or not, respectively)

* (for hive tables) [HiveAnalysis](../hive/HiveAnalysis.md) post-hoc logical resolution rule to a `CreateTableCommand` or a [CreateHiveTableAsSelectCommand](../hive/CreateHiveTableAsSelectCommand.md) logical command (based on the [query](#query) defined or not, respectively)

## Creating Instance

`CreateTable` takes the following to be created:

* <span id="tableDesc"> [CatalogTable](../CatalogTable.md)
* <span id="mode"> [SaveMode](../DataFrameWriter.md#SaveMode)
* <span id="query"> Optional Query ([LogicalPlan](LogicalPlan.md))

While being created, `CreateTable` asserts the following:

* The [table](#tableDesc) to be created must have the [provider](../CatalogTable.md#provider)
* With no [query](#query), the [SaveMode](#mode) must be either `ErrorIfExists` or `Ignore`

`CreateTable` is created when:

* [DataFrameWriter.saveAsTable](../DataFrameWriter.md#saveAsTable) operator is used (and [creates a table](../DataFrameWriter.md#createTable))
* [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule is executed (to [constructV1TableCmd](../logical-analysis-rules/ResolveSessionCatalog.md#constructV1TableCmd))

## Never Resolved { #resolved }

??? note "LogicalPlan"

    ```scala
    resolved: Boolean
    ```

    `resolved` is part of the [LogicalPlan](LogicalPlan.md#resolved) abstraction.

`resolved` is always `false`.
