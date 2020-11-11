# InsertIntoStatement

`InsertIntoStatement` is a [ParsedStatement](ParsedStatement.md).

## Creating Instance

`InsertIntoStatement` takes the following to be created:

* <span id="table"> [Logical Query Plan](LogicalPlan.md)
* <span id="partitionSpec"> Partition Specification
* <span id="query"> [Query](LogicalPlan.md)
* <span id="overwrite"> `overwrite` flag
* <span id="ifPartitionNotExists"> `ifPartitionNotExists` flag

`InsertIntoStatement` is created when:

* Catalyst DSL (`DslLogicalPlan`) is used to [insertInto](../spark-sql-catalyst-dsl.md#insertInto)
* `AstBuilder` is requested to [withInsertInto](../sql/AstBuilder.md#withInsertInto)
* `DataFrameWriter` is requested to [insertInto](../DataFrameWriter.md#insertInto)
