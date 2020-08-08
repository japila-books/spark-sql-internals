# ShowTablesExec Physical Command

`ShowTablesExec` is a [physical command](V2CommandExec.md) that represents a [ShowTables](../logical-operators/ShowTables.md) logical command at execution time.

`ShowTablesExec` is a [leaf physical operator](SparkPlan.md#LeafExecNode).

## Creating Instance

`ShowTablesExec` takes the following to be created:

* <span id="output"> Output [Attributes](../expressions/Attribute.md)
* <span id="catalog"> [TableCatalog](../connector/catalog/TableCatalog.md)
* <span id="namespace"> Multi-Part Namespace
* <span id="pattern"> Optional Pattern (of tables to show)

`ShowTablesExec` is created when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is requested to plan a [ShowTables](../logical-operators/ShowTables.md) logical command.

## <span id="run"> Executing Command

```scala
run(): Seq[InternalRow]
```

`run` requests the [TableCatalog](#catalog) to [listTables](../connector/catalog/TableCatalog.md#listTables) in the [namespace](#namespace).

`run` returns tables that match the [pattern](#pattern) if defined or all the tables available.

`run` is part of the [V2CommandExec](V2CommandExec.md#run) abstraction.
