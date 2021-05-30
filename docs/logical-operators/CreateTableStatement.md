# CreateTableStatement

`CreateTableStatement` is a [ParsedStatement](ParsedStatement.md).

## Creating Instance

`CreateTableStatement` takes the following to be created:

* <span id="tableName"> Multi-Part Table Name
* <span id="tableSchema"> Table [Schema](../types/StructType.md)
* <span id="partitioning"> Partitioning [Transform](../connector/Transform.md)s
* <span id="bucketSpec"> [BucketSpec](../BucketSpec.md) (optional)
* <span id="properties"> Properties
* <span id="provider"> Provider (optional)
* <span id="options"> Options
* <span id="location"> Location (optional)
* <span id="comment"> Comment (optional)
* <span id="serde"> `SerdeInfo` (optional)
* <span id="external"> `external` flag
* <span id="ifNotExists"> `ifNotExists` flag

`CreateTableStatement` is created when:

* `AstBuilder` is requested to [parse CREATE TABLE statement](../sql/AstBuilder.md#visitCreateTable)

## Logical Analysis

`CreateTableStatement` is resolved to the following logical operators:

* [CreateV2Table](CreateV2Table.md) logical command (by [ResolveCatalogs](../logical-analysis-rules/ResolveCatalogs.md) logical resolution rule)
* [CreateTable](CreateTable.md) or [CreateTableAsSelect](CreateTableAsSelect.md) logical commands (by [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule)
