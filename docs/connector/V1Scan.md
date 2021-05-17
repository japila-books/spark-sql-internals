# V1Scan

`V1Scan` is an [extension](#contract) of the [Scan](Scan.md) abstraction for [V1 DataSources](#implementations) that would like to participate in the DataSource V2 read code paths.

## Contract

### <span id="toV1TableScan"> toV1TableScan

```java
<T extends BaseRelation & TableScan> T toV1TableScan(
  SQLContext context)
```

[BaseRelation](../BaseRelation.md) with [TableScan](../TableScan.md) to scan data from a DataSource v1 (to `RDD[Row]`)

Used when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (to plan [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) with `V1Scan` to [RowDataSourceScanExec](../physical-operators/RowDataSourceScanExec.md))

## Implementations

* [JDBCScan](../datasources/jdbc/JDBCScan.md)
