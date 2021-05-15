# CreateTableAsSelectStatement

`CreateTableAsSelectStatement` is a [ParsedStatement](ParsedStatement.md).

## Creating Instance

`CreateTableAsSelectStatement` takes the following to be created:

* <span id="tableName"> Table Name
* <span id="asSelect"> [LogicalPlan](LogicalPlan.md)
* <span id="partitioning"> Partitioning [Transform](../connector/Transform.md)s
* <span id="bucketSpec"> [BucketSpec](../BucketSpec.md) (optional)
* <span id="properties"> Properties
* <span id="provider"> Provider (optional)
* <span id="options"> Options
* <span id="location"> Location (optional)
* <span id="comment"> Comment (optional)
* <span id="writeOptions"> Write Options
* <span id="serde"> `SerdeInfo` (optional)
* <span id="external"> `external` flag
* <span id="ifNotExists"> `ifNotExists` flag

`CreateTableAsSelectStatement` is created when:

* `AstBuilder` is requested to [parse CREATE TABLE AS SELECT statement](../sql/AstBuilder.md#visitCreateTable)
* `DataFrameWriter` is requested to [saveAsTable](../DataFrameWriter.md#saveAsTable)
* `DataFrameWriterV2` is requested to [create](../DataFrameWriterV2.md#create)

## Logical Analysis

`CreateTableAsSelectStatement` is resolved to the following logical operators:

* [CreateTableAsSelect](CreateTableAsSelect.md) logical command (by [ResolveCatalogs](../logical-analysis-rules/ResolveCatalogs.md) logical resolution rule).
* [CreateTable](CreateTable.md) or [CreateTableAsSelect](CreateTableAsSelect.md) logical commands (by [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule)
