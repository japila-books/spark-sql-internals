# HashClusteredDistribution

`HashClusteredDistribution` is a spark-sql-Distribution.md[Distribution] that <<createPartitioning, creates a HashPartitioning>> for the <<expressions, hash expressions>> and a requested number of partitions.

[[requiredNumPartitions]]
`HashClusteredDistribution` specifies `None` for the spark-sql-Distribution.md#requiredNumPartitions[required number of partitions].

NOTE: `None` for the required number of partitions indicates to use any number of partitions (possibly spark-sql-properties.md#spark.sql.shuffle.partitions[spark.sql.shuffle.partitions] configuration property with the default of `200` partitions).

`HashClusteredDistribution` is <<creating-instance, created>> when the following physical operators are requested for the SparkPlan.md#requiredChildDistribution[required partition requirements of the child operator(s)] (e.g. spark-sql-SparkPlan-CoGroupExec.md[CoGroupExec], spark-sql-SparkPlan-ShuffledHashJoinExec.md[ShuffledHashJoinExec], spark-sql-SparkPlan-SortMergeJoinExec.md[SortMergeJoinExec] and Spark Structured Streaming's `StreamingSymmetricHashJoinExec`).

[[creating-instance]][[expressions]]
`HashClusteredDistribution` takes hash expressions/Expression.md[expressions] when created.

`HashClusteredDistribution` requires that the <<expressions, hash expressions>> should not be empty (i.e. `Nil`).

`HashClusteredDistribution` is used when:

* [EnsureRequirements](physical-optimizations/EnsureRequirements.md) is executed (for Adaptive Query Execution)

* `HashPartitioning` is requested to `satisfies`

=== [[createPartitioning]] `createPartitioning` Method

[source, scala]
----
createPartitioning(
  numPartitions: Int): Partitioning
----

NOTE: `createPartitioning` is part of spark-sql-Distribution.md#createPartitioning[Distribution Contract] to create a spark-sql-SparkPlan-Partitioning.md[Partitioning] for a given number of partitions.

`createPartitioning` creates a `HashPartitioning` for the <<expressions, hash expressions>> and the input `numPartitions`.
