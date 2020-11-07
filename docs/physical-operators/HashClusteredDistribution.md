# HashClusteredDistribution

`HashClusteredDistribution` is a Distribution.md[Distribution] that <<createPartitioning, creates a HashPartitioning>> for the <<expressions, hash expressions>> and a requested number of partitions.

[[requiredNumPartitions]]
`HashClusteredDistribution` specifies `None` for the Distribution.md#requiredNumPartitions[required number of partitions].

!!! note
    `None` for the required number of partitions indicates to use any number of partitions (possibly [spark.sql.shuffle.partitions](../configuration-properties.md#spark.sql.shuffle.partitions) configuration property).

`HashClusteredDistribution` is <<creating-instance, created>> when the following physical operators are requested for the SparkPlan.md#requiredChildDistribution[required partition requirements of the child operator(s)] (e.g. CoGroupExec.md[CoGroupExec], ShuffledHashJoinExec.md[ShuffledHashJoinExec], SortMergeJoinExec.md[SortMergeJoinExec] and Spark Structured Streaming's `StreamingSymmetricHashJoinExec`).

[[creating-instance]][[expressions]]
`HashClusteredDistribution` takes hash expressions/Expression.md[expressions] when created.

`HashClusteredDistribution` requires that the <<expressions, hash expressions>> should not be empty (i.e. `Nil`).

`HashClusteredDistribution` is used when:

* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) is executed (for Adaptive Query Execution)

* `HashPartitioning` is requested to `satisfies`

=== [[createPartitioning]] `createPartitioning` Method

[source, scala]
----
createPartitioning(
  numPartitions: Int): Partitioning
----

`createPartitioning` creates a `HashPartitioning` for the <<expressions, hash expressions>> and the input `numPartitions`.

`createPartitioning` is part of the [Distribution](Distribution.md#createPartitioning) abstraction.
