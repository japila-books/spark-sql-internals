# SupportsPushDownFilters

`SupportsPushDownFilters` is an [extension](#contract) of the [ScanBuilder](ScanBuilder.md) abstraction for [scan builders](#implementations) that can [pushFilters](#pushFilters) and [pushedFilters](#pushedFilters) (for filter pushdown performance optimization and thus reduce the size of the data to be read).

## Contract

### <span id="pushedFilters"> pushedFilters

```java
Filter[] pushedFilters()
```

[Data source filters](../Filter.md) that were pushed down to the data source (in [pushFilters](#pushFilters))

Used when [V2ScanRelationPushDown](../logical-optimizations/V2ScanRelationPushDown.md) logical optimization is executed (that uses `PushDownUtils` utility to `pushFilters`)

### <span id="pushFilters"> pushFilters

```java
Filter[] pushFilters(
  Filter[] filters)
```

[Data source filters](../Filter.md) that need to be evaluated again after scanning (so Spark can plan an extra filter operator)

Used when:

* [V2ScanRelationPushDown](../logical-optimizations/V2ScanRelationPushDown.md) logical optimization is executed (that uses `PushDownUtils` utility to `pushFilters`)
* `CSVScanBuilder` is requested for a [Scan](../datasources/csv/CSVScanBuilder.md#build)
* `OrcScanBuilder` is requested for a [Scan](../datasources/orc/OrcScanBuilder.md#build)

## Implementations

* [CSVScanBuilder](../datasources/csv/CSVScanBuilder.md)
* [OrcScanBuilder](../datasources/orc/OrcScanBuilder.md)
* [ParquetScanBuilder](../datasources/parquet/ParquetScanBuilder.md)
