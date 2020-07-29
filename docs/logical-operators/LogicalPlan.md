# LogicalPlan &mdash; Logical Relational Operator

`LogicalPlan` is an extension of the <<catalyst/QueryPlan.md#, QueryPlan contract>> for <<implementations, logical operators>> to build a *logical query plan* (i.e. a tree of logical operators).

NOTE: A logical query plan is a tree of [nodes](../catalyst/TreeNode.md) of logical operators that in turn can have (trees of) <<expressions/Expression.md#, Catalyst expressions>>. In other words, there are _at least_ two trees at every level (operator).

`LogicalPlan` can be <<resolved, resolved>>.

In order to get the <<spark-sql-QueryExecution.md#logical, logical plan>> of a structured query you should use the <<spark-sql-Dataset.md#queryExecution, QueryExecution>>.

[source, scala]
----
scala> :type q
org.apache.spark.sql.Dataset[Long]

val plan = q.queryExecution.logical
scala> :type plan
org.apache.spark.sql.catalyst.plans.logical.LogicalPlan
----

`LogicalPlan` goes through <<spark-sql-QueryExecution.md#execution-pipeline, execution stages>> (as a <<spark-sql-QueryExecution.md#, QueryExecution>>). In order to convert a `LogicalPlan` to a `QueryExecution` you should use `SessionState` and request it to <<SessionState.md#executePlan, "execute" the plan>>.

[source, scala]
----
scala> :type spark
org.apache.spark.sql.SparkSession

// You could use Catalyst DSL to create a logical query plan
scala> :type plan
org.apache.spark.sql.catalyst.plans.logical.LogicalPlan

val qe = spark.sessionState.executePlan(plan)
scala> :type qe
org.apache.spark.sql.execution.QueryExecution
----

[[logical-plan-to-be-analyzed-idiom]]
[NOTE]
====
A common idiom in Spark SQL to make sure that a logical plan can be analyzed is to request a `SparkSession` for the <<SparkSession.md#sessionState, SessionState>> that is in turn requested to <<SessionState.md#executePlan, "execute">> the logical plan (which simply creates a <<spark-sql-QueryExecution.md#creating-instance, QueryExecution>>).

[source, scala]
----
scala> :type plan
org.apache.spark.sql.catalyst.plans.logical.LogicalPlan

val qe = sparkSession.sessionState.executePlan(plan)
qe.assertAnalyzed()
// the following gives the analyzed logical plan
// no exceptions are expected since analysis went fine
val analyzedPlan = qe.analyzed
----
====

[[converting-logical-plan-to-dataset]]
[NOTE]
====
Another common idiom in Spark SQL to convert a `LogicalPlan` into a `Dataset` is to use <<spark-sql-Dataset.md#ofRows, Dataset.ofRows>> internal method that <<SessionState.md#executePlan, "executes">> the logical plan followed by creating a <<spark-sql-Dataset.md#creating-instance, Dataset>> with the <<spark-sql-QueryExecution.md#, QueryExecution>> and a <<spark-sql-RowEncoder.md#, RowEncoder>>.
====

[[childrenResolved]]
A logical operator is considered *partially resolved* when its [child operators](../catalyst/TreeNode.md#children) are resolved (aka _children resolved_).

[[resolved]]
A logical operator is (fully) *resolved* to a specific schema when all catalyst/QueryPlan.md#expressions[expressions] and the <<childrenResolved, children are resolved>>.

[source, scala]
----
scala> plan.resolved
res2: Boolean = true
----

A logical plan knows the size of objects that are results of query operators, like `join`, through `Statistics` object.

[source, scala]
----
scala> val stats = plan.statistics
stats: org.apache.spark.sql.catalyst.plans.logical.Statistics = Statistics(8,false)
----

[[maxRows]]
A logical plan knows the maximum number of records it can compute.

[source, scala]
----
scala> val maxRows = plan.maxRows
maxRows: Option[Long] = None
----

`LogicalPlan` can be <<isStreaming, streaming>> if it contains one or more spark-sql-streaming-source.md[structured streaming sources].

NOTE: `LogicalPlan` is in the end transformed to a SparkPlan.md[physical query plan].

[[implementations]]
[[specialized-logical-plans]]
.Logical Operators / Specialized Logical Plans
[cols="1,2",options="header",width="100%"]
|===
| LogicalPlan
| Description

| spark-sql-LogicalPlan-LeafNode.md[LeafNode]
| [[LeafNode]] Logical operator with no [child](../catalyst/TreeNode.md#children) operators

| `UnaryNode`
| [[UnaryNode]] Logical plan with a single [child](../catalyst/TreeNode.md#children) logical operator

| `BinaryNode`
| [[BinaryNode]] Logical operator with two [child](../catalyst/TreeNode.md#children) logical operators

| spark-sql-LogicalPlan-Command.md[Command]
| [[Command]]

| spark-sql-LogicalPlan-RunnableCommand.md[RunnableCommand]
| [[RunnableCommand]]
|===

[[internal-registries]]
.LogicalPlan's Internal Registries and Counters
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| [[statsCache]] `statsCache`
| Cached plan statistics (as `Statistics`) of the `LogicalPlan`

Computed and cached in <<stats, stats>>.

Used in <<stats, stats>> and <<verboseStringWithSuffix, verboseStringWithSuffix>>.

Reset in <<invalidateStatsCache, invalidateStatsCache>>
|===

=== [[stats]] Getting Cached or Calculating Estimated Statistics -- `stats` Method

```scala
stats(
  conf: CatalystConf): Statistics
```

`stats` returns the <<statsCache, cached plan statistics>> or <<computeStats, computes a new one>> (and caches it as <<statsCache, statsCache>>).

`stats` is used when:

* A `LogicalPlan` <<computeStats, computes `Statistics`>>
* `QueryExecution` spark-sql-QueryExecution.md#completeString[builds complete text representation]
* `JoinSelection` [checks whether a plan can be broadcast](../execution-planning-strategies/JoinSelection.md#canBroadcast) et al
* spark-sql-Optimizer-CostBasedJoinReorder.md[CostBasedJoinReorder] attempts to reorder inner joins
* `LimitPushDown` is spark-sql-Optimizer-LimitPushDown.md#apply[executed] (for spark-sql-joins.md#FullOuter[FullOuter] join)
* `AggregateEstimation` estimates `Statistics`
* `FilterEstimation` estimates child `Statistics`
* `InnerOuterEstimation` estimates `Statistics` of the left and right sides of a join
* `LeftSemiAntiEstimation` estimates `Statistics`
* `ProjectEstimation` estimates `Statistics`

=== [[invalidateStatsCache]] `invalidateStatsCache` method

CAUTION: FIXME

=== [[verboseStringWithSuffix]] `verboseStringWithSuffix` method

CAUTION: FIXME

=== [[setAnalyzed]] `setAnalyzed` method

CAUTION: FIXME

=== [[isStreaming]] Is Logical Plan Streaming? -- `isStreaming` method

[source, scala]
----
isStreaming: Boolean
----

`isStreaming` is part of the public API of `LogicalPlan` and is enabled (i.e. `true`) when a logical plan is a spark-sql-streaming-source.md[streaming source].

By default, it walks over subtrees and calls itself, i.e. `isStreaming`, on every child node to find a streaming source.

[source, scala]
----
val spark: SparkSession = ...

// Regular dataset
scala> val ints = spark.createDataset(0 to 9)
ints: org.apache.spark.sql.Dataset[Int] = [value: int]

scala> ints.queryExecution.logical.isStreaming
res1: Boolean = false

// Streaming dataset
scala> val logs = spark.readStream.format("text").load("logs/*.out")
logs: org.apache.spark.sql.DataFrame = [value: string]

scala> logs.queryExecution.logical.isStreaming
res2: Boolean = true
----

NOTE: Streaming Datasets are part of Structured Streaming.

=== [[refresh]] Refreshing Child Logical Plans -- `refresh` Method

[source, scala]
----
refresh(): Unit
----

`refresh` calls itself recursively for every [child](../catalyst/TreeNode.md#children) logical operator.

NOTE: `refresh` is overriden by spark-sql-LogicalPlan-LogicalRelation.md#refresh[LogicalRelation] only (that refreshes the location of `HadoopFsRelation` relations only).

[NOTE]
====
`refresh` is used when:

* `SessionCatalog` is requested to spark-sql-SessionCatalog.md#refreshTable[refresh a table]

* `CatalogImpl` is requested to spark-sql-CatalogImpl.md#refreshTable[refresh a table]
====

=== [[resolveQuoted]] `resolveQuoted` Method

[source, scala]
----
resolveQuoted(
  name: String,
  resolver: Resolver): Option[NamedExpression]
----

`resolveQuoted`...FIXME

NOTE: `resolveQuoted` is used when...FIXME

=== [[resolve]] Resolving Column Attributes to References in Query Plan -- `resolve` Method

[source, scala]
----
resolve(
  schema: StructType,
  resolver: Resolver): Seq[Attribute]
resolve(
  nameParts: Seq[String],
  resolver: Resolver): Option[NamedExpression]
resolve(
  nameParts: Seq[String],
  input: Seq[Attribute],
  resolver: Resolver): Option[NamedExpression]  // <1>
----
<1> A protected method

`resolve`...FIXME

NOTE: `resolve` is used when...FIXME
