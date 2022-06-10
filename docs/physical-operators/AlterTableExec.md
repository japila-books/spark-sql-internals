# AlterTableExec

`AlterTableExec` is a [V2CommandExec](V2CommandExec.md) leaf physical command to represent [AlterTableCommand](../logical-operators/AlterTableCommand.md) logical operator at execution.

## Creating Instance

`AlterTableExec` takes the following to be created:

* <span id="catalog"> [TableCatalog](../connector/catalog/TableCatalog.md)
* <span id="ident"> Table Identifier
* <span id="changes"> [TableChange](../connector/catalog/TableChange.md)s

`AlterTableExec` is created when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (to plan an [AlterTableCommand](../logical-operators/AlterTableCommand.md) logical operator)

## <span id="run"> Executing Command

```scala
run(): Seq[InternalRow]
```

`run` is part of the [V2CommandExec](V2CommandExec.md#run) abstraction.

---

`run` requests the [TableCatalog](#catalog) to [alter a table](../connector/catalog/TableCatalog.md#alterTable) (with the [identifier](#ident) and [TableChanges](#changes)).
