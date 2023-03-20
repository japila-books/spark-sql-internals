---
title: SupportsDeleteV2
---

# SupportsDeleteV2 Tables

`SupportsDeleteV2` is an [extension](#contract) of the [TruncatableTable](TruncatableTable.md) abstraction for [truncatable tables](#implementations) that can [deleteWhere](#deleteWhere).

## Contract

### <span id="deleteWhere"> deleteWhere

```java
void deleteWhere(
  Predicate[] predicates)
```

See:

* [SupportsDelete](SupportsDelete.md#deleteWhere)

Used when:

* `SupportsDeleteV2` is requested to [truncateTable](#truncateTable) (with [canDeleteWhere](#canDeleteWhere) enabled)
* [DeleteFromTableExec](../physical-operators/DeleteFromTableExec.md) physical operator is executed

## Implementations

* [SupportsDelete](SupportsDelete.md)

## <span id="canDeleteWhere"> canDeleteWhere

```java
boolean canDeleteWhere(
    Predicate[] predicates)
```

`canDeleteWhere` is enabled (`true`).

---

`canDeleteWhere` is used when:

* `SupportsDeleteV2` is requested to [truncateTable](#truncateTable)
* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (to plan a [DeleteFromTable](../logical-operators/DeleteFromTable.md) over a `SupportsDeleteV2`)
* `OptimizeMetadataOnlyDeleteFromTable` logical optimization is executed
