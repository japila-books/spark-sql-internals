# ShuffleExchangeLike Physical Operators

`ShuffleExchangeLike` is an [extension](#contract) of the [Exchange](Exchange.md) abstraction for [physical operators](#implementations) that...FIXME

## Contract

### <span id="getShuffleRDD"> getShuffleRDD

```scala
getShuffleRDD(
  partitionSpecs: Array[ShufflePartitionSpec]): RDD[_]
```

`RDD` ([Spark Core]({{ book.spark_core }}/rdd/RDD))

Used when:

* `CustomShuffleReaderExec` physical operator is requested for the shuffleRDD

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

* `OptimizeShuffleWithLocalRead` physical optimization is requested for the [shuffle partition specification](../adaptive-query-execution/OptimizeShuffleWithLocalRead.md#getPartitionSpecs)

### <span id="numPartitions"> Number of Partitions

```scala
numPartitions: Int
```

Used when:

* `OptimizeShuffleWithLocalRead` physical optimization is requested for the [shuffle partition specification](../adaptive-query-execution/OptimizeShuffleWithLocalRead.md#getPartitionSpecs)

### <span id="runtimeStatistics"> runtimeStatistics

```scala
runtimeStatistics: Statistics
```

Used when:

* `ShuffleQueryStageExec` physical operator is requested for [runtime statistics](../adaptive-query-execution/ShuffleQueryStageExec.md)

### <span id="shuffleOrigin"> ShuffleOrigin

```scala
shuffleOrigin: ShuffleOrigin
```

[ShuffleOrigin](ShuffleOrigin.md)

Used when:

* `AdaptiveSparkPlanExec` physical operator is requested for the [finalStageOptimizerRules](../adaptive-query-execution/AdaptiveSparkPlanExec.md#finalStageOptimizerRules)
* `CoalesceShufflePartitions` physical optimization is requested to [supportCoalesce](../adaptive-query-execution/CoalesceShufflePartitions.md#supportCoalesce)
* `OptimizeShuffleWithLocalRead` physical optimization is requested to [supportLocalReader](../adaptive-query-execution/OptimizeShuffleWithLocalRead.md#supportLocalReader)
* `ShuffleStage` utility is used to [destructure a SparkPlan to a ShuffleStageInfo](../adaptive-query-execution/ShuffleStage.md#supportLocalReader)

## Implementations

* [ShuffleExchangeExec](ShuffleExchangeExec.md)

## <span id="submitShuffleJob"> Submitting Shuffle Job

```scala
submitShuffleJob: Future[MapOutputStatistics]
```

`submitShuffleJob` [executes a query](SparkPlan.md#executeQuery) with the [mapOutputStatisticsFuture](#mapOutputStatisticsFuture).

??? note "Final Method"
    `submitShuffleJob` is a Scala **final method** and may not be overridden in [subclasses](#implementations).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#final).

`submitShuffleJob` is used when:

* `ShuffleQueryStageExec` adaptive leaf physical operator is requested for the [shuffleFuture](../adaptive-query-execution/ShuffleQueryStageExec.md#shuffleFuture)