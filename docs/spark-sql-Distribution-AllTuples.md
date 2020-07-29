# AllTuples

[[requiredNumPartitions]]
`AllTuples` is a spark-sql-Distribution.md[Distribution] that indicates to use one partition only.

=== [[createPartitioning]] `createPartitioning` Method

[source, scala]
----
createPartitioning(numPartitions: Int): Partitioning
----

NOTE: `createPartitioning` is part of spark-sql-Distribution.md#createPartitioning[Distribution Contract] to create a spark-sql-SparkPlan-Partitioning.md[Partitioning] for a given number of partitions.

`createPartitioning`...FIXME
