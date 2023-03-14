---
tags:
  - DeveloperApi
---

# SparkSessionExtensions

`SparkSessionExtensions` is an [Injection API](#injection-api) for Spark SQL developers to extend the capabilities of a [SparkSession](SparkSession.md).

Spark SQL developers use [Builder.withExtensions](SparkSession-Builder.md#withExtensions) method or register custom extensions using [spark.sql.extensions](StaticSQLConf.md#spark.sql.extensions) configuration property.

`SparkSessionExtensions` is an integral part of [SparkSession](SparkSession.md#extensions).

## <span id="injectedFunctions"> injectedFunctions

`SparkSessionExtensions` uses a collection of 3-element tuples with the following:

1. `FunctionIdentifier`
1. `ExpressionInfo`
1. `Seq[Expression] => Expression`

## Injection API

### <span id="injectCheckRule"> injectCheckRule

```scala
type CheckRuleBuilder = SparkSession => LogicalPlan => Unit
injectCheckRule(
  builder: CheckRuleBuilder): Unit
```

`injectCheckRule` injects an check analysis `Rule` builder into a [SparkSession](SparkSession.md).

The injected rules will be executed after the analysis phase. A check analysis rule is used to detect problems with a [LogicalPlan](logical-operators/LogicalPlan.md) and should throw an exception when a problem is found.

### <span id="injectColumnar"> injectColumnar

```scala
type ColumnarRuleBuilder = SparkSession => ColumnarRule
injectColumnar(
  builder: ColumnarRuleBuilder): Unit
```

Injects a [ColumnarRule](ColumnarRule.md) to a [SparkSession](SparkSession.md)

### <span id="injectFunction"> injectFunction

```scala
type FunctionDescription = (FunctionIdentifier, ExpressionInfo, FunctionBuilder)
injectFunction(
  functionDescription: FunctionDescription): Unit
```

`injectFunction`...FIXME

### <span id="injectOptimizerRule"> injectOptimizerRule

```scala
type RuleBuilder = SparkSession => Rule[LogicalPlan]
injectOptimizerRule(
  builder: RuleBuilder): Unit
```

`injectOptimizerRule` registers a custom logical optimization rules builder.

### <span id="injectParser"> injectParser

```scala
type ParserBuilder = (SparkSession, ParserInterface) => ParserInterface
injectParser(
  builder: ParserBuilder): Unit
```

`injectParser`...FIXME

### <span id="injectPlannerStrategy"> injectPlannerStrategy

```scala
type StrategyBuilder = SparkSession => Strategy
injectPlannerStrategy(
  builder: StrategyBuilder): Unit
```

`injectPlannerStrategy`...FIXME

### <span id="injectPostHocResolutionRule"> injectPostHocResolutionRule

```scala
type RuleBuilder = SparkSession => Rule[LogicalPlan]
injectPostHocResolutionRule(
  builder: RuleBuilder): Unit
```

`injectPostHocResolutionRule`...FIXME

### <span id="injectQueryStagePrepRule"><span id="queryStagePrepRuleBuilders"> injectQueryStagePrepRule

```scala
type QueryStagePrepRuleBuilder = SparkSession => Rule[SparkPlan]
injectQueryStagePrepRule(
  builder: QueryStagePrepRuleBuilder): Unit
```

`injectQueryStagePrepRule` registers a `QueryStagePrepRuleBuilder` (that can [build a query stage preparation rule](#buildQueryStagePrepRules)).

### <span id="injectResolutionRule"> injectResolutionRule

```scala
type RuleBuilder = SparkSession => Rule[LogicalPlan]
injectResolutionRule(
  builder: RuleBuilder): Unit
```

`injectResolutionRule`...FIXME

## <span id="buildOptimizerRules"> Registering Custom Logical Optimization Rules

```scala
buildOptimizerRules(
  session: SparkSession): Seq[Rule[LogicalPlan]]
```

`buildOptimizerRules` gives the [optimizerRules](#optimizerRules) logical rules given the input [SparkSession](SparkSession.md).

`buildOptimizerRules` is used when `BaseSessionStateBuilder` is requested for the [custom operator optimization rules](BaseSessionStateBuilder.md#customOperatorOptimizationRules) (to add to the base Operator Optimization batch).

## <span id="optimizerRules"> Logical Optimizer Rules (Builder)

```scala
optimizerRules: Buffer[SparkSession => Rule[LogicalPlan]]
```

`optimizerRules` are functions (_builders_) that take a [SparkSession](SparkSession.md) and return logical optimizer rules (`Rule[LogicalPlan]`).

`optimizerRules` is added a new rule when `SparkSessionExtensions` is requested to [injectOptimizerRule](#injectOptimizerRule).

## <span id="buildColumnarRules"> buildColumnarRules Internal Method

```scala
buildColumnarRules(
  session: SparkSession): Seq[ColumnarRule]
```

`buildColumnarRules`...FIXME

`buildColumnarRules` is used when `BaseSessionStateBuilder` is requested for [columnarRules](BaseSessionStateBuilder.md#columnarRules).

## <span id="buildCheckRules"> buildCheckRules

```scala
buildCheckRules(
  session: SparkSession): Seq[LogicalPlan => Unit]
```

`buildCheckRules`...FIXME

`buildCheckRules` is used when `BaseSessionStateBuilder` is requested to [customCheckRules](BaseSessionStateBuilder.md#customCheckRules).

## <span id="buildQueryStagePrepRules"> Building Query Stage Preparation Rules

```scala
buildQueryStagePrepRules(
  session: SparkSession): Seq[Rule[SparkPlan]]
```

`buildQueryStagePrepRules` executes the [queryStagePrepRuleBuilders](#queryStagePrepRuleBuilders) (to build query stage preparation rules).

---

`buildQueryStagePrepRules` is used when:

* `BaseSessionStateBuilder` is requested for the [query stage preparation rules](BaseSessionStateBuilder.md#queryStagePrepRules)

## <span id="registerTableFunctions"> registerTableFunctions

```scala
registerTableFunctions(
  tableFunctionRegistry: TableFunctionRegistry): TableFunctionRegistry
```

`registerTableFunctions`...FIXME

---

`registerTableFunctions` is used when:

* `BaseSessionStateBuilder` is requested for the [TableFunctionRegistry](#tableFunctionRegistry)
