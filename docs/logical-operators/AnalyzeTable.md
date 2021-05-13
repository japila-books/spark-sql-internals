# AnalyzeTable

`AnalyzeTable` is a [Command](Command.md) for [ANALYZE TABLE](../sql/AstBuilder.md#visitAnalyze) SQL statement.

## Creating Instance

`AnalyzeTable` takes the following to be created:

* <span id="child"> Child [Logical Operator](LogicalPlan.md)
* <span id="partitionSpec"> Partitions
* <span id="noScan"> `noScan` Flag

`AnalyzeTable` is created when:

* `AstBuilder` is requested to [parse ANALYZE TABLE statement](../sql/AstBuilder.md#visitAnalyze)

## Logical Analysis

`AnalyzeTable` is resolved to the following logical runnable commands (by [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule):

* [AnalyzePartitionCommand](AnalyzePartitionCommand.md)
* [AnalyzeTableCommand](AnalyzeTableCommand.md) (with no [partitions](#partitionSpec))

## Query Planning

[DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) throws an `AnalysisException` for `AnalyzeTable`s over `ResolvedTable`s:

```text
ANALYZE TABLE is not supported for v2 tables.
```
