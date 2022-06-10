# AlterTableCommand

`AlterTableCommand` is an [extension](#contract) of the [Command](Command.md) abstraction for [unary logical commands](#implementations) to alter a table.

## Contract

### <span id="changes"> TableChanges

```scala
changes: Seq[TableChange]
```

[TableChange](../connector/catalog/TableChange.md)s to apply to the [table](#table)

Used when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (to plan an `AlterTableCommand` to [AlterTableExec](../physical-operators/AlterTableExec.md))

### <span id="table"> Table

```scala
table: LogicalPlan
```

[LogicalPlan](LogicalPlan.md) of the table to alter

Used when:

* `ResolveAlterTableCommands` analysis rule is executed
* `AlterTableCommand` is requested for the [child](#child)
* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (to plan an `AlterTableCommand` to [AlterTableExec](../physical-operators/AlterTableExec.md))

## Implementations

* `AddColumns`
* `AlterColumn`
* `CommentOnTable`
* `DropColumns`
* [RenameColumn](#RenameColumn)
* `ReplaceColumns`
* `SetTableLocation`
* `SetTableProperties`
* `UnsetTableProperties`

### <span id="RenameColumn"> RenameColumn

AlterTableCommand | TableChange | SQL
------------------|-------------|----
 `RenameColumn`   | [RenameColumn](../connector/catalog/TableChange.md#RenameColumn) | [ALTER TABLE RENAME COLUMN](../sql/AstBuilder.md#visitRenameTableColumn)

## Execution Planning

`AlterTableCommand`s are planned as [AlterTableExec](../physical-operators/AlterTableExec.md)s (by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy).
