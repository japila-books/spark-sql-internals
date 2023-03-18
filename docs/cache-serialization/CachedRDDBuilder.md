# CachedRDDBuilder

## Creating Instance

`CachedRDDBuilder` takes the following to be created:

* <span id="serializer"> [CachedBatchSerializer](CachedBatchSerializer.md)
* <span id="storageLevel"> `StorageLevel` ([Spark Core]({{ book.spark_core }}/storage/StorageLevel/))
* <span id="cachedPlan"> Cached [SparkPlan](../physical-operators/SparkPlan.md)
* <span id="tableName"> (optional) Table Name

`CachedRDDBuilder` is created alongside [InMemoryRelation](../logical-operators/InMemoryRelation.md#cacheBuilder) leaf logical operator.

<!---
## Review Me

[[cachedColumnBuffers]]
`CachedRDDBuilder` uses a `RDD` of <<CachedBatch, CachedBatches>> that is either <<_cachedColumnBuffers, given>> or <<buildBuffers, built internally>>.

[[CachedBatch]]
`CachedRDDBuilder` uses `CachedBatch` data structure with the following attributes:

* [[numRows]] Number of rows
* [[buffers]] Buffers (`Array[Array[Byte]]`)
* [[stats]] Statistics ([InternalRow](InternalRow.md))

[[isCachedColumnBuffersLoaded]]
`CachedRDDBuilder` uses `isCachedColumnBuffersLoaded` flag that is enabled (`true`) when the <<_cachedColumnBuffers, _cachedColumnBuffers>> is defined (not `null`). `isCachedColumnBuffersLoaded` is used exclusively when `CacheManager` is requested to [recacheByCondition](CacheManager.md#recacheByCondition).

[[sizeInBytesStats]]
`CachedRDDBuilder` uses `sizeInBytesStats` metric (`LongAccumulator`) to <<buildBuffers, buildBuffers>> and when `InMemoryRelation` is requested to [computeStats](logical-operators/InMemoryRelation.md#computeStats).
-->
