# TruncateTableExec Physical Operator

`TruncateTableExec` is a `LeafV2CommandExec` physical operator that represents the following logical operators at execution:

* [DeleteFromTable](../logical-operators/DeleteFromTable.md) logical operator with a [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) over a [TruncatableTable](../connector/TruncatableTable.md) table with no `WHERE` clause
* `TruncateTable`

## Creating Instance

`TruncateTableExec` takes the following to be created:

* <span id="table"> [TruncatableTable](../connector/TruncatableTable.md)
* <span id="refreshCache"> Refresh Cache Procedure (`() => Unit`)

`TruncateTableExec` is created when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed

## <span id="output"> Output Schema

??? note "Signature"

    ```scala
    output: Seq[Attribute]
    ```

    `output` is part of the [QueryPlan](../catalyst/QueryPlan.md#output) abstraction.

`output` is empty.

## <span id="run"> run

??? note "Signature"

    ```scala
    run(): Seq[InternalRow]
    ```

    `run` is part of the [V2CommandExec](V2CommandExec.md#run) abstraction.

`run` requests the [TruncatableTable](#table) to [truncateTable](../connector/TruncatableTable.md#truncateTable) followed by executing the [refreshCache](#refreshCache) procedure.
