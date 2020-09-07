title: Dataset

# Dataset -- Structured Query with Data Encoder

*Dataset* is a strongly-typed data structure in Spark SQL that represents a structured query.

NOTE: A structured query can be written using SQL or <<spark-sql-dataset-operators.md#, Dataset API>>.

The following figure shows the relationship between different entities of Spark SQL that all together give the `Dataset` data structure.

.Dataset's Internals
image::images/spark-sql-Dataset.png[align="center"]

It is therefore fair to say that `Dataset` consists of the following three elements:

* [QueryExecution](QueryExecution.md) (with the parsed unanalyzed <<spark-sql-LogicalPlan.md#, LogicalPlan>> of a structured query)

* [Encoder](spark-sql-Encoder.md) (of the type of the records for fast serialization and deserialization to and from <<spark-sql-InternalRow.md#, InternalRow>>)

* [SparkSession](SparkSession.md)

When <<creating-instance, created>>, `Dataset` takes such a 3-element tuple with a `SparkSession`, a `QueryExecution` and an `Encoder`.

`Dataset` is <<creating-instance, created>> when:

* <<apply, Dataset.apply>> (for a <<spark-sql-LogicalPlan.md#, LogicalPlan>> and a <<SparkSession.md#, SparkSession>> with the <<spark-sql-Encoder.md#, Encoder>> in a Scala implicit scope)

* <<ofRows, Dataset.ofRows>> (for a <<spark-sql-LogicalPlan.md#, LogicalPlan>> and a <<SparkSession.md#, SparkSession>>)

* <<spark-sql-Dataset-untyped-transformations.md#toDF, Dataset.toDF>> untyped transformation is used

* <<spark-sql-Dataset-typed-transformations.md#select, Dataset.select>>, <<spark-sql-Dataset-typed-transformations.md#randomSplit, Dataset.randomSplit>> and <<spark-sql-Dataset-typed-transformations.md#mapPartitions, Dataset.mapPartitions>> typed transformations are used

* <<spark-sql-KeyValueGroupedDataset.md#agg, KeyValueGroupedDataset.agg>> operator is used (that requests `KeyValueGroupedDataset` to <<spark-sql-KeyValueGroupedDataset.md#aggUntyped, aggUntyped>>)

* <<SparkSession.md#emptyDataset, SparkSession.emptyDataset>> and <<SparkSession.md#range, SparkSession.range>> operators are used

* `CatalogImpl` is requested to
[makeDataset](CatalogImpl.md#makeDataset) (when requested to [list databases](CatalogImpl.md#listDatabases), [tables](CatalogImpl.md#listTables), [functions](CatalogImpl.md#listFunctions) and [columns](CatalogImpl.md#listColumns))

* Spark Structured Streaming's `MicroBatchExecution` is requested to `runBatch`

Datasets are _lazy_ and structured query operators and expressions are only triggered when an action is invoked.

[source, scala]
----
import org.apache.spark.sql.SparkSession
val spark: SparkSession = ...

scala> val dataset = spark.range(5)
dataset: org.apache.spark.sql.Dataset[Long] = [id: bigint]

// Variant 1: filter operator accepts a Scala function
dataset.filter(n => n % 2 == 0).count

// Variant 2: filter operator accepts a Column-based SQL expression
dataset.filter('value % 2 === 0).count

// Variant 3: filter operator accepts a SQL query
dataset.filter("value % 2 = 0").count
----

The <<spark-sql-dataset-operators.md#, Dataset API>> offers declarative and type-safe operators that makes for an improved experience for data processing (comparing to spark-sql-DataFrame.md[DataFrames] that were a set of index- or column name-based spark-sql-Row.md[Rows]).

[NOTE]
====
`Dataset` was first introduced in Apache Spark *1.6.0* as an experimental feature, and has since turned itself into a fully supported API.

As of Spark *2.0.0*, spark-sql-DataFrame.md[DataFrame] - the flagship data abstraction of previous versions of Spark SQL - is currently a _mere_ type alias for `Dataset[Row]`:

[source, scala]
----
type DataFrame = Dataset[Row]
----

See https://github.com/apache/spark/blob/master/sql/core/src/main/scala/org/apache/spark/sql/package.scala#L45[package object sql].
====

`Dataset` offers convenience of RDDs with the performance optimizations of DataFrames and the strong static type-safety of Scala. The last feature of bringing the strong type-safety to spark-sql-DataFrame.md[DataFrame] makes Dataset so appealing. All the features together give you a more functional programming interface to work with structured data.

[source, scala]
----
scala> spark.range(1).filter('id === 0).explain(true)
== Parsed Logical Plan ==
'Filter ('id = 0)
+- Range (0, 1, splits=8)

== Analyzed Logical Plan ==
id: bigint
Filter (id#51L = cast(0 as bigint))
+- Range (0, 1, splits=8)

== Optimized Logical Plan ==
Filter (id#51L = 0)
+- Range (0, 1, splits=8)

== Physical Plan ==
*Filter (id#51L = 0)
+- *Range (0, 1, splits=8)

scala> spark.range(1).filter(_ == 0).explain(true)
== Parsed Logical Plan ==
'TypedFilter <function1>, class java.lang.Long, [StructField(value,LongType,true)], unresolveddeserializer(newInstance(class java.lang.Long))
+- Range (0, 1, splits=8)

== Analyzed Logical Plan ==
id: bigint
TypedFilter <function1>, class java.lang.Long, [StructField(value,LongType,true)], newInstance(class java.lang.Long)
+- Range (0, 1, splits=8)

== Optimized Logical Plan ==
TypedFilter <function1>, class java.lang.Long, [StructField(value,LongType,true)], newInstance(class java.lang.Long)
+- Range (0, 1, splits=8)

== Physical Plan ==
*Filter <function1>.apply
+- *Range (0, 1, splits=8)
----

It is only with Datasets to have syntax and analysis checks at compile time (that was not possible using spark-sql-DataFrame.md[DataFrame], regular SQL queries or even RDDs).

Using `Dataset` objects turns `DataFrames` of spark-sql-Row.md[Row] instances into a `DataFrames` of case classes with proper names and types (following their equivalents in the case classes). Instead of using indices to access respective fields in a DataFrame and cast it to a type, all this is automatically handled by Datasets and checked by the Scala compiler.

If however a spark-sql-LogicalPlan.md[LogicalPlan] is used to <<creating-instance, create a `Dataset`>>, the logical plan is first SessionState.md#executePlan[executed] (using the current SessionState.md#executePlan[SessionState] in the `SparkSession`) that yields the [QueryExecution](QueryExecution.md) plan.

A `Dataset` is <<Queryable, Queryable>> and `Serializable`, i.e. can be saved to a persistent storage.

NOTE: SparkSession.md[SparkSession] and [QueryExecution](QueryExecution.md) are transient attributes of a `Dataset` and therefore do not participate in Dataset serialization. The only _firmly-tied_ feature of a `Dataset` is the spark-sql-Encoder.md[Encoder].

You can request the ["untyped" view](spark-sql-dataset-operators.md#toDF) of a Dataset or access the spark-sql-dataset-operators.md#rdd[RDD] that is generated after executing the query. It is supposed to give you a more pleasant experience while transitioning from the legacy RDD-based or DataFrame-based APIs you may have used in the earlier versions of Spark SQL or encourage migrating from Spark Core's RDD API to Spark SQL's Dataset API.

The default storage level for `Datasets` is spark-rdd-caching.md[MEMORY_AND_DISK] because recomputing the in-memory columnar representation of the underlying table is expensive. You can however spark-sql-caching-and-persistence.md#persist[persist a `Dataset`].

NOTE: Spark 2.0 has introduced a new query model called spark-structured-streaming.md[Structured Streaming] for continuous incremental execution of structured queries. That made possible to consider Datasets a static and bounded as well as streaming and unbounded data sets with a single unified API for different execution models.

A `Dataset` is spark-sql-dataset-operators.md#isLocal[local] if it was created from local collections using SparkSession.md#emptyDataset[SparkSession.emptyDataset] or SparkSession.md#createDataset[SparkSession.createDataset] methods and their derivatives like <<toDF,toDF>>. If so, the queries on the Dataset can be optimized and run locally, i.e. without using Spark executors.

NOTE: `Dataset` makes sure that the underlying `QueryExecution` is [analyzed](QueryExecution.md#analyzed) and spark-sql-Analyzer-CheckAnalysis.md#checkAnalysis[checked].

[[properties]]
[[attributes]]
.Dataset's Properties
[cols="1,2",options="header",width="100%",separator="!"]
!===
! Name
! Description

! [[boundEnc]] `boundEnc`
! spark-sql-ExpressionEncoder.md[ExpressionEncoder]

Used when...FIXME

! [[deserializer]] `deserializer`
a! Deserializer expressions/Expression.md[expression] to convert internal rows to objects of type `T`

Created lazily by requesting the <<exprEnc, ExpressionEncoder>> to spark-sql-ExpressionEncoder.md#resolveAndBind[resolveAndBind]

Used when:

* `Dataset` is <<apply, created>> (for a logical plan in a given `SparkSession`)

* spark-sql-dataset-operators.md#spark-sql-dataset-operators.md[Dataset.toLocalIterator] operator is used (to create a Java `Iterator` of objects of type `T`)

* `Dataset` is requested to <<collectFromPlan, collect all rows from a spark plan>>

! [[exprEnc]] `exprEnc`
! Implicit spark-sql-ExpressionEncoder.md[ExpressionEncoder]

Used when...FIXME

! `logicalPlan`
a! [[logicalPlan]] Analyzed <<spark-sql-LogicalPlan.md#, logical plan>> with all <<spark-sql-LogicalPlan-Command.md#, logical commands>> executed and turned into a <<spark-sql-LogicalPlan-LocalRelation.md#creating-instance, LocalRelation>>.

[source, scala]
----
logicalPlan: LogicalPlan
----

When initialized, `logicalPlan` requests the <<queryExecution, QueryExecution>> for [analyzed logical plan](QueryExecution.md#analyzed). If the plan is a <<spark-sql-LogicalPlan-Command.md#, logical command>> or a union thereof, `logicalPlan` <<withAction, executes the QueryExecution>> (using <<SparkPlan.md#executeCollect, executeCollect>>).

! `planWithBarrier`
a! [[planWithBarrier]]

[source, scala]
----
planWithBarrier: AnalysisBarrier
----

! [[rdd]] `rdd`
a! (lazily-created) spark-rdd.md[RDD] of JVM objects of type `T` (as converted from rows in `Dataset` in the spark-sql-InternalRow.md[internal binary row format]).

[source, scala]
----
rdd: RDD[T]
----

NOTE: `rdd` gives `RDD` with the extra execution step to convert rows from their internal binary row format to JVM objects that will impact the JVM memory as the objects are inside JVM (while were outside before). You should not use `rdd` directly.

Internally, `rdd` first spark-sql-CatalystSerde.md#deserialize[creates a new logical plan that deserializes] the Dataset's <<logicalPlan, logical plan>>.

[source, scala]
----
val dataset = spark.range(5).withColumn("group", 'id % 2)
scala> dataset.rdd.toDebugString
res1: String =
(8) MapPartitionsRDD[8] at rdd at <console>:26 [] // <-- extra deserialization step
 |  MapPartitionsRDD[7] at rdd at <console>:26 []
 |  MapPartitionsRDD[6] at rdd at <console>:26 []
 |  MapPartitionsRDD[5] at rdd at <console>:26 []
 |  ParallelCollectionRDD[4] at rdd at <console>:26 []

// Compare with a more memory-optimized alternative
// Avoids copies and has no schema
scala> dataset.queryExecution.toRdd.toDebugString
res2: String =
(8) MapPartitionsRDD[11] at toRdd at <console>:26 []
 |  MapPartitionsRDD[10] at toRdd at <console>:26 []
 |  ParallelCollectionRDD[9] at toRdd at <console>:26 []
----

`rdd` then requests `SessionState` to SessionState.md#executePlan[execute the logical plan] to get the corresponding [RDD of binary rows](QueryExecution.md#toRdd).

NOTE: `rdd` uses <<sparkSession, SparkSession>> to SparkSession.md#sessionState[access `SessionState`].

`rdd` then requests the Dataset's <<exprEnc, ExpressionEncoder>> for the expressions/Expression.md#dataType[data type] of the rows (using spark-sql-ExpressionEncoder.md#deserializer[deserializer] expression) and spark-rdd-transformations.md#mapPartitions[maps over them (per partition)] to create records of the expected type `T`.

NOTE: `rdd` is at the "boundary" between the internal binary row format and the JVM type of the dataset. Avoid the extra deserialization step to lower JVM memory requirements of your Spark application.

! [[sqlContext]] `sqlContext`
! Lazily-created spark-sql-SQLContext.md[SQLContext]

Used when...FIXME
!===

=== [[inputFiles]] Getting Input Files of Relations (in Structured Query) -- `inputFiles` Method

[source, scala]
----
inputFiles: Array[String]
----

`inputFiles` requests <<queryExecution, QueryExecution>> for [optimized logical plan](QueryExecution.md#optimizedPlan) and collects the following logical operators:

* spark-sql-LogicalPlan-LogicalRelation.md[LogicalRelation] with spark-sql-FileRelation.md[FileRelation] (as the spark-sql-LogicalPlan-LogicalRelation.md#relation[BaseRelation])

* spark-sql-FileRelation.md[FileRelation]

* hive/HiveTableRelation.md[HiveTableRelation]

`inputFiles` then requests the logical operators for their underlying files:

* spark-sql-FileRelation.md#inputFiles[inputFiles] of the `FileRelations`

* spark-sql-CatalogStorageFormat.md#locationUri[locationUri] of the `HiveTableRelation`

=== [[resolve]] `resolve` Internal Method

[source, scala]
----
resolve(colName: String): NamedExpression
----

CAUTION: FIXME

=== [[creating-instance]] Creating Dataset Instance

`Dataset` takes the following when created:

* [[sparkSession]] [SparkSession](SparkSession.md)
* [[queryExecution]] [QueryExecution](QueryExecution.md)
* [[encoder]] [Encoder](spark-sql-Encoder.md) for the type `T` of the records

NOTE: You can also create a `Dataset` using spark-sql-LogicalPlan.md[LogicalPlan] that is immediately SessionState.md#executePlan[executed using `SessionState`].

Internally, `Dataset` requests <<queryExecution, QueryExecution>> to [analyze itself](QueryExecution.md#assertAnalyzed).

`Dataset` initializes the <<internal-registries, internal registries and counters>>.

=== [[isLocal]] Is Dataset Local? -- `isLocal` Method

[source, scala]
----
isLocal: Boolean
----

`isLocal` flag is enabled (i.e. `true`) when operators like `collect` or `take` could be run locally, i.e. without using executors.

Internally, `isLocal` checks whether the logical query plan of a `Dataset` is spark-sql-LogicalPlan-LocalRelation.md[LocalRelation].

=== [[isStreaming]] Is Dataset Streaming? -- `isStreaming` method

[source, scala]
----
isStreaming: Boolean
----

`isStreaming` is enabled (i.e. `true`) when the logical plan spark-sql-LogicalPlan.md#isStreaming[is streaming].

Internally, `isStreaming` takes the Dataset's spark-sql-LogicalPlan.md[logical plan] and gives spark-sql-LogicalPlan.md#isStreaming[whether the plan is streaming or not].

=== [[Queryable]] Queryable

CAUTION: FIXME

=== [[withNewRDDExecutionId]] `withNewRDDExecutionId` Internal Method

[source, scala]
----
withNewRDDExecutionId[U](body: => U): U
----

`withNewRDDExecutionId` executes the input `body` action under <<spark-sql-SQLExecution.md#withNewExecutionId, new execution id>>.

CAUTION: FIXME What's the difference between `withNewRDDExecutionId` and <<withNewExecutionId, withNewExecutionId>>?

NOTE: `withNewRDDExecutionId` is used when <<spark-sql-dataset-operators.md#foreach, Dataset.foreach>> and <<spark-sql-dataset-operators.md#foreachPartition, Dataset.foreachPartition>> actions are used.

## <span id="ofRows"> Creating DataFrame (For Logical Query Plan and SparkSession)

```scala
ofRows(
  sparkSession: SparkSession,
  logicalPlan: LogicalPlan): DataFrame
```

!!! note
    `ofRows` is part of `Dataset` Scala object that is marked as a `private[sql]` and so can only be accessed from code in `org.apache.spark.sql` package.

`ofRows` returns spark-sql-DataFrame.md[DataFrame] (which is the type alias for `Dataset[Row]`). `ofRows` uses spark-sql-RowEncoder.md[RowEncoder] to convert the schema (based on the input `logicalPlan` logical plan).

Internally, `ofRows` SessionState.md#executePlan[prepares the input `logicalPlan` for execution] and creates a `Dataset[Row]` with the current SparkSession.md[SparkSession], the [QueryExecution](QueryExecution.md) and [RowEncoder](spark-sql-RowEncoder.md).

`ofRows` is used when:

* `DataFrameReader` is requested to [load data from a data source](DataFrameReader.md#load)

* `Dataset` is requested to execute <<checkpoint, checkpoint>>, `mapPartitionsInR`, <<withPlan, untyped transformations>> and <<withSetOperator, set-based typed transformations>>

* `RelationalGroupedDataset` is requested to <<spark-sql-RelationalGroupedDataset.md#toDF, create a DataFrame from aggregate expressions>>, `flatMapGroupsInR` and `flatMapGroupsInPandas`

* `SparkSession` is requested to <<SparkSession.md#baseRelationToDataFrame, create a DataFrame from a BaseRelation>>, <<SparkSession.md#createDataFrame, createDataFrame>>, <<SparkSession.md#internalCreateDataFrame, internalCreateDataFrame>>, <<SparkSession.md#sql, sql>> and <<SparkSession.md#table, table>>

* `CacheTableCommand`, <<spark-sql-LogicalPlan-CreateTempViewUsing.md#run, CreateTempViewUsing>>, <<spark-sql-LogicalPlan-InsertIntoDataSourceCommand.md#run, InsertIntoDataSourceCommand>> and `SaveIntoDataSourceCommand` logical commands are executed (run)

* `DataSource` is requested to <<spark-sql-DataSource.md#writeAndRead, writeAndRead>> (for a <<spark-sql-CreatableRelationProvider.md#, CreatableRelationProvider>>)

* `FrequentItems` is requested to `singlePassFreqItems`

* `StatFunctions` is requested to `crossTabulate` and `summary`

* Spark Structured Streaming's `DataStreamReader` is requested to `load`

* Spark Structured Streaming's `DataStreamWriter` is requested to `start`

* Spark Structured Streaming's `FileStreamSource` is requested to `getBatch`

* Spark Structured Streaming's `MemoryStream` is requested to `toDF`

=== [[withNewExecutionId]] Tracking Multi-Job Structured Query Execution (PySpark) -- `withNewExecutionId` Internal Method

[source, scala]
----
withNewExecutionId[U](body: => U): U
----

`withNewExecutionId` executes the input `body` action under <<spark-sql-SQLExecution.md#withNewExecutionId, new execution id>>.

NOTE: `withNewExecutionId` sets a unique execution id so that all Spark jobs belong to the `Dataset` action execution.

[NOTE]
====
`withNewExecutionId` is used exclusively when `Dataset` is executing Python-based actions (i.e. `collectToPython`, `collectAsArrowToPython` and `toPythonIterator`) that are not of much interest in this gitbook.

Feel free to contact me at jacek@japila.pl if you think I should re-consider my decision.
====

=== [[withAction]] Executing Action Under New Execution ID -- `withAction` Internal Method

[source, scala]
----
withAction[U](name: String, qe: QueryExecution)(action: SparkPlan => U)
----

`withAction` requests `QueryExecution` for the [optimized physical query plan](QueryExecution.md#executedPlan) and SparkPlan.md[resets the metrics] of every physical operator (in the physical plan).

`withAction` requests `SQLExecution` to <<spark-sql-SQLExecution.md#withNewExecutionId, execute>> the input `action` with the executable physical plan (tracked under a new execution id).

In the end, `withAction` notifies `ExecutionListenerManager` that the `name` action has finished ExecutionListenerManager.md#onSuccess[successfully] or ExecutionListenerManager.md#onFailure[with an exception].

NOTE: `withAction` uses <<sparkSession, SparkSession>> to access SparkSession.md#listenerManager[ExecutionListenerManager].

[NOTE]
====
`withAction` is used when `Dataset` is requested for the following:

* <<logicalPlan, Computing the logical plan>> (and executing a spark-sql-LogicalPlan-Command.md[logical command] or their `Union`)

* Dataset operators: <<spark-sql-dataset-operators.md#collect, collect>>, <<spark-sql-dataset-operators.md#count, count>>, <<spark-sql-dataset-operators.md#head, head>> and <<spark-sql-dataset-operators.md#toLocalIterator, toLocalIterator>>
====

=== [[apply]] Creating Dataset Instance (For LogicalPlan and SparkSession) -- `apply` Internal Factory Method

[source, scala]
----
apply[T: Encoder](sparkSession: SparkSession, logicalPlan: LogicalPlan): Dataset[T]
----

NOTE: `apply` is part of `Dataset` Scala object that is marked as a `private[sql]` and so can only be accessed from code in `org.apache.spark.sql` package.

`apply`...FIXME

[NOTE]
====
`apply` is used when:

* `Dataset` is requested to execute <<withTypedPlan, typed transformations>> and <<withSetOperator, set-based typed transformations>>

* Spark Structured Streaming's `MemoryStream` is requested to `toDS`
====

=== [[collectFromPlan]] Collecting All Rows From Spark Plan -- `collectFromPlan` Internal Method

[source, scala]
----
collectFromPlan(plan: SparkPlan): Array[T]
----

`collectFromPlan`...FIXME

NOTE: `collectFromPlan` is used for spark-sql-dataset-operators.md#head[Dataset.head], spark-sql-dataset-operators.md#collect[Dataset.collect] and spark-sql-dataset-operators.md#collectAsList[Dataset.collectAsList] operators.

=== [[selectUntyped]] `selectUntyped` Internal Method

[source, scala]
----
selectUntyped(columns: TypedColumn[_, _]*): Dataset[_]
----

`selectUntyped`...FIXME

NOTE: `selectUntyped` is used exclusively when <<spark-sql-Dataset-typed-transformations.md#select, Dataset.select>> typed transformation is used.

=== [[withTypedPlan]] Helper Method for Typed Transformations -- `withTypedPlan` Internal Method

[source, scala]
----
withTypedPlan[U: Encoder](logicalPlan: LogicalPlan): Dataset[U]
----

`withTypedPlan`...FIXME

NOTE: `withTypedPlan` is annotated with Scala's https://www.scala-lang.org/api/current/scala/inline.html[@inline] annotation that requests the Scala compiler to try especially hard to inline it.

NOTE: `withTypedPlan` is used in the `Dataset` <<spark-sql-Dataset-typed-transformations.md#, typed transformations>>, i.e. <<spark-sql-Dataset-typed-transformations.md#withWatermark, withWatermark>>, <<spark-sql-Dataset-typed-transformations.md#joinWith, joinWith>>, <<spark-sql-Dataset-typed-transformations.md#hint, hint>>, <<spark-sql-Dataset-typed-transformations.md#as, as>>, <<spark-sql-Dataset-typed-transformations.md#filter, filter>>, <<spark-sql-Dataset-typed-transformations.md#limit, limit>>, <<spark-sql-Dataset-typed-transformations.md#sample, sample>>, <<spark-sql-Dataset-typed-transformations.md#dropDuplicates, dropDuplicates>>, <<spark-sql-Dataset-typed-transformations.md#filter, filter>>, <<spark-sql-Dataset-typed-transformations.md#map, map>>, <<spark-sql-Dataset-typed-transformations.md#repartition, repartition>>, <<spark-sql-Dataset-typed-transformations.md#repartitionByRange, repartitionByRange>>, <<spark-sql-Dataset-typed-transformations.md#coalesce, coalesce>> and <<spark-sql-Dataset-typed-transformations.md#sort, sort>> with <<spark-sql-Dataset-typed-transformations.md#sortWithinPartitions, sortWithinPartitions>> (through the <<sortInternal, sortInternal>> internal method).

=== [[withSetOperator]] Helper Method for Set-Based Typed Transformations -- `withSetOperator` Internal Method

[source, scala]
----
withSetOperator[U: Encoder](
  logicalPlan: LogicalPlan): Dataset[U]
----

`withSetOperator`...FIXME

NOTE: `withSetOperator` is annotated with Scala's https://www.scala-lang.org/api/current/scala/inline.html[@inline] annotation that requests the Scala compiler to try especially hard to inline it.

NOTE: `withSetOperator` is used for the spark-sql-Dataset-typed-transformations.md[Dataset's typed transformations] (i.e. spark-sql-Dataset-typed-transformations.md#union[union], spark-sql-Dataset-typed-transformations.md#unionByName[unionByName], spark-sql-Dataset-typed-transformations.md#intersect[intersect], spark-sql-Dataset-typed-transformations.md#intersectAll[intersectAll], spark-sql-Dataset-typed-transformations.md#except[except] and spark-sql-Dataset-typed-transformations.md#exceptAll[exceptAll]).

=== [[sortInternal]] `sortInternal` Internal Method

[source, scala]
----
sortInternal(global: Boolean, sortExprs: Seq[Column]): Dataset[T]
----

`sortInternal` <<withTypedPlan, creates a Dataset>> with <<spark-sql-LogicalPlan-Sort.md#, Sort>> unary logical operator (and the <<logicalPlan, logicalPlan>> as the <<spark-sql-LogicalPlan-Sort.md#child, child logical plan>>).

[source, scala]
----
val nums = Seq((0, "zero"), (1, "one")).toDF("id", "name")
// Creates a Sort logical operator:
// - descending sort direction for id column (specified explicitly)
// - name column is wrapped with ascending sort direction
val numsSorted = nums.sort('id.desc, 'name)
val logicalPlan = numsSorted.queryExecution.logical
scala> println(logicalPlan.numberedTreeString)
00 'Sort ['id DESC NULLS LAST, 'name ASC NULLS FIRST], true
01 +- Project [_1#11 AS id#14, _2#12 AS name#15]
02    +- LocalRelation [_1#11, _2#12]
----

Internally, `sortInternal` firstly builds ordering expressions for the given `sortExprs` columns, i.e. takes the `sortExprs` columns and makes sure that they are <<spark-sql-Expression-SortOrder.md#, SortOrder>> expressions already (and leaves them untouched) or wraps them into <<spark-sql-Expression-SortOrder.md#, SortOrder>> expressions with <<spark-sql-Expression-SortOrder.md#Ascending, Ascending>> sort direction.

In the end, `sortInternal` <<withTypedPlan, creates a Dataset>> with <<spark-sql-LogicalPlan-Sort.md#, Sort>> unary logical operator (with the ordering expressions, the given `global` flag, and the <<logicalPlan, logicalPlan>> as the <<spark-sql-LogicalPlan-Sort.md#child, child logical plan>>).

NOTE: `sortInternal` is used for the <<spark-sql-dataset-operators.md#sort, sort>> and <<spark-sql-dataset-operators.md#sortWithinPartitions, sortWithinPartitions>> typed transformations in the Dataset API (with the only change of the `global` flag being enabled and disabled, respectively).

=== [[withPlan]] Helper Method for Untyped Transformations and Basic Actions -- `withPlan` Internal Method

[source, scala]
----
withPlan(logicalPlan: LogicalPlan): DataFrame
----

`withPlan` simply uses <<ofRows, ofRows>> internal factory method to create a `DataFrame` for the input <<spark-sql-LogicalPlan.md#, LogicalPlan>> and the current <<sparkSession, SparkSession>>.

NOTE: `withPlan` is annotated with Scala's https://www.scala-lang.org/api/current/scala/inline.html[@inline] annotation that requests the Scala compiler to try especially hard to inline it.

NOTE: `withPlan` is used in the `Dataset` <<spark-sql-Dataset-untyped-transformations.md#, untyped transformations>> (i.e. <<spark-sql-Dataset-untyped-transformations.md#join, join>>, <<spark-sql-Dataset-untyped-transformations.md#crossJoin, crossJoin>> and <<spark-sql-Dataset-untyped-transformations.md#select, select>>) and <<spark-sql-Dataset-basic-actions.md#, basic actions>> (i.e. <<spark-sql-Dataset-basic-actions.md#createTempView, createTempView>>, <<spark-sql-Dataset-basic-actions.md#createOrReplaceTempView, createOrReplaceTempView>>, <<spark-sql-Dataset-basic-actions.md#createGlobalTempView, createGlobalTempView>> and <<spark-sql-Dataset-basic-actions.md#createOrReplaceGlobalTempView, createOrReplaceGlobalTempView>>).

=== [[i-want-more]] Further Reading and Watching

* (video) https://youtu.be/i7l3JQRx7Qw[Structuring Spark: DataFrames, Datasets, and Streaming]
