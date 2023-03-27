---
title: ExposesMetadataColumns
---

# ExposesMetadataColumns Logical Operators

`ExposesMetadataColumns` is an [extension](#contract) of the [LogicalPlan](LogicalPlan.md) abstraction for [logical operators](#implementations) that can [withMetadataColumns](#withMetadataColumns).

## Contract

### <span id="withMetadataColumns"> withMetadataColumns

```scala
withMetadataColumns(): LogicalPlan
```

See:

* [DataSourceV2Relation](DataSourceV2Relation.md#withMetadataColumns)
* [LogicalRelation](LogicalRelation.md#withMetadataColumns)

Used when:

* [AddMetadataColumns](../logical-analysis-rules/AddMetadataColumns.md) logical analysis rule is executed (and [addMetadataCol](../logical-analysis-rules/AddMetadataColumns.md#addMetadataCol))

## Implementations

* [DataSourceV2Relation](DataSourceV2Relation.md)
* [LogicalRelation](LogicalRelation.md)
* `StreamingRelation` ([Spark Structured Streaming]({{ book.structured_streaming }}/logical-operators/StreamingRelation))
