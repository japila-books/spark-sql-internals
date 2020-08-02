# ClusteredDistribution

`ClusteredDistribution` is a spark-sql-Distribution.md[Distribution] that <<createPartitioning, creates a HashPartitioning>> for the <<clustering, clustering expressions>> and a requested number of partitions.

`ClusteredDistribution` requires that the <<clustering, clustering expressions>> should not be empty (i.e. `Nil`).

`ClusteredDistribution` is <<creating-instance, created>> when the following physical operators are requested for a required child distribution:

* `MapGroupsExec`, spark-sql-SparkPlan-HashAggregateExec.md#requiredChildDistribution[HashAggregateExec], spark-sql-SparkPlan-ObjectHashAggregateExec.md#requiredChildDistribution[ObjectHashAggregateExec], spark-sql-SparkPlan-SortAggregateExec.md#requiredChildDistribution[SortAggregateExec], spark-sql-SparkPlan-WindowExec.md#requiredChildDistribution[WindowExec]

* Spark Structured Streaming's `FlatMapGroupsWithStateExec`, `StateStoreRestoreExec`, `StateStoreSaveExec`, `StreamingDeduplicateExec`, `StreamingSymmetricHashJoinExec`, `StreamingSymmetricHashJoinExec`

* SparkR's `FlatMapGroupsInRExec`

* PySpark's `FlatMapGroupsInPandasExec`

`ClusteredDistribution` is used when:

* `DataSourcePartitioning`, `SinglePartition`, `HashPartitioning`, and `RangePartitioning` are requested to `satisfies`

* [EnsureRequirements](physical-optimizations/EnsureRequirements.md) is executed for Adaptive Query Execution

=== [[createPartitioning]] `createPartitioning` Method

[source, scala]
----
createPartitioning(numPartitions: Int): Partitioning
----

NOTE: `createPartitioning` is part of spark-sql-Distribution.md#createPartitioning[Distribution Contract] to create a spark-sql-SparkPlan-Partitioning.md[Partitioning] for a given number of partitions.

`createPartitioning` creates a `HashPartitioning` for the <<clustering, clustering expressions>> and the input `numPartitions`.

`createPartitioning` reports an `AssertionError` when the <<requiredNumPartitions, number of partitions>> is not the input `numPartitions`.

[options="wrap"]
```
This ClusteredDistribution requires [requiredNumPartitions] partitions, but the actual number of partitions is [numPartitions].
```

=== [[creating-instance]] Creating ClusteredDistribution Instance

`ClusteredDistribution` takes the following when created:

* [[clustering]] Clustering expressions/Expression.md[expressions]
* [[requiredNumPartitions]] Required number of partitions (default: `None`)

NOTE: `None` for the required number of partitions indicates to use any number of partitions (possibly spark-sql-properties.md#spark.sql.shuffle.partitions[spark.sql.shuffle.partitions] configuration property with the default of `200` partitions).
