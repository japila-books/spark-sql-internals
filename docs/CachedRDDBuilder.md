# CachedRDDBuilder

`CachedRDDBuilder` is <<creating-instance, created>> exclusively when [InMemoryRelation](logical-operators/InMemoryRelation.md) leaf logical operator is created.

[[cachedColumnBuffers]]
`CachedRDDBuilder` uses a `RDD` of <<CachedBatch, CachedBatches>> that is either <<_cachedColumnBuffers, given>> or <<buildBuffers, built internally>>.

[[CachedBatch]]
`CachedRDDBuilder` uses `CachedBatch` data structure with the following attributes:

* [[numRows]] Number of rows
* [[buffers]] Buffers (`Array[Array[Byte]]`)
* [[stats]] Statistics (<<spark-sql-InternalRow.md#, InternalRow>>)

[[isCachedColumnBuffersLoaded]]
`CachedRDDBuilder` uses `isCachedColumnBuffersLoaded` flag that is enabled (`true`) when the <<_cachedColumnBuffers, _cachedColumnBuffers>> is defined (not `null`). `isCachedColumnBuffersLoaded` is used exclusively when `CacheManager` is requested to [recacheByCondition](CacheManager.md#recacheByCondition).

[[sizeInBytesStats]]
`CachedRDDBuilder` uses `sizeInBytesStats` metric (`LongAccumulator`) to <<buildBuffers, buildBuffers>> and when `InMemoryRelation` is requested to [computeStats](logical-operators/InMemoryRelation.md#computeStats).

=== [[creating-instance]] Creating CachedRDDBuilder Instance

`CachedRDDBuilder` takes the following to be created:

* [[useCompression]] `useCompression` flag
* [[batchSize]] Batch size
* [[storageLevel]] `StorageLevel`
* [[cachedPlan]] [Physical operator](physical-operators/SparkPlan.md)
* [[tableName]] Table name
* [[_cachedColumnBuffers]] `RDD[CachedBatch]` (default: `null`)

`CachedRDDBuilder` initializes the <<internal-registries, internal registries and counters>>.

=== [[buildBuffers]] `buildBuffers` Internal Method

[source, scala]
----
buildBuffers(): RDD[CachedBatch]
----

`buildBuffers`...FIXME

NOTE: `buildBuffers` is used exclusively when `CachedRDDBuilder` is requested to <<cachedColumnBuffers, cachedColumnBuffers>>.

## clearCache

```scala
clearCache(
  blocking: Boolean = true): Unit
```

`clearCache`...FIXME

`clearCache` is used exclusively when `CacheManager` is requested to [clearCache](CacheManager.md#clearCache), [uncacheQuery](CacheManager.md#uncacheQuery), and [recacheByCondition](CacheManager.md#recacheByCondition).
