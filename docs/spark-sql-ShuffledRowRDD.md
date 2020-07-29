# ShuffledRowRDD

`ShuffledRowRDD` is an `RDD` of spark-sql-InternalRow.md[internal binary rows] (i.e. `RDD[InternalRow]`) that is <<creating-instance, created>> when:

* `ShuffleExchangeExec` physical operator is requested to <<spark-sql-SparkPlan-ShuffleExchangeExec.md#preparePostShuffleRDD, create one>>

* `CollectLimitExec` and `TakeOrderedAndProjectExec` physical operators are executed

[[creating-instance]]
`ShuffledRowRDD` takes the following to be created:

* [[dependency]] Spark Core `ShuffleDependency[Int, InternalRow, InternalRow]`
* [[specifiedPartitionStartIndices]] Optional *partition start indices* (`Option[Array[Int]]` , default: `None`)

NOTE: The <<dependency, dependency>> property is mutable so it can be <<clearDependencies, cleared>>.

`ShuffledRowRDD` takes an optional <<specifiedPartitionStartIndices, partition start indices>> that is the number of post-shuffle partitions. When not specified, the number of post-shuffle partitions is managed by the spark-rdd-Partitioner.md[Partitioner] of the input `ShuffleDependency`. Otherwise, when specified (when `ExchangeCoordinator` is requested to <<spark-sql-ExchangeCoordinator.md#doEstimationIfNecessary, doEstimationIfNecessary>>), `ShuffledRowRDD`...FIXME

NOTE: *Post-shuffle partition* is...FIXME

NOTE: `ShuffledRowRDD` is similar to Spark Core's `ShuffledRDD`, with the difference being the type of the values to process, i.e. spark-sql-InternalRow.md[InternalRow] and `(K, C)` key-value pairs, respectively.

.ShuffledRowRDD and RDD Contract
[cols="1,3",options="header",width="100%"]
|===
| Name
| Description

| `getDependencies`
| A single-element collection with `ShuffleDependency[Int, InternalRow, InternalRow]`.

| `partitioner`
| <<CoalescedPartitioner, CoalescedPartitioner>> (with the spark-rdd-Partitioner.md[Partitioner] of the `dependency`)

| <<getPreferredLocations, getPreferredLocations>>
|

| <<compute, compute>>
|
|===

=== [[numPreShufflePartitions]] `numPreShufflePartitions` Internal Property

[source, scala]
----
numPreShufflePartitions: Int
----

`numPreShufflePartitions` is exactly the number of partitions of the `Partitioner` of the given <<dependency, ShuffleDependency>>.

NOTE: `numPreShufflePartitions` is used when `ShuffledRowRDD` is requested for the <<partitionStartIndices, partitionStartIndices>> (with no <<specifiedPartitionStartIndices, optional partition indices>> given) and <<getPartitions, partitions>>.

=== [[partitionStartIndices]] `partitionStartIndices` Internal Property

[source, scala]
----
partitionStartIndices: Array[Int]
----

`partitionStartIndices` is whatever given by the <<specifiedPartitionStartIndices, optional partition indices>> or an empty array of <<numPreShufflePartitions, numPreShufflePartitions>> elements (that means that post-shuffle partitions correspond to pre-shuffle partitions).

NOTE: `partitionStartIndices` is used when `ShuffledRowRDD` is requested for the <<getPartitions, partitions>> and <<part, Partitioner>>.

=== [[part]] `part` Internal Property

[source, scala]
----
part: Partitioner
----

`part` is simply a `CoalescedPartitioner` (for the `Partitioner` of the given <<dependency, ShuffleDependency>> and the <<partitionStartIndices, partitionStartIndices>>).

NOTE: `part` is used when `ShuffledRowRDD` is requested for the <<partitioner, Partitioner>> and the <<getPartitions, partitions>>.

=== [[compute]] Computing Partition (in TaskContext) -- `compute` Method

[source, scala]
----
compute(
  split: Partition,
  context: TaskContext): Iterator[InternalRow]
----

NOTE: `compute` is part of Spark Core's `RDD` contract to compute a partition (in a `TaskContext`).

Internally, `compute` makes sure that the input `split` is a <<ShuffledRowRDDPartition, ShuffledRowRDDPartition>>. `compute` then requests the `ShuffleManager` for a `ShuffleReader` to read ``InternalRow``s for the input `split` partition.

NOTE: `compute` uses Spark Core's `SparkEnv` to access the current `ShuffleManager`.

NOTE: `compute` uses `ShuffleHandle` (of the <<dependency, ShuffleDependency>>) with the pre-shuffle start and end partition offsets of the `ShuffledRowRDDPartition`.

=== [[getPreferredLocations]] Getting Placement Preferences of Partition -- `getPreferredLocations` Method

[source, scala]
----
getPreferredLocations(partition: Partition): Seq[String]
----

NOTE: `getPreferredLocations` is part of `RDD` contract to specify placement preferences (aka _preferred task locations_), i.e. where tasks should be executed to be as close to the data as possible.

Internally, `getPreferredLocations` requests `MapOutputTrackerMaster` for the preferred locations of the single <<dependency, ShuffleDependency>> and the input `partition`.

NOTE: `getPreferredLocations` uses `SparkEnv` to access the current `MapOutputTrackerMaster` (that runs on the driver).

=== [[CoalescedPartitioner]] `CoalescedPartitioner`

CAUTION: FIXME

=== [[ShuffledRowRDDPartition]] `ShuffledRowRDDPartition`

CAUTION: FIXME

=== [[clearDependencies]] Clearing Dependencies -- `clearDependencies` Method

[source, scala]
----
clearDependencies(): Unit
----

NOTE: `clearDependencies` is part of the `RDD` contract to clear dependencies of the RDD (to enable the parent RDDs to be garbage collected).

`clearDependencies` simply requests the parent RDD to `clearDependencies` followed by clear the given <<dependency, dependency>> (i.e. set to `null`).
