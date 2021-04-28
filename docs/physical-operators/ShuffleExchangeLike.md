# ShuffleExchangeLike Physical Operators

`ShuffleExchangeLike` is an [extension](#contract) of the [Exchange](Exchange.md) abstraction for [physical operators](#implementations) that...FIXME

## Contract

### <span id="getShuffleRDD"> getShuffleRDD

```scala
getShuffleRDD(
  partitionSpecs: Array[ShufflePartitionSpec]): RDD[_]
```

Used when:

* `CustomShuffleReaderExec` physical operator is requested for the [shuffleRDD](CustomShuffleReaderExec.md#shuffleRDD)

### <span id="mapOutputStatisticsFuture"> mapOutputStatisticsFuture

```scala
mapOutputStatisticsFuture: Future[MapOutputStatistics]
```

Used when:

* `ShuffleQueryStageExec` physical operator is requested to [doMaterialize](../adaptive-query-execution/ShuffleQueryStageExec.md#doMaterialize) and [cancel](../adaptive-query-execution/ShuffleQueryStageExec.md#cancel)

### <span id="numMappers"> numMappers

```scala
numMappers: Int
```

Used when:

* `OptimizeLocalShuffleReader` physical optimization is requested for the [shuffle partition specification](../physical-optimizations/OptimizeLocalShuffleReader.md#getPartitionSpecs)

### <span id="numPartitions"> numPartitions

```scala
numPartitions: Int
```

Used when:

* `OptimizeLocalShuffleReader` physical optimization is requested for the [shuffle partition specification](../physical-optimizations/OptimizeLocalShuffleReader.md#getPartitionSpecs)

### <span id="runtimeStatistics"> runtimeStatistics

```scala
runtimeStatistics: Statistics
```

Used when:

* `ShuffleQueryStageExec` physical operator is requested for [runtime statistics](../adaptive-query-execution/ShuffleQueryStageExec.md)

### <span id="shuffleOrigin"> shuffleOrigin

```scala
shuffleOrigin: ShuffleOrigin
```

Used when:

* `AdaptiveSparkPlanExec` physical operator is requested for the [finalStageOptimizerRules](../adaptive-query-execution/AdaptiveSparkPlanExec.md#finalStageOptimizerRules)
* `CoalesceShufflePartitions` physical optimization is requested to [supportCoalesce](../physical-optimizations/CoalesceShufflePartitions.md#supportCoalesce)
* `OptimizeLocalShuffleReader` physical optimization is requested to [supportLocalReader](../physical-optimizations/OptimizeLocalShuffleReader.md#supportLocalReader)
* `ShuffleStage` utility is used to [destructure a SparkPlan to a ShuffleStageInfo](../adaptive-query-execution/ShuffleStage.md#supportLocalReader)

## Implementations

* [ShuffleExchangeExec](ShuffleExchangeExec.md)
