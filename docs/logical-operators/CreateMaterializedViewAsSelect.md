---
title: CreateMaterializedViewAsSelect
---

# CreateMaterializedViewAsSelect Logical Operator

`CreateMaterializedViewAsSelect` is a [CreatePipelineDatasetAsSelect](CreatePipelineDatasetAsSelect.md) binary logical command that represents [CREATE MATERIALIZED VIEW ... AS](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset) SQL statement in [Spark Declarative Pipelines](../declarative-pipelines/index.md) framework.

`CreateMaterializedViewAsSelect` is handled by [SqlGraphRegistrationContext](../declarative-pipelines/SqlGraphRegistrationContext.md#CreateMaterializedViewAsSelect).

## Creating Instance

`CreateMaterializedViewAsSelect` takes the following to be created:

* <span id="name"> Name ([LogicalPlan](LogicalPlan.md))
* <span id="columns"> Columns (`ColumnDefinition`s)
* <span id="partitioning"> Partitioning ([Transform](../connector/Transform.md))
* <span id="tableSpec"> `TableSpecBase`
* <span id="query"> [LogicalPlan](LogicalPlan.md)
* <span id="originalText"> SQL Text
* <span id="ifNotExists"> `ifNotExists` flag

`CreateMaterializedViewAsSelect` is created when:

* `SparkSqlAstBuilder` is requested to [parse CREATE MATERIALIZED VIEW ... AS SQL statement](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset)
