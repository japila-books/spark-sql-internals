# SparkSessionExtensions

`SparkSessionExtensions` is an interface for a Spark SQL developer to extend (the features of) a [SparkSession](SparkSession.md).

Spark SQL developers use [Builder.withExtensions](SparkSession-Builder.md#withExtensions) method or register extensions using [spark.sql.extensions](spark-sql-StaticSQLConf.md#spark.sql.extensions) configuration property.

`SparkSessionExtensions` is an integral part of [SparkSession](SparkSession.md#extensions).

## <span id="buildOptimizerRules"> Registering Custom Logical Optimization Rules

```scala
buildOptimizerRules(
  session: SparkSession): Seq[Rule[LogicalPlan]]
```

`buildOptimizerRules` gives the [optimizerRules](#optimizerRules) logical rules given the input [SparkSession](SparkSession.md).

`buildOptimizerRules` is used when `BaseSessionStateBuilder` is requested for the [custom operator optimization rules](BaseSessionStateBuilder.md#customOperatorOptimizationRules) (to add to the base Operator Optimization batch).

## <span id="injectOptimizerRule"> Registering Custom Operator Optimization Rule (Builder)

```scala
injectOptimizerRule(
    builder: SparkSession => Rule[LogicalPlan]): Unit
```

`injectOptimizerRule` registers a custom logical optimization rules builder.

## <span id="optimizerRules"> Logical Optimizer Rules (Builder)

```scala
optimizerRules: Buffer[SparkSession => Rule[LogicalPlan]]
```

`optimizerRules` are functions (_builders_) that take a [SparkSession](SparkSession.md) and return logical optimizer rules (`Rule[LogicalPlan]`).

`optimizerRules` is added a new rule when `SparkSessionExtensions` is requested to [injectOptimizerRule](#injectOptimizerRule).
