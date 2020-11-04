# WriteToDataSourceV2 Logical Operator

`WriteToDataSourceV2` is a [logical operator](LogicalPlan.md) that represents writing data to a [DataSourceV2](../spark-sql-DataSourceV2.md) data source in the [DataSource V2](../new-and-noteworthy/datasource-v2.md).

NOTE: `WriteToDataSourceV2` is deprecated for <<spark-sql-LogicalPlan-AppendData.md#, AppendData>> logical operator since Spark SQL 2.4.0.

`WriteToDataSourceV2` is <<creating-instance, created>> when:

* `DataFrameWriter` is requested to [save a DataFrame to a data source](../DataFrameWriter.md#save) (that is a [DataSourceV2](../spark-sql-DataSourceV2.md) data source with [WriteSupport](../spark-sql-WriteSupport.md))

* Spark Structured Streaming's `MicroBatchExecution` is requested to run a streaming batch (with a streaming sink with `StreamWriteSupport`)

[[creating-instance]]
`WriteToDataSourceV2` takes the following to be created:

* [[writer]] <<spark-sql-DataSourceWriter.md#, DataSourceWriter>>
* [[query]] Child <<spark-sql-LogicalPlan.md#, logical plan>>

[[children]]
When requested for the [child operators](../catalyst/TreeNode.md#children), `WriteToDataSourceV2` gives the one <<query, child logical plan>>.

[[output]]
When requested for the <<catalyst/QueryPlan.md#output, output attributes>>, `WriteToDataSourceV2` gives no attributes (an empty collection).

`WriteToDataSourceV2` is planned (_translated_) to a <<spark-sql-SparkPlan-WriteToDataSourceV2Exec.md#, WriteToDataSourceV2Exec>> physical operator (when <<execution-planning-strategies/DataSourceV2Strategy.mdadoc#, DataSourceV2Strategy>> execution planning strategy is requested to <<execution-planning-strategies/DataSourceV2Strategy.mdadoc#apply-WriteToDataSourceV2, plan a logical query>>).
