# SupportsPushDownV2Filters

`SupportsPushDownV2Filters` is an [extension](#contract) of the [ScanBuilder](ScanBuilder.md) abstraction for [scan builders](#implementations) that support [pushPredicates](#pushPredicates) (using "modern" [Predicate](Predicate.md)s).

## Contract

### <span id="pushedPredicates"> pushedPredicates

```java
Predicate[] pushedPredicates()
```

Used when:

* `PushDownUtils` is requested to [pushFilters](../PushDownUtils.md#pushFilters)

### <span id="pushPredicates"> pushPredicates

```java
Predicate[] pushPredicates(
  Predicate[] predicates)
```

Used when:

* `PushDownUtils` is requested to [pushFilters](../PushDownUtils.md#pushFilters)

## Implementations

* [JDBCScanBuilder](../jdbc/JDBCScanBuilder.md)
