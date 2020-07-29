# LookupFunctions Logical Rule -- Checking Whether UnresolvedFunctions Are Resolvable

`LookupFunctions` is a logical rule that the [logical query plan analyzer](../Analyzer.md#LookupFunctions) uses to <<apply, make sure that UnresolvedFunction expressions can be resolved>> in an entire logical query plan.

`LookupFunctions` is similar to [ResolveFunctions](ResolveFunctions.md) logical resolution rule, but it is `ResolveFunctions` to resolve `UnresolvedFunction` expressions while `LookupFunctions` is just a sanity check that a future resolution is possible if tried.

Technically, `LookupFunctions` is just a catalyst/Rule.md[Catalyst rule] for transforming spark-sql-LogicalPlan.md[logical plans], i.e. `Rule[LogicalPlan]`.

NOTE: `LookupFunctions` does not however transform a logical plan.

`LookupFunctions` is part of [Simple Sanity Check](../Analyzer.md#Simple-Sanity-Check) one-off batch of rules.

## Example

```text
// Using Catalyst DSL to create a logical plan with an unregistered function
import org.apache.spark.sql.catalyst.dsl.plans._
val t1 = table("t1")

import org.apache.spark.sql.catalyst.dsl.expressions._
val f1 = 'f1.function()

val plan = t1.select(f1)
scala> println(plan.numberedTreeString)
00 'Project [unresolvedalias('f1(), None)]
01 +- 'UnresolvedRelation `t1`

// Make sure the function f1 does not exist
import org.apache.spark.sql.catalyst.FunctionIdentifier
spark.sessionState.catalog.dropFunction(FunctionIdentifier("f1"), ignoreIfNotExists = true)

assert(spark.catalog.functionExists("f1") == false)

import spark.sessionState.analyzer.LookupFunctions
scala> LookupFunctions(plan)
org.apache.spark.sql.AnalysisException: Undefined function: 'f1'. This function is neither a registered temporary function nor a permanent function registered in the database 'default'.;
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15$$anonfun$applyOrElse$49.apply(Analyzer.scala:1198)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15$$anonfun$applyOrElse$49.apply(Analyzer.scala:1198)
  at org.apache.spark.sql.catalyst.analysis.package$.withPosition(package.scala:48)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15.applyOrElse(Analyzer.scala:1197)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15.applyOrElse(Analyzer.scala:1195)
```

=== [[apply]] Applying LookupFunctions to Logical Plan -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply` finds all spark-sql-Expression-UnresolvedFunction.md[UnresolvedFunction] expressions (in every logical operator in the input spark-sql-LogicalPlan.md[logical plan]) and requests the [SessionCatalog](../Analyzer.md#catalog) to [check if their functions exist](../spark-sql-SessionCatalog.md#functionExists).

`apply` does nothing if a function exists or reports a `NoSuchFunctionException` (that fails logical analysis).

```text
Undefined function: '[func]'. This function is neither a registered temporary function nor a permanent function registered in the database '[db]'.
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
