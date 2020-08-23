# BroadcastDistribution

[[requiredNumPartitions]]
`BroadcastDistribution` is a Distribution.md[Distribution] that indicates to use one partition only and...FIXME.

`BroadcastDistribution` is <<creating-instance, created>> when:

. `BroadcastHashJoinExec` is requested for spark-sql-SparkPlan-BroadcastHashJoinExec.md#requiredChildDistribution[required child output distributions] (with spark-sql-HashedRelationBroadcastMode.md[HashedRelationBroadcastMode] of the spark-sql-HashJoin.md#buildKeys[build join keys])

. `BroadcastNestedLoopJoinExec` is requested for spark-sql-SparkPlan-BroadcastNestedLoopJoinExec.md#requiredChildDistribution[required child output distributions] (with spark-sql-IdentityBroadcastMode.md[IdentityBroadcastMode])

[[creating-instance]]
[[mode]]
`BroadcastDistribution` takes a spark-sql-BroadcastMode.md[BroadcastMode] when created.

NOTE: `BroadcastDistribution` is converted to a spark-sql-SparkPlan-BroadcastExchangeExec.md[BroadcastExchangeExec] physical operator when [EnsureRequirements](physical-optimizations/EnsureRequirements.md) physical optimization is executed.

=== [[createPartitioning]] `createPartitioning` Method

[source, scala]
----
createPartitioning(numPartitions: Int): Partitioning
----

`createPartitioning`...FIXME

`createPartitioning` is part of the [Distribution](Distribution.md#createPartitioning) abstraction.
