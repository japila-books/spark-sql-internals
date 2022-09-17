# WriteToDataSourceV2 Logical Operator

`WriteToDataSourceV2` is a [unary logical operator](LogicalPlan.md#UnaryNode) that represents writing data in Spark Structured Streaming (using [WriteToMicroBatchDataSource]({{ book.structured_streaming }}/logical-operators/WriteToMicroBatchDataSource) unary logical operator).

!!! note "Deprecated"
    `WriteToDataSourceV2` is deprecated since Spark SQL 2.4.0 (in favour of [AppendData](AppendData.md) logical operator).

## Creating Instance

`WriteToDataSourceV2` takes the following to be created:

* <span id="relation"> [DataSourceV2Relation](DataSourceV2Relation.md)
* <span id="batchWrite"> [BatchWrite](../connector/BatchWrite.md)
* <span id="query"> Query [LogicalPlan](LogicalPlan.md)
* <span id="customMetrics"> Write [CustomMetric](../connector/CustomMetric.md)s

`WriteToDataSourceV2` is created when:

* [V2Writes](../logical-optimizations/V2Writes.md) logical optimization is requested to optimize a logical query (with a `WriteToMicroBatchDataSource` unary logical operator)

## Query Planning

`WriteToDataSourceV2` is planned as [WriteToDataSourceV2Exec](../physical-operators/WriteToDataSourceV2Exec.md) physical operator by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy.
