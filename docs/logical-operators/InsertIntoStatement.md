# InsertIntoStatement

`InsertIntoStatement` is a [UnaryParsedStatement](ParsedStatement.md).

## Creating Instance

`InsertIntoStatement` takes the following to be created:

* <span id="table"> Table ([LogicalPlan](LogicalPlan.md))
* <span id="partitionSpec"> Partition Specification (`Map[String, Option[String]]`)
* <span id="userSpecifiedCols"> User-specified column names
* <span id="query"> [Query](LogicalPlan.md)
* <span id="overwrite"> `overwrite` flag
* <span id="ifPartitionNotExists"> `ifPartitionNotExists` flag

`InsertIntoStatement` is created when:

* Catalyst DSL is used to [insertInto](../catalyst-dsl/index.md#insertInto)
* `AstBuilder` is requested to [withInsertInto](../sql/AstBuilder.md#withInsertInto)
* `DataFrameWriter` is requested to [insertInto](../DataFrameWriter.md#insertInto)

## Logical Resolution

`InsertIntoStatement` is resolved to the following logical operators:

* [InsertIntoDataSourceCommand](InsertIntoDataSourceCommand.md) (for `InsertIntoStatement`s over [LogicalRelation](LogicalRelation.md) over [InsertableRelation](../InsertableRelation.md)) by [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md)
* [InsertIntoHadoopFsRelationCommand](InsertIntoHadoopFsRelationCommand.md) (for `InsertIntoStatement`s over [LogicalRelation](LogicalRelation.md) over [HadoopFsRelation](../InsertableRelation.md)) by [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md)

## Logical Analysis

`InsertIntoStatement`s with `UnresolvedCatalogRelation`s are resolved by the following logical analysis rules:

* [FindDataSourceTable](../logical-analysis-rules/FindDataSourceTable.md)
* `FallBackFileSourceV2`
* `PreprocessTableInsertion`
* [PreWriteCheck](../logical-analysis-rules/PreWriteCheck.md)
