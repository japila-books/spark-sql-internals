# BroadcastQueryStageExec Physical Operator

`BroadcastQueryStageExec` is a [QueryStageExec](QueryStageExec.md).

## Creating Instance

`BroadcastQueryStageExec` takes the following to be created:

* <span id="id"> ID
* <span id="plan"> [SparkPlan](../physical-operators/SparkPlan.md)

`BroadcastQueryStageExec` is created when:

* `AdaptiveSparkPlanExec` physical operator is requested to [newQueryStage](../physical-operators/AdaptiveSparkPlanExec.md#newQueryStage) (for a [BroadcastExchangeExec](../physical-operators/BroadcastExchangeExec.md))

* `BroadcastQueryStageExec` physical operator is requested to [newReuseInstance](#newReuseInstance)

## <span id="getRuntimeStatistics"> Runtime Statistics

```scala
getRuntimeStatistics: Statistics
```

`getRuntimeStatistics` is part of the [QueryStageExec](QueryStageExec.md#getRuntimeStatistics) abstraction.

`getRuntimeStatistics` requests the [BroadcastExchangeLike](#broadcast) operator for the [runtime statistics](../physical-operators/BroadcastExchangeLike.md#runtimeStatistics).

## <span id="materializeWithTimeout"> materializeWithTimeout

```scala
materializeWithTimeout: Future[Any]
```

`materializeWithTimeout` is...FIXME

## <span id="broadcast"> BroadcastExchangeExec Physical Operator

```scala
broadcast: BroadcastExchangeExec
```

`BroadcastQueryStageExec` creates a [BroadcastExchangeExec](../physical-operators/BroadcastExchangeExec.md) when [created](#creating-instance).

## <span id="newReuseInstance"> Creating BroadcastQueryStageExec Physical Operator

```scala
newReuseInstance(
  newStageId: Int,
  newOutput: Seq[Attribute]): QueryStageExec
```

`newReuseInstance` creates a new `BroadcastQueryStageExec` with the given `newStageId` and a new [ReusedExchangeExec](../physical-operators/ReusedExchangeExec.md) (with the given `newOutput` and the [broadcast](#broadcast)).

`newReuseInstance` is part of the [QueryStageExec](QueryStageExec.md#newReuseInstance) abstraction.
