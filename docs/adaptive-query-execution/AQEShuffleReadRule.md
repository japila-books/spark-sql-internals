# AQEShuffleReadRule Physical Optimization Rules

`AQEShuffleReadRule` is an [extension](#contract) of the [Rule](../catalyst/Rule.md) abstraction for [physical optimization rules](#implementations) (`Rule[SparkPlan]`) that [supportedShuffleOrigins](#supportedShuffleOrigins).

## Contract

### <span id="supportedShuffleOrigins"> supportedShuffleOrigins

```scala
supportedShuffleOrigins: Seq[ShuffleOrigin]
```

Used when:

* `AdaptiveSparkPlanExec` physical operator is requested for the [final physical query plan](../adaptive-query-execution/AdaptiveSparkPlanExec.md#getFinalPhysicalPlan)
* _others_ (FIXME: perhaps not as important?)

## Implementations

* [CoalesceShufflePartitions](CoalesceShufflePartitions.md)
* [OptimizeShuffleWithLocalRead](OptimizeShuffleWithLocalRead.md)
* [OptimizeSkewedJoin](OptimizeSkewedJoin.md)
* [OptimizeSkewInRebalancePartitions](OptimizeSkewInRebalancePartitions.md)
