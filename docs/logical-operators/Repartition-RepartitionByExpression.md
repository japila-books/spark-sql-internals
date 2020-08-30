# Repartition Logical Operators -- Repartition and RepartitionByExpression

<<Repartition, Repartition>> and <<RepartitionByExpression, RepartitionByExpression>> (*repartition operations* in short) are spark-sql-LogicalPlan.md#UnaryNode[unary logical operators] that create a new `RDD` that has exactly <<numPartitions, numPartitions>> partitions.

NOTE: `RepartitionByExpression` is also called *distribute* operator.

[[Repartition]]
<<Repartition, Repartition>> is the result of spark-sql-dataset-operators.md#coalesce[coalesce] or spark-sql-dataset-operators.md#repartition[repartition] (with no partition expressions defined) operators.

[source, scala]
----
val rangeAlone = spark.range(5)

scala> rangeAlone.rdd.getNumPartitions
res0: Int = 8

// Repartition the records

val withRepartition = rangeAlone.repartition(numPartitions = 5)

scala> withRepartition.rdd.getNumPartitions
res1: Int = 5

scala> withRepartition.explain(true)
== Parsed Logical Plan ==
Repartition 5, true
+- Range (0, 5, step=1, splits=Some(8))

// ...

== Physical Plan ==
Exchange RoundRobinPartitioning(5)
+- *Range (0, 5, step=1, splits=Some(8))

// Coalesce the records

val withCoalesce = rangeAlone.coalesce(numPartitions = 5)
scala> withCoalesce.explain(true)
== Parsed Logical Plan ==
Repartition 5, false
+- Range (0, 5, step=1, splits=Some(8))

// ...

== Physical Plan ==
Coalesce 5
+- *Range (0, 5, step=1, splits=Some(8))
----

[[RepartitionByExpression]]
<<RepartitionByExpression, RepartitionByExpression>> is the result of the following operators:

* spark-sql-dataset-operators.md#repartition[Dataset.repartition] operator (with explicit partition expressions defined)

* <<spark-sql-Dataset-typed-transformations.md#repartitionByRange, Dataset.repartitionByRange>>

* spark-sql-SparkSqlAstBuilder.md#withRepartitionByExpression[DISTRIBUTE BY] SQL clause.

[source, scala]
----
// RepartitionByExpression
// 1) Column-based partition expression only
scala> rangeAlone.repartition(partitionExprs = 'id % 2).explain(true)
== Parsed Logical Plan ==
'RepartitionByExpression [('id % 2)], 200
+- Range (0, 5, step=1, splits=Some(8))

// ...

== Physical Plan ==
Exchange hashpartitioning((id#10L % 2), 200)
+- *Range (0, 5, step=1, splits=Some(8))

// 2) Explicit number of partitions and partition expression
scala> rangeAlone.repartition(numPartitions = 2, partitionExprs = 'id % 2).explain(true)
== Parsed Logical Plan ==
'RepartitionByExpression [('id % 2)], 2
+- Range (0, 5, step=1, splits=Some(8))

// ...

== Physical Plan ==
Exchange hashpartitioning((id#10L % 2), 2)
+- *Range (0, 5, step=1, splits=Some(8))
----

`Repartition` and `RepartitionByExpression` logical operators are described by:

* [[shuffle]] `shuffle` flag
* [[numPartitions]] target number of partitions

!!! note
    [BasicOperators](../execution-planning-strategies/BasicOperators.md) strategy resolves `Repartition` to spark-sql-SparkPlan-ShuffleExchangeExec.md[ShuffleExchangeExec] (with [RoundRobinPartitioning](../physical-operators/Partitioning.md#RoundRobinPartitioning) partitioning scheme) or spark-sql-SparkPlan-CoalesceExec.md[CoalesceExec] physical operators per shuffle -- enabled or not, respectively.

!!! note
    [BasicOperators](../execution-planning-strategies/BasicOperators.md) strategy resolves `RepartitionByExpression` to spark-sql-SparkPlan-ShuffleExchangeExec.md[ShuffleExchangeExec] physical operator with [HashPartitioning](../physical-operators/Partitioning.md#HashPartitioning) partitioning scheme.

=== [[optimizations]] Repartition Operation Optimizations

* [CollapseRepartition](../catalyst/Optimizer.md#CollapseRepartition) logical optimization collapses adjacent repartition operations.

* Repartition operations allow [FoldablePropagation](../catalyst/Optimizer.md#FoldablePropagation) and spark-sql-Optimizer-PushDownPredicate.md[PushDownPredicate] logical optimizations to "push through".

* spark-sql-Optimizer-PropagateEmptyRelation.md[PropagateEmptyRelation] logical optimization may result in an empty spark-sql-LogicalPlan-LocalRelation.md[LocalRelation] for repartition operations.
