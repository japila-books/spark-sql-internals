---
title: CreateStreamingTable
---

# CreateStreamingTable Unary Logical Command

`CreateStreamingTable` is a `UnaryCommand` and a [CreatePipelineDataset](CreatePipelineDataset.md) that represents [CREATE STREAMING TABLE](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset) SQL statement (with no `AS` clause) in [Spark Declarative Pipelines](../declarative-pipelines/index.md) framework.

`CreateStreamingTable` is handled by [SqlGraphRegistrationContext](../declarative-pipelines/SqlGraphRegistrationContext.md#CreateStreamingTable).

??? note "CreateStreamingTableAsSelect for `CREATE STREAMING TABLE ... AS` SQL Statement"
    [CREATE STREAMING TABLE ... AS](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset) SQL statement (with `AS` clause) gives a [CreateStreamingTableAsSelect](CreateStreamingTableAsSelect.md) binary logical command.

## Creating Instance

`CreateStreamingTable` takes the following to be created:

* <span id="name"> Name ([LogicalPlan](LogicalPlan.md))
* <span id="columns"> Columns (`ColumnDefinition`s)
* <span id="partitioning"> Partitioning [Transform](../connector/Transform.md)s
* <span id="tableSpec"> `TableSpecBase`
* <span id="ifNotExists"> `ifNotExists` flag

`CreateStreamingTable` is created when:

* `SparkSqlAstBuilder` is requested to [parse CREATE STREAMING TABLE SQL statement](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset)
