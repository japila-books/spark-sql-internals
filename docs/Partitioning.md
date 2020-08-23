# Partitioning &mdash; Specification of Physical Operator's Output Partitions

`Partitioning` is an [abstraction](#contract) of [partitioning schemes](#implementations) that hint the Spark Physical Optimizer about the [number of partitions](#numPartitions) and data distribution of the output of a [physical operator](physical-operators/SparkPlan.md).

## Contract

### <span id="numPartitions"> Number of Partitions

```scala
numPartitions: Int
```

Used when:

* [EnsureRequirements](physical-optimizations/EnsureRequirements.md) physical optimization is executed
* [SortMergeJoinExec](physical-operators/SortMergeJoinExec.md) for `outputPartitioning` for `FullOuter` join type
* `Partitioning.allCompatible`

## Implementations

### BroadcastPartitioning

```scala
BroadcastPartitioning(
  mode: BroadcastMode)
```

compatibleWith: `BroadcastPartitioning` with the same `BroadcastMode`

guarantees: Exactly the same `BroadcastPartitioning`

numPartitions: 1

satisfies: [BroadcastDistribution](BroadcastDistribution.md) with the same `BroadcastMode`

### DataSourcePartitioning

```scala
DataSourcePartitioning(
  partitioning: Partitioning,
  colNames: AttributeMap[String])
```

### HashPartitioning

[HashPartitioning](expressions/HashPartitioning.md)

numPartitions: the given [numPartitions](expressions/HashPartitioning.md#numPartitions)

satisfies:

* [UnspecifiedDistribution](UnspecifiedDistribution.md)
* [ClusteredDistribution](ClusteredDistribution.md) with all the hashing [expressions](expressions/Expression.md) included in `clustering` expressions

### PartitioningCollection

```scala
PartitioningCollection(
  partitionings: Seq[Partitioning])
```

compatibleWith: Any `Partitioning` that is compatible with one of the input `partitionings`

guarantees: Any `Partitioning` that is guaranteed by any of the input `partitionings`

numPartitions: Number of partitions of the first `Partitioning` in the input `partitionings`

satisfies: Any `Distribution` that is satisfied by any of the input `partitionings`

### RangePartitioning

[RangePartitioning](expressions/RangePartitioning.md)

compatibleWith: `RangePartitioning` when semantically equal (i.e. underlying expressions are deterministic and canonically equal)

guarantees: `RangePartitioning` when semantically equal (i.e. underlying expressions are deterministic and canonically equal)

numPartitions: the given [numPartitions](expressions/RangePartitioning.md#numPartitions)

satisfies:

* [UnspecifiedDistribution](UnspecifiedDistribution.md)
* [OrderedDistribution](OrderedDistribution.md) with `requiredOrdering` that matches the input `ordering`
* [ClusteredDistribution](ClusteredDistribution.md) with all the children of the input `ordering` semantically equal to one of the `clustering` expressions

### RoundRobinPartitioning

```scala
RoundRobinPartitioning(
  numPartitions: Int)
```

compatibleWith: Always `false`

guarantees: Always `false`

numPartitions: the given `numPartitions`

satisfies: [UnspecifiedDistribution](UnspecifiedDistribution.md)

### SinglePartition

compatibleWith: Any `Partitioning` with one partition

guarantees: Any `Partitioning` with one partition

numPartitions: 1

satisfies: Any `Distribution` except [BroadcastDistribution](BroadcastDistribution.md)

### UnknownPartitioning

```scala
UnknownPartitioning(
  numPartitions: Int)
```

compatibleWith: Always `false`

guarantees: Always `false`

numPartitions: the given `numPartitions`

satisfies: [UnspecifiedDistribution](UnspecifiedDistribution.md)
