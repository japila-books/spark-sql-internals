---
title: BaseSessionStateBuilder
---

# BaseSessionStateBuilder &mdash; Generic Builder of SessionState

`BaseSessionStateBuilder` is an [abstraction](#contract) of [builders](#extensions) that can [produce a new BaseSessionStateBuilder](#newBuilder) to [create a SessionState](#createClone).

!!! note "spark.sql.catalogImplementation Configuration Property"
    `BaseSessionStateBuilder` and [spark.sql.catalogImplementation](StaticSQLConf.md#spark.sql.catalogImplementation) configuration property allow for Hive and non-Hive Spark deployments.

```text
assert(spark.sessionState.isInstanceOf[org.apache.spark.sql.internal.SessionState])
```

`BaseSessionStateBuilder` holds [properties](#properties) that (together with [newBuilder](#newBuilder)) are used to create a [SessionState](SessionState.md).

## Contract

### newBuilder { #newBuilder }

```scala
newBuilder: (SparkSession, Option[SessionState]) => BaseSessionStateBuilder
```

Produces a new `BaseSessionStateBuilder` for given SparkSession.md[SparkSession] and optional SessionState.md[SessionState]

Used when `BaseSessionStateBuilder` is requested to <<createClone, create a SessionState>>

## Implementations

* [HiveSessionStateBuilder](hive/HiveSessionStateBuilder.md)
* [SessionStateBuilder](SessionStateBuilder.md)

## Creating Instance

`BaseSessionStateBuilder` takes the following to be created:

* <span id="session"> [SparkSession](SparkSession.md)
* <span id="parentState"> Optional parent [SessionState](SessionState.md) (default: undefined)

`BaseSessionStateBuilder` is created when `SparkSession` is requested to [instantiateSessionState](SparkSession.md#instantiateSessionState).

## Session-Specific Registries

The following registries are Scala lazy values which are created once and on demand (when accessed for the first time).

### Analyzer { #analyzer }

```scala
analyzer: Analyzer
```

[Logical Analyzer](Analyzer.md)

### SessionCatalog { #catalog }

```scala
catalog: SessionCatalog
```

[SessionCatalog](SessionCatalog.md)

!!! note HiveSessionStateBuilder
    [HiveSessionStateBuilder](hive/HiveSessionStateBuilder.md) manages its own Hive-aware [HiveSessionCatalog](hive/HiveSessionStateBuilder.md#catalog).

### CatalogManager { #catalogManager }

```scala
catalogManager: CatalogManager
```

[CatalogManager](connector/catalog/CatalogManager.md) that is created with this [V2SessionCatalog](#v2SessionCatalog) and this [SessionCatalog](#catalog).

`catalogManager` is used when:

* `BaseSessionStateBuilder` is requested for the [Analyzer](#analyzer) and the [Optimizer](#optimizer)
* `HiveSessionStateBuilder` is requested for the [Analyzer](hive/HiveSessionStateBuilder.md#analyzer)

### SQLConf { #conf }

[SQLConf](SQLConf.md)

### ExperimentalMethods { #experimentalMethods }

[ExperimentalMethods](ExperimentalMethods.md)

### FunctionRegistry { #functionRegistry }

[FunctionRegistry](FunctionRegistry.md)

### SessionResourceLoader { #resourceLoader }

```scala
resourceLoader: SessionResourceLoader
```

`SessionResourceLoader`

### ParserInterface { #sqlParser }

```scala
sqlParser: ParserInterface
```

[ParserInterface](sql/ParserInterface.md)

### TableFunctionRegistry { #tableFunctionRegistry }

```scala
tableFunctionRegistry: TableFunctionRegistry
```

[TableFunctionRegistry](TableFunctionRegistry.md)

---

When requested for the first time (as a `lazy val`), `tableFunctionRegistry` requests the [parent SessionState](#parentState) (if available) to clone the [tableFunctionRegistry](SessionState.md#tableFunctionRegistry) or requests the [SparkSessionExtensions](#extensions) to [register](SparkSessionExtensions.md#registerTableFunctions) the [built-in function expressions](TableFunctionRegistry.md#builtin).

`tableFunctionRegistry` is used when:

* `HiveSessionStateBuilder` is requested for a [HiveSessionCatalog](hive/HiveSessionStateBuilder.md#catalog)
* `BaseSessionStateBuilder` is requested for a [SessionCatalog](BaseSessionStateBuilder.md#catalog) and a [SessionState](BaseSessionStateBuilder.md#build)

### V2SessionCatalog { #v2SessionCatalog }

```scala
v2SessionCatalog: V2SessionCatalog
```

[V2SessionCatalog](V2SessionCatalog.md) that is created with this [SessionCatalog](#catalog).

This `V2SessionCatalog` is used when:

* `BaseSessionStateBuilder` is requested for the [CatalogManager](#catalogManager)

## Custom Operator Optimization Rules { #customOperatorOptimizationRules }

```scala
customOperatorOptimizationRules: Seq[Rule[LogicalPlan]]
```

Custom operator optimization rules to add to the [base Operator Optimization batch](catalyst/Optimizer.md#extendedOperatorOptimizationRules).

When requested for the custom rules, `customOperatorOptimizationRules` simply requests the [SparkSessionExtensions](#extensions) to [buildOptimizerRules](SparkSessionExtensions.md#buildOptimizerRules).

`customOperatorOptimizationRules` is used when `BaseSessionStateBuilder` is requested for an [Optimizer](#optimizer).

## <span id="extensions"> SparkSessionExtensions

```scala
extensions: SparkSessionExtensions
```

[SparkSessionExtensions](SparkSessionExtensions.md)

## <span id="listenerManager"> ExecutionListenerManager

```scala
listenerManager: ExecutionListenerManager
```

[ExecutionListenerManager](ExecutionListenerManager.md)

## <span id="optimizer"> Optimizer

```scala
optimizer: Optimizer
```

`optimizer` creates a [SparkOptimizer](SparkOptimizer.md) for the [CatalogManager](#catalogManager), [SessionCatalog](#catalog) and [ExperimentalMethods](#experimentalMethods).

The `SparkOptimizer` uses the following extension methods:

* [customEarlyScanPushDownRules](#customEarlyScanPushDownRules) for [earlyScanPushDownRules](SparkOptimizer.md#earlyScanPushDownRules)
* [customOperatorOptimizationRules](#customOperatorOptimizationRules) for [extendedOperatorOptimizationRules](SparkOptimizer.md#extendedOperatorOptimizationRules)

`optimizer` is used when `BaseSessionStateBuilder` is requested to [build a SessionState](#build) (as the [optimizerBuilder](SessionState.md#optimizerBuilder) function to [build a logical query plan optimizer](SessionState.md#optimizer) on demand).

## <span id="planner"> SparkPlanner

```scala
planner: SparkPlanner
```

[SparkPlanner](SparkPlanner.md)

## <span id="streamingQueryManager"> StreamingQueryManager

```scala
streamingQueryManager: StreamingQueryManager
```

Spark Structured Streaming's `StreamingQueryManager`

## <span id="udfRegistration"> UDFRegistration

```scala
udfRegistration: UDFRegistration
```

[UDFRegistration](user-defined-functions/UDFRegistration.md)

## <span id="createClone"> Creating Clone of SessionState

```scala
createClone: (SparkSession, SessionState) => SessionState
```

`createClone` creates a [SessionState](SessionState.md) using [newBuilder](#newBuilder) followed by [build](#build).

`createClone` is used when `BaseSessionStateBuilder` is requested for a [SessionState](#build).

## <span id="build"> Building SessionState

```scala
build(): SessionState
```

`build` creates a [SessionState](SessionState.md) with the following:

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

* `SparkSession` is requested for a [SessionState](SparkSession.md#sessionState) (that in turn [builds one using a class name](SparkSession.md#instantiateSessionState) based on [spark.sql.catalogImplementation](StaticSQLConf.md#spark.sql.catalogImplementation) configuration property)

* `BaseSessionStateBuilder` is requested to [create a clone](#createClone) of a `SessionState`

## <span id="createQueryExecution"> Getting Function to Create QueryExecution For LogicalPlan

```scala
createQueryExecution: LogicalPlan => QueryExecution
```

`createQueryExecution` simply returns a function that takes a [LogicalPlan](logical-operators/LogicalPlan.md) and creates a [QueryExecution](QueryExecution.md) with the [SparkSession](#session) and the logical plan.

`createQueryExecution` is used when `BaseSessionStateBuilder` is requested to [create a SessionState instance](#build).

## ColumnarRules { #columnarRules }

```scala
columnarRules: Seq[ColumnarRule]
```

`columnarRules` requests the [SparkSessionExtensions](#extensions) to [buildColumnarRules](SparkSessionExtensions.md#buildColumnarRules).

---

`columnarRules` is used when:

* `BaseSessionStateBuilder` is requested to [build a SessionState instance](#build)

## customCheckRules { #customCheckRules }

```scala
customCheckRules: Seq[LogicalPlan => Unit]
```

`customCheckRules` requests the [SparkSessionExtensions](#extensions) to [buildCheckRules](SparkSessionExtensions.md#buildCheckRules) on the [SparkSession](#session).

---

`customCheckRules` is used when:

* `BaseSessionStateBuilder` is requested for an [Analyzer](#analyzer)
* `HiveSessionStateBuilder` is requested for an [Analyzer](hive/HiveSessionStateBuilder.md#analyzer)

## Adaptive Rules { #adaptiveRulesHolder }

```scala
adaptiveRulesHolder: AdaptiveRulesHolder
```

`adaptiveRulesHolder` creates a new [AdaptiveRulesHolder](adaptive-query-execution/AdaptiveRulesHolder.md) with the user-defined AQE rules built using the [SparkSessionExtensions](#extensions):

* [Adaptive Query Stage Preparation Rules](SparkSessionExtensions.md#buildQueryStagePrepRules)
* [AQE Optimizer rules](SparkSessionExtensions.md#buildRuntimeOptimizerRules)
* [AQE query stage optimizer rules](SparkSessionExtensions.md#buildQueryStageOptimizerRules)
* [Adaptive Query Post Planner Strategy Rules](SparkSessionExtensions.md#buildQueryPostPlannerStrategyRules)
