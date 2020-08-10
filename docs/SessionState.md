# SessionState &mdash; State Separation Layer Between SparkSessions

:hadoop-version: 2.10.0
:url-hadoop-javadoc: https://hadoop.apache.org/docs/r{hadoop-version}/api

`SessionState` is the <<attributes, state separation layer>> between Spark SQL sessions, including SQL configuration, tables, functions, UDFs, SQL parser, and everything else that depends on a [SQLConf](SQLConf.md).

`SessionState` is available as the <<SparkSession.md#sessionState, sessionState>> property of a `SparkSession`.

[source, scala]
----
scala> :type spark
org.apache.spark.sql.SparkSession

scala> :type spark.sessionState
org.apache.spark.sql.internal.SessionState
----

`SessionState` is <<creating-instance, created>> when `SparkSession` is requested to <<SparkSession.md#instantiateSessionState, instantiateSessionState>> (when requested for the <<SparkSession.md#sessionState, SessionState>> per <<spark-sql-StaticSQLConf.md#spark.sql.catalogImplementation, spark.sql.catalogImplementation>> configuration property).

.Creating SessionState
image::images/spark-sql-SessionState.png[align="center"]

[NOTE]
====
When requested for the <<SparkSession.md#sessionState, SessionState>>, `SparkSession` uses <<spark-sql-StaticSQLConf.md#spark.sql.catalogImplementation, spark.sql.catalogImplementation>> configuration property to load and create a <<BaseSessionStateBuilder.md#, BaseSessionStateBuilder>> that is then requested to <<BaseSessionStateBuilder.md#build, create a SessionState instance>>.

There are two `BaseSessionStateBuilders` available:

* (default) <<spark-sql-SessionStateBuilder.md#, SessionStateBuilder>> for `in-memory` catalog

* hive/HiveSessionStateBuilder.md[HiveSessionStateBuilder] for `hive` catalog

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
| [Analyzer](Analyzer.md)
| [[analyzer]] [Logical Analyzer](Analyzer.md)

Initialized lazily (only when requested the first time) using the <<analyzerBuilder, analyzerBuilder>> factory function.

Used when...FIXME

| conf
| [SQLConf](SQLConf.md)
| [[conf]] FIXME

Used when...FIXME

| experimentalMethods
| [ExperimentalMethods](ExperimentalMethods.md)
| [[experimentalMethods]] FIXME

Used when...FIXME

| functionRegistry
| spark-sql-FunctionRegistry.md[FunctionRegistry]
| [[functionRegistry]] FIXME

Used when...FIXME

| listenerManager
| spark-sql-ExecutionListenerManager.md[ExecutionListenerManager]
| [[listenerManager]] FIXME

Used when...FIXME

| resourceLoader
| `SessionResourceLoader`
| [[resourceLoader]] FIXME

Used when...FIXME

| sqlParser
| spark-sql-ParserInterface.md[ParserInterface]
| [[sqlParser]] FIXME

Used when...FIXME

| streamingQueryManager
| `StreamingQueryManager`
| [[streamingQueryManager]] Used to manage streaming queries in *Spark Structured Streaming*

| udfRegistration
| spark-sql-UDFRegistration.md[UDFRegistration]
| [[udfRegistration]] Interface to register user-defined functions.

Used when...FIXME
|===

NOTE: `SessionState` is a `private[sql]` class and, given the package `org.apache.spark.sql.internal`, `SessionState` should be considered _internal_.

=== [[creating-instance]] Creating SessionState Instance

`SessionState` takes the following when created:

* [[sharedState]] <<SharedState.md#, SharedState>>
* [[conf]] [SQLConf](SQLConf.md)
* [[experimentalMethods]] [ExperimentalMethods](ExperimentalMethods.md)
* [[functionRegistry]] <<spark-sql-FunctionRegistry.md#, FunctionRegistry>>
* [[udfRegistration]] <<spark-sql-UDFRegistration.md#, UDFRegistration>>
* [[catalogBuilder]] `catalogBuilder` function to create a [SessionCatalog](SessionCatalog.md) (`() => SessionCatalog`)
* [[sqlParser]] <<spark-sql-ParserInterface.md#, ParserInterface>>
* [[analyzerBuilder]] `analyzerBuilder` function to create an [Analyzer](Analyzer.md) (`() => Analyzer`)
* [optimizerBuilder](#optimizerBuilder) function to create an [Optimizer](catalyst/Optimizer.md) (`() => Optimizer`)
* [[planner]] [SparkPlanner](SparkPlanner.md)
* [[streamingQueryManager]] Spark Structured Streaming's `StreamingQueryManager`
* [[listenerManager]] <<spark-sql-ExecutionListenerManager.md#, ExecutionListenerManager>>
* [[resourceLoaderBuilder]] `resourceLoaderBuilder` function to create a `SessionResourceLoader` (`() => SessionResourceLoader`)
* [[createQueryExecution]] `createQueryExecution` function to create a [QueryExecution](QueryExecution.md) given a <<spark-sql-LogicalPlan.md#, LogicalPlan>> (`LogicalPlan => QueryExecution`)
* [[createClone]] `createClone` function to clone the `SessionState` given a <<SparkSession.md#, SparkSession>> (`(SparkSession, SessionState) => SessionState`)

## <span id="optimizerBuilder"> optimizerBuilder Function

`SessionState` is given a function to create a [logical query plan optimizer](catalyst/Optimizer.md) (`() => Optimizer`) when [created](#creating-instance).

`optimizerBuilder` function is used when `SessionState` is requested for the [Optimizer](#optimizer) (and cached for later usage).

## <span id="optimizer"> Logical Query Plan Optimizer

[Optimizer](catalyst/Optimizer.md) that is created using [optimizerBuilder function](#optimizerBuilder) (and cached for later usage).

Used when:

* `QueryExecution` is requested to [create an optimized logical plan](QueryExecution.md#optimizedPlan)

* (Structured Streaming) `IncrementalExecution` is requested to create an optimized logical plan

## <span id="catalog"> SessionCatalog

[SessionCatalog](SessionCatalog.md)

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

`executePlan` simply executes the <<createQueryExecution, createQueryExecution>> function on the input <<spark-sql-LogicalPlan.md#, logical plan>> (that simply creates a [QueryExecution](QueryExecution.md) with the current <<BaseSessionStateBuilder.md#session, SparkSession>> and the input logical plan).

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

* `TextBasedFileFormat` is requested to spark-sql-TextBasedFileFormat.md#isSplitable[say whether it is splitable or not]

* `FileSourceScanExec` is requested for the spark-sql-SparkPlan-FileSourceScanExec.md#inputRDD[input RDD]

* `InsertIntoHadoopFsRelationCommand` is requested to spark-sql-LogicalPlan-InsertIntoHadoopFsRelationCommand.md#run[run]

* `PartitioningAwareFileIndex` is requested for the PartitioningAwareFileIndex.md#hadoopConf[Hadoop Configuration]
====
