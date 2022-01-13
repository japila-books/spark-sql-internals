# Unevaluable Expressions

`Unevaluable` is an extension of the [Expression](Expression.md) abstraction for [unevaluable expression](#implementations) that cannot be evaluated to produce a value (neither in the [interpreted](Expression.md#eval) nor [code-generated](Expression.md#doGenCode) mode).

`Unevaluable` expressions are expected to be resolved (replaced) to "evaluable" expressions or logical operators at [analysis](../QueryExecution.md#analyzed) or [optimization](../QueryExecution.md#optimizedPlan) phases or they fail analysis.

Unevaluable expressions cannot be evaluated (neither in <<Expression.md#eval, interpreted>> nor <<Expression.md#doGenCode, code-generated>> expression evaluations) and has to be  

## Implementations

* [AggregateExpression](AggregateExpression.md)
* [DeclarativeAggregate](DeclarativeAggregate.md)
* [DynamicPruningSubquery](DynamicPruningSubquery.md)
* [Exists](Exists.md)
* [HashPartitioning](HashPartitioning.md)
* [ListQuery](ListQuery.md)
* [RuntimeReplaceable](RuntimeReplaceable.md)
* [SortOrder](SortOrder.md)
* [TimeWindow](TimeWindow.md)
* [UnresolvedAttribute](UnresolvedAttribute.md)
* [UnresolvedFunction](UnresolvedFunction.md)
* [UnresolvedOrdinal](UnresolvedOrdinal.md)
* [UnresolvedRegex](UnresolvedRegex.md)
* [UnresolvedStar](UnresolvedStar.md)
* [UnresolvedWindowExpression](UnresolvedWindowExpression.md)
* [WindowExpression](WindowExpression.md)
* [WindowSpecDefinition](WindowSpecDefinition.md)
* _others_

## Demo

```text
/**
Example: Analysis failure due to an Unevaluable expression
UnresolvedFunction is an Unevaluable expression
Using Catalyst DSL to create a UnresolvedFunction
*/
import org.apache.spark.sql.catalyst.dsl.expressions._
val f = 'f.function()

import org.apache.spark.sql.catalyst.dsl.plans._
val logicalPlan = table("t1").select(f)
scala> println(logicalPlan.numberedTreeString)
00 'Project [unresolvedalias('f(), None)]
01 +- 'UnresolvedRelation `t1`

scala> spark.sessionState.analyzer.execute(logicalPlan)
org.apache.spark.sql.AnalysisException: Undefined function: 'f'. This function is neither a registered temporary function nor a permanent function registered in the database 'default'.;
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15$$anonfun$applyOrElse$49.apply(Analyzer.scala:1198)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15$$anonfun$applyOrElse$49.apply(Analyzer.scala:1198)
  at org.apache.spark.sql.catalyst.analysis.package$.withPosition(package.scala:48)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15.applyOrElse(Analyzer.scala:1197)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$LookupFunctions$$anonfun$apply$15.applyOrElse(Analyzer.scala:1195)
```
