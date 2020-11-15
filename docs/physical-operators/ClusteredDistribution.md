# ClusteredDistribution

`ClusteredDistribution` is a [Distribution](Distribution.md) that <<createPartitioning, creates a HashPartitioning>> for the <<clustering, clustering expressions>> and a requested number of partitions.

`ClusteredDistribution` requires that the <<clustering, clustering expressions>> should not be empty (i.e. `Nil`).

`ClusteredDistribution` is <<creating-instance, created>> when the following physical operators are requested for a required child distribution:

* `MapGroupsExec`, [HashAggregateExec](HashAggregateExec.md#requiredChildDistribution), [ObjectHashAggregateExec](ObjectHashAggregateExec.md#requiredChildDistribution), [SortAggregateExec](SortAggregateExec.md#requiredChildDistribution), [WindowExec](WindowExec.md#requiredChildDistribution)

* Spark Structured Streaming's `FlatMapGroupsWithStateExec`, `StateStoreRestoreExec`, `StateStoreSaveExec`, `StreamingDeduplicateExec`, `StreamingSymmetricHashJoinExec`, `StreamingSymmetricHashJoinExec`

* SparkR's `FlatMapGroupsInRExec`

* PySpark's `FlatMapGroupsInPandasExec`

`ClusteredDistribution` is used when:

* `DataSourcePartitioning`, `SinglePartition`, `HashPartitioning`, and `RangePartitioning` are requested to `satisfies`

* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) is executed for Adaptive Query Execution

=== [[createPartitioning]] `createPartitioning` Method

[source, scala]
----
createPartitioning(numPartitions: Int): Partitioning
----

`createPartitioning` creates a `HashPartitioning` for the <<clustering, clustering expressions>> and the input `numPartitions`.

`createPartitioning` reports an `AssertionError` when the <<requiredNumPartitions, number of partitions>> is not the input `numPartitions`.

[options="wrap"]
```
This ClusteredDistribution requires [requiredNumPartitions] partitions, but the actual number of partitions is [numPartitions].
```

`createPartitioning` is part of the [Distribution](Distribution.md#createPartitioning) abstraction.

## Creating Instance

`ClusteredDistribution` takes the following to be created:

* [[clustering]] Clustering [expressions](../expressions/Expression.md)
* [[requiredNumPartitions]] Required number of partitions (default: `None`)

!!! note
    `None` for the required number of partitions indicates to use any number of partitions (possibly [spark.sql.shuffle.partitions](../configuration-properties.md#spark.sql.shuffle.partitions) configuration property).
