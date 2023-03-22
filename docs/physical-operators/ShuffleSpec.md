# ShuffleSpec

`ShuffleSpec` is an [abstraction](#contract) of [shuffle specifications](#implementations) for the following physical optimizations:

* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md)
* [OptimizeSkewedJoin](../physical-optimizations/OptimizeSkewedJoin.md)
* [AdaptiveSparkPlanExec](AdaptiveSparkPlanExec.md)

## Contract

### <span id="canCreatePartitioning"> canCreatePartitioning

```scala
canCreatePartitioning: Boolean
```

Used when:

* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization is [executed](../physical-optimizations/EnsureRequirements.md#ensureDistributionAndOrdering)

### <span id="isCompatibleWith"> isCompatibleWith

```scala
isCompatibleWith(
  other: ShuffleSpec): Boolean
```

Used when:

* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization is [executed](../physical-optimizations/EnsureRequirements.md#ensureDistributionAndOrdering)
* `ValidateRequirements` is requested to `validate` (for [OptimizeSkewedJoin](../physical-optimizations/OptimizeSkewedJoin.md) physical optimization and [AdaptiveSparkPlanExec](AdaptiveSparkPlanExec.md) physical operator)

### <span id="numPartitions"> numPartitions

```scala
numPartitions: Int
```

Used when:

* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization is [executed](../physical-optimizations/EnsureRequirements.md#ensureDistributionAndOrdering)

## Implementations

* `HashShuffleSpec`
* `KeyGroupedShuffleSpec`
* `RangeShuffleSpec`
* `ShuffleSpecCollection`
* `SinglePartitionShuffleSpec`
