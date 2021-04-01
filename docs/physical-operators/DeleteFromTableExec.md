# DeleteFromTableExec

`DeleteFromTableExec` is a [V2CommandExec](V2CommandExec.md) for [DeleteFromTable](../logical-operators/DeleteFromTable.md) logical operators at execution.

## Creating Instance

`DeleteFromTableExec` takes the following to be created:

* <span id="table"> Table that [SupportsDelete](../connector/SupportsDelete.md)
* <span id="condition"> Condition [Filter](../Filter.md)s
* <span id="refreshCache"> Refresh Cache Function (`() => Unit`)

`DeleteFromTableExec` is created when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (and plans [DeleteFromTable](../logical-operators/DeleteFromTable.md) logical operators)

## <span id="run"> Executing Command

```scala
run(): Seq[InternalRow]
```

`run` is part of the [V2CommandExec](V2CommandExec.md#run) abstraction.

`run` requests the [table](#table) to [deleteWhere](../connector/SupportsDelete.md#deleteWhere) with the [condition](#condition).

In the end, `run` calls the [refresh cache function](#refreshCache).
