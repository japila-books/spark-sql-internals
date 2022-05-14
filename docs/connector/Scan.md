# Scan

`Scan` is an [abstraction](#contract) of [logical scans](#implementations) over data sources.

## Contract

### <span id="description"> Description

```java
String description()
```

Used when `DataSourceV2ScanExecBase` physical operator is requested for a [simpleString](../physical-operators/DataSourceV2ScanExecBase.md#simpleString)

### <span id="readSchema"> readSchema

```java
StructType readSchema()
```

Used when...FIXME

### <span id="toBatch"> toBatch

```java
Batch toBatch()
```

By default, `toBatch` throws an `UnsupportedOperationException` (with [description](#description)):

```text
[description]: Batch scan are not supported
```

Must be implemented (_overriden_), if the [Table](Table.md) that created this `Scan` has `BATCH_READ` capability (among the [capabilities](Table.md#capabilities)).

Used when `BatchScanExec` physical operator is requested for [batch](../physical-operators/BatchScanExec.md#batch).

### <span id="toContinuousStream"> toContinuousStream

```java
ContinuousStream toContinuousStream(
    String checkpointLocation)
```

Used when...FIXME

### <span id="toMicroBatchStream"> toMicroBatchStream

```java
MicroBatchStream toMicroBatchStream(
    String checkpointLocation)
```

Used when...FIXME

## Implementations

* [FileScan](../datasources/FileScan.md)
* [KafkaScan](../datasources/kafka/KafkaScan.md)
* `MemoryStreamScanBuilder`
* [SupportsReportPartitioning](SupportsReportPartitioning.md)
* [SupportsReportStatistics](SupportsReportStatistics.md)
* [V1Scan](V1Scan.md)
* `V1ScanWrapper`
