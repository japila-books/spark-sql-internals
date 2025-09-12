---
title: CreateMaterializedViewAsSelect
---

# CreateMaterializedViewAsSelect Logical Operator

`CreateMaterializedViewAsSelect` is a [CreatePipelineDatasetAsSelect](CreatePipelineDatasetAsSelect.md) logical operator that represents [CREATE MATERIALIZED VIEW](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset) SQL statement.

`CreateMaterializedViewAsSelect` is handled by [SqlGraphRegistrationContext](../declarative-pipelines/SqlGraphRegistrationContext.md#CreateMaterializedViewAsSelect) in [Spark Declarative Pipelines](../declarative-pipelines/index.md) framework.

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

* `SparkSqlAstBuilder` is requested to [parse CREATE MATERIALIZED VIEW SQL statement](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset)
