# LookupFunctions Logical Rule

`LookupFunctions` is a [logical rule](../catalyst/Rule.md) that the [logical query plan analyzer](../Analyzer.md#LookupFunctions) uses to [make sure that UnresolvedFunction expressions can be resolved](#apply) in a logical query plan.

!!! note "ResolveFunctions Logical Resolution Rule"
    `LookupFunctions` is similar to [ResolveFunctions](ResolveFunctions.md) logical resolution rule, but it is `ResolveFunctions` to resolve `UnresolvedFunction` expressions while `LookupFunctions` is just a sanity check that a future resolution is possible if tried.

`LookupFunctions` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

!!! note
    `LookupFunctions` does not transform a logical plan, but simply assert that a query plan is valid with regards to functions used.

`LookupFunctions` is part of [Simple Sanity Check](../Analyzer.md#Simple-Sanity-Check) one-off batch of rules.

## Demo

Let's use [Catalyst DSL](../spark-sql-catalyst-dsl.md) to create a logical plan with an unregistered function.

```scala
import org.apache.spark.sql.catalyst.dsl.plans._
val t1 = table("t1")

import org.apache.spark.sql.catalyst.dsl.expressions._
val f1 = 'f1.function()

val plan = t1.select(f1)
```

```text
scala> println(plan.numberedTreeString)
00 'Project [unresolvedalias('f1(), None)]
01 +- 'UnresolvedRelation `t1`
```

Make sure the function `f1` does not exist.

```scala
import org.apache.spark.sql.catalyst.FunctionIdentifier
spark.sessionState.catalog.dropFunction(FunctionIdentifier("f1"), ignoreIfNotExists = true)

assert(spark.catalog.functionExists("f1") == false)
```

Executing `LookupFunctions` rule should end up with an `AnalysisException` since there is a function (`f1`) in the query plan that is not available.

```text
import spark.sessionState.analyzer.LookupFunctions
scala> LookupFunctions.apply(plan)
org.apache.spark.sql.AnalysisException: Undefined function: 'f1'. This function is neither a registered temporary function nor a permanent function registered in the database 'default'.;
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15.$anonfun$applyOrElse$100(Analyzer.scala:1893)
  at org.apache.spark.sql.catalyst.analysis.package$.withPosition(package.scala:53)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15.applyOrElse(Analyzer.scala:1893)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15.applyOrElse(Analyzer.scala:1884)
  ...
```

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` finds all [UnresolvedFunction](../expressions/UnresolvedFunction.md) expressions (in every logical operator in the input [logical plan](../logical-operators/LogicalPlan.md)) and requests the [SessionCatalog](../Analyzer.md#catalog) to [check if their functions exist](../SessionCatalog.md#functionExists).

`apply` does nothing when a function exists, and reports a `NoSuchFunctionException` otherwise (that fails logical analysis).

```text
Undefined function: '[func]'. This function is neither a registered temporary function nor a permanent function registered in the database '[db]'.
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
