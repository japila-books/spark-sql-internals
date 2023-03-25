# SupportsPushDownAggregates

`SupportsPushDownAggregates` is an [extension](#contract) of the [ScanBuilder](ScanBuilder.md) abstraction for [scan builders](#implementations) with [support for complete aggregate push-down optimization](#supportCompletePushDown).

## Contract

### <span id="pushAggregation"> pushAggregation

```java
boolean pushAggregation(
  Aggregation aggregation)
```

See:

* [JDBCScanBuilder](../datasources/jdbc/JDBCScanBuilder.md#pushAggregation)
* [ParquetScanBuilder](../datasources/parquet/ParquetScanBuilder.md#pushAggregation)

Used when:

* [V2ScanRelationPushDown](../logical-optimizations/V2ScanRelationPushDown.md) logical optimization is executed (to [rewriteAggregate](../logical-optimizations/V2ScanRelationPushDown.md#rewriteAggregate))

### <span id="supportCompletePushDown"> supportCompletePushDown

```java
boolean supportCompletePushDown(
  Aggregation aggregation)
```

Default: `false`

See:

* [JDBCScanBuilder](../datasources/jdbc/JDBCScanBuilder.md#supportCompletePushDown)

Used when:

* [V2ScanRelationPushDown](../logical-optimizations/V2ScanRelationPushDown.md) logical optimization is executed (to [rewriteAggregate](../logical-optimizations/V2ScanRelationPushDown.md#rewriteAggregate))

## Implementations

* [JDBCScanBuilder](../datasources/jdbc/JDBCScanBuilder.md)
* `OrcScanBuilder`
* [ParquetScanBuilder](../datasources/parquet/ParquetScanBuilder.md)
