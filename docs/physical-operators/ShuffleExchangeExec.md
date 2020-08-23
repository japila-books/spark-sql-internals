# ShuffleExchangeExec Unary Physical Operator

`ShuffleExchangeExec` is an [Exchange](Exchange.md) unary physical operator that is used to [perform a shuffle](#doExecute).

`ShuffleExchangeExec` [presents itself](#nodeName) as **Exchange** in physical query plans.

## Creating Instance

`ShuffleExchangeExec` takes the following to be created:

* <span id="outputPartitioning"> Output [Partitioning](../spark-sql-SparkPlan-Partitioning.md)
* <span id="child"> Child [physical operator](SparkPlan.md)
* <span id="canChangeNumPartitions"> `canChangeNumPartitions` flag (default: `true`)

`ShuffleExchangeExec` is created when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (and plans [Repartition](../logical-operators/Repartition-RepartitionByExpression.md) with the [shuffle](../logical-operators/Repartition-RepartitionByExpression.md#shuffle) flag enabled or [RepartitionByExpression](../logical-operators/Repartition-RepartitionByExpression.md))

* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization is executed

## <span id="nodeName"> Node Name

```scala
nodeName: String
```

`nodeName` is always **Exchange**.

`nodeName` is part of the [TreeNode](../catalyst/TreeNode.md) abstraction.

## <span id="metrics"><span id="writeMetrics"><span id="readMetrics"> Performance Metrics

Key | Name (in web UI) | Description
---------|----------|---------
dataSize | data size | C1

![ShuffleExchangeExec in web UI (Details for Query)](../images/ShuffleExchangeExec-webui.png)

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` gives a [ShuffledRowRDD](../ShuffledRowRDD.md) for the [ShuffleDependency](#shuffleDependency) and [read performance metrics](#readMetrics).

`doExecute` uses [cachedShuffleRDD](#cachedShuffleRDD) to avoid multiple execution.

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

## <span id="prepareShuffleDependency"> Creating ShuffleDependency

```scala
prepareShuffleDependency(
  rdd: RDD[InternalRow],
  outputAttributes: Seq[Attribute],
  newPartitioning: Partitioning,
  serializer: Serializer,
  writeMetrics: Map[String, SQLMetric]): ShuffleDependency[Int, InternalRow, InternalRow]
```

`prepareShuffleDependency` creates a Spark Core `ShuffleDependency` with a `RDD[Product2[Int, InternalRow]]` (where `Ints` are partition IDs of the `InternalRows` values) and the given `Serializer` (e.g. the <<serializer, Serializer>> of the `ShuffleExchangeExec` physical operator).

Internally, `prepareShuffleDependency`...FIXME

`prepareShuffleDependency` is used when:

* [CollectLimitExec](CollectLimitExec.md), <<doExecute, ShuffleExchangeExec>> and TakeOrderedAndProjectExec physical operators are executed

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

`shuffleDependency` is a Spark Core `ShuffleDependency`.

??? note "shuffleDependency lazy value"
    `shuffleDependency` is a Scala lazy value which is computed once when accessed and cached afterwards.

`ShuffleExchangeExec` operator [creates a ShuffleDependency](#prepareShuffleDependency) for the following:

* [RDD[InternalRow]](#inputRDD)
* [Output attributes](../catalyst/QueryPlan.md#output) of the [child physical operator](#child)
* [Output partitioning](#outputPartitioning)
* [UnsafeRowSerializer](#serializer)
* [writeMetrics](#writeMetrics)

`shuffleDependency` is used when:

* [CustomShuffleReaderExec](CustomShuffleReaderExec.md) physical operator is executed
* [OptimizeLocalShuffleReader](../physical-optimizations/OptimizeLocalShuffleReader.md) is requested to `getPartitionSpecs`
* [OptimizeSkewedJoin](../physical-optimizations/OptimizeSkewedJoin.md) physical optimization is executed
* `ShuffleExchangeExec` physical operator is [executed](#doExecute) and requested for [MapOutputStatistics](#mapOutputStatisticsFuture)

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
