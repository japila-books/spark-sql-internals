# Distributions

`Distribution` is an [abstraction](#contract) of [data distribution specifications](#implementations) for [EnsureRequirements](physical-optimizations/EnsureRequirements.md) physical optimization.

??? note "sealed abstract class"
    `Distribution` is a Scala sealed abstract class which means that all possible implementations (`Distribution`s) are all in the same compilation unit (file).

## Contract

### <span id="createPartitioning"> createPartitioning

```scala
createPartitioning(
  numPartitions: Int): Partitioning
```

Creates the [Partitioning](Partitioning.md) with the given number of partitions

Used when [EnsureRequirements](physical-optimizations/EnsureRequirements.md) physical optimization is executed

### <span id="requiredNumPartitions"> requiredNumPartitions

```scala
requiredNumPartitions: Option[Int]
```

Required number of partitions of the distribution

Used when [EnsureRequirements](physical-optimizations/EnsureRequirements.md) physical optimization is executed

## Implementations

* [AllTuples](AllTuples.md)
* [BroadcastDistribution](BroadcastDistribution.md)
* [ClusteredDistribution](ClusteredDistribution.md)
* [HashClusteredDistribution](HashClusteredDistribution.md)
* [OrderedDistribution](OrderedDistribution.md)
* [UnspecifiedDistribution](UnspecifiedDistribution.md)
