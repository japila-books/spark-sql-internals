---
title: CreateTableAsSelectExec
---

# CreateTableAsSelectExec Physical Command

`CreateTableAsSelectExec` is a [TableWriteExecHelper](TableWriteExecHelper.md) that represents [CreateTableAsSelect](../logical-operators/CreateTableAsSelect.md) logical operator at execution time.

## Creating Instance

`CreateTableAsSelectExec` takes the following to be created:

* <span id="catalog"> [TableCatalog](../connector/catalog/TableCatalog.md)
* <span id="ident"> `Identifier`
* <span id="partitioning"> Partitioning [Transform](../connector/Transform.md)s
* <span id="plan"> [LogicalPlan](../logical-operators/LogicalPlan.md)
* <span id="query"> [SparkPlan](SparkPlan.md)
* <span id="properties"> Properties
* <span id="writeOptions"> Case-Insensitive Write Options
* <span id="ifNotExists"> `ifNotExists` flag

`CreateTableAsSelectExec` is created when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (for [CreateTableAsSelect](../logical-operators/CreateTableAsSelect.md))

## <span id="run"> Executing Command

??? note "Signature"

    ```scala
    run(): Seq[InternalRow]
    ```

    `run` is part of the [V2CommandExec](V2CommandExec.md#run) abstraction.

`run`...FIXME
