title: Subqueries

# Subqueries (Subquery Expressions)

As of Spark 2.0, Spark SQL supports subqueries.

A *subquery* (aka *subquery expression*) is a query that is nested inside of another query.

There are the following kinds of subqueries:

. A subquery as a source (inside a SQL `FROM` clause)
. A scalar subquery or a predicate subquery (as a column)

Every subquery can also be *correlated* or *uncorrelated*.

[[scalar-subquery]]
A *scalar subquery* is a structured query that returns a single row and a single column only. Spark SQL uses spark-sql-Expression-SubqueryExpression-ScalarSubquery.md[ScalarSubquery (SubqueryExpression)] expression to represent scalar subqueries (while spark-sql-AstBuilder.md#visitSubqueryExpression[parsing a SQL statement]).

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

Spark Analyzer uses [ResolveSubquery](logical-analysis-rules/ResolveSubquery.md) resolution rule to [resolve subqueries](logical-analysis-rules/ResolveSubquery.md#resolveSubQueries) and at the end spark-sql-Analyzer-CheckAnalysis.md#checkSubqueryExpression[makes sure that they are valid].

Catalyst Optimizer uses the following optimizations for subqueries:

* spark-sql-Optimizer-PullupCorrelatedPredicates.md[PullupCorrelatedPredicates] optimization to spark-sql-Optimizer-PullupCorrelatedPredicates.md#rewriteSubQueries[rewrite subqueries] and pull up correlated predicates

* spark-sql-Optimizer-RewriteCorrelatedScalarSubquery.md[RewriteCorrelatedScalarSubquery] optimization to spark-sql-Optimizer-RewriteCorrelatedScalarSubquery.md#constructLeftJoins[constructLeftJoins]

Spark Physical Optimizer uses spark-sql-PlanSubqueries.md[PlanSubqueries] physical optimization to spark-sql-PlanSubqueries.md#apply[plan queries with scalar subqueries].

CAUTION: FIXME Describe how a physical spark-sql-Expression-ExecSubqueryExpression-ScalarSubquery.md[ScalarSubquery] is executed (cf. `updateResult`, `eval` and `doGenCode`).
