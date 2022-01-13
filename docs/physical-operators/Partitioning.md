# Partitioning (Catalyst)

`Partitioning` is an [abstraction](#contract) of [partitioning specifications](#implementations) that hint the Spark Physical Optimizer about the [number of partitions](#numPartitions) and data distribution of the output of a [physical operator](SparkPlan.md).

## Contract

### <span id="numPartitions"> Number of Partitions

```scala
numPartitions: Int
```

Used when:

* `AliasAwareOutputPartitioning` unary physical operators are requested for the [outputPartitioning](AliasAwareOutputPartitioning.md#outputPartitioning)
* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization is executed
* `ShuffleExchangeExec` utility is used to [prepareShuffleDependency](ShuffleExchangeExec.md#prepareShuffleDependency)
* `ValidateRequirements` utility is used to `validateInternal`
* `ShuffledJoin` physical operators are requested for the [outputPartitioning](ShuffledJoin.md#outputPartitioning) (for `FullOuter` join type)
* `Partitioning` is requested to [satisfies](#satisfies), [satisfies0](#satisfies0)

## Implementations

### <span id="BroadcastPartitioning"> BroadcastPartitioning

```scala
BroadcastPartitioning(
  mode: BroadcastMode)
```

[numPartitions](#numPartitions): 1

[satisfies](#satisfies):

* [UnspecifiedDistribution](UnspecifiedDistribution.md)
* [BroadcastDistribution](BroadcastDistribution.md) with the same [BroadcastMode](BroadcastMode.md)

Created when:

* `BroadcastDistribution` is requested to [create a Partitioning](BroadcastDistribution.md#createPartitioning)
* `BroadcastExchangeExec` physical operator is requested for the [outputPartitioning](BroadcastExchangeExec.md#outputPartitioning)

### <span id="DataSourcePartitioning"> DataSourcePartitioning

An adapter for the [Connector Partitioning](../connector/Partitioning.md) to this Catalyst `Partitioning`

Created with:

* [Connector Partitioning](../connector/Partitioning.md)
* A lookup table of column names ([Attribute](../expressions/Attribute.md)s and their names by `ExprId`)

[numPartitions](#numPartitions):

* The [numPartitions](../connector/Partitioning.md#numPartitions) of the given Connector `Partitioning`

[satisfies](#satisfies):

One of the following:

1. [satisfies0](#satisfies0)
1. FIXME

Created when:

* `DataSourceV2ScanExecBase` leaf physical operators are requested for the [outputPartitioning](DataSourceV2ScanExecBase.md#outputPartitioning) (for [SupportsReportPartitioning](../connector/SupportsReportPartitioning.md) scans)

### <span id="HashPartitioning"> HashPartitioning

[HashPartitioning](../expressions/HashPartitioning.md)

[numPartitions](#numPartitions): the given [numPartitions](../expressions/HashPartitioning.md#numPartitions)

[satisfies](#satisfies):

* [UnspecifiedDistribution](UnspecifiedDistribution.md)
* [ClusteredDistribution](ClusteredDistribution.md) with all the hashing [expressions](../expressions/Expression.md) included in `clustering` expressions

### <span id="PartitioningCollection"> PartitioningCollection

```scala
PartitioningCollection(
  partitionings: Seq[Partitioning])
```

compatibleWith: Any `Partitioning` that is compatible with one of the input `partitionings`

guarantees: Any `Partitioning` that is guaranteed by any of the input `partitionings`

[numPartitions](#numPartitions): Number of partitions of the first `Partitioning` in the input `partitionings`

[satisfies](#satisfies): Any `Distribution` that is satisfied by any of the input `partitionings`

### <span id="RangePartitioning"> RangePartitioning

compatibleWith: `RangePartitioning` when semantically equal (i.e. underlying expressions are deterministic and canonically equal)

guarantees: `RangePartitioning` when semantically equal (i.e. underlying expressions are deterministic and canonically equal)

[numPartitions](#numPartitions): the given `numPartitions`

[satisfies](#satisfies):

* [UnspecifiedDistribution](UnspecifiedDistribution.md)
* [OrderedDistribution](OrderedDistribution.md) with `requiredOrdering` that matches the input `ordering`
* [ClusteredDistribution](ClusteredDistribution.md) with all the children of the input `ordering` semantically equal to one of the `clustering` expressions

### <span id="RoundRobinPartitioning"> RoundRobinPartitioning

```scala
RoundRobinPartitioning(
  numPartitions: Int)
```

compatibleWith: Always `false`

guarantees: Always `false`

[numPartitions](#numPartitions): the given `numPartitions`

[satisfies](#satisfies): [UnspecifiedDistribution](UnspecifiedDistribution.md)

### <span id="SinglePartition"> SinglePartition

compatibleWith: Any `Partitioning` with one partition

guarantees: Any `Partitioning` with one partition

[numPartitions](#numPartitions): `1`

[satisfies](#satisfies): Any `Distribution` except [BroadcastDistribution](BroadcastDistribution.md)

### <span id="UnknownPartitioning"> UnknownPartitioning

```scala
UnknownPartitioning(
  numPartitions: Int)
```

compatibleWith: Always `false`

guarantees: Always `false`

[numPartitions](#numPartitions): the given `numPartitions`

[satisfies](#satisfies): [UnspecifiedDistribution](UnspecifiedDistribution.md)

## <span id="satisfies"> Satisfying Distribution

```scala
satisfies(
  required: Distribution): Boolean
```

`satisfies` is `true` when  all the following hold:

1. The optional [required number of partitions](Distribution.md#requiredNumPartitions) of the given [Distribution](Distribution.md) is the [number of partitions](#numPartitions) of this `Partitioning`
1. [satisfies0](#satisfies0) holds

??? note "Final Method"
    `satisfies` is a Scala **final method** and may not be overridden in [subclasses](#implementations).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#final).

`satisfies` is used when:

* [RemoveRedundantSorts](../physical-optimizations/RemoveRedundantSorts.md) physical optimization is executed
* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization is executed
* [AdaptiveSparkPlanExec](../adaptive-query-execution/AdaptiveSparkPlanExec.md) leaf physical operator is executed

### <span id="satisfies0"> satisfies0

```scala
satisfies0(
  required: Distribution): Boolean
```

`satisfies0` is `true` when either holds:

* The given [Distribution](Distribution.md) is a [UnspecifiedDistribution](UnspecifiedDistribution.md)
* The given [Distribution](Distribution.md) is a [AllTuples](AllTuples.md) and the [number of partitions](#numPartitions) is `1`.

!!! note
    `satisfies0` can be overriden by [subclasses](#implementations) if needed (to influence the final [satisfies](#satisfies)).
