# CacheManager

`CacheManager` is a registry of structured queries that are cached and supposed to be replaced with corresponding [InMemoryRelation](logical-operators/InMemoryRelation.md) logical operators as their cached representation (when `QueryExecution` is requested for a [logical query plan with cached data](QueryExecution.md#withCachedData)).

## Accessing CacheManager

`CacheManager` is shared across [SparkSession](SparkSession.md)s through [SharedState](SparkSession.md#sharedState).

```text
val spark: SparkSession = ...
spark.sharedState.cacheManager
```

## Dataset.cache and persist Operators

A structured query (as [Dataset](Dataset.md)) can be [cached](#cacheQuery) and registered with `CacheManager` using [Dataset.cache](spark-sql-caching-and-persistence.md#cache) or [Dataset.persist](spark-sql-caching-and-persistence.md#persist) high-level operators.

## <span id="cachedData"><span id="CachedData"> Cached Queries

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

## <span id="recacheByPath"> Re-Caching By Path

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

`recacheByPath` is used when:

* `CatalogImpl` is requested to [refreshByPath](CatalogImpl.md#refreshByPath)
* [InsertIntoHadoopFsRelationCommand](logical-operators/InsertIntoHadoopFsRelationCommand.md) command is executed

### <span id="lookupAndRefresh"> lookupAndRefresh

```scala
lookupAndRefresh(
  plan: LogicalPlan,
  fs: FileSystem,
  qualifiedPath: Path): Boolean
```

`lookupAndRefresh`...FIXME

### <span id="refreshFileIndexIfNecessary"> refreshFileIndexIfNecessary

```scala
refreshFileIndexIfNecessary(
  fileIndex: FileIndex,
  fs: FileSystem,
  qualifiedPath: Path): Boolean
```

`refreshFileIndexIfNecessary`...FIXME

`refreshFileIndexIfNecessary` is used when `CacheManager` is requested to [lookupAndRefresh](#lookupAndRefresh).

## <span id="lookupCachedData"> Looking Up CachedData

```scala
lookupCachedData(
  query: Dataset[_]): Option[CachedData]
lookupCachedData(
  plan: LogicalPlan): Option[CachedData]
```

`lookupCachedData`...FIXME

`lookupCachedData` is used when:

* [Dataset.storageLevel](spark-sql-dataset-operators.md#storageLevel) basic action is used
* `CatalogImpl` is requested to [isCached](CatalogImpl.md#isCached)
* `CacheManager` is requested to [cacheQuery](#cacheQuery) and [useCachedData](#useCachedData)

## <span id="uncacheQuery"> Un-caching Dataset

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

`uncacheQuery` is used when:

* [Dataset.unpersist](spark-sql-dataset-operators.md#unpersist) basic action is used
* `DropTableCommand` and [TruncateTableCommand](logical-operators/TruncateTableCommand.md) logical commands are executed
* `CatalogImpl` is requested to [uncache](CatalogImpl.md#uncacheTable) and [refresh](CatalogImpl.md#refreshTable) a table or view, [dropTempView](CatalogImpl.md#dropTempView) and [dropGlobalTempView](CatalogImpl.md#dropGlobalTempView)

## <span id="cacheQuery"> Caching Query

```scala
cacheQuery(
  query: Dataset[_],
  tableName: Option[String] = None,
  storageLevel: StorageLevel = MEMORY_AND_DISK): Unit
```

`cacheQuery` adds the [analyzed logical plan](Dataset.md#logicalPlan) of the input [Dataset](Dataset.md) to the [cachedData](#cachedData) internal registry of cached queries.

Internally, `cacheQuery` requests the `Dataset` for the [analyzed logical plan](Dataset.md#logicalPlan) and creates a [InMemoryRelation](logical-operators/InMemoryRelation.md) with the following:

* [spark.sql.inMemoryColumnarStorage.compressed](configuration-properties.md#spark.sql.inMemoryColumnarStorage.compressed) configuration property
* [spark.sql.inMemoryColumnarStorage.batchSize](configuration-properties.md#spark.sql.inMemoryColumnarStorage.batchSize) configuration property
* Input `storageLevel` storage level
* [Optimized physical query plan](QueryExecution.md#executedPlan) (after requesting `SessionState` to [execute](SessionState.md#executePlan) the analyzed logical plan)
* Input `tableName`
* [Statistics](logical-operators/LogicalPlanStats.md#stats) of the analyzed query plan

`cacheQuery` then creates a `CachedData` (for the analyzed query plan and the `InMemoryRelation`) and adds it to the [cachedData](#cachedData) internal registry.

If the input `query` [has already been cached](#lookupCachedData), `cacheQuery` simply prints out the following WARN message to the logs and exits (i.e. does nothing but prints out the WARN message):

```text
Asked to cache already cached data.
```

`cacheQuery` is used when:

* [Dataset.persist](spark-sql-dataset-operators.md#persist) basic action is used
* `CatalogImpl` is requested to [cache](CatalogImpl.md#cacheTable) and [refresh](CatalogImpl.md#refreshTable) a table or view in-memory

## <span id="clearCache"> Clearing Cache

```scala
clearCache(): Unit
```

`clearCache` takes every `CachedData` from the [cachedData](#cachedData) internal registry and requests it for the [InMemoryRelation](#cachedRepresentation) to access the [CachedRDDBuilder](logical-operators/InMemoryRelation.md#cacheBuilder). `clearCache` requests the `CachedRDDBuilder` to [clearCache](CachedRDDBuilder.md#clearCache).

In the end, `clearCache` removes all `CachedData` entries from the [cachedData](#cachedData) internal registry.

`clearCache` is used when `CatalogImpl` is requested to [clear the cache](CatalogImpl.md#clearCache).

## <span id="recacheByCondition"> Re-Caching Query

```scala
recacheByCondition(
  spark: SparkSession,
  condition: LogicalPlan => Boolean): Unit
```

`recacheByCondition`...FIXME

`recacheByCondition` is used when `CacheManager` is requested to [uncache a structured query](#uncacheQuery), [recacheByPlan](#recacheByPlan), and [recacheByPath](#recacheByPath).

## <span id="recacheByPlan"> Re-Caching By Logical Plan

```scala
recacheByPlan(
  spark: SparkSession,
  plan: LogicalPlan): Unit
```

`recacheByPlan`...FIXME

`recacheByPlan` is used when [InsertIntoDataSourceCommand](logical-operators/InsertIntoDataSourceCommand.md) logical command is executed.

## <span id="useCachedData"> Replacing Segments of Logical Query Plan With Cached Data

```scala
useCachedData(
  plan: LogicalPlan): LogicalPlan
```

`useCachedData` traverses the given [logical query plan](logical-operators/LogicalPlan.md) down (parent operators first, children later) and replaces them with [cached representation](#lookupCachedData) (i.e. [InMemoryRelation](logical-operators/InMemoryRelation.md)) if found. `useCachedData` does this operator substitution for [SubqueryExpression](expressions/SubqueryExpression.md) expressions, too.

`useCachedData` skips `IgnoreCachedData` commands (and leaves them unchanged).

`useCachedData` is used (recursively) when `QueryExecution` is requested for a [logical query plan with cached data](QueryExecution.md#withCachedData).

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.CacheManager` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.CacheManager=ALL
```

Refer to [Logging](spark-logging.md).
