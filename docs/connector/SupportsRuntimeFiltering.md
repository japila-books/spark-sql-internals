---
title: SupportsRuntimeFiltering
---

# SupportsRuntimeFiltering

`SupportsRuntimeFiltering` is an [extension](#contract) of the [SupportsRuntimeV2Filtering](SupportsRuntimeV2Filtering.md) abstraction for [connectors](#implementations) that want to filter initially planned [InputPartition](InputPartition.md)s using predicates Spark infers at runtime.

## Contract

### filterAttributes { #filterAttributes }

```java
NamedReference[] filterAttributes()
```

Used when:

* [PartitionPruning](../logical-optimizations/PartitionPruning.md) logical optimization is executed (to [getFilterableTableScan](../logical-optimizations/PartitionPruning.md#getFilterableTableScan))
* `RowLevelOperationRuntimeGroupFiltering` logical optimization is executed

### filter { #filter }

```java
void filter(
  Filter[] filters)
void filter(
  Predicate[] predicates) // (1)!
```

1. Converts the given [Predicate](Predicate.md)s to the older [Filter](../Filter.md)s

Used when:

* [BatchScanExec](../physical-operators/BatchScanExec.md) physical operator is executed (to [filteredPartitions](../physical-operators/BatchScanExec.md#filteredPartitions))

## Implementations

!!! note
    No built-in implementations available.
