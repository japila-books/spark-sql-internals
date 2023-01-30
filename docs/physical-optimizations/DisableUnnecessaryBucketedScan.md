# DisableUnnecessaryBucketedScan Physical Optimization

`DisableUnnecessaryBucketedScan` is a physical query plan optimization.

`DisableUnnecessaryBucketedScan` is a [Catalyst Rule](../catalyst/Rule.md) for transforming [SparkPlan](../physical-operators/SparkPlan.md)s (`Rule[SparkPlan]`).

`DisableUnnecessaryBucketedScan` is used when:

* `QueryExecution` utility is used for [preparations rules](../QueryExecution.md#preparations)
* `AdaptiveSparkPlanExec` physical operator is requested for the [physical preparation rules](../physical-operators/AdaptiveSparkPlanExec.md#queryStagePreparationRules)

## Creating Instance

`DisableUnnecessaryBucketedScan` takes no input arguments to be created.

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` finds [FileSourceScanExec](../physical-operators/FileSourceScanExec.md) physical operators with [bucketedScan](../physical-operators/FileSourceScanExec.md#bucketedScan) enabled. If there are any, the given [SparkPlan](../physical-operators/SparkPlan.md) is considered to be a **bucketed scan**.

`apply` [disableBucketWithInterestingPartition](#disableBucketWithInterestingPartition) unless any of the configuration properties is `false` (and `apply` returns the given [SparkPlan](../physical-operators/SparkPlan.md)):

* [spark.sql.sources.bucketing.enabled](../configuration-properties.md#spark.sql.sources.bucketing.enabled)
* [spark.sql.sources.bucketing.autoBucketedScan.enabled](../configuration-properties.md#spark.sql.sources.bucketing.autoBucketedScan.enabled)

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
