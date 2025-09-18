---
title: CreatePipelineDatasetAsSelect
---

# CreatePipelineDatasetAsSelect Binary Logical Commands

`CreatePipelineDatasetAsSelect` is an [extension](#contract) of the [BinaryCommand](Command.md#BinaryCommand) and the [CreatePipelineDataset](CreatePipelineDataset.md) abstractions for [CTAS-like CREATE statements](#implementations).

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
