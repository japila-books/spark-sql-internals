---
title: SupportsRuntimeV2Filtering
---

# SupportsRuntimeV2Filtering

`SupportsRuntimeV2Filtering` is an [extension](#contract) of the [Scan](Scan.md) abstraction for [connectors](#implementations) that can filter initially planned [InputPartition](InputPartition.md)s using predicates Spark infers at runtime.

## Contract

### filterAttributes { #filterAttributes }

```java
NamedReference[] filterAttributes()
```

### filter

```java
void filter(
  Predicate[] predicates)
```

## Implementations

* [SupportsRuntimeFiltering](SupportsRuntimeFiltering.md)
