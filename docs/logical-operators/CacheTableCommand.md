---
title: CacheTableCommand
---

# CacheTableCommand Runnable Logical Command

When <<run, executed>>, `CacheTableCommand` [creates a DataFrame](../Dataset.md#ofRows) followed by [registering a temporary view](../dataset-operators.md#createTempView) for the optional `query`.

```text
CACHE LAZY? TABLE [table] (AS? [query])?
```

`CacheTableCommand` requests the session-specific `Catalog` to [cache the table](../Catalog.md#cacheTable).

!!! note
    `CacheTableCommand` uses `SparkSession` [to access the `Catalog`](../SparkSession.md#catalog).

If the caching is not `LAZY` (which is not by default), `CacheTableCommand` [creates a DataFrame for the table](../SparkSession.md#table) and [counts the rows](../dataset-operators.md#count) (that will trigger the caching).

!!! note
    `CacheTableCommand` uses a Spark SQL pattern to trigger DataFrame caching by executing `count` operation.

```text
val q = "CACHE TABLE ids AS SELECT * from range(5)"
scala> println(sql(q).queryExecution.logical.numberedTreeString)
00 CacheTableCommand `ids`, false
01    +- 'Project [*]
02       +- 'UnresolvedTableValuedFunction range, [5]

// ids table is already cached but let's use it anyway (and see what happens)
val q2 = "CACHE LAZY TABLE ids"
scala> println(sql(q2).queryExecution.logical.numberedTreeString)
17/05/17 06:16:39 WARN CacheManager: Asked to cache already cached data.
00 CacheTableCommand `ids`, true
```
