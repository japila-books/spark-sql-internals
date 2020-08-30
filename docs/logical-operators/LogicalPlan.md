# LogicalPlan &mdash; Logical Relational Operators of Structured Query

`LogicalPlan` is an extension of the [QueryPlan](../catalyst/QueryPlan.md) abstraction for [logical operators](#implementations) to build a **logical query plan** (as a tree of logical operators).

A logical query plan is a tree of [nodes](../catalyst/TreeNode.md) of logical operators that in turn can have (trees of) [Catalyst expressions](../expressions/Expression.md). In other words, there are _at least_ two trees at every level (operator).

`LogicalPlan` is eventually resolved (_transformed_) to a [physical operator](../physical-operators/SparkPlan.md).

## Implementations

### BinaryNode

Logical operators with two [child](../catalyst/TreeNode.md#children) logical operators

### Command

[Command](Command.md)

### LeafNode

[LeafNode](LeafNode.md) is a logical operator with no [child](../catalyst/TreeNode.md#children) operators

### UnaryNode

Logical operators with a single [child](../catalyst/TreeNode.md#children) logical operator

### Other Logical Operators

* [CreateTable](CreateTable.md)
* IgnoreCachedData
* NamedRelation
* ObjectProducer
* [ParsedStatement](ParsedStatement.md)
* [SupportsSubquery](SupportsSubquery.md)
* [Union](Union.md)
* [V2CreateTablePlan](V2CreateTablePlan.md)
* [View](View.md)
* [WriteToDataSourceV2](WriteToDataSourceV2.md)

## <span id="statsCache"> Statistics Cache

Cached plan statistics (as `Statistics`) of the `LogicalPlan`

Computed and cached in [stats](#stats)

Used in [stats](#stats) and [verboseStringWithSuffix](#verboseStringWithSuffix)

Reset in [invalidateStatsCache](#invalidateStatsCache)

## <span id="stats"> Estimated Statistics

```scala
stats(
  conf: CatalystConf): Statistics
```

`stats` returns the <<statsCache, cached plan statistics>> or <<computeStats, computes a new one>> (and caches it as <<statsCache, statsCache>>).

`stats` is used when:

* A `LogicalPlan` <<computeStats, computes `Statistics`>>
* `QueryExecution` is requested to [build a complete text representation](../QueryExecution.md#completeString)
* `JoinSelection` [checks whether a plan can be broadcast](../execution-planning-strategies/JoinSelection.md#canBroadcast) et al
* spark-sql-Optimizer-CostBasedJoinReorder.md[CostBasedJoinReorder] attempts to reorder inner joins
* `LimitPushDown` is spark-sql-Optimizer-LimitPushDown.md#apply[executed] (for spark-sql-joins.md#FullOuter[FullOuter] join)
* `AggregateEstimation` estimates `Statistics`
* `FilterEstimation` estimates child `Statistics`
* `InnerOuterEstimation` estimates `Statistics` of the left and right sides of a join
* `LeftSemiAntiEstimation` estimates `Statistics`
* `ProjectEstimation` estimates `Statistics`

## <span id="refresh"> Refreshing Child Logical Operators

```scala
refresh(): Unit
```

`refresh` calls itself recursively for every [child](../catalyst/TreeNode.md#children) logical operator.

!!! note
    `refresh` is overriden by [LogicalRelation](LogicalRelation.md#refresh) only (that refreshes the location of `HadoopFsRelation` relations only).

`refresh` is used when:

* `SessionCatalog` is requested to [refresh a table](../SessionCatalog.md#refreshTable)

* `CatalogImpl` is requested to [refresh a table](../CatalogImpl.md#refreshTable)

## <span id="resolveQuoted"> resolveQuoted

```scala
resolveQuoted(
  name: String,
  resolver: Resolver): Option[NamedExpression]
```

`resolveQuoted`...FIXME

`resolveQuoted` is used when...FIXME

## <span id="resolve"> Resolving Column Attributes to References in Query Plan

```scala
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
```
<1> A protected method

`resolve`...FIXME

`resolve` is used when...FIXME

## Accessing Logical Query Plan of Structured Query

In order to get the [logical plan](../QueryExecution.md#logical) of a structured query you should use the <<spark-sql-Dataset.md#queryExecution, QueryExecution>>.

```text
scala> :type q
org.apache.spark.sql.Dataset[Long]

val plan = q.queryExecution.logical
scala> :type plan
org.apache.spark.sql.catalyst.plans.logical.LogicalPlan
```

`LogicalPlan` goes through [execution stages](../QueryExecution.md#execution-pipeline) (as a [QueryExecution](../QueryExecution.md)). In order to convert a `LogicalPlan` to a `QueryExecution` you should use `SessionState` and request it to ["execute" the plan](../SessionState.md#executePlan).

```text
scala> :type spark
org.apache.spark.sql.SparkSession

// You could use Catalyst DSL to create a logical query plan
scala> :type plan
org.apache.spark.sql.catalyst.plans.logical.LogicalPlan

val qe = spark.sessionState.executePlan(plan)
scala> :type qe
org.apache.spark.sql.execution.QueryExecution
```

## <span id="maxRows"> Maximum Number of Records

```scala
maxRows: Option[Long]
```

`maxRows` is undefined by default (`None`).

`maxRows` is used when `LogicalPlan` is requested for [maxRowsPerPartition](#maxRowsPerPartition).

## <span id="maxRowsPerPartition"> Maximum Number of Records per Partition

```scala
maxRowsPerPartition: Option[Long]
```

`maxRowsPerPartition` is exactly the [maximum number of records](#maxRows) by default.

`maxRowsPerPartition` is used when [LimitPushDown](../logical-optimizations/LimitPushDown.md) logical optimization is executed.

## Executing Logical Plan

A common idiom in Spark SQL to make sure that a logical plan can be analyzed is to request a `SparkSession` for the [SessionState](../SparkSession.md#sessionState) that is in turn requested to ["execute"](../SessionState.md#executePlan) the logical plan (which simply creates a [QueryExecution](../QueryExecution.md)).

```text
scala> :type plan
org.apache.spark.sql.catalyst.plans.logical.LogicalPlan

val qe = sparkSession.sessionState.executePlan(plan)
qe.assertAnalyzed()
// the following gives the analyzed logical plan
// no exceptions are expected since analysis went fine
val analyzedPlan = qe.analyzed
```

## Converting Logical Plan to Dataset

Another common idiom in Spark SQL to convert a `LogicalPlan` into a `Dataset` is to use [Dataset.ofRows](../spark-sql-Dataset.md#ofRows) internal method that ["executes"](../SessionState.md#executePlan) the logical plan followed by creating a [Dataset](../spark-sql-Dataset.md) with the [QueryExecution](../QueryExecution.md) and [RowEncoder](../spark-sql-RowEncoder.md).

## <span id="childrenResolved"> childrenResolved

```scala
childrenResolved: Boolean
```

A logical operator is considered **partially resolved** when its [child operators](../catalyst/TreeNode.md#children) are resolved (aka _children resolved_).

## resolved

<span id="resolved">
```scala
resolved: Boolean
```

A logical operator is (fully) **resolved** to a specific schema when all catalyst/QueryPlan.md#expressions[expressions] and the <<childrenResolved, children are resolved>>.

```scala
scala> plan.resolved
res2: Boolean = true
```
