# BaseSessionStateBuilder &mdash; Generic Builder of SessionState

`BaseSessionStateBuilder` is the <<contract, abstraction>> of <<implementations, builders>> that can <<newBuilder, produce a new BaseSessionStateBuilder>> to <<createClone, create a SessionState>>.

NOTE: `BaseSessionStateBuilder` and spark-sql-StaticSQLConf.md#spark.sql.catalogImplementation[spark.sql.catalogImplementation] configuration property allow for Hive and non-Hive Spark deployments.

[[contract]]
.BaseSessionStateBuilder Contract (Abstract Methods Only)
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| newBuilder
a| [[newBuilder]]

[source, scala]
----
newBuilder: (SparkSession, Option[SessionState]) => BaseSessionStateBuilder
----

Produces a new `BaseSessionStateBuilder` for given spark-sql-SparkSession.md[SparkSession] and optional spark-sql-SessionState.md[SessionState]

Used when `BaseSessionStateBuilder` is requested to <<createClone, create a SessionState>>

|===

`BaseSessionStateBuilder` is <<creating-instance, created>> when `SparkSession` is requested for a spark-sql-SparkSession.md#instantiateSessionState[SessionState].

[source, scala]
----
scala> :type spark
org.apache.spark.sql.SparkSession

scala> :type spark.sessionState
org.apache.spark.sql.internal.SessionState
----

`BaseSessionStateBuilder` holds <<properties, properties>> that (together with <<newBuilder, newBuilder>>) are used to create a spark-sql-SessionState.md[SessionState].

## Properties

### <span id="analyzer"> analyzer

[Logical analyzer](spark-sql-Analyzer.md)

### <span id="conf"> conf

[SQLConf](spark-sql-SQLConf.md)

### <span id="customOperatorOptimizationRules"> customOperatorOptimizationRules

Custom operator optimization rules to add to the [base Operator Optimization batch](spark-sql-Optimizer.md#extendedOperatorOptimizationRules).

When requested for the custom rules, `customOperatorOptimizationRules` simply requests the [SparkSessionExtensions](#extensions) to [buildOptimizerRules](spark-sql-SparkSessionExtensions.md#buildOptimizerRules).

### <span id="experimentalMethods"> experimentalMethods

[ExperimentalMethods](spark-sql-ExperimentalMethods.md)

### <span id="extensions"> extensions

[SparkSessionExtensions](spark-sql-SparkSessionExtensions.md)

### <span id="functionRegistry"> functionRegistry

[FunctionRegistry](spark-sql-FunctionRegistry.md)

### <span id="listenerManager"> listenerManager

[ExecutionListenerManager](spark-sql-ExecutionListenerManager.md)

### <span id="optimizer"> optimizer

[SparkOptimizer](spark-sql-SparkOptimizer.md) (that is downcast to the base <<spark-sql-Optimizer.md#, Optimizer>>) that is <<spark-sql-SparkOptimizer.md#creating-instance, created>> with the <<catalog, SessionCatalog>> and the <<experimentalMethods, ExperimentalMethods>>.

Note that the `SparkOptimizer` adds the <<customOperatorOptimizationRules, customOperatorOptimizationRules>> to the <<spark-sql-Optimizer.md#extendedOperatorOptimizationRules, operator optimization rules>>.

`optimizer` is used when `BaseSessionStateBuilder` is requested to <<build, create a SessionState>> (for the <<spark-sql-SessionState.md#optimizerBuilder, optimizerBuilder>> function to create an <<spark-sql-Optimizer.md#, Optimizer>> when requested for the <<spark-sql-SessionState.md#optimizer, Optimizer>>).

### <span id="planner"> planner

[SparkPlanner](spark-sql-SparkPlanner.md)

### <span id="resourceLoader"> resourceLoader

`SessionResourceLoader`

### <span id="sqlParser"> sqlParser

[ParserInterface](sql/ParserInterface.md)

### <span id="streamingQueryManager"> streamingQueryManager

Spark Structured Streaming's `StreamingQueryManager`

### <span id="udfRegistration"> udfRegistration

[UDFRegistration](spark-sql-UDFRegistration.md)

## Implementations

[cols="30,70",options="header",width="100%"]
|===
| BaseSessionStateBuilder
| Description

| spark-sql-SessionStateBuilder.md[SessionStateBuilder]
| [[SessionStateBuilder]]

| hive/HiveSessionStateBuilder.md[HiveSessionStateBuilder]
| [[HiveSessionStateBuilder]]

|===

[[NewBuilder]]
[NOTE]
====
`BaseSessionStateBuilder` defines a type alias https://github.com/apache/spark/blob/master/sql/core/src/main/scala/org/apache/spark/sql/internal/BaseSessionStateBuilder.scala#L57[NewBuilder] for a function to create a `BaseSessionStateBuilder`.

[source, scala]
----
type NewBuilder = (SparkSession, Option[SessionState]) => BaseSessionStateBuilder
----
====

NOTE: `BaseSessionStateBuilder` is an experimental and unstable API.

## <span id="catalog" /> SessionCatalog

```scala
catalog: SessionCatalog
```

`BaseSessionStateBuilder` creates a [SessionCatalog](spark-sql-SessionCatalog.md) on demand (and caches it for later usage).

Used to create [Analyzer](#analyzer), [Optimizer](#optimizer) and a [SessionState](#build) itself

!!! note HiveSessionStateBuilder
    [HiveSessionStateBuilder](hive/HiveSessionStateBuilder.md) manages its own Hive-aware [HiveSessionCatalog](hive/HiveSessionStateBuilder.md#catalog).

=== [[creating-instance]] Creating BaseSessionStateBuilder Instance

`BaseSessionStateBuilder` takes the following to be created:

* [[session]] spark-sql-SparkSession.md[SparkSession]
* [[parentState]] Optional spark-sql-SessionState.md[SessionState]

=== [[createClone]] Creating Clone of SessionState (Lazily) -- `createClone` Method

[source, scala]
----
createClone: (SparkSession, SessionState) => SessionState
----

`createClone` creates a spark-sql-SessionState.md[SessionState] (lazily as a function) using <<newBuilder, newBuilder>> followed by <<build, build>>.

NOTE: `createClone` is used when `BaseSessionStateBuilder` is requested for a <<build, SessionState>>.

=== [[build]] Creating SessionState -- `build` Method

[source, scala]
----
build(): SessionState
----

`build` creates a spark-sql-SessionState.md[SessionState] with the following:

* spark-sql-SparkSession.md#sharedState[SharedState] of the <<session, SparkSession>>
* <<conf, SQLConf>>
* <<experimentalMethods, ExperimentalMethods>>
* <<functionRegistry, FunctionRegistry>>
* <<udfRegistration, UDFRegistration>>
* <<catalog, SessionCatalog>>
* <<sqlParser, ParserInterface>>
* <<analyzer, Analyzer>>
* <<optimizer, Optimizer>>
* <<planner, SparkPlanner>>
* <<streamingQueryManager, StreamingQueryManager>>
* <<listenerManager, ExecutionListenerManager>>
* <<resourceLoader, SessionResourceLoader>>
* <<createQueryExecution, createQueryExecution>>
* <<createClone, createClone>>

[NOTE]
====
`build` is used when:

* `SparkSession` is requested for a spark-sql-SparkSession.md#sessionState[SessionState] (that in turn spark-sql-SparkSession.md#instantiateSessionState[builds one using a class name] based on spark-sql-StaticSQLConf.md#spark.sql.catalogImplementation[spark.sql.catalogImplementation] configuration property)

* `BaseSessionStateBuilder` is requested to <<createClone, create a clone>> of a `SessionState`
====

=== [[createQueryExecution]] Getting Function to Create QueryExecution For LogicalPlan -- `createQueryExecution` Method

[source, scala]
----
createQueryExecution: LogicalPlan => QueryExecution
----

`createQueryExecution` simply returns a function that takes a <<spark-sql-LogicalPlan.md#, LogicalPlan>> and creates a <<spark-sql-QueryExecution.md#creating-instance, QueryExecution>> with the <<session, SparkSession>> and the logical plan.

NOTE: `createQueryExecution` is used exclusively when `BaseSessionStateBuilder` is requested to <<build, create a SessionState instance>>.
