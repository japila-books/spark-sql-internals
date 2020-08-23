# OrderedDistribution

`OrderedDistribution` is a Distribution.md[Distribution] that...FIXME

[[requiredNumPartitions]]
`OrderedDistribution` specifies `None` for the Distribution.md#requiredNumPartitions[required number of partitions].

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

`createPartitioning`...FIXME

`createPartitioning` is part of the [Distribution](Distribution.md#createPartitioning) abstraction.
