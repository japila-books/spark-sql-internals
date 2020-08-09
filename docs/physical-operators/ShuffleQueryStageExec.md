# ShuffleQueryStageExec Physical Operator

`ShuffleQueryStageExec` is a [QueryStageExec](QueryStageExec.md) with [ShuffleExchangeExec](ShuffleExchangeExec.md) or [ReusedExchangeExec](ReusedExchangeExec.md) child operators.

## Creating Instance

`ShuffleQueryStageExec` takes the following to be created:

* <span id="id"> ID
* <span id="plan"> [Physical Operator](SparkPlan.md) ([ShuffleExchangeExec](ShuffleExchangeExec.md) or [ReusedExchangeExec](ReusedExchangeExec.md))

`ShuffleQueryStageExec` is created when:

* [AdaptiveSparkPlanExec](AdaptiveSparkPlanExec.md) physical operator is requested to [newQueryStage](AdaptiveSparkPlanExec.md#newQueryStage) (for a [ShuffleExchangeExec](ShuffleExchangeExec.md))

* `ShuffleQueryStageExec` physical operator is requested to [newReuseInstance](#newReuseInstance)

## <span id="newReuseInstance"> newReuseInstance

```scala
newReuseInstance(
  newStageId: Int,
  newOutput: Seq[Attribute]): QueryStageExec
```

`newReuseInstance` is...FIXME

`newReuseInstance` is part of the [QueryStageExec](QueryStageExec.md) abstraction.
