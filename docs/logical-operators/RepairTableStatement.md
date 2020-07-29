# RepairTableStatement Parsed Statement

`RepairTableStatement` is a [ParsedStatement](ParsedStatement.md) that represents [MSCK REPAIR TABLE](../sql/AstBuilder.md#visitRepairTable) SQL statement.

!!! info
    `RepairTableStatement` is resolved to [AlterTableRecoverPartitionsCommand](AlterTableRecoverPartitionsCommand.md) logical command when [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical analyzer rule is executed.

## Creating Instance

`RepairTableStatement` takes the following to be created:

* <span id="tableName"> Table Name

`RepairTableStatement` is created when `AstBuilder` is requested to [visitRepairTable](../sql/AstBuilder.md#visitRepairTable).
