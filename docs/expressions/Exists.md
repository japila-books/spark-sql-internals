# Exists &mdash; Correlated Predicate Subquery Expression

`Exists` is a [SubqueryExpression](SubqueryExpression.md) and a [predicate expression](Expression.md#Predicate).

`Exists` is <<creating-instance, created>> when:

* `ResolveSubquery` is requested to [resolveSubQueries](../logical-analysis-rules/ResolveSubquery.md#resolveSubQueries)

* `PullupCorrelatedPredicates` is requested to spark-sql-PullupCorrelatedPredicates.md#rewriteSubQueries[rewriteSubQueries]

* `AstBuilder` is requested to spark-sql-AstBuilder.md#visitExists[visitExists] (in SQL statements)

[[Unevaluable]]
`Exists` is [unevaluable expression](Unevaluable.md).

[[eval]][[doGenCode]]
When requested to evaluate or `doGenCode`, `Exists` simply reports a `UnsupportedOperationException`.

```
Cannot evaluate expression: [this]
```

[[nullable]]
`Exists` is never Expression.md#nullable[nullable].

[[toString]]
`Exists` uses the following *text representation*:

```
exists#[exprId] [conditionString]
```

[[canonicalized]]
When requested for a [canonicalized](../physical-operators/BroadcastMode.md#canonicalized) version, `Exists` <<creating-instance, creates>> a new instance with...FIXME

## Creating Instance

`Exists` takes the following to be created:

* [[plan]] Subquery [LogicalPlan](../logical-operators/LogicalPlan.md)
* [[children]] Child [Expression](Expression.md)s
* [[exprId]] `ExprId`
