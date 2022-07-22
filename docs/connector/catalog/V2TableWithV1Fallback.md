# V2TableWithV1Fallback Tables

`V2TableWithV1Fallback` is an [extension](#contract) of the [Table](../Table.md) abstraction for [tables](#implementations) with [V1 fallback support](#v1Table) (using [CatalogTable](../../CatalogTable.md)).

## Contract

### <span id="v1Table"> v1Table

```scala
v1Table: CatalogTable
```

[CatalogTable](../../CatalogTable.md) to fall back to for unsupported V2 capabilities (that are supported in V1)

Used when:

* `ResolveRelations` logical resolution rule is requested to [createRelation](../../logical-analysis-rules/ResolveRelations.md#createRelation) (for a streaming table)
* `DataStreamWriter` ([Spark Structured Streaming]({{ book.structured_streaming }}/DataStreamWriter)) is requested to `toTable`

## Implementations

!!! note
    No known native Spark SQL implementations.
