# BroadcastQueryStageExec Physical Operator

`BroadcastQueryStageExec` is a [QueryStageExec](QueryStageExec.md).

## Creating Instance

`BroadcastQueryStageExec` takes the following to be created:

* <span id="id"> ID
* <span id="plan"> [SparkPlan](SparkPlan.md)

`BroadcastQueryStageExec` is created when:

* `AdaptiveSparkPlanExec` physical operator is requested to [newQueryStage](AdaptiveSparkPlanExec.md#newQueryStage) (for a [BroadcastExchangeExec](BroadcastExchangeExec.md))

* `BroadcastQueryStageExec` physical operator is requested to [newReuseInstance](#newReuseInstance)

## <span id="broadcast"> BroadcastExchangeExec Physical Operator

```scala
broadcast: BroadcastExchangeExec
```

`BroadcastQueryStageExec` creates a [BroadcastExchangeExec](BroadcastExchangeExec.md) when created.

## <span id="newReuseInstance"> Creating BroadcastQueryStageExec Physical Operator

```scala
newReuseInstance(
  newStageId: Int,
  newOutput: Seq[Attribute]): QueryStageExec
```

`newReuseInstance` creates a new `BroadcastQueryStageExec` with the given `newStageId` and a new [ReusedExchangeExec](ReusedExchangeExec.md) (with the given `newOutput` and the [broadcast](#broadcast)).

`newReuseInstance` is part of the [QueryStageExec](QueryStageExec.md#newReuseInstance) abstraction.
