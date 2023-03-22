# SupportsReportOrdering

`SupportsReportOrdering` is an [extension](#contract) of the [Scan](Scan.md) abstraction for [scans](#implementations) that report the [order of data](#outputOrdering) (in each partition).

## Contract

### <span id="outputOrdering"> outputOrdering

```java
SortOrder[] outputOrdering()
```

[SortOrder](expressions/SortOrder.md)s of the output ordering of this scan

Used when:

* `V2ScanPartitioningAndOrdering` logical optimization is executed (and `ordering`)

## Implementations

!!! note
    No built-in implementations available.
