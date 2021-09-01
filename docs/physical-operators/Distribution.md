# Distributions

`Distribution` is an [abstraction](#contract) of the [data distribution requirements](#implementations) of a [physical operator](SparkPlan.md#requiredChildDistribution).

`Distribution` is enforced by [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization.

## Contract

### <span id="createPartitioning"> Creating Partitioning

```scala
createPartitioning(
  numPartitions: Int): Partitioning
```

Creates a [Partitioning](Partitioning.md)

Used when:

* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization is executed

### <span id="requiredNumPartitions"> Required Number of Partitions

```scala
requiredNumPartitions: Option[Int]
```

Required number of partitions for this data distribution

Used when:

* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization is executed

## Implementations

??? note "sealed abstract class"
    `Distribution` is a Scala **sealed abstract class** which means that all possible implementations (`Distribution`s) are all in the same compilation unit (file).

* [AllTuples](AllTuples.md)
* [BroadcastDistribution](BroadcastDistribution.md)
* [ClusteredDistribution](ClusteredDistribution.md)
* [HashClusteredDistribution](HashClusteredDistribution.md)
* [OrderedDistribution](OrderedDistribution.md)
* [UnspecifiedDistribution](UnspecifiedDistribution.md)
