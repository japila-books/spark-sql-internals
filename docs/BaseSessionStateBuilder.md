# BaseSessionStateBuilder &mdash; Generic Builder of SessionState

`BaseSessionStateBuilder` is an [abstraction](#contract) of [builders](#extensions) that can [produce a new BaseSessionStateBuilder](#newBuilder) to [create a SessionState](#createClone).

!!! note "spark.sql.catalogImplementation Configuration Property"
    `BaseSessionStateBuilder` and [spark.sql.catalogImplementation](spark-sql-StaticSQLConf.md#spark.sql.catalogImplementation) configuration property allow for Hive and non-Hive Spark deployments.

```text
scala> :type spark
org.apache.spark.sql.SparkSession

scala> :type spark.sessionState
org.apache.spark.sql.internal.SessionState
```

`BaseSessionStateBuilder` holds [properties](#properties) that (together with [newBuilder](#newBuilder)) are used to create a [SessionState](spark-sql-SessionState.md).

## Contract

### <span id="newBuilder"> newBuilder

```scala
newBuilder: (SparkSession, Option[SessionState]) => BaseSessionStateBuilder
```

Produces a new `BaseSessionStateBuilder` for given SparkSession.md[SparkSession] and optional spark-sql-SessionState.md[SessionState]

Used when `BaseSessionStateBuilder` is requested to <<createClone, create a SessionState>>

## Implementations

* [HiveSessionStateBuilder](hive/HiveSessionStateBuilder.md)
* [SessionStateBuilder](spark-sql-SessionStateBuilder.md)

## Creating Instance

`BaseSessionStateBuilder` takes the following to be created:

* <span id="session"> [SparkSession](SparkSession.md)
* <span id="parentState"> Optional parent [SessionState](spark-sql-SessionState.md) (default: undefined)

`BaseSessionStateBuilder` is created when `SparkSession` is requested to [instantiateSessionState](SparkSession.md#instantiateSessionState).

## SQL Services

The following SQL services are created on demand (_lazily_) once and reused.

### <span id="analyzer"> Analyzer

```scala
analyzer: Analyzer
```

[Logical analyzer](spark-sql-Analyzer.md)

### <span id="catalog"> SessionCatalog

```scala
catalog: SessionCatalog
```

`BaseSessionStateBuilder` creates a [SessionCatalog](spark-sql-SessionCatalog.md) on demand (and caches it for later usage).

Used to create [Analyzer](#analyzer), [Optimizer](#optimizer) and a [SessionState](#build) itself

!!! note HiveSessionStateBuilder
    [HiveSessionStateBuilder](hive/HiveSessionStateBuilder.md) manages its own Hive-aware [HiveSessionCatalog](hive/HiveSessionStateBuilder.md#catalog).

### <span id="catalogManager"> CatalogManager

```scala
catalogManager: CatalogManager
```

### <span id="conf"> SQLConf

[SQLConf](spark-sql-SQLConf.md)

### <span id="experimentalMethods"> ExperimentalMethods

[ExperimentalMethods](spark-sql-ExperimentalMethods.md)

### <span id="functionRegistry"> FunctionRegistry

[FunctionRegistry](spark-sql-FunctionRegistry.md)

### <span id="resourceLoader"> SessionResourceLoader

```scala
resourceLoader: SessionResourceLoader
```

`SessionResourceLoader`

### <span id="sqlParser"> ParserInterface

```scala
sqlParser: ParserInterface
```

[ParserInterface](sql/ParserInterface.md)

### <span id="v2SessionCatalog"> V2SessionCatalog

```scala
v2SessionCatalog: V2SessionCatalog
```

## <span id="customOperatorOptimizationRules"> customOperatorOptimizationRules

```scala
customOperatorOptimizationRules: Seq[Rule[LogicalPlan]]
```

Custom operator optimization rules to add to the [base Operator Optimization batch](spark-sql-Optimizer.md#extendedOperatorOptimizationRules).

When requested for the custom rules, `customOperatorOptimizationRules` simply requests the [SparkSessionExtensions](#extensions) to [buildOptimizerRules](spark-sql-SparkSessionExtensions.md#buildOptimizerRules).

## <span id="extensions"> SparkSessionExtensions

```scala
extensions: SparkSessionExtensions
```

[SparkSessionExtensions](spark-sql-SparkSessionExtensions.md)

## <span id="listenerManager"> ExecutionListenerManager

```scala
listenerManager: ExecutionListenerManager
```

[ExecutionListenerManager](spark-sql-ExecutionListenerManager.md)

## <span id="optimizer"> Optimizer

```scala
optimizer: Optimizer
```

[SparkOptimizer](spark-sql-SparkOptimizer.md) (that is downcast to the base [Optimizer](spark-sql-Optimizer.md)) that is [created](spark-sql-SparkOptimizer.md#creating-instance) with the [SessionCatalog](#catalog) and the [ExperimentalMethods](#experimentalMethods).

Note that the `SparkOptimizer` adds the <<customOperatorOptimizationRules, customOperatorOptimizationRules>> to the <<spark-sql-Optimizer.md#extendedOperatorOptimizationRules, operator optimization rules>>.

`optimizer` is used when `BaseSessionStateBuilder` is requested to <<build, create a SessionState>> (for the <<spark-sql-SessionState.md#optimizerBuilder, optimizerBuilder>> function to create an <<spark-sql-Optimizer.md#, Optimizer>> when requested for the <<spark-sql-SessionState.md#optimizer, Optimizer>>).

## <span id="planner"> SparkPlanner

```scala
planner: SparkPlanner
```

[SparkPlanner](spark-sql-SparkPlanner.md)

## <span id="streamingQueryManager"> StreamingQueryManager

```scala
streamingQueryManager: StreamingQueryManager
```

Spark Structured Streaming's `StreamingQueryManager`

## <span id="udfRegistration"> UDFRegistration

```scala
udfRegistration: UDFRegistration
```

[UDFRegistration](spark-sql-UDFRegistration.md)

## <span id="createClone"> Creating Clone of SessionState

```scala
createClone: (SparkSession, SessionState) => SessionState
```

`createClone` creates a [SessionState](spark-sql-SessionState.md) using [newBuilder](#newBuilder) followed by [build](#build).

`createClone` is used when `BaseSessionStateBuilder` is requested for a [SessionState](#build).

## <span id="build"> Creating SessionState

```scala
build(): SessionState
```

`build` creates a [SessionState](spark-sql-SessionState.md) with the following:

* SparkSession.md#sharedState[SharedState] of the <<session, SparkSession>>
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

`build` is used when:

* `SparkSession` is requested for a SparkSession.md#sessionState[SessionState] (that in turn SparkSession.md#instantiateSessionState[builds one using a class name] based on spark-sql-StaticSQLConf.md#spark.sql.catalogImplementation[spark.sql.catalogImplementation] configuration property)

* `BaseSessionStateBuilder` is requested to <<createClone, create a clone>> of a `SessionState`

## <span id="createQueryExecution"> Getting Function to Create QueryExecution For LogicalPlan

```scala
createQueryExecution: LogicalPlan => QueryExecution
```

`createQueryExecution` simply returns a function that takes a [LogicalPlan](logical-operators/LogicalPlan.md) and creates a [QueryExecution](spark-sql-QueryExecution.md) with the [SparkSession](#session) and the logical plan.

`createQueryExecution` is used when `BaseSessionStateBuilder` is requested to [create a SessionState instance](#build).
