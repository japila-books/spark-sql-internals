---
title: AQEShuffleReadRule
---

# AQEShuffleReadRule Physical Optimization Rules

`AQEShuffleReadRule` is an [extension](#contract) of the [Rule](../catalyst/Rule.md) abstraction for [physical optimization rules](#implementations) (`Rule[SparkPlan]`) that [supportedShuffleOrigins](#supportedShuffleOrigins).

## Contract

### Supported ShuffleOrigins { #supportedShuffleOrigins }

```scala
supportedShuffleOrigins: Seq[ShuffleOrigin]
```

Supported [ShuffleOrigin](../physical-operators/ShuffleOrigin.md)s

See:

* [CoalesceShufflePartitions](CoalesceShufflePartitions.md#supportedShuffleOrigins)
* [OptimizeShuffleWithLocalRead](OptimizeShuffleWithLocalRead.md#supportedShuffleOrigins)
* [OptimizeSkewInRebalancePartitions](OptimizeSkewInRebalancePartitions.md#supportedShuffleOrigins)

Used when:

* `AdaptiveSparkPlanExec` physical operator is requested for the [final physical query plan](../physical-operators/AdaptiveSparkPlanExec.md#getFinalPhysicalPlan)
* _others_ (FIXME: perhaps not as important?)

## Implementations

* [CoalesceShufflePartitions](CoalesceShufflePartitions.md)
* [OptimizeShuffleWithLocalRead](OptimizeShuffleWithLocalRead.md)
* [OptimizeSkewInRebalancePartitions](OptimizeSkewInRebalancePartitions.md)
