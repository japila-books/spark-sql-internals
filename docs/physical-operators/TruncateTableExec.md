---
title: TruncateTableExec
---

# TruncateTableExec Physical Operator

`TruncateTableExec` is a `LeafV2CommandExec` physical operator that represents the following logical operators at execution:

* [DeleteFromTable](../logical-operators/DeleteFromTable.md) logical operator with a [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) over a [TruncatableTable](../connector/TruncatableTable.md) table with no `WHERE` clause
* `TRUNCATE TABLE` SQL command (with no `PARTITION` clause)

## Creating Instance

`TruncateTableExec` takes the following to be created:

* <span id="table"> [TruncatableTable](../connector/TruncatableTable.md)
* <span id="refreshCache"> Refresh Cache Procedure (`() => Unit`)

`TruncateTableExec` is created when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed

## Output Schema { #output }

??? note "QueryPlan"

    ```scala
    output: Seq[Attribute]
    ```

    `output` is part of the [QueryPlan](../catalyst/QueryPlan.md#output) abstraction.

`output` is empty.

## Executing Command { #run }

??? note "V2CommandExec"

    ```scala
    run(): Seq[InternalRow]
    ```

    `run` is part of the [V2CommandExec](V2CommandExec.md#run) abstraction.

`run` requests the [TruncatableTable](#table) to [truncateTable](../connector/TruncatableTable.md#truncateTable). Only if successful, `run` executes this [refreshCache](#refreshCache) procedure.

`run` returns an empty collection.
