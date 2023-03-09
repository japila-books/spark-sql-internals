---
tags:
  - DeveloperApi
---

# CachedBatchSerializer

`CachedBatchSerializer` is an [abstraction](#contract) of [serializers](#implementations).

`CachedBatchSerializer` is configured using [spark.sql.cache.serializer](../configuration-properties.md#spark.sql.cache.serializer) configuration property (for [InMemoryRelation](../logical-operators/InMemoryRelation.md#getSerializer)).

`CachedBatchSerializer` is used to create a [CachedRDDBuilder](CachedRDDBuilder.md#serializer).

`CachedBatchSerializer` is a `Serializable`.

## Contract (Subset)

### <span id="buildFilter"> buildFilter

```scala
buildFilter(
  predicates: Seq[Expression],
  cachedAttributes: Seq[Attribute]): (Int, Iterator[CachedBatch]) => Iterator[CachedBatch]
```

See:

* [SimpleMetricsCachedBatchSerializer](SimpleMetricsCachedBatchSerializer.md#buildFilter)

Used when:

* `InMemoryTableScanExec` physical operator is requested to [filteredCachedBatches](../physical-operators/InMemoryTableScanExec.md#filteredCachedBatches) (with [spark.sql.inMemoryColumnarStorage.partitionPruning](../configuration-properties.md#spark.sql.inMemoryColumnarStorage.partitionPruning) enabled)

### <span id="supportsColumnarInput"> supportsColumnarInput

```scala
supportsColumnarInput(
  schema: Seq[Attribute]): Boolean
```

See:

* [DefaultCachedBatchSerializer](DefaultCachedBatchSerializer.md#supportsColumnarInput)

Used when:

* `CachedRDDBuilder` is requested to [buildBuffers](CachedRDDBuilder.md#buildBuffers)
* `InMemoryRelation` is [created](../logical-operators/InMemoryRelation.md#apply)

## Implementations

* [SimpleMetricsCachedBatchSerializer](SimpleMetricsCachedBatchSerializer.md)
