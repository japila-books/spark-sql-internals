---
title: CacheTableAsSelectExec
---

# CacheTableAsSelectExec Physical Operator

`CacheTableAsSelectExec` is a [BaseCacheTableExec](BaseCacheTableExec.md) physical operator that represents `CACHE TABLE` SQL command (as a `CacheTableAsSelect` logical operator) at execution.

```sql
CACHE [LAZY] TABLE identifierReference
  [OPTIONS key=value (, key=value)*]
  [[AS] query]
```

When [executed](BaseCacheTableExec.md#run), `CacheTableAsSelectExec` uses [CreateViewCommand](../logical-operators/CreateViewCommand.md) logical operator followed by [SparkSession.table](../SparkSession.md#table) operator to create a [LogicalPlan to cache](#planToCache).

In other words, `CacheTableAsSelectExec` is a shorter version (_shortcut_) of executing [CREATE VIEW](../sql/SparkSqlAstBuilder.md#visitCreateView) SQL command (or the corresponding Dataset operators, e.g. [Dataset.createTempView](../dataset/index.md#createTempView)) followed by `CACHE TABLE` (that boils down to requesting the session-wide [CacheManager](../CacheManager.md) to [cache](../CacheManager.md#cacheQuery) this [LogicalPlan to cache](#planToCache)).

## Creating Instance

`CacheTableAsSelectExec` takes the following to be created:

* <span id="tempViewName"> The name of the temporary view
* <span id="query"> The [LogicalPlan](../logical-operators/LogicalPlan.md) of the query
* <span id="originalText"> Original SQL Text
* <span id="isLazy"> `isLazy` flag
* <span id="options"> Options (`Map[String, String]`)
* <span id="referredTempFunctions"> Referred temporary functions (`Seq[String]`)

`CacheTableAsSelectExec` is created when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (to plan a `CacheTableAsSelect` logical operator)

## Relation Name { #relationName }

??? note "BaseCacheTableExec"

    ```scala
    relationName: String
    ```

    `relationName` is part of the [BaseCacheTableExec](BaseCacheTableExec.md#relationName) abstraction.

`relationName` is this [name of the temporary view](#tempViewName).

## LogicalPlan to Cache { #planToCache }

??? note "BaseCacheTableExec"

    ```scala
    planToCache: LogicalPlan
    ```

    `planToCache` is part of the [BaseCacheTableExec](BaseCacheTableExec.md#planToCache) abstraction.

??? note "Lazy Value"
    `planToCache` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`planToCache` creates a [CreateViewCommand](../logical-operators/CreateViewCommand.md) logical operator that is immediately [executed](../logical-operators/CreateViewCommand.md#run).

??? note "CreateViewCommand"
    CreateViewCommand | Value
    -|-
    [Table name](../logical-operators/CreateViewCommand.md#name) | this [name](#tempViewName)
    [Original Text](../logical-operators/CreateViewCommand.md#originalText) | this [original text](#originalText)
    [Logical query plan](../logical-operators/CreateViewCommand.md#plan) | this [query](#query)
    [ViewType](../logical-operators/CreateViewCommand.md#viewType) | `LocalTempView`

In the end, `planToCache` requests the [dataFrameForCachedPlan](#dataFrameForCachedPlan) for the [logical plan](../dataset/index.md#logicalPlan).

## dataFrameForCachedPlan { #dataFrameForCachedPlan }

??? note "BaseCacheTableExec"

    ```scala
    dataFrameForCachedPlan: DataFrame
    ```

    `dataFrameForCachedPlan` is part of the [BaseCacheTableExec](BaseCacheTableExec.md#dataFrameForCachedPlan) abstraction.

??? note "Lazy Value"
    `dataFrameForCachedPlan` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`dataFrameForCachedPlan` uses [SparkSession.table](../SparkSession.md#table) operator to create a [DataFrame](../DataFrame.md) that represents loading data from the [temporary view](#tempViewName).
