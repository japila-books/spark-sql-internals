---
title: CreatePipelineDatasetAsSelect
---

# CreatePipelineDatasetAsSelect Binary Logical Commands

`CreatePipelineDatasetAsSelect` is an [extension](#contract) of [BinaryCommand](Command.md#BinaryCommand) and [CreatePipelineDataset](CreatePipelineDataset.md) abstractions for [CTAS-like CREATE statements](#implementations):

* [CREATE MATERIALIZED VIEW ... AS](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset)
* [CREATE STREAMING TABLE ... AS](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset)

`CreatePipelineDatasetAsSelect` is a `CTEInChildren`.

## Contract

### Query { #query }

```scala
query: LogicalPlan
```

### Original SQL Text { #originalText }

```scala
originalText: String
```

## Implementations

* [CreateMaterializedViewAsSelect](CreateMaterializedViewAsSelect.md)
* [CreateStreamingTableAsSelect](CreateStreamingTableAsSelect.md)
