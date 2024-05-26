---
title: Partitioning
---

# Partitioning

`Partitioning` is an [abstraction](#contract) of [output data partitioning requirements](#implementations) (_data distribution_) of a [Spark SQL connector](index.md).

!!! note
    This `Partitioning` interface for Spark SQL developers mimics the internal Catalyst [Partitioning](../physical-operators/Partitioning.md) that is converted into with the help of [DataSourcePartitioning](../physical-operators/Partitioning.md#DataSourcePartitioning).

## Contract

### Number of Partitions { #numPartitions }

```java
int numPartitions()
```

Used when:

* [DataSourcePartitioning](../physical-operators/Partitioning.md#DataSourcePartitioning) is requested for the [number of partitions](../physical-operators/Partitioning.md#numPartitions)

### Satisfying Distribution { #satisfy }

```java
boolean satisfy(
  Distribution distribution)
```

Used when:

* [DataSourcePartitioning](../physical-operators/Partitioning.md#DataSourcePartitioning) is asked whether it [satisfies a given data distribution](../physical-operators/Partitioning.md#satisfies0)

## Implementations

* [KeyGroupedPartitioning](KeyGroupedPartitioning.md)
* `UnknownPartitioning`
