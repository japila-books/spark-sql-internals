# HashPartitioning

`HashPartitioning` is a [Catalyst Partitioning](../physical-operators/Partitioning.md) in which rows are distributed across partitions using the [MurMur3 hash](#partitionIdExpression) (of the [partitioning expressions](#expressions)) modulo the [number of partitions](#numPartitions).

`HashPartitioning` is an [Expression](Expression.md) that computes the [partition Id](#partitionIdExpression) for data distribution to be consistent across shuffling and bucketing (for joins of bucketed and regular tables).

## Creating Instance

`HashPartitioning` takes the following to be created:

* <span id="expressions"> Partitioning [Expression](Expression.md)s
* <span id="numPartitions"> Number of partitions

`HashPartitioning` is created when:

* `RepartitionByExpression` is requested for the [partitioning](../logical-operators/RepartitionOperation.md#partitioning)
* `RebalancePartitions` is requested for the [partitioning](../logical-operators/RebalancePartitions.md#partitioning)
* `ClusteredDistribution` is requested to [create a Partitioning](../physical-operators/ClusteredDistribution.md)
* `HashClusteredDistribution` is requested to [create a Partitioning](../physical-operators/HashClusteredDistribution.md)
* `FileSourceScanExec` physical operator is requested for the [output partitioning](../physical-operators/FileSourceScanExec.md#outputPartitioning)
* `BucketingUtils` utility is used to `getBucketIdFromValue`
* `FileFormatWriter` utility is used to [write out a query result](../files/FileFormatWriter.md#write) (with a bucketing spec)
* `BroadcastHashJoinExec` physical operator is requested to [expandOutputPartitioning](../physical-operators/BroadcastHashJoinExec.md#expandOutputPartitioning)

## <span id="Unevaluable"> Unevaluable

`HashPartitioning` is an [Unevaluable](Unevaluable.md) expression.

## <span id="satisfies0"> Satisfying Distribution

```scala
satisfies0(
  required: Distribution): Boolean
```

`satisfies0` is positive (`true`) when either the base [satisfies0](../physical-operators/Partitioning.md#satisfies0) holds or one of the given [Distribution](../physical-operators/Distribution.md) satisfies the following:

* For a [HashClusteredDistribution](../physical-operators/HashClusteredDistribution.md), the number of the given [partitioning expressions](#expressions) and the [HashClusteredDistribution](../physical-operators/HashClusteredDistribution.md#expressions)'s are the same and [semantically equal](Expression.md#semanticEquals) pair-wise

* For a [ClusteredDistribution](../physical-operators/ClusteredDistribution.md), the given [partitioning expressions](#expressions) are among the [clustering expressions](../physical-operators/ClusteredDistribution.md#clustering) (of the ClusteredDistribution) and they are [semantically equal](Expression.md#semanticEquals) pair-wise

Otherwise, `satisfies0` is negative (`false`).

`satisfies0` is part of the [Partitioning](../physical-operators/Partitioning.md#satisfies0) abstraction.

## <span id="partitionIdExpression"> PartitionId Expression

```scala
partitionIdExpression: Expression
```

`partitionIdExpression` gives an [Expression](Expression.md) that produces a valid partition ID.

`partitionIdExpression` is a `Pmod` expression of a [Murmur3Hash](Murmur3Hash.md) (with the [partitioning expressions](#expressions)) and a [Literal](Literal.md) (with the [number of partitions](#numPartitions)).

`partitionIdExpression` is used when:

* `BucketingUtils` utility is used to `getBucketIdFromValue`
* `FileFormatWriter` utility is used to [write out a query result](../files/FileFormatWriter.md#write) (with a bucketing spec)
* `ShuffleExchangeExec` utility is used to [prepare a ShuffleDependency](../physical-operators/ShuffleExchangeExec.md#prepareShuffleDependency)

## Demo

```text
val nums = spark.range(5)
val numParts = 200 // the default number of partitions
val partExprs = Seq(nums("id"))

val partitionIdExpression = pmod(hash(partExprs: _*), lit(numParts))
scala> partitionIdExpression.explain(extended = true)
pmod(hash(id#32L, 42), 200)

val q = nums.withColumn("partitionId", partitionIdExpression)
```

```text
scala> q.show
+---+-----------+
| id|partitionId|
+---+-----------+
|  0|          5|
|  1|         69|
|  2|        128|
|  3|        107|
|  4|        140|
+---+-----------+
```
