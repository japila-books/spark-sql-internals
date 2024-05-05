---
title: CacheTableAsSelectExec
---

# CacheTableAsSelectExec Physical Operator

`CacheTableAsSelectExec` is a [BaseCacheTableExec](BaseCacheTableExec.md) physical operator that represents a `CacheTableAsSelect` logical operator at execution.

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

`relationName` is the [name of the temporary view](#tempViewName).

## planToCache { #planToCache }

??? note "BaseCacheTableExec"

    ```scala
    planToCache: LogicalPlan
    ```

    `planToCache` is part of the [BaseCacheTableExec](BaseCacheTableExec.md#planToCache) abstraction.

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
    dataFrameForCachedPlan: LogicalPlan
    ```

    `dataFrameForCachedPlan` is part of the [BaseCacheTableExec](BaseCacheTableExec.md#dataFrameForCachedPlan) abstraction.

`dataFrameForCachedPlan` uses [SparkSession.table](../SparkSession.md#table) operator to load data from the [temporary view](#tempViewName).
