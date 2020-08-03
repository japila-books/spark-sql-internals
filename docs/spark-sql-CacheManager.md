title: CacheManager

# CacheManager -- In-Memory Cache for Tables and Views

`CacheManager` is an in-memory cache (_registry_) for structured queries (by their spark-sql-LogicalPlan.md[logical plans]).

`CacheManager` is shared across `SparkSessions` through SparkSession.md#sharedState[SharedState].

[source, scala]
----
val spark: SparkSession = ...
spark.sharedState.cacheManager
----

NOTE: A Spark developer can use `CacheManager` to cache ``Dataset``s using spark-sql-caching-and-persistence.md#cache[cache] or spark-sql-caching-and-persistence.md#persist[persist] operators.

`CacheManager` uses the <<cachedData, cachedData>> internal registry to manage cached structured queries and their spark-sql-LogicalPlan-InMemoryRelation.md[InMemoryRelation] cached representation.

`CacheManager` <<isEmpty, can be empty>>.

[[CachedData]]
[[plan]]
[[cachedRepresentation]]
`CacheManager` uses `CachedData` data structure for managing <<cachedData, cached structured queries>> with the <<spark-sql-LogicalPlan.md#, LogicalPlan>> (of a structured query) and a corresponding <<spark-sql-LogicalPlan-InMemoryRelation.md#, InMemoryRelation>> leaf logical operator.

[[logging]]
[TIP]
====
Enable `ALL` logging level for `org.apache.spark.sql.execution.CacheManager` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.execution.CacheManager=ALL
```

Refer to <<spark-logging.md#, Logging>>.
====

=== [[cachedData]] Cached Structured Queries -- `cachedData` Internal Registry

[source, scala]
----
cachedData: LinkedList[CachedData]
----

`cachedData` is a collection of <<CachedData, CachedData>>.

A new `CachedData` added when `CacheManager` is requested to:

* <<cacheQuery, cacheQuery>>

* <<recacheByCondition, recacheByCondition>>

A `CachedData` removed when `CacheManager` is requested to:

* <<uncacheQuery, uncacheQuery>>

* <<recacheByCondition, recacheByCondition>>

All `CachedData` removed (cleared) when `CacheManager` is requested to <<clearCache, clearCache>>

=== [[lookupCachedData]] `lookupCachedData` Method

[source, scala]
----
lookupCachedData(query: Dataset[_]): Option[CachedData]
lookupCachedData(plan: LogicalPlan): Option[CachedData]
----

`lookupCachedData`...FIXME

[NOTE]
====
`lookupCachedData` is used when:

* <<spark-sql-dataset-operators.md#storageLevel, Dataset.storageLevel>> basic action is used

* `CatalogImpl` is requested to <<spark-sql-CatalogImpl.md#isCached, isCached>>

* `CacheManager` is requested to <<cacheQuery, cacheQuery>> and <<useCachedData, useCachedData>>
====

=== [[uncacheQuery]] Un-caching Dataset -- `uncacheQuery` Method

[source, scala]
----
uncacheQuery(
  query: Dataset[_],
  cascade: Boolean,
  blocking: Boolean = true): Unit
uncacheQuery(
  spark: SparkSession,
  plan: LogicalPlan,
  cascade: Boolean,
  blocking: Boolean): Unit
----

`uncacheQuery`...FIXME

[NOTE]
====
`uncacheQuery` is used when:

* <<spark-sql-dataset-operators.md#unpersist, Dataset.unpersist>> basic action is used

* <<spark-sql-LogicalPlan-DropTableCommand.md#, DropTableCommand>> and `TruncateTableCommand` logical commands are executed

* `CatalogImpl` is requested to <<spark-sql-CatalogImpl.md#uncacheTable, uncache>> and <<spark-sql-CatalogImpl.md#refreshTable, refresh>> a table or view, <<spark-sql-CatalogImpl.md#dropTempView, dropTempView>> and <<spark-sql-CatalogImpl.md#dropGlobalTempView, dropGlobalTempView>>
====

=== [[isEmpty]] `isEmpty` Method

[source, scala]
----
isEmpty: Boolean
----

`isEmpty` simply says whether there are any <<CachedData, CachedData>> entries in the <<cachedData, cachedData>> internal registry.

=== [[cacheQuery]] Caching Dataset -- `cacheQuery` Method

[source, scala]
----
cacheQuery(
  query: Dataset[_],
  tableName: Option[String] = None,
  storageLevel: StorageLevel = MEMORY_AND_DISK): Unit
----

`cacheQuery` adds the spark-sql-Dataset.md#logicalPlan[analyzed logical plan] of the input <<spark-sql-Dataset.md#, Dataset>> to the <<cachedData, cachedData>> internal registry of cached queries.

Internally, `cacheQuery` requests the `Dataset` for the spark-sql-Dataset.md#logicalPlan[analyzed logical plan] and creates a spark-sql-LogicalPlan-InMemoryRelation.md#apply[InMemoryRelation] with the following properties:

* spark-sql-properties.md#spark.sql.inMemoryColumnarStorage.compressed[spark.sql.inMemoryColumnarStorage.compressed] (enabled by default)

* spark-sql-properties.md#spark.sql.inMemoryColumnarStorage.batchSize[spark.sql.inMemoryColumnarStorage.batchSize] (default: `10000`)

* Input `storageLevel` storage level (default: `MEMORY_AND_DISK`)

* [Optimized physical query plan](QueryExecution.md#executedPlan) (after requesting `SessionState` to [execute](SessionState.md#executePlan) the analyzed logical plan)

* Input `tableName`

* spark-sql-LogicalPlanStats.md#stats[Statistics] of the analyzed query plan

`cacheQuery` then creates a <<CachedData, CachedData>> (for the analyzed query plan and the `InMemoryRelation`) and adds it to the <<cachedData, cachedData>> internal registry.

If the input `query` <<lookupCachedData, has already been cached>>, `cacheQuery` simply prints the following WARN message to the logs and exits (i.e. does nothing but prints out the WARN message):

```
Asked to cache already cached data.
```

[NOTE]
====
`cacheQuery` is used when:

* <<spark-sql-dataset-operators.md#persist, Dataset.persist>> basic action is used

* `CatalogImpl` is requested to <<spark-sql-CatalogImpl.md#cacheTable, cache>> and <<spark-sql-CatalogImpl.md#refreshTable, refresh>> a table or view in-memory
====

=== [[clearCache]] Removing All Cached Logical Plans -- `clearCache` Method

[source, scala]
----
clearCache(): Unit
----

`clearCache` takes every `CachedData` from the <<cachedData, cachedData>> internal registry and requests it for the <<cachedRepresentation, InMemoryRelation>> to access the <<spark-sql-LogicalPlan-InMemoryRelation.md#cacheBuilder, CachedRDDBuilder>>. `clearCache` requests the `CachedRDDBuilder` to <<spark-sql-CachedRDDBuilder.md#clearCache, clearCache>>.

In the end, `clearCache` removes all `CachedData` entries from the <<cachedData, cachedData>> internal registry.

NOTE: `clearCache` is used exclusively when `CatalogImpl` is requested to <<spark-sql-CatalogImpl.md#clearCache, clear the cache>>.

=== [[recacheByCondition]] Re-Caching Structured Query -- `recacheByCondition` Internal Method

[source, scala]
----
recacheByCondition(spark: SparkSession, condition: LogicalPlan => Boolean): Unit
----

`recacheByCondition`...FIXME

NOTE: `recacheByCondition` is used when `CacheManager` is requested to <<uncacheQuery, uncache a structured query>>, <<recacheByPlan, recacheByPlan>>, and <<recacheByPath, recacheByPath>>.

=== [[recacheByPlan]] `recacheByPlan` Method

[source, scala]
----
recacheByPlan(spark: SparkSession, plan: LogicalPlan): Unit
----

`recacheByPlan`...FIXME

NOTE: `recacheByPlan` is used exclusively when `InsertIntoDataSourceCommand` logical command is <<spark-sql-LogicalPlan-InsertIntoDataSourceCommand.md#run, executed>>.

=== [[recacheByPath]] `recacheByPath` Method

[source, scala]
----
recacheByPath(spark: SparkSession, resourcePath: String): Unit
----

`recacheByPath`...FIXME

NOTE: `recacheByPath` is used exclusively when `CatalogImpl` is requested to spark-sql-CatalogImpl.md#refreshByPath[refreshByPath].

=== [[useCachedData]] Replacing Segments of Logical Query Plan With Cached Data -- `useCachedData` Method

[source, scala]
----
useCachedData(plan: LogicalPlan): LogicalPlan
----

`useCachedData`...FIXME

`useCachedData` is used when `QueryExecution` is requested for a [cached logical query plan](QueryExecution.md#withCachedData).

=== [[lookupAndRefresh]] `lookupAndRefresh` Internal Method

[source, scala]
----
lookupAndRefresh(
  plan: LogicalPlan,
  fs: FileSystem,
  qualifiedPath: Path): Boolean
----

`lookupAndRefresh`...FIXME

NOTE: `lookupAndRefresh` is used exclusively when `CacheManager` is requested to <<recacheByPath, recacheByPath>>.
