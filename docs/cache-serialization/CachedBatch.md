---
tags:
  - DeveloperApi
---

# CachedBatch

`CachedBatch` is an [abstraction](#contract) of [cached batches of data](#implementations) with the [numRows](#numRows) and [sizeInBytes](#sizeInBytes) metrics.

## Contract

### <span id="numRows"> numRows

```scala
numRows: Int
```

Used when:

* `CachedRDDBuilder` is requested to [buildBuffers](CachedRDDBuilder.md#buildBuffers)
* `InMemoryTableScanExec` physical operator is requested for the [inputRDD](../physical-operators/InMemoryTableScanExec.md#inputRDD)

### <span id="sizeInBytes"> sizeInBytes

```scala
sizeInBytes: Long
```

Used when:

* `CachedRDDBuilder` is requested to [buildBuffers](CachedRDDBuilder.md#buildBuffers)

## Implementations

* [SimpleMetricsCachedBatch](SimpleMetricsCachedBatch.md)
