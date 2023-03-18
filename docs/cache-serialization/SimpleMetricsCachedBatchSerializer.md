---
tags:
  - DeveloperApi
---

# SimpleMetricsCachedBatchSerializer

`SimpleMetricsCachedBatchSerializer` is a base abstraction of the [CachedBatchSerializer](CachedBatchSerializer.md) abstraction for [serializers](#implementations) with the default [buildFilter](#buildFilter).

## Implementations

* [DefaultCachedBatchSerializer](DefaultCachedBatchSerializer.md)

## <span id="buildFilter"> Building Batch Filter

??? note "Signature"

    ```scala
    buildFilter(
      predicates: Seq[Expression],
      cachedAttributes: Seq[Attribute]): (Int, Iterator[CachedBatch]) => Iterator[CachedBatch]
    ```

    `buildFilter` is part of the [CachedBatchSerializer](CachedBatchSerializer.md#buildFilter) abstraction.

`buildFilter`...FIXME
