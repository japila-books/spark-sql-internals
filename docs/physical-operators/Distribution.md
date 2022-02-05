# Distribution

`Distribution` is an [abstraction](#contract) of the [data distribution requirements](#implementations) of [physical operators](#physical-operators-distribution-requirements).

`Distribution` is enforced by [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization.

## Contract

### <span id="createPartitioning"> Creating Partitioning

```scala
createPartitioning(
  numPartitions: Int): Partitioning
```

Creates a [Partitioning](Partitioning.md) for the given number of partitions

Used when:

* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization is executed

### <span id="requiredNumPartitions"> Required Number of Partitions

```scala
requiredNumPartitions: Option[Int]
```

Required number of partitions for this data distribution

When defined, only [Partitioning](Partitioning.md)s with the same number of partitions can [satisfy the distribution requirement](Partitioning.md#satisfies).

When undefined (`None`), indicates to use any number of partitions (possibly [spark.sql.shuffle.partitions](../configuration-properties.md#spark.sql.shuffle.partitions)).

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

## Physical Operators' Distribution Requirements

[Physical operators](SparkPlan.md) use `Distribution`s to specify the [required child distribution](SparkPlan.md#requiredChildDistribution) for every [child operator](SparkPlan.md#children).

The default `Distribution`s are [UnspecifiedDistribution](UnspecifiedDistribution.md)s for all the [children](SparkPlan.md#children).

Physical Operator | Required Child Distribution
------------------|----------------------------
 [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md) | [UnspecifiedDistribution](UnspecifiedDistribution.md) or [AQEUtils.getRequiredDistribution](../adaptive-query-execution/AQEUtils.md#getRequiredDistribution)
 [BaseAggregateExec](BaseAggregateExec.md) | One of [AllTuples](AllTuples.md), [ClusteredDistribution](ClusteredDistribution.md) and [UnspecifiedDistribution](UnspecifiedDistribution.md)
 [BroadcastHashJoinExec](BroadcastHashJoinExec.md) | [BroadcastDistribution](BroadcastDistribution.md) with [UnspecifiedDistribution](UnspecifiedDistribution.md) or vice versa
 [BroadcastNestedLoopJoinExec](BroadcastNestedLoopJoinExec.md) | [BroadcastDistribution](BroadcastDistribution.md) with [UnspecifiedDistribution](UnspecifiedDistribution.md) or vice versa
 CoGroupExec      | [HashClusteredDistribution](HashClusteredDistribution.md)s
 GlobalLimitExec  | [AllTuples](AllTuples.md)
 [ShuffledJoin](ShuffledJoin.md) | [UnspecifiedDistribution](UnspecifiedDistribution.md)s or [HashClusteredDistribution](HashClusteredDistribution.md)s
 [SortExec](SortExec.md)      | [OrderedDistribution](OrderedDistribution.md) or [UnspecifiedDistribution](UnspecifiedDistribution.md)
 _others_ |
