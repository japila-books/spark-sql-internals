---
title: CreateStreamingTableAsSelect
---

# CreateStreamingTableAsSelect Binary Logical Command

`CreateStreamingTableAsSelect` is a [CreatePipelineDatasetAsSelect](CreatePipelineDatasetAsSelect.md) binary logical command that represents [CREATE STREAMING TABLE ... AS](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset) SQL statement in [Spark Declarative Pipelines](../declarative-pipelines/SqlGraphRegistrationContext.md#CreateStreamingTableAsSelect).

??? note "CreateStreamingTable for `CREATE STREAMING TABLE` SQL Statement"
    [CREATE STREAMING TABLE](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset) SQL statement (with no `AS` clause) gives a [CreateStreamingTable](CreateStreamingTable.md) unary logical command.

## Creating Instance

`CreateStreamingTableAsSelect` takes the following to be created:

* <span id="name"> Name ([LogicalPlan](LogicalPlan.md))
* <span id="columns"> Colums (`ColumnDefinition`s)
* <span id="partitioning"> Partitioning [Transform](../connector/Transform.md)s
* <span id="tableSpec"> `TableSpecBase`
* <span id="query"> `CREATE` query ([LogicalPlan](LogicalPlan.md))
* <span id="originalText"> Original SQL Text
* <span id="ifNotExists"> `ifNotExists` flag

`CreateStreamingTableAsSelect` is created when:

* `SparkSqlAstBuilder` is requested to parse [CREATE STREAMING TABLE ... AS](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset) SQL statement
