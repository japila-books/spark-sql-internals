# OptimizeSkewedJoin Physical Optimization

`OptimizeSkewedJoin` is a physical query plan optimization to [make data distribution more even](#apply) in [Adaptive Query Execution](index.md).

`OptimizeSkewedJoin` is a [AQEShuffleReadRule](AQEShuffleReadRule.md).

`OptimizeSkewedJoin` is also called **skew join optimization**.

`OptimizeSkewedJoin` is a [Catalyst rule](../catalyst/Rule.md) for transforming [physical plans](../physical-operators/SparkPlan.md) (`Rule[SparkPlan]`).

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

`OptimizeSkewedJoin` is created when `AdaptiveSparkPlanExec` physical operator is requested for the [adaptive optimizations](../adaptive-query-execution/AdaptiveSparkPlanExec.md#queryStageOptimizerRules).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` uses [spark.sql.adaptive.skewJoin.enabled](../configuration-properties.md#spark.sql.adaptive.skewJoin.enabled) configuration property to determine whether to apply any optimizations or not.

`apply` collects [ShuffleQueryStageExec](../adaptive-query-execution/ShuffleQueryStageExec.md) physical operators.

!!! note
    `apply` does nothing and simply gives the query plan "untouched" when applied to a query plan with the number of [ShuffleQueryStageExec](../adaptive-query-execution/ShuffleQueryStageExec.md) physical operators different than `2`.

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

## <span id="optimizeSkewJoin"> Optimizing Skewed Joins

```scala
optimizeSkewJoin(
  plan: SparkPlan): SparkPlan
```

`optimizeSkewJoin` transforms [SortMergeJoinExec](../physical-operators/SortMergeJoinExec.md) physical operators (with the [supportedJoinTypes](#supportedJoinTypes)) of two [SortExec](../physical-operators/SortExec.md) operators with [ShuffleQueryStageExec](../adaptive-query-execution/ShuffleQueryStageExec.md) children.

`optimizeSkewJoin` handles `SortMergeJoinExec` operators with the left and right operators of the same number of partitions.

`optimizeSkewJoin` computes [median partition size](#medianSize) for the left and right operators.

`optimizeSkewJoin` prints out the following DEBUG message to the logs:

```text
Optimizing skewed join.
Left side partitions size info:
[info]
Right side partitions size info:
[info]
```

`optimizeSkewJoin`...FIXME

`optimizeSkewJoin` prints out the following DEBUG message to the logs:

```text
number of skewed partitions: left [numPartitions], right [numPartitions]
```

In the end, `optimizeSkewJoin` creates [CustomShuffleReaderExec](../physical-operators/CustomShuffleReaderExec.md) physical operators for the left and right children of the [SortMergeJoinExec](../physical-operators/SortMergeJoinExec.md) operator if and only if the number of skewed partitions for either side is greater than `0`. `optimizeSkewJoin` turns on the [isSkewJoin](../physical-operators/SortMergeJoinExec.md#isSkewJoin) flag (of the `SortMergeJoinExec` operator). Otherwise, `optimizeSkewJoin` leaves the `SortMergeJoinExec` operator "untouched".

## <span id="isSkewed"> isSkewed Predicate

```scala
isSkewed(
  size: Long,
  medianSize: Long): Boolean
```

`isSkewed` is on (`true`) when the given `size` is greater than all of the following:

* [spark.sql.adaptive.skewJoin.skewedPartitionFactor](../configuration-properties.md#spark.sql.adaptive.skewJoin.skewedPartitionFactor) configuration property multiplied by the given `medianSize`
* [spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes](../configuration-properties.md#spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes) configuration property

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

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.adaptive.OptimizeSkewedJoin` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.adaptive.OptimizeSkewedJoin=ALL
```

Refer to [Logging](../spark-logging.md).
