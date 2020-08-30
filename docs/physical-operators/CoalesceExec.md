title: CoalesceExec

# CoalesceExec Unary Physical Operator

`CoalesceExec` is a SparkPlan.md#UnaryExecNode[unary physical operator] (i.e. with one <<child, child>> physical operator) to...FIXME...with `numPartitions` number of partitions and a `child` spark plan.

`CoalesceExec` represents [Repartition](../logical-operators/RepartitionOperation.md#Repartition) logical operator at execution (when `shuffle` was disabled -- see [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy). When executed, it executes the input `child` and calls spark-rdd-partitions.md#coalesce[coalesce] on the result RDD (with `shuffle` disabled).

Please note that since physical operators present themselves without the suffix _Exec_, `CoalesceExec` is the `Coalesce` in the Physical Plan section in the following example:

[source, scala]
----
scala> df.rdd.getNumPartitions
res6: Int = 8

scala> df.coalesce(1).rdd.getNumPartitions
res7: Int = 1

scala> df.coalesce(1).explain(extended = true)
== Parsed Logical Plan ==
Repartition 1, false
+- LocalRelation [value#1]

== Analyzed Logical Plan ==
value: int
Repartition 1, false
+- LocalRelation [value#1]

== Optimized Logical Plan ==
Repartition 1, false
+- LocalRelation [value#1]

== Physical Plan ==
Coalesce 1
+- LocalTableScan [value#1]
----

`output` collection of spark-sql-Expression-Attribute.md[Attribute] matches the ``child``'s (since `CoalesceExec` is about changing the number of partitions not the internal representation).

`outputPartitioning` returns a [SinglePartition](Partitioning.md#SinglePartition) when the input `numPartitions` is `1` while a [UnknownPartitioning](Partitioning.md#UnknownPartitioning) partitioning scheme for the other cases.
