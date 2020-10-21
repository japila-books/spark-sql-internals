# UnresolvedFunction Unevaluable Expression

`UnresolvedFunction` is an Expression.md[Catalyst expression] that represents a function (application) in a logical query plan.

`UnresolvedFunction` is <<creating-instance, created>> as a result of the following:

* spark-sql-functions.md#callUDF[callUDF] standard function

* spark-sql-RelationalGroupedDataset.md#agg[RelationalGroupedDataset.agg] operator with aggregation functions specified by name (that spark-sql-RelationalGroupedDataset.md#strToExpr[converts function names to UnresolvedFunction expressions])

* `AstBuilder` is requested to spark-sql-AstBuilder.md#visitFunctionCall[visitFunctionCall] (in SQL queries)

[[resolved]]
`UnresolvedFunction` can never be Expression.md#resolved[resolved] (and is replaced at analysis phase).

NOTE: `UnresolvedFunction` is first looked up in [LookupFunctions](../logical-analysis-rules/LookupFunctions.md) logical rule and then resolved in [ResolveFunctions](../logical-analysis-rules/ResolveFunctions.md) logical resolution rule.

[[Unevaluable]][[eval]][[doGenCode]]
Given `UnresolvedFunction` can never be resolved it should not come as a surprise that it [cannot be evaluated](Unevaluable.md) either (i.e. produce a value given an internal row). When requested to evaluate, `UnresolvedFunction` simply reports a `UnsupportedOperationException`.

```text
Cannot evaluate expression: [this]
```

TIP: Use Catalyst DSL's spark-sql-catalyst-dsl.md#function[function] or spark-sql-catalyst-dsl.md#distinctFunction[distinctFunction] to create a `UnresolvedFunction` with <<isDistinct, isDistinct>> flag off and on, respectively.

[source, scala]
----
// Using Catalyst DSL to create UnresolvedFunctions
import org.apache.spark.sql.catalyst.dsl.expressions._

// Scala Symbols supported only
val f = 'f.function()
scala> :type f
org.apache.spark.sql.catalyst.analysis.UnresolvedFunction

scala> f.isDistinct
res0: Boolean = false

val g = 'g.distinctFunction()
scala> g.isDistinct
res1: Boolean = true
----

=== [[apply]] Creating UnresolvedFunction (With Database Undefined) -- `apply` Factory Method

[source, scala]
----
apply(name: String, children: Seq[Expression], isDistinct: Boolean): UnresolvedFunction
----

`apply` creates a `FunctionIdentifier` with the `name` and no database first and then creates a <<UnresolvedFunction, UnresolvedFunction>> with the `FunctionIdentifier`, `children` and `isDistinct` flag.

[NOTE]
====
`apply` is used when:

* spark-sql-functions.md#callUDF[callUDF] standard function is used

* `RelationalGroupedDataset` is requested to spark-sql-RelationalGroupedDataset.md#agg[agg] with aggregation functions specified by name (and spark-sql-RelationalGroupedDataset.md#strToExpr[converts function names to UnresolvedFunction expressions])
====

=== [[creating-instance]] Creating UnresolvedFunction Instance

`UnresolvedFunction` takes the following when created:

* [[name]] `FunctionIdentifier`
* [[children]] Child Expression.md[expressions]
* [[isDistinct]] `isDistinct` flag
