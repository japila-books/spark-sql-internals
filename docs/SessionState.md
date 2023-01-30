# SessionState &mdash; State Separation Layer Between SparkSessions

`SessionState` is a [state separation layer](#attributes) between Spark SQL sessions, including SQL configuration, tables, functions, UDFs, SQL parser, and everything else that depends on a [SQLConf](SQLConf.md).

## Attributes

### <span id="columnarRules"> ColumnarRules

```scala
columnarRules: Seq[ColumnarRule]
```

[ColumnarRule](ColumnarRule.md)s

### <span id="listenerManager"> ExecutionListenerManager

```scala
listenerManager: ExecutionListenerManager
```

[ExecutionListenerManager](ExecutionListenerManager.md)

### <span id="experimentalMethods"> ExperimentalMethods

```scala
experimentalMethods: ExperimentalMethods
```

[ExperimentalMethods](ExperimentalMethods.md)

### <span id="functionRegistry"> FunctionRegistry

```scala
functionRegistry: FunctionRegistry
```

[FunctionRegistry](FunctionRegistry.md)

### <span id="analyzer"> Logical Analyzer

```scala
analyzer: Analyzer
```

[Analyzer](Analyzer.md)

Initialized lazily (only when requested the first time) using the [analyzerBuilder](#analyzerBuilder) factory function.

### <span id="optimizer"> Logical Optimizer

```scala
optimizer: Optimizer
```

[Logical Optimizer](catalyst/Optimizer.md) that is created using the [optimizerBuilder function](#optimizerBuilder) (and cached for later usage)

Used when:

* `QueryExecution` is requested to [create an optimized logical plan](QueryExecution.md#optimizedPlan)
* (Structured Streaming) `IncrementalExecution` is requested to create an optimized logical plan

### <span id="sqlParser"> ParserInterface

```scala
sqlParser: ParserInterface
```

[ParserInterface](sql/ParserInterface.md)

### <span id="catalog"> SessionCatalog

```scala
catalog: SessionCatalog
```

[SessionCatalog](SessionCatalog.md) that is created using the [catalogBuilder function](#catalogBuilder) (and cached for later usage).

### <span id="resourceLoader"> SessionResourceLoader

```scala
resourceLoader: SessionResourceLoader
```

### <span id="planner"> Spark Query Planner

```scala
planner: SparkPlanner
```

[SparkPlanner](SparkPlanner.md)

### <span id="conf"> SQLConf

```scala
conf: SQLConf
```

[SQLConf](SQLConf.md)

### <span id="streamingQueryManager"> StreamingQueryManager

```scala
streamingQueryManager: StreamingQueryManager
```

### <span id="udfRegistration"><span id="UDFRegistration"> UDFRegistration

```scala
udfRegistration: UDFRegistration
```

`SessionState` is given an [UDFRegistration](UDFRegistration.md) when [created](#creating-instance).

### <span id="queryStagePrepRules"> AQE QueryStage Physical Preparation Rules

```scala
queryStagePrepRules: Seq[Rule[SparkPlan]]
```

`SessionState` can be given a collection of physical optimizations (`Rule[SparkPlan]`s) when [created](#creating-instance).

`queryStagePrepRules` is given when `BaseSessionStateBuilder` is requested to [build a SessionState](BaseSessionStateBuilder.md#build) based on [queryStagePrepRules](BaseSessionStateBuilder.md#queryStagePrepRules) (from a [SparkSessionExtensions](SparkSessionExtensions.md#buildQueryStagePrepRules)).

`queryStagePrepRules` is used to extend the built-in [QueryStage Physical Preparation Rules](physical-operators/AdaptiveSparkPlanExec.md#queryStagePreparationRules) in [Adaptive Query Execution](adaptive-query-execution/index.md).

## Creating Instance

`SessionState` takes the following to be created:

* <span id="sharedState"> [SharedState](SharedState.md)
* [SQLConf](#conf)
* [ExperimentalMethods](#experimentalMethods)
* [FunctionRegistry](#functionRegistry)
* [UDFRegistration](#udfRegistration)
* <span id="catalogBuilder"> Function to build a [SessionCatalog](SessionCatalog.md) (`() => SessionCatalog`)
* [ParserInterface](#sqlParser)
* <span id="analyzerBuilder"> Function to build a [Analyzer](Analyzer.md) (`() => Analyzer`)
* <span id="optimizerBuilder"> Function to build a [Logical Optimizer](catalyst/Optimizer.md) (`() => Optimizer`)
* [SparkPlanner](#planner)
* <span id="streamingQueryManagerBuilder"> Function to build a `StreamingQueryManager` (`() => StreamingQueryManager`)
* [ExecutionListenerManager](#listenerManager)
* <span id="resourceLoaderBuilder"> Function to build a `SessionResourceLoader` (`() => SessionResourceLoader`)
* <span id="createQueryExecution"> Function to build a [QueryExecution](QueryExecution.md) (`LogicalPlan => QueryExecution`)
* <span id="createClone"> `SessionState` Clone Function (`(SparkSession, SessionState) => SessionState`)
* [ColumnarRules](#columnarRules)
* [AQE QueryStage Preparation Rules](#queryStagePrepRules)

`SessionState` is created when:

* `SparkSession` is requested to [instantiateSessionState](SparkSession.md#instantiateSessionState) (when requested for the [SessionState](SparkSession.md#sessionState) per [spark.sql.catalogImplementation](StaticSQLConf.md#spark.sql.catalogImplementation) configuration property)

![Creating SessionState](images/spark-sql-SessionState.png)

---

When requested for the [SessionState](SparkSession.md#sessionState), `SparkSession` uses [spark.sql.catalogImplementation](StaticSQLConf.md#spark.sql.catalogImplementation) configuration property to load and create a [BaseSessionStateBuilder](BaseSessionStateBuilder.md) that is then requested to [create a SessionState instance](BaseSessionStateBuilder.md#build).

There are two `BaseSessionStateBuilders` available:

* (default) [SessionStateBuilder](SessionStateBuilder.md) for `in-memory` catalog
* [HiveSessionStateBuilder](hive/HiveSessionStateBuilder.md) for `hive` catalog

`hive` catalog is set when the `SparkSession` was [created](SparkSession-Builder.md#getOrCreate) with the Hive support enabled (using [Builder.enableHiveSupport](SparkSession-Builder.md#enableHiveSupport)).

## <span id="executePlan"> Creating QueryExecution For LogicalPlan

```scala
executePlan(
  plan: LogicalPlan): QueryExecution
```

`executePlan` uses the [createQueryExecution](#createQueryExecution) function to create a [QueryExecution](QueryExecution.md) for the given [LogicalPlan](logical-operators/LogicalPlan.md).

## <span id="newHadoopConf"> Creating New Hadoop Configuration

```scala
newHadoopConf(): Configuration
```

`newHadoopConf` returns a new Hadoop [Configuration](https://hadoop.apache.org/docs/r2.10.0/api/org/apache/hadoop/conf/Configuration.html) (with the `SparkContext.hadoopConfiguration` and all the configuration properties of the [SQLConf](#conf)).

## <span id="newHadoopConfWithOptions"> Creating New Hadoop Configuration With Extra Options

```scala
newHadoopConfWithOptions(
  options: Map[String, String]): Configuration
```

`newHadoopConfWithOptions` [creates a new Hadoop Configuration](#newHadoopConf) with the input `options` set (except `path` and `paths` options that are skipped).

`newHadoopConfWithOptions` is used when:

* `TextBasedFileFormat` is requested to [say whether it is splitable or not](datasources/TextBasedFileFormat.md#isSplitable)
* `FileSourceScanExec` physical operator is requested for the [input RDD](physical-operators/FileSourceScanExec.md#inputRDD)
* [InsertIntoHadoopFsRelationCommand](logical-operators/InsertIntoHadoopFsRelationCommand.md) logical command is executed
* `PartitioningAwareFileIndex` is requested for the [Hadoop Configuration](datasources/PartitioningAwareFileIndex.md#hadoopConf)

## Accessing SessionState

`SessionState` is available using [SparkSession.sessionState](SparkSession.md#sessionState).

```scala
import org.apache.spark.sql.SparkSession
assert(spark.isInstanceOf[SparkSession])
```

```text
// object SessionState in package org.apache.spark.sql.internal cannot be accessed directly
scala> :type spark.sessionState
org.apache.spark.sql.internal.SessionState
```
