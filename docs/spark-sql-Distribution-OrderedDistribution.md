# OrderedDistribution

`OrderedDistribution` is a spark-sql-Distribution.md[Distribution] that...FIXME

[[requiredNumPartitions]]
`OrderedDistribution` specifies `None` for the spark-sql-Distribution.md#requiredNumPartitions[required number of partitions].

NOTE: `None` for the required number of partitions indicates to use any number of partitions (possibly spark-sql-properties.md#spark.sql.shuffle.partitions[spark.sql.shuffle.partitions] configuration property with the default of `200` partitions).

`OrderedDistribution` is <<creating-instance, created>> when...FIXME

[[creating-instance]]
[[ordering]]
`OrderedDistribution` takes `SortOrder` expressions for ordering when created.

`OrderedDistribution` requires that the <<ordering, ordering expressions>> should not be empty (i.e. `Nil`).

=== [[createPartitioning]] `createPartitioning` Method

[source, scala]
----
createPartitioning(numPartitions: Int): Partitioning
----

NOTE: `createPartitioning` is part of spark-sql-Distribution.md#createPartitioning[Distribution Contract] to create a spark-sql-SparkPlan-Partitioning.md[Partitioning] for a given number of partitions.

`createPartitioning`...FIXME
