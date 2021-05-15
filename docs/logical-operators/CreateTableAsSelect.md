# CreateTableAsSelect Logical Command

`CreateTableAsSelect` is a [Command](Command.md) with [V2CreateTablePlan](V2CreateTablePlan.md).

## Creating Instance

`CreateTableAsSelect` takes the following to be created:

* <span id="catalog"> [TableCatalog](../connector/catalog/TableCatalog.md)
* <span id="tableName"> `Identifier`
* <span id="partitioning"> Partitioning [Transform](../connector/Transform.md)s
* <span id="query"> [LogicalPlan](LogicalPlan.md)
* <span id="properties"> Properties
* <span id="writeOptions"> Case-Insensitive Write Options
* <span id="ignoreIfExists"> `ignoreIfExists` flag

`CreateTableAsSelect` is created when:

* [ResolveCatalogs](../logical-analysis-rules/ResolveCatalogs.md) logical resolution rule is executed (for [CreateTableAsSelectStatement](CreateTableAsSelectStatement.md))
* [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule is executed (for [CreateTableAsSelectStatement](CreateTableAsSelectStatement.md))
* `DataFrameWriter` is requested to [saveInternal](../DataFrameWriter.md#saveInternal)

## Query Execution Planning

`CreateTableAsSelect` is planned to [CreateTableAsSelectExec](../physical-operators/CreateTableAsSelectExec.md) physical command by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy.
