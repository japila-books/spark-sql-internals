# Scan

`Scan` is an [abstraction](#contract) of [logical scans](#implementations) over data sources.

## Contract

### <span id="description"> description

```java
String description()
```

Used when...FIXME

### <span id="readSchema"> readSchema

```java
StructType readSchema()
```

Used when...FIXME

### <span id="toBatch"> toBatch

```java
Batch toBatch()
```

Used when...FIXME

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

* FileScan
* KafkaScan
* MemoryStreamScanBuilder
* SupportsReportPartitioning
* SupportsReportStatistics
* V1Scan
* V1ScanWrapper
