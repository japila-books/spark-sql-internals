# AnalyzeTablesCommand Logical Command

`AnalyzeTablesCommand` is a [LeafRunnableCommand](LeafRunnableCommand.md) that represents `ANALYZE TABLES COMPUTE STATISTICS` SQL statement (`AnalyzeTables` logical command) at query execution.

## Creating Instance

`AnalyzeTablesCommand` takes the following to be created:

* <span id="databaseName"> Database Name
* <span id="noScan"> `noScan` flag

`AnalyzeTablesCommand` is created when:

* [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) analysis rule is executed (and resolves an `AnalyzeTables` logical command for `ANALYZE TABLES COMPUTE STATISTICS` SQL statement)
