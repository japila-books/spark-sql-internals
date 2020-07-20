title: ShuffleExchangeExec

# ShuffleExchangeExec Unary Physical Operator

`ShuffleExchangeExec` is an link:spark-sql-SparkPlan-Exchange.adoc[Exchange] unary physical operator that is used to <<doExecute, perform a shuffle>>.

`ShuffleExchangeExec` is created (possibly indirectly using <<apply, apply>> factory) when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed and plans link:spark-sql-LogicalPlan-Repartition-RepartitionByExpression.adoc[Repartition] (with `shuffle` flag enabled) and link:spark-sql-LogicalPlan-Repartition-RepartitionByExpression.adoc[RepartitionByExpression] logical operators

* link:spark-sql-EnsureRequirements.adoc[EnsureRequirements] physical query optimization is executed (and requested to link:spark-sql-EnsureRequirements.adoc#ensureDistributionAndOrdering[enforce partition requirements])

NOTE: `ShuffleExchangeExec` <<nodeName, presents itself>> as *Exchange* in physical query plans.

[source, scala]
----
// Uses Repartition logical operator
// ShuffleExchangeExec with RoundRobinPartitioning
val q1 = spark.range(6).repartition(2)
scala> q1.explain
== Physical Plan ==
Exchange RoundRobinPartitioning(2)
+- *Range (0, 6, step=1, splits=Some(8))

// Uses RepartitionByExpression logical operator
// ShuffleExchangeExec with HashPartitioning
val q2 = spark.range(6).repartition(2, 'id % 2)
scala> q2.explain
== Physical Plan ==
Exchange hashpartitioning((id#38L % 2), 2)
+- *Range (0, 6, step=1, splits=Some(8))
----

[[nodeName]]
When requested for [nodeName](../catalyst/TreeNode.md#nodeName), `ShuffleExchangeExec` gives *Exchange* prefix possibly followed by *(coordinator id: [coordinator-hash-code])* per the optional <<coordinator, ExchangeCoordinator>>.

[[outputPartitioning]]
When requested for the <<SparkPlan.md#outputPartitioning, output data partitioning requirements>>, `ShuffleExchangeExec` simply returns the <<newPartitioning, Partitioning>>.

[[doPrepare]]
When requested to <<SparkPlan.md#doPrepare, prepare for execution>>, `ShuffleExchangeExec` registers itself with the optional <<coordinator, ExchangeCoordinator>> if defined.

=== [[creating-instance]] Creating ShuffleExchangeExec Instance

`ShuffleExchangeExec` takes the following to be created:

* [[newPartitioning]] link:spark-sql-SparkPlan-Partitioning.adoc[[Partitioning]]
* [[child]] Child link:SparkPlan.md[[physical operator]]
* [[coordinator]] Optional link:spark-sql-ExchangeCoordinator.adoc[[ExchangeCoordinator]]

The optional <<coordinator, ExchangeCoordinator>> is defined only for <<spark-sql-adaptive-query-execution.adoc#, Adaptive Query Execution>> (when <<spark-sql-EnsureRequirements.adoc#, EnsureRequirements>> physical query optimization is <<apply, executed>>).

=== [[metrics]] Performance Metrics -- `metrics` Method

.ShuffleExchangeExec's Performance Metrics
[cols="1m,2,2",options="header",width="100%"]
|===
| Key
| Name (in web UI)
| Description

| dataSize
| data size
| [[dataSize]]
|===

.ShuffleExchangeExec in web UI (Details for Query)
image::images/spark-sql-ShuffleExchangeExec-webui.png[align="center"]

=== [[doExecute]] Executing Physical Operator (Generating RDD[InternalRow]) -- `doExecute` Method

[source, scala]
----
doExecute(): RDD[InternalRow]
----

NOTE: `doExecute` is part of <<SparkPlan.md#doExecute, SparkPlan Contract>> to generate the runtime representation of a structured query as a distributed computation over <<spark-sql-InternalRow.adoc#, internal binary rows>> on Apache Spark (i.e. `RDD[InternalRow]`).

`doExecute` creates a new link:spark-sql-ShuffledRowRDD.adoc[ShuffledRowRDD] or (re)uses the <<cachedShuffleRDD, cached one>> if `doExecute` was executed before.

NOTE: `ShuffleExchangeExec` caches a `ShuffledRowRDD` for later reuse.

`doExecute` branches off per the optional <<coordinator, ExchangeCoordinator>>.

NOTE: The optional <<coordinator, ExchangeCoordinator>> is available only when <<spark-sql-adaptive-query-execution.adoc#, Adaptive Query Execution>> is enabled (and `EnsureRequirements` physical query optimization is requested to <<spark-sql-SparkPlan-ShuffleExchangeExec.adoc#ensureDistributionAndOrdering, enforce partition requirements (distribution and ordering) of a physical operator>>).

With an `ExchangeCoordinator` available, `doExecute` requests the <<coordinator, ExchangeCoordinator>> for a <<spark-sql-ExchangeCoordinator.adoc#postShuffleRDD, ShuffledRowRDD>>.

Otherwise (with no `ExchangeCoordinator` available), `doExecute` <<prepareShuffleDependency, prepares a ShuffleDependency>> and then <<preparePostShuffleRDD, creates a ShuffledRowRDD>>.

In the end, `doExecute` saves (_caches_) the result `ShuffledRowRDD` (as the <<cachedShuffleRDD, cachedShuffleRDD>> internal registry).

=== [[preparePostShuffleRDD]] `preparePostShuffleRDD` Method

[source, scala]
----
preparePostShuffleRDD(
  shuffleDependency: ShuffleDependency[Int, InternalRow, InternalRow],
  specifiedPartitionStartIndices: Option[Array[Int]] = None): ShuffledRowRDD
----

`preparePostShuffleRDD`...FIXME

[NOTE]
====
`preparePostShuffleRDD` is used when:

* `ExchangeCoordinator` is requested to <<spark-sql-ExchangeCoordinator.adoc#doEstimationIfNecessary, doEstimationIfNecessary>>

* `ShuffleExchangeExec` physical operator is requested to <<doExecute, execute>>
====

=== [[prepareShuffleDependency]] Preparing ShuffleDependency -- `prepareShuffleDependency` Internal Method

[source, scala]
----
prepareShuffleDependency(): ShuffleDependency[Int, InternalRow, InternalRow] // <1>
prepareShuffleDependency(
  rdd: RDD[InternalRow],
  outputAttributes: Seq[Attribute],
  newPartitioning: Partitioning,
  serializer: Serializer): ShuffleDependency[Int, InternalRow, InternalRow]
----
<1> Uses the <<child, child>> operator (for the `rdd` and `outputAttributes`) and the <<serializer, serializer>>

`prepareShuffleDependency` creates a Spark Core `ShuffleDependency` with a `RDD[Product2[Int, InternalRow]]` (where `Ints` are partition IDs of the `InternalRows` values) and the given `Serializer` (e.g. the <<serializer, Serializer>> of the `ShuffleExchangeExec` physical operator).

Internally, `prepareShuffleDependency`...FIXME

[NOTE]
====
`prepareShuffleDependency` is used when:

* `ExchangeCoordinator` is requested to <<spark-sql-ExchangeCoordinator.adoc#doEstimationIfNecessary, doEstimationIfNecessary>> (when `ExchangeCoordinator` is requested for a <<spark-sql-ExchangeCoordinator.adoc#postShuffleRDD, post-shuffle RDD (ShuffledRowRDD)>>)

* `CollectLimitExec`, <<doExecute, ShuffleExchangeExec>> and TakeOrderedAndProjectExec physical operators are executed
====

=== [[prepareShuffleDependency-helper]] `prepareShuffleDependency` Helper Method

[source, scala]
----
prepareShuffleDependency(
  rdd: RDD[InternalRow],
  outputAttributes: Seq[Attribute],
  newPartitioning: Partitioning,
  serializer: Serializer): ShuffleDependency[Int, InternalRow, InternalRow]
----

`prepareShuffleDependency` creates a link:spark-rdd-ShuffleDependency.adoc[ShuffleDependency] dependency.

NOTE: `prepareShuffleDependency` is used when `ShuffleExchangeExec` <<prepareShuffleDependency, prepares a `ShuffleDependency`>> (as part of...FIXME), `CollectLimitExec` and `TakeOrderedAndProjectExec` physical operators are executed.

=== [[doPrepare]] Preparing Physical Operator for Execution -- `doPrepare` Method

[source, scala]
----
doPrepare(): Unit
----

NOTE: `doPrepare` is part of link:SparkPlan.md#doPrepare[SparkPlan Contract] to prepare a physical operator for execution.

`doPrepare` simply requests the <<coordinator, ExchangeCoordinator>> to <<spark-sql-ExchangeCoordinator.adoc#registerExchange, register the ShuffleExchangeExec unary physical operator>>.

=== [[apply]] Creating ShuffleExchangeExec Without ExchangeCoordinator -- `apply` Utility

[source, scala]
----
apply(
  newPartitioning: Partitioning,
  child: SparkPlan): ShuffleExchangeExec
----

`apply` creates a new <<creating-instance, ShuffleExchangeExec>> physical operator with an empty link:spark-sql-ExchangeCoordinator.adoc[ExchangeCoordinator].

`apply` is used when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (and plans a link:spark-sql-LogicalPlan-Repartition-RepartitionByExpression.adoc[Repartition] logical operator with `shuffle` flag enabled, a link:spark-sql-LogicalPlan-Repartition-RepartitionByExpression.adoc[RepartitionByExpression])

* link:spark-sql-EnsureRequirements.adoc[EnsureRequirements] physical query optimization is executed (and requested to link:spark-sql-EnsureRequirements.adoc#ensureDistributionAndOrdering[enforce partition requirements])

=== [[internal-properties]] Internal Properties

[cols="30m,70",options="header",width="100%"]
|===
| Name
| Description

| cachedShuffleRDD
| [[cachedShuffleRDD]] <<spark-sql-ShuffledRowRDD.adoc#, ShuffledRowRDD>> that is created when `ShuffleExchangeExec` operator is <<doExecute, executed (to generate RDD[InternalRow])>> and reused (_cached_) if the operator is used by multiple plans

| serializer
| [[serializer]] `UnsafeRowSerializer` (of the size as the number of the <<spark-sql-catalyst-QueryPlan.adoc#output, output schema attributes>> of the <<child, child>> physical operator and the <<dataSize, dataSize>> performance metric)

Used exclusively in <<prepareShuffleDependency, prepareShuffleDependency>> to create a `ShuffleDependency`

|===
