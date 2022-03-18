# AddColumns Logical Operator

`AddColumns` is an `AlterTableCommand` logical operator that represents [ALTER TABLE ADD COLUMNS](../sql/AstBuilder.md#visitAddTableColumns) SQL statement (in a logical query plan).

## Creating Instance

`AddColumns` takes the following to be created:

* <span id="table"> Table ([LogicalPlan](LogicalPlan.md))
* <span id="columnsToAdd"> Columns to Add

`AddColumns` is created when:

* `AstBuilder` is requested to [parse ALTER TABLE ADD COLUMNS statement](../sql/AstBuilder.md#visitAddTableColumns)

## <span id="AlterTableAddColumnsCommand"> AlterTableAddColumnsCommand

`AddColumns` is resolved to a [AlterTableAddColumnsCommand](AlterTableAddColumnsCommand.md) logical runnable command by [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule.
