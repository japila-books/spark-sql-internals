title: Partitioning

# Partitioning -- Specification of Physical Operator's Output Partitions

`Partitioning` is the <<contract, contract>> to hint the Spark Physical Optimizer for the number of partitions the output of a <<SparkPlan.md#, physical operator>> should be split across.

[[contract]]
[[numPartitions]]
[source, scala]
----
numPartitions: Int
----

`numPartitions` is used in:

* `EnsureRequirements` physical preparation rule to spark-sql-EnsureRequirements.md#ensureDistributionAndOrdering[enforce partition requirements of a physical operator]

* spark-sql-SparkPlan-SortMergeJoinExec.md[SortMergeJoinExec] for `outputPartitioning` for `FullOuter` join type
* `Partitioning.allCompatible`

[[implementations]]
.Partitioning Schemes (Partitionings) and Their Properties
[width="100%",cols="1,1,1,1,1",options="header"]
|===
| Partitioning
| compatibleWith
| guarantees
| numPartitions
| satisfies

m| BroadcastPartitioning
| `BroadcastPartitioning` with the same `BroadcastMode`
| Exactly the same `BroadcastPartitioning`
^| 1
| [[BroadcastPartitioning]] spark-sql-Distribution-BroadcastDistribution.md[BroadcastDistribution] with the same `BroadcastMode`

a| `HashPartitioning`

* `clustering` expressions
* `numPartitions`

| `HashPartitioning` (when their underlying expressions are semantically equal, i.e. deterministic and canonically equal)
| `HashPartitioning` (when their underlying expressions are semantically equal, i.e. deterministic and canonically equal)
| Input `numPartitions`
a| [[HashPartitioning]]

* spark-sql-Distribution-UnspecifiedDistribution.md[UnspecifiedDistribution]

* spark-sql-Distribution-ClusteredDistribution.md[ClusteredDistribution] with all the hashing expressions/Expression.md[expressions] included in `clustering` expressions

a| `PartitioningCollection`

* `partitionings`

| Any `Partitioning` that is compatible with one of the input `partitionings`
| Any `Partitioning` that is guaranteed by any of the input `partitionings`
| Number of partitions of the first `Partitioning` in the input `partitionings`
| [[PartitioningCollection]] Any `Distribution` that is satisfied by any of the input `partitionings`

a| `RangePartitioning`

* `ordering` collection of `SortOrder`
* `numPartitions`

| `RangePartitioning` (when semantically equal, i.e. underlying expressions are deterministic and canonically equal)
| `RangePartitioning` (when semantically equal, i.e. underlying expressions are deterministic and canonically equal)
| Input `numPartitions`
a| [[RangePartitioning]]

* spark-sql-Distribution-UnspecifiedDistribution.md[UnspecifiedDistribution]
* spark-sql-Distribution-OrderedDistribution.md[OrderedDistribution] with `requiredOrdering` that matches the input `ordering`
* spark-sql-Distribution-ClusteredDistribution.md[ClusteredDistribution] with all the children of the input `ordering` semantically equal to one of the `clustering` expressions

a| `RoundRobinPartitioning`

* `numPartitions`

| Always negative
| Always negative
| Input `numPartitions`
| [[RoundRobinPartitioning]] spark-sql-Distribution-UnspecifiedDistribution.md[UnspecifiedDistribution]

| `SinglePartition`
| Any `Partitioning` with exactly one partition
| Any `Partitioning` with exactly one partition
^| 1
| [[SinglePartition]] Any `Distribution` except spark-sql-Distribution-BroadcastDistribution.md[BroadcastDistribution]

a| `UnknownPartitioning`

* `numPartitions`
| Always negative
| Always negative
| Input `numPartitions`
| [[UnknownPartitioning]] spark-sql-Distribution-UnspecifiedDistribution.md[UnspecifiedDistribution]
|===
