# CacheManager

`CacheManager` is a registry of logical query plans that are cached and supposed to be replaced with corresponding [InMemoryRelation](logical-operators/InMemoryRelation.md) logical operators as their cached representation (when `QueryExecution` is requested for a [logical query plan with cached data](QueryExecution.md#withCachedData)).

## Accessing CacheManager

`CacheManager` is shared across [SparkSession](SparkSession.md)s through [SharedState](SparkSession.md#sharedState).

```scala
spark.sharedState.cacheManager
```

## Dataset.cache and persist Operators

A structured query (as [Dataset](dataset/index.md)) can be [cached](#cacheQuery) and registered with `CacheManager` using [Dataset.cache](caching-and-persistence.md#cache) or [Dataset.persist](caching-and-persistence.md#persist) high-level operators.

## <span id="CachedData"> Cached Queries { #cachedData }

```scala
cachedData: LinkedList[CachedData]
```

`CacheManager` uses the `cachedData` internal registry to manage cached structured queries as `CachedData` with [InMemoryRelation](logical-operators/InMemoryRelation.md) leaf logical operators.

A new `CachedData` is added when `CacheManager` is requested to:

* [cacheQuery](#cacheQuery)
* [recacheByCondition](#recacheByCondition)

A `CachedData` is removed when `CacheManager` is requested to:

* [uncacheQuery](#uncacheQuery)
* [recacheByCondition](#recacheByCondition)

All `CachedData` are removed (cleared) when `CacheManager` is requested to [clearCache](#clearCache)

## Re-Caching By Path { #recacheByPath }

```scala
recacheByPath(
  spark: SparkSession,
  resourcePath: String): Unit
recacheByPath(
  spark: SparkSession,
  resourcePath: Path,
  fs: FileSystem): Unit
```

`recacheByPath`...FIXME

---

`recacheByPath` is used when:

* `CatalogImpl` is requested to [refreshByPath](CatalogImpl.md#refreshByPath)
* [InsertIntoHadoopFsRelationCommand](logical-operators/InsertIntoHadoopFsRelationCommand.md) command is executed

### lookupAndRefresh { #lookupAndRefresh }

```scala
lookupAndRefresh(
  plan: LogicalPlan,
  fs: FileSystem,
  qualifiedPath: Path): Boolean
```

`lookupAndRefresh`...FIXME

### refreshFileIndexIfNecessary { #refreshFileIndexIfNecessary }

```scala
refreshFileIndexIfNecessary(
  fileIndex: FileIndex,
  fs: FileSystem,
  qualifiedPath: Path): Boolean
```

`refreshFileIndexIfNecessary`...FIXME

## Looking Up CachedData { #lookupCachedData }

```scala
lookupCachedData(
  query: Dataset[_]): Option[CachedData]
lookupCachedData(
  plan: LogicalPlan): Option[CachedData]
```

`lookupCachedData`...FIXME

---

`lookupCachedData` is used when:

* [Dataset.storageLevel](dataset/index.md#storageLevel) action is used
* `CatalogImpl` is requested to [isCached](CatalogImpl.md#isCached)
* `CacheManager` is requested to [cacheQuery](#cacheQuery) and [useCachedData](#useCachedData)

## Un-caching Dataset { #uncacheQuery }

```scala
uncacheQuery(
  query: Dataset[_],
  cascade: Boolean,
  blocking: Boolean = true): Unit
uncacheQuery(
  spark: SparkSession,
  plan: LogicalPlan,
  cascade: Boolean,
  blocking: Boolean): Unit
```

`uncacheQuery`...FIXME

---

`uncacheQuery` is used when:

* [Dataset.unpersist](dataset/index.md#unpersist) basic action is used
* `DropTableCommand` and [TruncateTableCommand](logical-operators/TruncateTableCommand.md) logical commands are executed
* `CatalogImpl` is requested to [uncache](CatalogImpl.md#uncacheTable) and [refresh](CatalogImpl.md#refreshTable) a table or view, [dropTempView](CatalogImpl.md#dropTempView) and [dropGlobalTempView](CatalogImpl.md#dropGlobalTempView)

## Caching Query { #cacheQuery }

```scala
cacheQuery(
  query: Dataset[_],
  tableName: Option[String] = None,
  storageLevel: StorageLevel = MEMORY_AND_DISK): Unit
```

`cacheQuery` adds the [analyzed logical plan](dataset/index.md#logicalPlan) of the input [Dataset](dataset/index.md) to the [cachedData](#cachedData) internal registry of cached queries.

Internally, `cacheQuery` requests the `Dataset` for the [analyzed logical plan](dataset/index.md#logicalPlan) and creates a [InMemoryRelation](logical-operators/InMemoryRelation.md) with the following:

* [spark.sql.inMemoryColumnarStorage.compressed](configuration-properties.md#spark.sql.inMemoryColumnarStorage.compressed) configuration property
* [spark.sql.inMemoryColumnarStorage.batchSize](configuration-properties.md#spark.sql.inMemoryColumnarStorage.batchSize) configuration property
* Input `storageLevel` storage level
* [Optimized physical query plan](QueryExecution.md#executedPlan) (after requesting `SessionState` to [execute](SessionState.md#executePlan) the analyzed logical plan)
* Input `tableName`
* [Statistics](cost-based-optimization/LogicalPlanStats.md#stats) of the analyzed query plan

`cacheQuery` then creates a `CachedData` (for the analyzed query plan and the `InMemoryRelation`) and adds it to the [cachedData](#cachedData) internal registry.

If the input `query` [has already been cached](#lookupCachedData), `cacheQuery` simply prints out the following WARN message to the logs and exits (i.e. does nothing but prints out the WARN message):

```text
Asked to cache already cached data.
```

---

`cacheQuery` is used when:

* [Dataset.persist](dataset/index.md#persist) basic action is used
* `CatalogImpl` is requested to [cache](CatalogImpl.md#cacheTable) and [refresh](CatalogImpl.md#refreshTable) a table or view in-memory

## Clearing Cache { #clearCache }

```scala
clearCache(): Unit
```

`clearCache` takes every `CachedData` from the [cachedData](#cachedData) internal registry and requests it for the [InMemoryRelation](#cachedRepresentation) to access the [CachedRDDBuilder](logical-operators/InMemoryRelation.md#cacheBuilder). `clearCache` requests the `CachedRDDBuilder` to [clearCache](cache-serialization/CachedRDDBuilder.md#clearCache).

In the end, `clearCache` removes all `CachedData` entries from the [cachedData](#cachedData) internal registry.

---

`clearCache` is used when:

* `CatalogImpl` is requested to [clear the cache](CatalogImpl.md#clearCache)

## Re-Caching Query { #recacheByCondition }

```scala
recacheByCondition(
  spark: SparkSession,
  condition: LogicalPlan => Boolean): Unit
```

`recacheByCondition`...FIXME

---

`recacheByCondition` is used when:

* `CacheManager` is requested to [uncache a structured query](#uncacheQuery), [recacheByPlan](#recacheByPlan), and [recacheByPath](#recacheByPath)

## Re-Caching By Logical Plan { #recacheByPlan }

```scala
recacheByPlan(
  spark: SparkSession,
  plan: LogicalPlan): Unit
```

`recacheByPlan`...FIXME

---

`recacheByPlan` is used when:

* [InsertIntoDataSourceCommand](logical-operators/InsertIntoDataSourceCommand.md) logical command is executed

## Replacing Segments of Logical Query Plan With Cached Data { #useCachedData }

```scala
useCachedData(
  plan: LogicalPlan): LogicalPlan
```

`useCachedData` traverses the given [logical query plan](logical-operators/LogicalPlan.md) down (parent operators first, children later) and replaces them with [cached representation](#lookupCachedData) (i.e. [InMemoryRelation](logical-operators/InMemoryRelation.md)) if found. `useCachedData` does this operator substitution for [SubqueryExpression](expressions/SubqueryExpression.md) expressions, too.

`useCachedData` skips [IgnoreCachedData](logical-operators/IgnoreCachedData.md) commands (and leaves them unchanged).

---

`useCachedData` is used (recursively) when:

* `QueryExecution` is requested for a [logical query plan with cached data](QueryExecution.md#withCachedData)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.CacheManager` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.CacheManager=ALL
```

Refer to [Logging](spark-logging.md).
