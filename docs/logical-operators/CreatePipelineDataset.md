---
title: CreatePipelineDataset
---

# CreatePipelineDataset Logical Commands

`CreatePipelineDataset` is an [extension](#contract) of the [Command](Command.md) abstraction for [CREATE pipeline commands](#implementations) in [Spark Declarative Pipelines](../declarative-pipelines/index.md) framework:

* [CREATE MATERIALIZED VIEW ... AS](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset)
* [CREATE STREAMING TABLE](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset)
* [CREATE STREAMING TABLE ... AS](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset)

## Contract (Subset)

### Name { #name }

```scala
name: LogicalPlan
```

## Implementations

* [CreatePipelineDatasetAsSelect](CreatePipelineDatasetAsSelect.md)
* [CreateStreamingTable](CreateStreamingTable.md)
