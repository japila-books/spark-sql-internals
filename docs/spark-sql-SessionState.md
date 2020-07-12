# SessionState &mdash; State Separation Layer Between SparkSessions

:hadoop-version: 2.10.0
:url-hadoop-javadoc: https://hadoop.apache.org/docs/r{hadoop-version}/api

`SessionState` is the <<attributes, state separation layer>> between Spark SQL sessions, including SQL configuration, tables, functions, UDFs, SQL parser, and everything else that depends on a link:spark-sql-SQLConf.adoc[SQLConf].

`SessionState` is available as the <<SparkSession.md#sessionState, sessionState>> property of a `SparkSession`.

[source, scala]
----
scala> :type spark
org.apache.spark.sql.SparkSession

scala> :type spark.sessionState
org.apache.spark.sql.internal.SessionState
----

`SessionState` is <<creating-instance, created>> when `SparkSession` is requested to <<SparkSession.md#instantiateSessionState, instantiateSessionState>> (when requested for the <<SparkSession.md#sessionState, SessionState>> per <<spark-sql-StaticSQLConf.adoc#spark.sql.catalogImplementation, spark.sql.catalogImplementation>> configuration property).

.Creating SessionState
image::images/spark-sql-SessionState.png[align="center"]

[NOTE]
====
When requested for the <<SparkSession.md#sessionState, SessionState>>, `SparkSession` uses <<spark-sql-StaticSQLConf.adoc#spark.sql.catalogImplementation, spark.sql.catalogImplementation>> configuration property to load and create a <<BaseSessionStateBuilder.md#, BaseSessionStateBuilder>> that is then requested to <<BaseSessionStateBuilder.md#build, create a SessionState instance>>.

There are two `BaseSessionStateBuilders` available:

* (default) <<spark-sql-SessionStateBuilder.adoc#, SessionStateBuilder>> for `in-memory` catalog

* link:hive/HiveSessionStateBuilder.adoc[HiveSessionStateBuilder] for `hive` catalog

`hive` catalog is set when the `SparkSession` was <<SparkSession-Builder.md#getOrCreate, created>> with the Hive support enabled (using <<SparkSession-Builder.md#enableHiveSupport, Builder.enableHiveSupport>>).
====

[[attributes]]
.SessionState's (Lazily-Initialized) Attributes
[cols="1m,1,2",options="header",width="100%"]
|===
| Name
| Type
| Description

| analyzer
| link:spark-sql-Analyzer.adoc[Analyzer]
| [[analyzer]] <<spark-sql-Analyzer.adoc#, Spark Analyzer>>

Initialized lazily (i.e. only when requested the first time) using the <<analyzerBuilder, analyzerBuilder>> factory function.

Used when...FIXME

| conf
| link:spark-sql-SQLConf.adoc[SQLConf]
| [[conf]] FIXME

Used when...FIXME

| experimentalMethods
| link:spark-sql-ExperimentalMethods.adoc[ExperimentalMethods]
| [[experimentalMethods]] FIXME

Used when...FIXME

| functionRegistry
| link:spark-sql-FunctionRegistry.adoc[FunctionRegistry]
| [[functionRegistry]] FIXME

Used when...FIXME

| listenerManager
| link:spark-sql-ExecutionListenerManager.adoc[ExecutionListenerManager]
| [[listenerManager]] FIXME

Used when...FIXME

| optimizer
| link:spark-sql-Optimizer.adoc[Optimizer]
| [[optimizer]] Logical query plan optimizer

Used exclusively when `QueryExecution`  link:spark-sql-QueryExecution.adoc#optimizedPlan[creates an optimized logical plan].

| resourceLoader
| `SessionResourceLoader`
| [[resourceLoader]] FIXME

Used when...FIXME

| sqlParser
| link:spark-sql-ParserInterface.adoc[ParserInterface]
| [[sqlParser]] FIXME

Used when...FIXME

| streamingQueryManager
| `StreamingQueryManager`
| [[streamingQueryManager]] Used to manage streaming queries in *Spark Structured Streaming*

| udfRegistration
| link:spark-sql-UDFRegistration.adoc[UDFRegistration]
| [[udfRegistration]] Interface to register user-defined functions.

Used when...FIXME
|===

NOTE: `SessionState` is a `private[sql]` class and, given the package `org.apache.spark.sql.internal`, `SessionState` should be considered _internal_.

=== [[creating-instance]] Creating SessionState Instance

`SessionState` takes the following when created:

* [[sharedState]] <<spark-sql-SharedState.adoc#, SharedState>>
* [[conf]] <<spark-sql-SQLConf.adoc#, SQLConf>>
* [[experimentalMethods]] <<spark-sql-ExperimentalMethods.adoc#, ExperimentalMethods>>
* [[functionRegistry]] <<spark-sql-FunctionRegistry.adoc#, FunctionRegistry>>
* [[udfRegistration]] <<spark-sql-UDFRegistration.adoc#, UDFRegistration>>
* [[catalogBuilder]] `catalogBuilder` function to create a <<spark-sql-SessionCatalog.adoc#, SessionCatalog>> (i.e. `() => SessionCatalog`)
* [[sqlParser]] <<spark-sql-ParserInterface.adoc#, ParserInterface>>
* [[analyzerBuilder]] `analyzerBuilder` function to create an <<spark-sql-Analyzer.adoc#, Analyzer>> (i.e. `() => Analyzer`)
* [[optimizerBuilder]] `optimizerBuilder` function to create an <<spark-sql-Optimizer.adoc#, Optimizer>> (i.e. `() => Optimizer`)
* [[planner]] <<spark-sql-SparkPlanner.adoc#, SparkPlanner>>
* [[streamingQueryManager]] Spark Structured Streaming's `StreamingQueryManager`
* [[listenerManager]] <<spark-sql-ExecutionListenerManager.adoc#, ExecutionListenerManager>>
* [[resourceLoaderBuilder]] `resourceLoaderBuilder` function to create a `SessionResourceLoader` (i.e. `() => SessionResourceLoader`)
* [[createQueryExecution]] `createQueryExecution` function to create a <<spark-sql-QueryExecution.adoc#, QueryExecution>> given a <<spark-sql-LogicalPlan.adoc#, LogicalPlan>> (i.e. `LogicalPlan => QueryExecution`)
* [[createClone]] `createClone` function to clone the `SessionState` given a <<SparkSession.md#, SparkSession>> (i.e. `(SparkSession, SessionState) => SessionState`)

## <span id="catalog" /> SessionCatalog

[SessionCatalog](spark-sql-SessionCatalog.md)

=== [[clone]] `clone` Method

[source, scala]
----
clone(newSparkSession: SparkSession): SessionState
----

`clone`...FIXME

NOTE: `clone` is used when...

=== [[executePlan]] "Executing" Logical Plan (Creating QueryExecution For LogicalPlan) -- `executePlan` Method

[source, scala]
----
executePlan(plan: LogicalPlan): QueryExecution
----

`executePlan` simply executes the <<createQueryExecution, createQueryExecution>> function on the input <<spark-sql-LogicalPlan.adoc#, logical plan>> (that simply creates a <<spark-sql-QueryExecution.adoc#creating-instance, QueryExecution>> with the current <<BaseSessionStateBuilder.md#session, SparkSession>> and the input logical plan).

=== [[refreshTable]] `refreshTable` Method

[source, scala]
----
refreshTable(tableName: String): Unit
----

`refreshTable`...FIXME

NOTE: `refreshTable` is used...FIXME

=== [[newHadoopConf]] Creating New Hadoop Configuration -- `newHadoopConf` Method

[source, scala]
----
newHadoopConf(): Configuration
----

`newHadoopConf` returns a new Hadoop {url-hadoop-javadoc}/org/apache/hadoop/conf/Configuration.html[Configuration] (with the `SparkContext.hadoopConfiguration` and all the configuration properties of the <<conf, SQLConf>>).

NOTE: `newHadoopConf` is used by `ScriptTransformation`, `ParquetRelation`, `StateStoreRDD`, and `SessionState` itself, and few other places.

=== [[newHadoopConfWithOptions]] Creating New Hadoop Configuration With Extra Options -- `newHadoopConfWithOptions` Method

[source, scala]
----
newHadoopConfWithOptions(options: Map[String, String]): Configuration
----

`newHadoopConfWithOptions` <<newHadoopConf, creates a new Hadoop Configuration>> with the input `options` set (except `path` and `paths` options that are skipped).

[NOTE]
====
`newHadoopConfWithOptions` is used when:

* `TextBasedFileFormat` is requested to link:spark-sql-TextBasedFileFormat.adoc#isSplitable[say whether it is splitable or not]

* `FileSourceScanExec` is requested for the link:spark-sql-SparkPlan-FileSourceScanExec.adoc#inputRDD[input RDD]

* `InsertIntoHadoopFsRelationCommand` is requested to link:spark-sql-LogicalPlan-InsertIntoHadoopFsRelationCommand.adoc#run[run]

* `PartitioningAwareFileIndex` is requested for the link:PartitioningAwareFileIndex.adoc#hadoopConf[Hadoop Configuration]
====
