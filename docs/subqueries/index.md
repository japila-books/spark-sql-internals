title: Subqueries

# Subqueries (Subquery Expressions)

As of Spark 2.0, Spark SQL supports subqueries.

A *subquery* (aka *subquery expression*) is a query that is nested inside of another query.

There are the following kinds of subqueries:

. A subquery as a source (inside a SQL `FROM` clause)
. A scalar subquery or a predicate subquery (as a column)

Every subquery can also be *correlated* or *uncorrelated*.

[[scalar-subquery]]
A *scalar subquery* is a structured query that returns a single row and a single column only. Spark SQL uses [ScalarSubquery (SubqueryExpression)](../expressions/ScalarSubquery.md) expression to represent scalar subqueries (while sql/AstBuilder.md#visitSubqueryExpression[parsing a SQL statement]).

[source, scala]
----
// FIXME: ScalarSubquery in a logical plan
----

A `ScalarSubquery` expression appears as *scalar-subquery#[exprId] [conditionString]* in a logical plan.

[source, scala]
----
// FIXME: Name of a ScalarSubquery in a logical plan
----

It is said that scalar subqueries should be used very rarely if at all and you should join instead.

Spark Analyzer uses [ResolveSubquery](../logical-analysis-rules/ResolveSubquery.md) resolution rule to [resolve subqueries](../logical-analysis-rules/ResolveSubquery.md#resolveSubQueries) and at the end CheckAnalysis.md#checkSubqueryExpression[makes sure that they are valid].

Catalyst Optimizer uses the following optimizations for subqueries:

* PullupCorrelatedPredicates.md[PullupCorrelatedPredicates] optimization to PullupCorrelatedPredicates.md#rewriteSubQueries[rewrite subqueries] and pull up correlated predicates

* [RewriteCorrelatedScalarSubquery](../logical-optimizations/RewriteCorrelatedScalarSubquery.md) optimization (to [constructLeftJoins](../logical-optimizations/RewriteCorrelatedScalarSubquery.md#constructLeftJoins))

Spark Physical Optimizer uses [PlanSubqueries](../physical-optimizations/PlanSubqueries.md) physical optimization to plan queries with scalar subqueries.
