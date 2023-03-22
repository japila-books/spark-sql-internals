# SupportsReportPartitioning

`SupportsReportPartitioning` is an [extension](#contract) of the [Scan](Scan.md) abstraction for [scans](#implementations) with custom [data partitioning](#outputOrdering).

## Contract

### <span id="outputOrdering"> outputOrdering

```java
Partitioning outputPartitioning()
```

[Partitioning](Partitioning.md)s of the data of this scan

Used when:

* `V2ScanPartitioningAndOrdering` logical optimization is executed (and `partitioning`)

## Implementations

!!! note
    No built-in implementations available.
