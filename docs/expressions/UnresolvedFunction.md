# UnresolvedFunction Unevaluable Expression

`UnresolvedFunction` is an [Catalyst expression](Expression.md) that represents a function (application) in a logical query plan.

`UnresolvedFunction` is <<creating-instance, created>> as a result of the following:

* [callUDF](../spark-sql-functions.md#callUDF) standard function

* [RelationalGroupedDataset.agg](../RelationalGroupedDataset.md#agg) operator with aggregation functions specified by name (that [converts function names to UnresolvedFunction expressions](../RelationalGroupedDataset.md#strToExpr))

* `AstBuilder` is requested to sql/AstBuilder.md#visitFunctionCall[visitFunctionCall] (in SQL queries)

[[resolved]]
`UnresolvedFunction` can never be Expression.md#resolved[resolved] (and is replaced at analysis phase).

NOTE: `UnresolvedFunction` is first looked up in [LookupFunctions](../logical-analysis-rules/LookupFunctions.md) logical rule and then resolved in [ResolveFunctions](../logical-analysis-rules/ResolveFunctions.md) logical resolution rule.

[[Unevaluable]][[eval]][[doGenCode]]
Given `UnresolvedFunction` can never be resolved it should not come as a surprise that it [cannot be evaluated](Unevaluable.md) either (i.e. produce a value given an internal row). When requested to evaluate, `UnresolvedFunction` simply reports a `UnsupportedOperationException`.

```text
Cannot evaluate expression: [this]
```

TIP: Use Catalyst DSL's [function](../catalyst-dsl/index.md#function) or [distinctFunction](../catalyst-dsl/index.md#distinctFunction) to create a `UnresolvedFunction` with <<isDistinct, isDistinct>> flag off and on, respectively.

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

`apply` is used when:

* [callUDF](../spark-sql-functions.md#callUDF) standard function is used

* `RelationalGroupedDataset` is requested to [agg](../RelationalGroupedDataset.md#agg) with aggregation functions specified by name (and [converts function names to UnresolvedFunction expressions](../RelationalGroupedDataset.md#strToExpr))

## Creating Instance

`UnresolvedFunction` takes the following to be created:

* [[name]] `FunctionIdentifier`
* [[children]] Child Expression.md[expressions]
* [[isDistinct]] `isDistinct` flag
