title: QueryExecution

# QueryExecution -- Structured Query Execution Pipeline

`QueryExecution` is the <<execution-pipeline, execution pipeline>> (_workflow_) of a <<logical, structured query>>.

`QueryExecution` is made up of *execution stages* (phases).

.Query Execution &mdash; From SQL through Dataset to RDD
image::images/QueryExecution-execution-pipeline.png[align="center"]

NOTE: When you execute an operator on a `Dataset` it triggers <<toRdd, query execution>> that gives the good ol' `RDD` of spark-sql-InternalRow.md[internal binary rows], i.e. `RDD[InternalRow]`, that is Spark's execution plan followed by executing an RDD action and so the result of the structured query.

`QueryExecution` is part of any `Dataset` using xref:spark-sql-Dataset.md#queryExecution[queryExecution] attribute.

[source, scala]
----
val ds: Dataset[Long] = ...
val queryExec = ds.queryExecution
----

`QueryExecution` is the result of SessionState.md#executePlan[executing a LogicalPlan in a SparkSession] (and so you could create a `Dataset` from a spark-sql-LogicalPlan.md[logical operator] or use the `QueryExecution` after executing a logical operator).

[source, scala]
----
val plan: LogicalPlan = ...
val qe = new QueryExecution(sparkSession, plan)
----

[[attributes]]
[[execution-pipeline]]
[[query-plan-lifecycle]]
.QueryExecution's Properties (aka QueryExecution Phases / Structured Query Execution Pipeline)
[cols="1m,3",options="header",width="100%"]
|===
| Attribute / Phase
| Description

| analyzed
a| [[analyzed]] Analyzed <<logical, logical plan>> that has passed [Logical Analyzer](Analyzer.md).

TIP: Beside `analyzed`, you can use spark-sql-dataset-operators.md#explain[Dataset.explain] basic action (with `extended` flag enabled) or SQL's `EXPLAIN EXTENDED` to see the analyzed logical plan of a structured query.

| withCachedData
| [[withCachedData]] <<analyzed, analyzed>> logical plan after `CacheManager` was requested to spark-sql-CacheManager.md#useCachedData[replace logical query segments with cached query plans].

`withCachedData` makes sure that the logical plan was <<assertAnalyzed, analyzed>> and <<assertSupported, uses supported operations only>>.

| optimizedPlan
| [[optimizedPlan]] Optimized spark-sql-LogicalPlan.md[logical plan] that is the result of executing the SessionState.md#optimizer[logical query plan optimizer] on the <<withCachedData, withCachedData>> logical plan.

| sparkPlan
a| [[sparkPlan]] SparkPlan.md[Physical plan] (after spark-sql-SparkPlanner.md[SparkPlanner] has planned the <<optimizedPlan, optimized logical plan>>).

NOTE: `sparkPlan` is the first physical plan from the collection of all possible physical plans.

NOTE: It is guaranteed that Catalyst's `QueryPlanner` (which `SparkPlanner` extends) catalyst/QueryPlanner.md#plan[will always generate at least one physical plan].

| executedPlan
a| [[executedPlan]] Optimized <<SparkPlan.md#, physical query plan>> that is in the final optimized "shape" and therefore ready for execution, i.e. the <<sparkPlan, physical sparkPlan>> with <<prepareForExecution, physical preparation rules applied>>.

NOTE: Amongst the physical optimization rules that `executedPlan` phase triggers is the <<spark-sql-CollapseCodegenStages.md#, CollapseCodegenStages>> physical preparation rule that collapses physical operators that support code generation together as a spark-sql-SparkPlan-WholeStageCodegenExec.md[WholeStageCodegenExec] operator.

[NOTE]
====
`executedPlan` physical plan is used when:

* <<spark-sql-dataset-operators.md#explain, Dataset.explain>> operator is used to show the logical and physical query plans of a structured query

* <<spark-sql-dataset-operators.md#localCheckpoint, Dataset.localCheckpoint>> and <<spark-sql-dataset-operators.md#checkpoint, Dataset.checkpoint>> operators are used (through <<spark-sql-Dataset-basic-actions.md#checkpoint-internal, checkpoint>>)

* <<spark-sql-dataset-operators.md#foreach, Dataset.foreach>> and <<spark-sql-dataset-operators.md#foreachPartition, Dataset.foreachPartition>> actions are used (through <<spark-sql-Dataset.md#withNewRDDExecutionId, withNewRDDExecutionId>>)

* `Dataset` is requested to <<spark-sql-Dataset.md#withAction, execute an action under a new execution ID>> (e.g. for the Dataset operators: <<spark-sql-dataset-operators.md#collect, collect>>, <<spark-sql-dataset-operators.md#count, count>>, <<spark-sql-dataset-operators.md#head, head>> and <<spark-sql-dataset-operators.md#toLocalIterator, toLocalIterator>>)

* `CacheManager` is requested to <<spark-sql-CacheManager.md#cacheQuery, cacheQuery>> (e.g. for <<spark-sql-dataset-operators.md#persist, Dataset.persist>> basic action) or <<spark-sql-CacheManager.md#recacheByCondition, recacheByCondition>>

* `QueryExecution` is requested for the `RDD[InternalRow]` of a structured query (in the <<toRdd, toRdd>> query execution phase), <<simpleString, simpleString>>, <<toString, toString>>, <<stringWithStats, stringWithStats>>, <<spark-sql-debugging-query-execution.md#codegenToSeq, codegenToSeq>>, and the <<hiveResultString, Hive-compatible output format>>

* `SQLExecution` is requested to <<spark-sql-SQLExecution.md#withNewExecutionId, execute a Dataset action under a new execution id>>

* `PlanSubqueries` physical query optimization is <<spark-sql-PlanSubqueries.md#apply, executed>>

* <<spark-sql-LogicalPlan-AnalyzeColumnCommand.md#, AnalyzeColumnCommand>> and <<spark-sql-LogicalPlan-ExplainCommand.md#, ExplainCommand>> logical commands are executed

* `DebugQuery` is requested for `debug` and `debugCodegen`
====

| toRdd
a| [[toRdd]]

[source, scala]
----
toRdd: RDD[InternalRow]
----

Spark Core's execution graph of a distributed computation (`RDD` of xref:spark-sql-InternalRow.md[internal binary rows]) from the <<executedPlan, executedPlan>> after xref:SparkPlan.md#execute[execution].

The `RDD` is the top-level RDD of the DAG of RDDs (that represent physical operators).

[NOTE]
====
`toRdd` is a "boundary" between two Spark modules: Spark SQL and Spark Core.

After you have executed `toRdd` (directly or not), you basically "leave" Spark SQL's Dataset world and "enter" Spark Core's RDD space.
====

`toRdd` triggers a structured query execution (i.e. physical planning, but not execution of the plan) using SparkPlan.md#execute[SparkPlan.execute] that recursively triggers execution of every child physical operator in the physical plan tree.

NOTE: You can use SparkSession.md#internalCreateDataFrame[SparkSession.internalCreateDataFrame] to apply a spark-sql-StructType.md[schema] to an `RDD[InternalRow]`.

NOTE: Use spark-sql-dataset-operators.md#rdd[Dataset.rdd] to access the `RDD[InternalRow]` with internal binary rows deserialized to a Scala type.
|===

You can access the lazy attributes as follows:

[source, scala]
----
val dataset: Dataset[Long] = ...
dataset.queryExecution.executedPlan
----

`QueryExecution` uses the [Logical Query Optimizer](Optimizer.md) and [Tungsten](spark-sql-tungsten.md) for better structured query performance.

[[properties]]
.QueryExecution's Properties
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| [[planner]] `planner`
| [SparkPlanner](spark-sql-SparkPlanner.md)
|===

`QueryExecution` uses the input `SparkSession` to access the current spark-sql-SparkPlanner.md[SparkPlanner] (through SessionState.md[SessionState]) when <<creating-instance, it is created>>. It then computes a SparkPlan.md[SparkPlan] (a `PhysicalPlan` exactly) using the planner. It is available as the <<sparkPlan, `sparkPlan` attribute>>.

[NOTE]
====
A variant of `QueryExecution` that Spark Structured Streaming uses for query planning is `IncrementalExecution`.

Refer to https://jaceklaskowski.gitbooks.io/spark-structured-streaming/spark-sql-streaming-IncrementalExecution.html[IncrementalExecution — QueryExecution of Streaming Datasets] in the Spark Structured Streaming gitbook.
====

TIP: Use spark-sql-dataset-operators.md#explain[explain] operator to know about the logical and physical plans of a `Dataset`.

[source, scala]
----
val ds = spark.range(5)
scala> ds.queryExecution
res17: org.apache.spark.sql.execution.QueryExecution =
== Parsed Logical Plan ==
Range 0, 5, 1, 8, [id#39L]

== Analyzed Logical Plan ==
id: bigint
Range 0, 5, 1, 8, [id#39L]

== Optimized Logical Plan ==
Range 0, 5, 1, 8, [id#39L]

== Physical Plan ==
WholeStageCodegen
:  +- Range 0, 1, 8, 5, [id#39L]
----

NOTE: `QueryExecution` belongs to `org.apache.spark.sql.execution` package.

NOTE: `QueryExecution` is a transient feature of a spark-sql-Dataset.md[Dataset], i.e. it is not preserved across serializations.

## <span id="stringWithStats"> Text Representation With Statistics

```scala
stringWithStats: String
```

`stringWithStats`...FIXME

`stringWithStats` is used when [ExplainCommand](logical-operators/ExplainCommand.md) logical command is executed (with `cost` flag enabled).

=== [[debug]] debug Object

CAUTION: FIXME

=== [[completeString]] Building Complete Text Representation -- `completeString` Internal Method

CAUTION: FIXME

=== [[creating-instance]] Creating QueryExecution Instance

`QueryExecution` takes the following when created:

* [[sparkSession]] SparkSession.md[SparkSession]
* [[logical]] spark-sql-LogicalPlan.md[Logical plan]

## <span id="preparations"> Physical Query Optimizations (Physical Plan Preparation Rules)

```scala
preparations: Seq[Rule[SparkPlan]]
```

`preparations` is the set of the physical query optimization rules that transform a [physical query plan](physical-operators/SparkPlan.md) to be more efficient and optimized for execution.

`preparations` physical query optimizations are applied sequentially (one by one) to a physical plan in the following order:

. <<spark-sql-ExtractPythonUDFs.md#, ExtractPythonUDFs>>
. <<spark-sql-PlanSubqueries.md#, PlanSubqueries>>
. <<spark-sql-EnsureRequirements.md#, EnsureRequirements>>
. <<spark-sql-CollapseCodegenStages.md#, CollapseCodegenStages>>
. <<spark-sql-ReuseExchange.md#, ReuseExchange>>
. <<spark-sql-ReuseSubquery.md#, ReuseSubquery>>

`preparations` rules are used when:

* `QueryExecution` is requested for the <<executedPlan, executedPlan>> physical plan (through <<prepareForExecution, prepareForExecution>>)

* (Spark Structured Streaming) `IncrementalExecution` is requested for the physical optimization rules for streaming structured queries

### preparations Internal Utility

```scala
preparations(
  sparkSession: SparkSession,
  adaptiveExecutionRule: Option[InsertAdaptiveSparkPlan] = None): Seq[Rule[SparkPlan]]
```

`preparations` is the set of [Catalyst Rules](catalyst/Rule.md) (for transforming [physical operators](physical-operators/SparkPlan.md)) in the following order:

1. [InsertAdaptiveSparkPlan](InsertAdaptiveSparkPlan.md) (if defined)
1. [PlanDynamicPruningFilters](physical-optimizations/PlanDynamicPruningFilters.md)
1. [PlanSubqueries](spark-sql-PlanSubqueries.md)
1. [EnsureRequirements](spark-sql-EnsureRequirements.md)
1. [ApplyColumnarRulesAndInsertTransitions](physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md)
1. [CollapseCodegenStages](spark-sql-CollapseCodegenStages.md)
1. [ReuseExchange](spark-sql-ReuseExchange.md)
1. [ReuseSubquery](spark-sql-ReuseSubquery.md)

`preparations` is used when:

* `QueryExecution` is requested for [physical optimization rules (preparations)](#preparations)

* `QueryExecution` utility is requested to [prepareExecutedPlan](#prepareExecutedPlan)

## <span id="prepareExecutedPlan"><span id="prepareExecutedPlan-SparkPlan"> prepareExecutedPlan for Physical Operators

```scala
prepareExecutedPlan(
  spark: SparkSession,
  plan: SparkPlan): SparkPlan
```

`prepareExecutedPlan` is...FIXME

`prepareExecutedPlan` is used when:

* `QueryExecution` utility is requested to [prepareExecutedPlan for a logical operator](#prepareExecutedPlan-LogicalPlan)

* [PlanDynamicPruningFilters](physical-optimizations/PlanDynamicPruningFilters.md) physical optimization is executed

## <span id="prepareExecutedPlan-LogicalPlan"> prepareExecutedPlan for Logical Operators

```scala
prepareExecutedPlan(
  spark: SparkSession,
  plan: LogicalPlan): SparkPlan
```

`prepareExecutedPlan` is...FIXME

`prepareExecutedPlan` is used when [PlanSubqueries](spark-sql-PlanSubqueries.md) physical optimization is executed.

=== [[prepareForExecution]] Applying preparations Physical Query Optimization Rules to Physical Plan -- `prepareForExecution` Method

[source, scala]
----
prepareForExecution(plan: SparkPlan): SparkPlan
----

`prepareForExecution` takes <<preparations, physical preparation rules>> and applies them one by one to the input physical `plan`.

NOTE: `prepareForExecution` is used exclusively when `QueryExecution` is requested to <<executedPlan, prepare the physical plan for execution>>.

=== [[assertSupported]] `assertSupported` Method

[source, scala]
----
assertSupported(): Unit
----

`assertSupported` requests `UnsupportedOperationChecker` to spark-sql-UnsupportedOperationChecker.md#checkForBatch[checkForBatch] when...FIXME

NOTE: `assertSupported` is used exclusively when `QueryExecution` is requested for <<withCachedData, withCachedData>> logical plan.

=== [[assertAnalyzed]] Creating Analyzed Logical Plan and Checking Correctness -- `assertAnalyzed` Method

[source, scala]
----
assertAnalyzed(): Unit
----

`assertAnalyzed` triggers initialization of <<analyzed, analyzed>> (which is almost like executing it).

NOTE: `assertAnalyzed` executes <<analyzed, analyzed>> by accessing it and throwing the result away. Since `analyzed` is a lazy value in Scala, it will then get initialized for the first time and stays so forever.

`assertAnalyzed` then requests `Analyzer` to spark-sql-Analyzer-CheckAnalysis.md#checkAnalysis[validate analysis of the logical plan] (i.e. `analyzed`).

[NOTE]
====
`assertAnalyzed` uses <<sparkSession, SparkSession>> to SparkSession.md#sessionState[access the current `SessionState`] that it then uses to SessionState.md#analyzer[access the `Analyzer`].

In Scala the access path looks as follows.

[source, scala]
----
sparkSession.sessionState.analyzer
----
====

In case of any `AnalysisException`, `assertAnalyzed` creates a new `AnalysisException` to make sure that it holds <<analyzed, analyzed>> and reports it.

[NOTE]
====
`assertAnalyzed` is used when:

* `Dataset` spark-sql-Dataset.md#creating-instance[is created]
* `QueryExecution` <<withCachedData, is requested for `LogicalPlan` with cached data>>
* spark-sql-LogicalPlan-CreateViewCommand.md#run[CreateViewCommand] and spark-sql-LogicalPlan-AlterViewAsCommand.md#run[AlterViewAsCommand] are executed
====

=== [[toStringWithStats]] Building Text Representation with Cost Stats -- `toStringWithStats` Method

[source, scala]
----
toStringWithStats: String
----

`toStringWithStats` is a mere alias for <<completeString, completeString>> with `appendStats` flag enabled.

NOTE: `toStringWithStats` is a custom <<toString, toString>> with spark-sql-Statistics.md[cost statistics].

[source, scala]
----
// test dataset
val dataset = spark.range(20).limit(2)

// toStringWithStats in action - note Optimized Logical Plan section with Statistics
scala> dataset.queryExecution.toStringWithStats
res6: String =
== Parsed Logical Plan ==
GlobalLimit 2
+- LocalLimit 2
   +- Range (0, 20, step=1, splits=Some(8))

== Analyzed Logical Plan ==
id: bigint
GlobalLimit 2
+- LocalLimit 2
   +- Range (0, 20, step=1, splits=Some(8))

== Optimized Logical Plan ==
GlobalLimit 2, Statistics(sizeInBytes=32.0 B, rowCount=2, isBroadcastable=false)
+- LocalLimit 2, Statistics(sizeInBytes=160.0 B, isBroadcastable=false)
   +- Range (0, 20, step=1, splits=Some(8)), Statistics(sizeInBytes=160.0 B, isBroadcastable=false)

== Physical Plan ==
CollectLimit 2
+- *Range (0, 20, step=1, splits=Some(8))
----

NOTE: `toStringWithStats` is used exclusively when `ExplainCommand` spark-sql-LogicalPlan-ExplainCommand.md#run[is executed] (only when `cost` attribute is enabled).

=== [[hiveResultString]] Transforming SparkPlan Execution Result to Hive-Compatible Output Format -- `hiveResultString` Method

[source, scala]
----
hiveResultString(): Seq[String]
----

`hiveResultString` returns the result as a Hive-compatible output format.

[source, scala]
----
scala> spark.range(5).queryExecution.hiveResultString
res0: Seq[String] = ArrayBuffer(0, 1, 2, 3, 4)

scala> spark.read.csv("people.csv").queryExecution.hiveResultString
res4: Seq[String] = ArrayBuffer(id	name	age, 0	Jacek	42)
----

Internally, `hiveResultString` <<hiveResultString-transformations, transformation>> the <<executedPlan, SparkPlan>>.

[[hiveResultString-transformations]]
.hiveResultString's SparkPlan Transformations (in execution order)
[width="100%",cols="1,2",options="header"]
|===
| SparkPlan
| Description

| spark-sql-SparkPlan-ExecutedCommandExec.md[ExecutedCommandExec] for spark-sql-LogicalPlan-DescribeTableCommand.md[DescribeTableCommand]
| Executes `DescribeTableCommand` and transforms every spark-sql-Row.md[Row] to a Hive-compatible output format.

| spark-sql-SparkPlan-ExecutedCommandExec.md[ExecutedCommandExec] for <<spark-sql-LogicalPlan-ShowTablesCommand.md#, ShowTablesCommand>>
| Executes `ExecutedCommandExec` and transforms the result to a collection of table names.

| Any other SparkPlan.md[SparkPlan]
| Executes `SparkPlan` and transforms the result to a Hive-compatible output format.
|===

NOTE: `hiveResultString` is used exclusively when `SparkSQLDriver` (of ThriftServer) runs a command.

=== [[toString]] Extended Text Representation with Logical and Physical Plans

[source, scala]
----
toString: String
----

NOTE: `toString` is part of Java's `Object` Contract to...FIXME.

`toString` is a mere alias for <<completeString, completeString>> with `appendStats` flag disabled.

NOTE: `toString` is on the "other" side of <<toStringWithStats, toStringWithStats>> which has `appendStats` flag enabled.

## <span id="explainString"> explainString

```scala
explainString(
   mode: ExplainMode): String
```

`explainString`...FIXME

`explainString` is used when:

* `Dataset.explain` operator is executed

* [ExplainCommand](logical-operators/ExplainCommand.md) logical command is executed

## <span id="simpleString"> Simple (Basic) Text Representation

```scala
// Uses formatted `false`
simpleString: String
simpleString(
  formatted: Boolean): String
```

`simpleString` requests the <<executedPlan, optimized SparkPlan>> for the [text representation](catalyst/TreeNode.md#treeString) (of all nodes in the query tree) with `verbose` flag turned off.

In the end, `simpleString` adds *== Physical Plan ==* header to the text representation and <<withRedaction, redacts sensitive information>>.

```text
import org.apache.spark.sql.{functions => f}
val q = spark.range(10).withColumn("rand", f.rand())
val output = q.queryExecution.simpleString

scala> println(output)
== Physical Plan ==
*(1) Project [id#5L, rand(6017561978775952851) AS rand#7]
+- *(1) Range (0, 10, step=1, splits=8)
```

`simpleString` is used when:

* `QueryExecution` is requested to [explainString](#explainString) (with `SimpleMode` and `FormattedMode` modes)

* (Spark Structured Streaming) `StreamingExplainCommand` logical command is executed

## <span id="withRedaction"> Redacting Sensitive Information

```scala
withRedaction(
  message: String): String
```

`withRedaction` takes the value of spark-sql-properties.md#spark.sql.redaction.string.regex[spark.sql.redaction.string.regex] configuration property (as the regular expression to point at sensitive information) and requests Spark Core's `Utils` to redact sensitive information in the input `message`.

NOTE: Internally, Spark Core's `Utils.redact` uses Java's `Regex.replaceAllIn` to replace all matches of a pattern with a string.

NOTE: `withRedaction` is used when `QueryExecution` is requested for the <<simpleString, simple>>, <<toString, extended>> and <<stringWithStats, with statistics>> text representations.

## <span id="writePlans"> writePlans

```scala
writePlans(
   append: String => Unit,
   maxFields: Int): Unit
```

`writePlans`...FIXME

`writePlans` is used when...FIXME
