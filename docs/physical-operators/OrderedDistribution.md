# OrderedDistribution

`OrderedDistribution` is a [Distribution](Distribution.md).

[[requiredNumPartitions]]
`OrderedDistribution` specifies `None` for the Distribution.md#requiredNumPartitions[required number of partitions].

!!! note
    `None` for the required number of partitions indicates to use any number of partitions (possibly [spark.sql.shuffle.partitions](../configuration-properties.md#spark.sql.shuffle.partitions) configuration property).

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
