# OptimizeSkewedJoin Adaptive Physical Optimization

`OptimizeSkewedJoin` is a [physical optimization](AQEShuffleReadRule.md) to [make data distribution more even](#apply) in [Adaptive Query Execution](../adaptive-query-execution/index.md).

`OptimizeSkewedJoin` is also called **skew join optimization**.

## <span id="getSkewThreshold"> Skew Threshold

```scala
getSkewThreshold(
  medianSize: Long): Long
```

`getSkewThreshold` is the maximum of the following:

1. [spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes](../configuration-properties.md#spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes)
1. [spark.sql.adaptive.skewJoin.skewedPartitionFactor](../configuration-properties.md#spark.sql.adaptive.skewJoin.skewedPartitionFactor) multiplied by the given `medianSize`

`getSkewThreshold` is used when:

* `OptimizeSkewedJoin` is requested to [tryOptimizeJoinChildren](#tryOptimizeJoinChildren)

## <span id="supportedJoinTypes"> Supported Join Types

`OptimizeSkewedJoin` supports the following join types:

* Inner
* Cross
* LeftSemi
* LeftAnti
* LeftOuter
* RightOuter

## Configuration Properties

`OptimizeSkewedJoin` uses the following configuration properties:

* [spark.sql.adaptive.skewJoin.enabled](../configuration-properties.md#spark.sql.adaptive.skewJoin.enabled)
* [spark.sql.adaptive.skewJoin.skewedPartitionFactor](../configuration-properties.md#spark.sql.adaptive.skewJoin.skewedPartitionFactor)
* [spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes](../configuration-properties.md#spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes)
* [spark.sql.adaptive.advisoryPartitionSizeInBytes](../configuration-properties.md#spark.sql.adaptive.advisoryPartitionSizeInBytes) 

## Creating Instance

`OptimizeSkewedJoin` takes the following to be created:

* <span id="conf"> [SQLConf](../SQLConf.md)

`OptimizeSkewedJoin` is created when:

* `AdaptiveSparkPlanExec` physical operator is requested for the [adaptive optimizations](../physical-operators/AdaptiveSparkPlanExec.md#queryStageOptimizerRules)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` uses [spark.sql.adaptive.skewJoin.enabled](../configuration-properties.md#spark.sql.adaptive.skewJoin.enabled) configuration property to determine whether to apply any optimizations or not.

`apply` collects [ShuffleQueryStageExec](../physical-operators/ShuffleQueryStageExec.md) physical operators.

!!! note
    `apply` does nothing and simply gives the query plan "untouched" when applied to a query plan with the number of [ShuffleQueryStageExec](../physical-operators/ShuffleQueryStageExec.md) physical operators different than `2`.

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

### <span id="optimizeSkewJoin"> Optimizing Skewed Joins

```scala
optimizeSkewJoin(
  plan: SparkPlan): SparkPlan
```

`optimizeSkewJoin` transforms the following physical operators:

* [SortMergeJoinExec](../physical-operators/SortMergeJoinExec.md) (of left and right [SortExec](../physical-operators/SortExec.md)s over `ShuffleStage` with [ShuffleQueryStageExec](../physical-operators/ShuffleQueryStageExec.md) and [isSkewJoin](../physical-operators/SortMergeJoinExec.md#isSkewJoin) disabled)
* [ShuffledHashJoinExec](../physical-operators/ShuffledHashJoinExec.md) (with left and right `ShuffleStage`s with [ShuffleQueryStageExec](../physical-operators/ShuffleQueryStageExec.md) and [isSkewJoin](../physical-operators/ShuffledHashJoinExec.md#isSkewJoin) disabled)

`optimizeSkewJoin` [tryOptimizeJoinChildren](#tryOptimizeJoinChildren) and, if a new join left and right child operators are determined, replaces them in the physical operators (with the `isSkewJoin` flag enabled).

### <span id="tryOptimizeJoinChildren"> tryOptimizeJoinChildren

```scala
tryOptimizeJoinChildren(
  left: ShuffleQueryStageExec,
  right: ShuffleQueryStageExec,
  joinType: JoinType): Option[(SparkPlan, SparkPlan)]
```

`tryOptimizeJoinChildren`...FIXME

## <span id="targetSize"> Target Partition Size

```scala
targetSize(
  sizes: Seq[Long],
  medianSize: Long): Long
```

`targetSize` determines the **target partition size** (to [optimize skewed join](#optimizeSkewJoin)) and is the greatest value among the following:

* [spark.sql.adaptive.advisoryPartitionSizeInBytes](../configuration-properties.md#spark.sql.adaptive.advisoryPartitionSizeInBytes) configuration property
* Average size of [non-skewed partitions](#isSkewed) (based on the given `medianSize`)

`targetSize` throws an `AssertionError` when all partitions are skewed (no non-skewed partitions).

## <span id="medianSize"> Median Partition Size

```scala
medianSize(
  sizes: Seq[Long]): Long
```

`medianSize`...FIXME

`medianSize` is used when:

* `OptimizeSkewedJoin` is requested to [tryOptimizeJoinChildren](#tryOptimizeJoinChildren)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.adaptive.OptimizeSkewedJoin` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.adaptive.OptimizeSkewedJoin=ALL
```

Refer to [Logging](../spark-logging.md).
