---
title: BaseCacheTableExec
---

# BaseCacheTableExec Physical Operators

`BaseCacheTableExec` is an [extension](#contract) of the `LeafV2CommandExec` abstraction for [physical operators](#implementations) that can [cache a query plan](#run).

## Contract (Subset)

### Relation Name { #relationName }

```scala
relationName: String
```

The name of the table to cache

See:

* [CacheTableAsSelectExec](CacheTableAsSelectExec.md#relationName)

### planToCache { #planToCache }

```scala
planToCache: LogicalPlan
```

See:

* [CacheTableAsSelectExec](CacheTableAsSelectExec.md#planToCache)

## Implementations

* [CacheTableAsSelectExec](CacheTableAsSelectExec.md)
* [CacheTableExec](CacheTableExec.md)

## Executing Command { #run }

??? note "V2CommandExec"

    ```scala
    run(): Seq[InternalRow]
    ```

    `run` is part of the [V2CommandExec](V2CommandExec.md#run) abstraction.

`run` requests the [CacheManager](../SharedState.md#cacheManager) (of the [SharedState](../SparkSession.md#sharedState)) to [cache](../CacheManager.md#cacheQuery) this [logical query plan](#planToCache).

Unless [isLazy](#isLazy), `run` performs eager caching (using [Dataset.count](../dataset/index.md#count) action).

In the end, `run` returns an empty collection.
