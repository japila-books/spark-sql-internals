title: Distribution

# Distribution -- Data Distribution Across Partitions

`Distribution` is the <<contract, contract>> of...FIXME

[[contract]]
[source, scala]
----
package org.apache.spark.sql.catalyst.plans.physical

sealed trait Distribution {
  def requiredNumPartitions: Option[Int]
  def createPartitioning(numPartitions: Int): Partitioning
}
----

NOTE: `Distribution` is a Scala `sealed` contract which means that all possible distributions are all in the same compilation unit (file).

.Distribution Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| [[requiredNumPartitions]] `requiredNumPartitions`
a| Gives the required number of partitions for a distribution.

Used exclusively when `EnsureRequirements` physical optimization is requested to spark-sql-EnsureRequirements.md#ensureDistributionAndOrdering[enforce partition requirements of a physical operator] (and a child operator's output partitioning does not satisfy a required child distribution that leads to inserting a `ShuffleExchangeExec` operator to a physical plan).

NOTE: `None` for the required number of partitions indicates to use any number of partitions (possibly spark-sql-properties.md#spark.sql.shuffle.partitions[spark.sql.shuffle.partitions] configuration property with the default of `200` partitions).

| [[createPartitioning]] `createPartitioning`
| Creates a spark-sql-SparkPlan-Partitioning.md[Partitioning] for a given number of partitions.

Used exclusively when `EnsureRequirements` physical optimization is requested to spark-sql-EnsureRequirements.md#ensureDistributionAndOrdering[enforce partition requirements of a physical operator] (and creates a spark-sql-SparkPlan-ShuffleExchangeExec.md[ShuffleExchangeExec] physical operator with a required `Partitioning`).
|===

[[implementations]]
.Distributions
[cols="1,2",options="header",width="100%"]
|===
| Distribution
| Description

| [[AllTuples]] spark-sql-Distribution-AllTuples.md[AllTuples]
|

| [[BroadcastDistribution]] spark-sql-Distribution-BroadcastDistribution.md[BroadcastDistribution]
|

| [[ClusteredDistribution]] spark-sql-Distribution-ClusteredDistribution.md[ClusteredDistribution]
|

| [[HashClusteredDistribution]] spark-sql-Distribution-HashClusteredDistribution.md[HashClusteredDistribution]
|

| [[OrderedDistribution]] spark-sql-Distribution-OrderedDistribution.md[OrderedDistribution]
|

| [[UnspecifiedDistribution]] spark-sql-Distribution-UnspecifiedDistribution.md[UnspecifiedDistribution]
|
|===
