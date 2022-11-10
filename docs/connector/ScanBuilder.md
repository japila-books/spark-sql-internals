# ScanBuilder

`ScanBuilder` is an [abstraction](#contract) of [scan builders](#implementations).

## Contract

### <span id="build"> Building Scan

```scala
Scan build()
```

Builds [Scan](Scan.md)

Used when:

* `PushDownUtils` is requested to `pruneColumns`
* [V2ScanRelationPushDown](../logical-optimizations/V2ScanRelationPushDown.md) logical optimization is executed (to [pushDownAggregates](../logical-optimizations/V2ScanRelationPushDown.md#pushDownAggregates))

## Implementations

* [FileScanBuilder](../datasources/FileScanBuilder.md)
* [JDBCScanBuilder](../datasources/jdbc/JDBCScanBuilder.md)
* `MemoryStreamScanBuilder` ([Spark Structured Streaming]({{ book.structured_streaming }}/datasources/memory/MemoryStreamScanBuilder))
* `SupportsPushDownAggregates`
* [SupportsPushDownFilters](SupportsPushDownFilters.md)
* `SupportsPushDownLimit`
* [SupportsPushDownRequiredColumns](SupportsPushDownRequiredColumns.md)
* `SupportsPushDownTableSample`
* `SupportsPushDownTopN`
* [SupportsPushDownV2Filters](SupportsPushDownV2Filters.md)
