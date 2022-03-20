# CoalesceShufflePartitions Adaptive Physical Optimization

`CoalesceShufflePartitions` is a [physical optimization](AQEShuffleReadRule.md) in [Adaptive Query Execution](../adaptive-query-execution/index.md).

## Creating Instance

`CoalesceShufflePartitions` takes the following to be created:

* <span id="session"> [SparkSession](../SparkSession.md)

`CoalesceShufflePartitions` is created when:

* `AdaptiveSparkPlanExec` physical operator is requested for the [QueryStage Optimizer Rules](../physical-operators/AdaptiveSparkPlanExec.md#queryStageOptimizerRules)

## <span id="spark.sql.adaptive.coalescePartitions.enabled"> spark.sql.adaptive.coalescePartitions.enabled

`CoalesceShufflePartitions` is enabled by default and can be turned off using [spark.sql.adaptive.coalescePartitions.enabled](../configuration-properties.md#spark.sql.adaptive.coalescePartitions.enabled) configuration property.

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

---

`apply` does nothing (and simply gives the input [SparkPlan](../physical-operators/SparkPlan.md) back unmodified) when one of the following holds:

1. [spark.sql.adaptive.coalescePartitions.enabled](../configuration-properties.md#spark.sql.adaptive.coalescePartitions.enabled) configuration property is disabled

1. The leaf physical operators are not all [QueryStageExec](../physical-operators/QueryStageExec.md)s (as it's not safe to reduce the number of shuffle partitions, because it may break the assumption that all children of a spark plan have same number of output partitions).

1. There is a [ShuffleExchangeLike](../physical-operators/ShuffleQueryStageExec.md#shuffle) among the [ShuffleQueryStageExec](../physical-operators/ShuffleQueryStageExec.md)s (of the given [SparkPlan](../physical-operators/SparkPlan.md)) that is not [supported](#isSupported)

`apply` [coalesces the partitions](../adaptive-query-execution/ShufflePartitionsUtil.md#coalescePartitions) (with the `MapOutputStatistics` and `ShufflePartitionSpec` of the `ShuffleStageInfo`s) based on the following settings:

* The minimum number of partitions being the default Spark parallelism with [spark.sql.adaptive.coalescePartitions.parallelismFirst](../SQLConf.md#COALESCE_PARTITIONS_PARALLELISM_FIRST) enabled or `1`

* [spark.sql.adaptive.advisoryPartitionSizeInBytes](../SQLConf.md#ADVISORY_PARTITION_SIZE_IN_BYTES) as the advisory target size of partitions

* [spark.sql.adaptive.coalescePartitions.minPartitionSize](../SQLConf.md#COALESCE_PARTITIONS_MIN_PARTITION_SIZE) as the minimum size of partitions

### <span id="updateShuffleReads"> updateShuffleReads

```scala
updateShuffleReads(
  plan: SparkPlan,
  specsMap: Map[Int, Seq[ShufflePartitionSpec]]): SparkPlan
```

`updateShuffleReads`...FIXME

## <span id="supportedShuffleOrigins"> Supported ShuffleOrigins

```scala
supportedShuffleOrigins: Seq[ShuffleOrigin]
```

`supportedShuffleOrigins` is the following `ShuffleOrigin`s:

* `ENSURE_REQUIREMENTS`
* `REPARTITION_BY_COL`
* `REBALANCE_PARTITIONS_BY_NONE`
* `REBALANCE_PARTITIONS_BY_COL`

`supportedShuffleOrigins` is part of the [AQEShuffleReadRule](AQEShuffleReadRule.md#supportedShuffleOrigins) abstraction.
