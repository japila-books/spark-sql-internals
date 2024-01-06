# ScanBuilder

`ScanBuilder` is an [abstraction](#contract) of [scan builders](#implementations).

## Contract

### <span id="build"> Building Scan

```scala
Scan build()
```

Builds a [Scan](Scan.md)

See:

* [ParquetScanBuilder](../parquet/ParquetScanBuilder.md#build)

Used when:

* `DataSourceV2Relation` logical operator is requested to [computeStats](../logical-operators/DataSourceV2Relation.md#computeStats)
* `DescribeColumnExec` physical command is executed
* `PushDownUtils` is requested to [pruneColumns](../PushDownUtils.md#pruneColumns)
* [V2ScanRelationPushDown](../logical-optimizations/V2ScanRelationPushDown.md) logical optimization is executed (to [buildScanWithPushedAggregate](../logical-optimizations/V2ScanRelationPushDown.md#buildScanWithPushedAggregate))
* `MicroBatchExecution` ([Spark Structured Streaming]({{ book.structured_streaming }}/micro-batch-execution/MicroBatchExecution)) is requested for the `logicalPlan`
* `ContinuousExecution` ([Spark Structured Streaming]({{ book.structured_streaming }}/continuous-execution/ContinuousExecution)) is requested for the `logicalPlan`

## Implementations

* [FileScanBuilder](../files/FileScanBuilder.md)
* [JDBCScanBuilder](../jdbc/JDBCScanBuilder.md)
* `MemoryStreamScanBuilder` ([Spark Structured Streaming]({{ book.structured_streaming }}/connectors/memory/MemoryStreamScanBuilder))
* [SupportsPushDownAggregates](SupportsPushDownAggregates.md)
* [SupportsPushDownFilters](SupportsPushDownFilters.md)
* `SupportsPushDownLimit`
* [SupportsPushDownRequiredColumns](SupportsPushDownRequiredColumns.md)
* `SupportsPushDownTableSample`
* `SupportsPushDownTopN`
* [SupportsPushDownV2Filters](SupportsPushDownV2Filters.md)
