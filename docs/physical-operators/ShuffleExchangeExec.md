# ShuffleExchangeExec Physical Operator

`ShuffleExchangeExec` is an [Exchange](Exchange.md) (indirectly as a [ShuffleExchangeLike](ShuffleExchangeLike.md)) unary physical operator that is used to [perform a shuffle](#doExecute).

## Creating Instance

`ShuffleExchangeExec` takes the following to be created:

* <span id="outputPartitioning"> Output [Partitioning](Partitioning.md)
* <span id="child"> Child [physical operator](SparkPlan.md)
* <span id="shuffleOrigin"> [ShuffleOrigin](ShuffleExchangeLike.md#shuffleOrigin) (default: [ENSURE_REQUIREMENTS](ShuffleExchangeLike.md#ENSURE_REQUIREMENTS))

`ShuffleExchangeExec` is created when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed and plans the following:
  * [Repartition](../logical-operators/Repartition.md) with the [shuffle](../logical-operators/Repartition.md#shuffle) flag enabled
  * [RepartitionByExpression](../logical-operators/RepartitionByExpression.md)
* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization is executed

## <span id="nodeName"> Node Name

```scala
nodeName: String
```

`nodeName` is part of the [TreeNode](../catalyst/TreeNode.md) abstraction.

---

`nodeName` is **Exchange**.

## <span id="metrics"> Performance Metrics

![ShuffleExchangeExec in web UI (Details for Query)](../images/ShuffleExchangeExec-webui.png)

### <span id="dataSize"> data size

### <span id="numPartitions"> number of partitions

Number of partitions (of the `Partitioner` of this [ShuffleDependency](#prepareShuffleDependency))

Posted as the only entry in `accumUpdates` of a `SparkListenerDriverAccumUpdates`

### <span id="readMetrics"> Read Metrics

Used to create a [ShuffledRowRDD](../ShuffledRowRDD.md#metrics) when:

* [Executing](#doExecute)
* [getShuffleRDD](#getShuffleRDD)

#### <span id="fetchWaitTime"> fetch wait time

#### <span id="localBlocksFetched"> local blocks read

#### <span id="localBytesRead"> local bytes read

#### <span id="recordsRead"> records read

#### <span id="remoteBlocksFetched"> remote blocks read

#### <span id="remoteBytesRead"> remote bytes read

#### <span id="remoteBytesReadToDisk"> remote bytes read to disk

### <span id="writeMetrics"> Write Metrics

The write metrics are used to (passed directly to) [create a ShuffleDependency](#shuffleDependency) (that in turn is used to [create a ShuffleWriteProcessor](#createShuffleWriteProcessor))

#### <span id="shuffleBytesWritten"> shuffle bytes written

#### <span id="shuffleRecordsWritten"> shuffle records written

#### <span id="shuffleWriteTime"> shuffle write time

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

---

`doExecute` gives a [ShuffledRowRDD](../ShuffledRowRDD.md) (with the [ShuffleDependency](#shuffleDependency) and [read performance metrics](#readMetrics)).

`doExecute` uses [cachedShuffleRDD](#cachedShuffleRDD) to avoid multiple execution.

## <span id="serializer"> UnsafeRowSerializer

```scala
serializer: Serializer
```

`serializer` is an `UnsafeRowSerializer` with the following properties:

* Number of fields is the number of the [output attributes](../catalyst/QueryPlan.md#output) of the [child](#child) physical operator
* [dataSize](#metrics) performance metric

`serializer` is used when `ShuffleExchangeExec` operator is requested for a [ShuffleDependency](#shuffleDependency).

## <span id="cachedShuffleRDD"> ShuffledRowRDD

```scala
cachedShuffleRDD: ShuffledRowRDD
```

`cachedShuffleRDD` is an internal registry for the [ShuffledRowRDD](../ShuffledRowRDD.md) that `ShuffleExchangeExec` operator creates when [executed](#doExecute).

The purpose of `cachedShuffleRDD` is to avoid multiple [executions](#doExecute) of `ShuffleExchangeExec` operator when it is reused in a query plan:

* `cachedShuffleRDD` is uninitialized (`null`) when `ShuffleExchangeExec` operator is [created](#creating-instance)
* `cachedShuffleRDD` is assigned a `ShuffledRowRDD` when `ShuffleExchangeExec` operator is [executed](#doExecute) for the first time

## <span id="shuffleDependency"> ShuffleDependency

```scala
shuffleDependency: ShuffleDependency[Int, InternalRow, InternalRow]
```

`shuffleDependency` is a `ShuffleDependency` ([Spark Core]({{ book.spark_core }}/rdd/ShuffleDependency)).

??? note "Lazy Value"
    `shuffleDependency` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`ShuffleExchangeExec` operator [creates a ShuffleDependency](#prepareShuffleDependency) for the following:

* [Input RDD](#inputRDD)
* [Output attributes](../catalyst/QueryPlan.md#output) of the [child physical operator](#child)
* [Output partitioning](#outputPartitioning)
* [UnsafeRowSerializer](#serializer)
* [writeMetrics](#writeMetrics)

---

`shuffleDependency` is used when:

* `CustomShuffleReaderExec` physical operator is executed
* [OptimizeShuffleWithLocalRead](../physical-optimizations/OptimizeShuffleWithLocalRead.md) is requested to `getPartitionSpecs`
* [OptimizeSkewedJoin](../physical-optimizations/OptimizeSkewedJoin.md) physical optimization is executed
* `ShuffleExchangeExec` physical operator is [executed](#doExecute) and requested for [MapOutputStatistics](#mapOutputStatisticsFuture)

## <span id="mapOutputStatisticsFuture"> mapOutputStatisticsFuture

```scala
mapOutputStatisticsFuture: Future[MapOutputStatistics]
```

`mapOutputStatisticsFuture` requests the [inputRDD](#inputRDD) for the number of partitions:

* If there are zero partitions, `mapOutputStatisticsFuture` simply creates an already completed `Future` ([Scala]({{ scala.api }}/scala/concurrent/Future.html)) with `null` value

* Otherwise, `mapOutputStatisticsFuture` requests the operator's `SparkContext` to `submitMapStage` ([Spark Core]({{ book.spark_core }}/SparkContext#submitMapStage)) with the [ShuffleDependency](#shuffleDependency).

??? note "Lazy Value"
    `mapOutputStatisticsFuture` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`mapOutputStatisticsFuture` is part of the [ShuffleExchangeLike](ShuffleExchangeLike.md#mapOutputStatisticsFuture) abstraction.

## <span id="createShuffleWriteProcessor"> Creating ShuffleWriteProcessor

```scala
createShuffleWriteProcessor(
  metrics: Map[String, SQLMetric]): ShuffleWriteProcessor
```

`createShuffleWriteProcessor` creates a `ShuffleWriteProcessor` ([Spark Core]({{ book.spark_core }}/shuffle/ShuffleWriteProcessor)) to plug in `SQLShuffleWriteMetricsReporter` (as a `ShuffleWriteMetricsReporter` ([Spark Core]({{ book.spark_core }}/shuffle/ShuffleWriteMetricsReporter))) with the [write metrics](#writeMetrics).

---

`createShuffleWriteProcessor` is used when:

* `ShuffleExchangeExec` operator is [executed](#doExecute) (and requested for a [ShuffleDependency](#prepareShuffleDependency))

## <span id="runtimeStatistics"> Runtime Statistics

```scala
runtimeStatistics: Statistics
```

`runtimeStatistics` is part of the [ShuffleExchangeLike](ShuffleExchangeLike.md#runtimeStatistics) abstraction.

---

`runtimeStatistics` creates a [Statistics](../logical-operators/Statistics.md) with the value of the following metrics.

Statistics | Metric
-----------|-------
 [Output size](../logical-operators/Statistics.md#sizeInBytes) | [data size](#dataSize)
 [Number of rows](../logical-operators/Statistics.md#rowCount) | [shuffle records written](#shuffleRecordsWritten)

## <span id="prepareShuffleDependency"> Creating ShuffleDependency

```scala
prepareShuffleDependency(
  rdd: RDD[InternalRow],
  outputAttributes: Seq[Attribute],
  newPartitioning: Partitioning,
  serializer: Serializer,
  writeMetrics: Map[String, SQLMetric]): ShuffleDependency[Int, InternalRow, InternalRow]
```

`prepareShuffleDependency` is used when:

* [CollectLimitExec](CollectLimitExec.md), [ShuffleExchangeExec](#doExecute) and `TakeOrderedAndProjectExec` physical operators are executed

---

`prepareShuffleDependency` creates a `ShuffleDependency` ([Apache Spark]({{ book.spark_core }}/rdd/ShuffleDependency)) with the following:

* [rddWithPartitionIds](#prepareShuffleDependency-rddWithPartitionIds)
* `PartitionIdPassthrough` serializer (with the number of partitions as the [Partitioner](#prepareShuffleDependency-part))
* The input `Serializer` (e.g., the [UnsafeRowSerializer](#serializer) for `ShuffleExchangeExec` physical operators)
* [Write Metrics](#writeMetrics)

??? note "Write Metrics for ShuffleExchangeExec"
    For `ShuffleExchangeExec`s, the write metrics are the following:

    * [shuffle bytes written](#shuffleBytesWritten)
    * [shuffle records written](#shuffleRecordsWritten)
    * [shuffle write time](#shuffleWriteTime)

### <span id="prepareShuffleDependency-part"> Partitioner

`prepareShuffleDependency` determines a `Partitioner` based on the given `newPartitioning` [Partitioning](Partitioning.md):

* For [RoundRobinPartitioning](Partitioning.md#RoundRobinPartitioning), `prepareShuffleDependency` creates a `HashPartitioner` for the same number of partitions
* For [HashPartitioning](Partitioning.md#HashPartitioning), `prepareShuffleDependency` creates a `Partitioner` for the same number of partitions and `getPartition` that is an "identity"
* For `RangePartitioning`, `prepareShuffleDependency` creates a `RangePartitioner` for the same number of partitions and `samplePointsPerPartitionHint` based on [spark.sql.execution.rangeExchange.sampleSizePerPartition](../configuration-properties.md#spark.sql.execution.rangeExchange.sampleSizePerPartition) configuration property
* For [SinglePartition](Partitioning.md#SinglePartition), `prepareShuffleDependency` creates a `Partitioner` with `1` for the number of partitions and `getPartition` that always gives `0`

### <span id="prepareShuffleDependency-getPartitionKeyExtractor"> getPartitionKeyExtractor

```scala
getPartitionKeyExtractor(): InternalRow => Any
```

`getPartitionKeyExtractor` uses the given `newPartitioning` [Partitioning](Partitioning.md):

* For [RoundRobinPartitioning](Partitioning.md#RoundRobinPartitioning),...FIXME
* For [HashPartitioning](Partitioning.md#HashPartitioning),...FIXME
* For `RangePartitioning`,...FIXME
* For [SinglePartition](Partitioning.md#SinglePartition),...FIXME

### <span id="prepareShuffleDependency-isRoundRobin"> isRoundRobin Flag

`prepareShuffleDependency` determines whether "this" is `isRoundRobin` or not based on the given `newPartitioning` partitioning. It is `isRoundRobin` when the partitioning is a `RoundRobinPartitioning` with more than one partition.

### <span id="prepareShuffleDependency-rddWithPartitionIds"> rddWithPartitionIds RDD

`prepareShuffleDependency` creates a `rddWithPartitionIds`:

1. Firstly, `prepareShuffleDependency` determines a `newRdd` based on `isRoundRobin` flag and [spark.sql.execution.sortBeforeRepartition](../configuration-properties.md#spark.sql.execution.sortBeforeRepartition) configuration property. When both are enabled (`true`), `prepareShuffleDependency` sorts partitions (using a `UnsafeExternalRowSorter`) Otherwise, `prepareShuffleDependency` returns the given `RDD[InternalRow]` (unchanged).
1. Secondly, `prepareShuffleDependency` determines whether this is `isOrderSensitive` or not. This is `isOrderSensitive` when `isRoundRobin` flag is enabled (`true`) while [spark.sql.execution.sortBeforeRepartition](../configuration-properties.md#spark.sql.execution.sortBeforeRepartition) configuration property is not (`false`).

`prepareShuffleDependency`...FIXME

## Demo

### ShuffleExchangeExec and Repartition Logical Operator

```text
val q = spark.range(6).repartition(2)
scala> q.explain(extended = true)
== Parsed Logical Plan ==
Repartition 2, true
+- Range (0, 6, step=1, splits=Some(16))

== Analyzed Logical Plan ==
id: bigint
Repartition 2, true
+- Range (0, 6, step=1, splits=Some(16))

== Optimized Logical Plan ==
Repartition 2, true
+- Range (0, 6, step=1, splits=Some(16))

== Physical Plan ==
Exchange RoundRobinPartitioning(2), false, [id=#8]
+- *(1) Range (0, 6, step=1, splits=16)
```

### ShuffleExchangeExec and RepartitionByExpression Logical Operator

```text
val q = spark.range(6).repartition(2, 'id % 2)
scala> q.explain(extended = true)
== Parsed Logical Plan ==
'RepartitionByExpression [('id % 2)], 2
+- Range (0, 6, step=1, splits=Some(16))

== Analyzed Logical Plan ==
id: bigint
RepartitionByExpression [(id#4L % cast(2 as bigint))], 2
+- Range (0, 6, step=1, splits=Some(16))

== Optimized Logical Plan ==
RepartitionByExpression [(id#4L % 2)], 2
+- Range (0, 6, step=1, splits=Some(16))

== Physical Plan ==
Exchange hashpartitioning((id#4L % 2), 2), false, [id=#17]
+- *(1) Range (0, 6, step=1, splits=16)
```
