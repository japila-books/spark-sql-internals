# AnalyzeColumnStatement

`AnalyzeColumnStatement` is a [ParsedStatement](ParsedStatement.md) for [ANALYZE TABLE](../sql/AstBuilder.md#visitAnalyze) SQL statement.

`AnalyzeColumnStatement` is resolved to [AnalyzeColumnCommand](AnalyzeColumnCommand.md) logical command (by [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule).

## Creating Instance

`AnalyzeColumnStatement` takes the following to be created:

* <span id="tableName"> Table Name (`Seq[String]`)
* <span id="columnNames"> Column Names (optional)
* <span id="allColumns"> `allColumns` Flag

`AnalyzeColumnStatement` requires that either [columnNames](#columnNames) or [allColumns](#allColumns) to be defined (as mutually exclusive).

`AnalyzeColumnStatement` is created when `AstBuilder` is requested to [parse ANALYZE TABLE statement](../sql/AstBuilder.md#visitAnalyze)
