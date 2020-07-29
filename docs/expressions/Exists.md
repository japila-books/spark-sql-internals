title: Exists

# Exists -- Correlated Predicate Subquery Expression

`Exists` is a spark-sql-Expression-SubqueryExpression.md[SubqueryExpression] and a expressions/Expression.md#Predicate[predicate expression] (i.e. the result expressions/Expression.md#dataType[data type] is always spark-sql-DataType.md#BooleanType[boolean]).

`Exists` is <<creating-instance, created>> when:

. `ResolveSubquery` is requested to spark-sql-Analyzer-ResolveSubquery.md#resolveSubQueries[resolveSubQueries]

. `PullupCorrelatedPredicates` is requested to spark-sql-PullupCorrelatedPredicates.md#rewriteSubQueries[rewriteSubQueries]

. `AstBuilder` is requested to spark-sql-AstBuilder.md#visitExists[visitExists] (in SQL statements)

[[Unevaluable]]
`Exists` expressions/Expression.md#Unevaluable[cannot be evaluated], i.e. produce a value given an internal row.

[[eval]][[doGenCode]]
When requested to evaluate or `doGenCode`, `Exists` simply reports a `UnsupportedOperationException`.

```
Cannot evaluate expression: [this]
```

[[nullable]]
`Exists` is never expressions/Expression.md#nullable[nullable].

[[toString]]
`Exists` uses the following *text representation*:

```
exists#[exprId] [conditionString]
```

[[canonicalized]]
When requested for a spark-sql-BroadcastMode.md#canonicalized[canonicalized] version, `Exists` <<creating-instance, creates>> a new instance with...FIXME

=== [[creating-instance]] Creating Exists Instance

`Exists` takes the following when created:

* [[plan]] Subquery spark-sql-LogicalPlan.md[logical plan]
* [[children]] Child expressions/Expression.md[expressions]
* [[exprId]] `ExprId`
