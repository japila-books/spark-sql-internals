# SupportsPushDownFilters

`SupportsPushDownFilters` is an [extension](#contract) of the [ScanBuilder](ScanBuilder.md) abstraction for [scan builders](#implementations) that can [pushFilters](#pushFilters) and [pushedFilters](#pushedFilters) (for filter pushdown performance optimization and thus reduce the size of the data to be read).

!!! danger "Obsolete as of Spark 3.3.0"
    [SupportsPushDownV2Filters](SupportsPushDownV2Filters.md) is preferred as it uses the modern [Predicate](Predicate.md) expression.

## Contract

### <span id="pushedFilters"> pushedFilters

```java
Filter[] pushedFilters()
```

[Data source filters](../Filter.md) that were pushed down to the data source (in [pushFilters](#pushFilters))

Used when:

* `PushDownUtils` is requested to [pushFilters](../PushDownUtils.md#pushFilters)
* [V2ScanRelationPushDown](../logical-optimizations/V2ScanRelationPushDown.md) logical optimization is executed (and [getWrappedScan](../logical-optimizations/V2ScanRelationPushDown.md#getWrappedScan) for [V1Scan](V1Scan.md)s)

### <span id="pushFilters"> pushFilters

```java
Filter[] pushFilters(
  Filter[] filters)
```

[Data source filters](../Filter.md) that need to be evaluated again after scanning (so Spark can plan an extra filter operator)

Used when:

* `PushDownUtils` is requested to [pushFilters](../PushDownUtils.md#pushFilters)

## Implementations

!!! note
    No built-in implementations available.
