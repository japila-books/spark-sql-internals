# Connector Partitioning

`Partitioning` is an [abstraction](#contract) of output data partitioning requirements (_data distribution_) of a Spark SQL Connector.

!!! note
    This `Partitioning` interface for Spark SQL developers mimics the internal Catalyst [Partitioning](../physical-operators/Partitioning.md) that is converted into with the help of [DataSourcePartitioning](../physical-operators/Partitioning.md#DataSourcePartitioning).

## Contract

### <span id="numPartitions"> Number of Partitions

```java
int numPartitions()
```

Used when:

* [DataSourcePartitioning](../physical-operators/Partitioning.md#DataSourcePartitioning) is requested for the [number of partitions](../physical-operators/Partitioning.md#numPartitions)

### <span id="satisfy"> Satisfying Distribution

```java
boolean satisfy(
  Distribution distribution)
```

Used when:

* [DataSourcePartitioning](../physical-operators/Partitioning.md#DataSourcePartitioning) is asked whether it [satisfies a given data distribution](../physical-operators/Partitioning.md#satisfies0)
