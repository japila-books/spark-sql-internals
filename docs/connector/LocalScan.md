# LocalScan

`LocalScan` is an [extension](#contract) of the [Scan](Scan.md) abstraction for [local scans](#implementations).

`LocalScan` is planned as [LocalTableScanExec](../physical-operators/LocalTableScanExec.md) physical operator at execution planning.

## Contract

### <span id="rows"> rows

```java
InternalRow[] rows()
```

Used when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (on a [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) logical operator with a `LocalScan`)

## Implementations

!!! note
    No built-in implementations available.
