---
tags:
  - DeveloperApi
---

# SparkSessionExtensions

`SparkSessionExtensions` is an [Injection API](#injection-api) for Spark SQL developers to extend the capabilities of a [SparkSession](SparkSession.md).

Spark SQL developers use [Builder.withExtensions](SparkSession-Builder.md#withExtensions) method or register custom extensions using [spark.sql.extensions](StaticSQLConf.md#spark.sql.extensions) configuration property.

`SparkSessionExtensions` is an integral part of [SparkSession](SparkSession.md#extensions).

## injectedFunctions { #injectedFunctions }

`SparkSessionExtensions` uses a collection of 3-element tuples with the following:

1. `FunctionIdentifier`
1. `ExpressionInfo`
1. `Seq[Expression] => Expression`

## Injection API

### injectCheckRule { #injectCheckRule }

```scala
type CheckRuleBuilder = SparkSession => LogicalPlan => Unit
injectCheckRule(
  builder: CheckRuleBuilder): Unit
```

`injectCheckRule` injects an check analysis `Rule` builder into a [SparkSession](SparkSession.md).

The injected rules will be executed after the analysis phase. A check analysis rule is used to detect problems with a [LogicalPlan](logical-operators/LogicalPlan.md) and should throw an exception when a problem is found.

### injectColumnar { #injectColumnar }

```scala
type ColumnarRuleBuilder = SparkSession => ColumnarRule
injectColumnar(
  builder: ColumnarRuleBuilder): Unit
```

Injects a [ColumnarRule](ColumnarRule.md) to a [SparkSession](SparkSession.md)

### injectFunction { #injectFunction }

```scala
type FunctionDescription = (FunctionIdentifier, ExpressionInfo, FunctionBuilder)
injectFunction(
  functionDescription: FunctionDescription): Unit
```

`injectFunction`...FIXME

### injectOptimizerRule { #injectOptimizerRule }

```scala
type RuleBuilder = SparkSession => Rule[LogicalPlan]
injectOptimizerRule(
  builder: RuleBuilder): Unit
```

`injectOptimizerRule` registers a custom logical optimization rules builder.

### injectParser { #injectParser }

```scala
type ParserBuilder = (SparkSession, ParserInterface) => ParserInterface
injectParser(
  builder: ParserBuilder): Unit
```

`injectParser`...FIXME

### injectPlannerStrategy { #injectPlannerStrategy }

```scala
type StrategyBuilder = SparkSession => Strategy
injectPlannerStrategy(
  builder: StrategyBuilder): Unit
```

`injectPlannerStrategy`...FIXME

### injectPostHocResolutionRule { #injectPostHocResolutionRule }

```scala
type RuleBuilder = SparkSession => Rule[LogicalPlan]
injectPostHocResolutionRule(
  builder: RuleBuilder): Unit
```

`injectPostHocResolutionRule`...FIXME

### injectQueryPostPlannerStrategyRule { #injectQueryPostPlannerStrategyRule }

```scala
injectQueryPostPlannerStrategyRule(
  builder: QueryPostPlannerStrategyBuilder): Unit
```

`injectQueryPostPlannerStrategyRule` adds a new `SparkSession => Rule[SparkPlan]` builder to the [queryPostPlannerStrategyRuleBuilders](#queryPostPlannerStrategyRuleBuilders) internal registry.

### <span id="queryStagePrepRuleBuilders"> injectQueryStagePrepRule { #injectQueryStagePrepRule }

```scala
type QueryStagePrepRuleBuilder = SparkSession => Rule[SparkPlan]
injectQueryStagePrepRule(
  builder: QueryStagePrepRuleBuilder): Unit
```

`injectQueryStagePrepRule` registers a `QueryStagePrepRuleBuilder` (that can [build a query stage preparation rule](#buildQueryStagePrepRules)).

### injectResolutionRule { #injectResolutionRule }

```scala
type RuleBuilder = SparkSession => Rule[LogicalPlan]
injectResolutionRule(
  builder: RuleBuilder): Unit
```

`injectResolutionRule`...FIXME

### injectTableFunction { #injectTableFunction }

```scala
type TableFunctionBuilder = Seq[Expression] => LogicalPlan
type TableFunctionDescription = (FunctionIdentifier, ExpressionInfo, TableFunctionBuilder)
injectTableFunction(
  functionDescription: TableFunctionDescription): Unit
```

`injectTableFunction` registers a new [Table-Valued Functions](table-valued-functions/index.md).

---

`injectTableFunction` adds the given `TableFunctionDescription` to the [injectedTableFunctions](#injectedTableFunctions) internal registry.

## Registering Custom Logical Optimization Rules { #buildOptimizerRules }

```scala
buildOptimizerRules(
  session: SparkSession): Seq[Rule[LogicalPlan]]
```

`buildOptimizerRules` gives the [optimizerRules](#optimizerRules) logical rules given the input [SparkSession](SparkSession.md).

`buildOptimizerRules` is used when:

* `BaseSessionStateBuilder` is requested for the [custom operator optimization rules](BaseSessionStateBuilder.md#customOperatorOptimizationRules) (to add to the base Operator Optimization batch)

## Logical Optimizer Rules (Builder) { #optimizerRules }

```scala
optimizerRules: Buffer[SparkSession => Rule[LogicalPlan]]
```

`optimizerRules` are functions (_builders_) that take a [SparkSession](SparkSession.md) and return logical optimizer rules (`Rule[LogicalPlan]`).

`optimizerRules` is added a new rule when `SparkSessionExtensions` is requested to [injectOptimizerRule](#injectOptimizerRule).

## buildColumnarRules Internal Method { #buildColumnarRules }

```scala
buildColumnarRules(
  session: SparkSession): Seq[ColumnarRule]
```

`buildColumnarRules`...FIXME

---

`buildColumnarRules` is used when:

* `BaseSessionStateBuilder` is requested for [columnarRules](BaseSessionStateBuilder.md#columnarRules)

## buildCheckRules { #buildCheckRules }

```scala
buildCheckRules(
  session: SparkSession): Seq[LogicalPlan => Unit]
```

`buildCheckRules`...FIXME

---

`buildCheckRules` is used when:

* `BaseSessionStateBuilder` is requested to [customCheckRules](BaseSessionStateBuilder.md#customCheckRules)

## Building Query Stage Preparation Rules { #buildQueryStagePrepRules }

```scala
buildQueryStagePrepRules(
  session: SparkSession): Seq[Rule[SparkPlan]]
```

`buildQueryStagePrepRules` executes the [queryStagePrepRuleBuilders](#queryStagePrepRuleBuilders) (to build query stage preparation rules).

---

`buildQueryStagePrepRules` is used when:

* `BaseSessionStateBuilder` is requested for the [query stage preparation rules](BaseSessionStateBuilder.md#queryStagePrepRules)

## registerTableFunctions { #registerTableFunctions }

```scala
registerTableFunctions(
  tableFunctionRegistry: TableFunctionRegistry): TableFunctionRegistry
```

`registerTableFunctions` requests the given [TableFunctionRegistry](TableFunctionRegistry.md) to [register](FunctionRegistryBase.md#registerFunction) all the [injected table functions](#injectedTableFunctions).

---

`registerTableFunctions` is used when:

* `BaseSessionStateBuilder` is requested for the [TableFunctionRegistry](#tableFunctionRegistry)

## injectedTableFunctions { #injectedTableFunctions }

```scala
injectedTableFunctions: Buffer[TableFunctionDescription]
```

`SparkSessionExtensions` creates an empty `injectedTableFunctions` mutable collection of `TableFunctionDescription`s:

```scala
type TableFunctionBuilder = Seq[Expression] => LogicalPlan
type TableFunctionDescription = (FunctionIdentifier, ExpressionInfo, TableFunctionBuilder)
```

A new `TableFunctionDescription` tuple is added using [injectTableFunction](#injectTableFunction) injector.

`TableFunctionDescription`s are registered when `SparkSessionExtensions` is requested to [registerTableFunctions](#registerTableFunctions).

## Adaptive Query Post Planner Strategy Rules Builders { #queryPostPlannerStrategyRuleBuilders }

`SparkSessionExtensions` uses `queryPostPlannerStrategyRuleBuilders` internal registry of the builder functions of Adaptive Query Post Planner Strategy Rules.

The rule builders are registered using [injectQueryPostPlannerStrategyRule](#injectQueryPostPlannerStrategyRule).

The rule builders are executed using [buildQueryPostPlannerStrategyRules](#buildQueryPostPlannerStrategyRules).

### buildQueryPostPlannerStrategyRules { #buildQueryPostPlannerStrategyRules }

```scala
buildQueryPostPlannerStrategyRules(
  session: SparkSession): Seq[Rule[SparkPlan]]
```

`buildQueryPostPlannerStrategyRules` executes the [Adaptive Query Post Planner Strategy Rules builders](#queryPostPlannerStrategyRuleBuilders) (with the given [SparkSession](SparkSession.md)).

---

`buildQueryPostPlannerStrategyRules` is used when:

* `BaseSessionStateBuilder` is requested to [adaptiveRulesHolder](BaseSessionStateBuilder.md#adaptiveRulesHolder)
