---
title: CreateStreamingTable
---

# CreateStreamingTable Unary Logical Command

`CreateStreamingTable` is a `UnaryCommand` and a [CreatePipelineDataset](CreatePipelineDataset.md).

## Creating Instance

`CreateStreamingTable` takes the following to be created:

* <span id="name"> Name ([LogicalPlan](LogicalPlan.md))
* <span id="columns"> Columns (`ColumnDefinition`s)
* <span id="partitioning"> Partitioning [Transform](../connector/Transform.md)s
* <span id="tableSpec"> `TableSpecBase`
* <span id="ifNotExists"> `ifNotExists` flag

`CreateStreamingTable` is created when:

* `SparkSqlAstBuilder` is requested to parse [visitCreatePipelineDataset](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset) SQL statement
