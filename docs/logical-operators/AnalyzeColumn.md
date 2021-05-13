# AnalyzeColumn

`AnalyzeColumn` is a [Command](Command.md) for [ANALYZE TABLE FOR COLUMNS](../sql/AstBuilder.md#visitAnalyze) SQL statement.

## Creating Instance

`AnalyzeColumn` takes the following to be created:

* <span id="child"> Child [Logical Operator](LogicalPlan.md)
* <span id="columnNames"> Column Names (optional)
* <span id="allColumns"> `allColumns` Flag

`AnalyzeColumn` requires that either the [column names](#columnNames) or [allColumns](#allColumns) flag is defined (as mutually exclusive).

`AnalyzeColumn` is created when:

* `AstBuilder` is requested to [parse ANALYZE TABLE FOR COLUMNS statement](../sql/AstBuilder.md#visitAnalyze)

## Logical Analysis

`AnalyzeColumn` is resolved to [AnalyzeColumnCommand](AnalyzeColumnCommand.md) logical command (by [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule).

## Query Planning

[DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) throws an `AnalysisException` for `AnalyzeColumn`s over `ResolvedTable`s:

```text
ANALYZE TABLE is not supported for v2 tables.
```
