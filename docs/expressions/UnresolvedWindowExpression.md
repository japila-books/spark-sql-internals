title: UnresolvedWindowExpression

# UnresolvedWindowExpression Unevaluable Expression -- WindowExpression With Unresolved Window Specification Reference

`UnresolvedWindowExpression` is an <<expressions/Expression.md#Unevaluable, unevaluable expression>> that represents...FIXME

NOTE: An <<expressions/Expression.md#Unevaluable, unevaluable expression>> cannot be evaluated to produce a value (neither in <<expressions/Expression.md#eval, interpreted>> nor <<expressions/Expression.md#doGenCode, code-generated>> expression evaluations) and has to be resolved (replaced) to some other expressions or logical operators at <<spark-sql-QueryExecution.md#analyzed, analysis>> or <<spark-sql-QueryExecution.md#optimizedPlan, optimization>> phases or they fail analysis.

`UnresolvedWindowExpression` is <<creating-instance, created>> when:

* FIXME

[[child]]
`UnresolvedWindowExpression` is created to represent a `child` expressions/Expression.md[expression] and `WindowSpecReference` (with an identifier for the window reference) when `AstBuilder` spark-sql-AstBuilder.md#visitFunctionCall-UnresolvedWindowExpression[parses a function evaluated in a windowed context with a `WindowSpecReference`].

`UnresolvedWindowExpression` is resolved to a <<WindowExpression, WindowExpression>> when `Analyzer` is requested to [resolve UnresolvedWindowExpressions](../Analyzer.md#WindowsSubstitution).

```scala
import spark.sessionState.sqlParser

scala> sqlParser.parseExpression("foo() OVER windowSpecRef")
res1: org.apache.spark.sql.catalyst.expressions.Expression = unresolvedwindowexpression('foo(), WindowSpecReference(windowSpecRef))
```

[[properties]]
.UnresolvedWindowExpression's Properties
[width="100%",cols="1,2",options="header"]
|===
| Name
| Description

| `dataType`
| Reports a `UnresolvedException`

| `foldable`
| Reports a `UnresolvedException`

| `nullable`
| Reports a `UnresolvedException`

| `resolved`
| Disabled (i.e. `false`)
|===
