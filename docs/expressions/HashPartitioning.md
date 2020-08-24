# HashPartitioning

[[Partitioning]]
`HashPartitioning` is a [Partitioning](../physical-operators/Partitioning.md) in which rows are distributed across partitions based on the <<partitionIdExpression, MurMur3 hash>> of <<expressions, partitioning expressions>> (modulo the <<numPartitions, number of partitions>>).

[[creating-instance]]
`HashPartitioning` takes the following to be created:

* [[expressions]] Partitioning expressions/Expression.md[expressions]
* [[numPartitions]] Number of partitions

[[Unevaluable]][[Expression]]
`HashPartitioning` is an [Unevaluable Expression](Unevaluable.md) that expressions/Expression.md#[cannot be evaluated] (and produce a value given an internal row).

`HashPartitioning` uses the spark-sql-Expression-Murmur3Hash.md[MurMur3 Hash] to compute the <<partitionIdExpression, partitionId>> for data distribution (consistent for shuffling and bucketing that is crucial for joins of bucketed and regular tables).

[source, scala]
----
val nums = spark.range(5)
val numParts = 200 // the default number of partitions
val partExprs = Seq(nums("id"))

val partitionIdExpression = pmod(hash(partExprs: _*), lit(numParts))
scala> partitionIdExpression.explain(extended = true)
pmod(hash(id#32L, 42), 200)

val q = nums.withColumn("partitionId", partitionIdExpression)
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
----

=== [[satisfies0]] `satisfies0` Method

[source, scala]
----
satisfies0(
  required: Distribution): Boolean
----

`satisfies0` is positive (`true`) when the following conditions all hold:

* The base [satisfies0](../physical-operators/Partitioning.md#satisfies0) holds

* For an input [HashClusteredDistribution](../physical-operators/HashClusteredDistribution.md), the number of the given <<expressions, partitioning expressions>> and the [HashClusteredDistribution's](../physical-operators/HashClusteredDistribution.md#expressions) are the same and [semantically equal](Expression.md#semanticEquals) pair-wise

* For an input [ClusteredDistribution](../physical-operators/ClusteredDistribution.md), the given <<expressions, partitioning expressions>> are among the [ClusteredDistribution's clustering expressions](../physical-operators/ClusteredDistribution.md#clustering) and they are [semantically equal](Expression.md#semanticEquals) pair-wise

Otherwise, `satisfies0` is negative (`false`).

`satisfies0` is part of the [Partitioning](../physical-operators/Partitioning.md#satisfies0) abstraction.

=== [[partitionIdExpression]] `partitionIdExpression` Method

[source, scala]
----
partitionIdExpression: Expression
----

`partitionIdExpression` creates (_returns_) a `Pmod` expression of a spark-sql-Expression-Murmur3Hash.md[Murmur3Hash] (with the <<expressions, partitioning expressions>>) and a spark-sql-Expression-Literal.md[Literal] (with the <<numPartitions, number of partitions>>).

[NOTE]
====
`partitionIdExpression` is used when:

* `BucketingUtils` utility is used for `getBucketIdFromValue` (for bucketing support)

* `FileFormatWriter` utility is used for spark-sql-FileFormatWriter.md#write[writing the result of a structured query out] (for bucketing support)

* `ShuffleExchangeExec` utility is used to spark-sql-SparkPlan-ShuffleExchangeExec.md#prepareShuffleDependency[prepare a ShuffleDependency]
====
