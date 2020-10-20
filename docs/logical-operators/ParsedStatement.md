# ParsedStatement Logical Operators

`ParsedStatement` is an extension of the [LogicalPlan](LogicalPlan.md) abstraction for [logical operators](#implementations) that hold exactly what was parsed from SQL statements.

`ParsedStatement` are never resolved and must be converted to concrete logical plans.

## Implementations

* AlterTableAddColumnsStatement
* AlterTableAddPartitionStatement
* AlterTableAlterColumnStatement
* AlterTableDropColumnsStatement
* AlterTableDropPartitionStatement
* [AlterTableRecoverPartitionsStatement](AlterTableRecoverPartitionsStatement.md)
* AlterTableRenameColumnStatement
* AlterTableRenamePartitionStatement
* AlterTableSerDePropertiesStatement
* AlterTableSetLocationStatement
* AlterTableSetPropertiesStatement
* AlterTableUnsetPropertiesStatement
* AlterViewAsStatement
* AlterViewSetPropertiesStatement
* AlterViewUnsetPropertiesStatement
* [AnalyzeColumnStatement](AnalyzeColumnStatement.md)
* AnalyzeTableStatement
* CacheTableStatement
* CreateFunctionStatement
* CreateNamespaceStatement
* CreateTableAsSelectStatement
* CreateTableStatement
* CreateViewStatement
* DescribeColumnStatement
* DescribeFunctionStatement
* DropFunctionStatement
* DropTableStatement
* DropViewStatement
* InsertIntoStatement
* LoadDataStatement
* RefreshTableStatement
* RenameTableStatement
* [RepairTableStatement](RepairTableStatement.md)
* ReplaceTableAsSelectStatement
* ReplaceTableStatement
* ShowColumnsStatement
* ShowCreateTableStatement
* [ShowCurrentNamespaceStatement](ShowCurrentNamespaceStatement.md)
* ShowFunctionsStatement
* ShowPartitionsStatement
* ShowTableStatement
* TruncateTableStatement
* UncacheTableStatement
* [UseStatement](UseStatement.md)
