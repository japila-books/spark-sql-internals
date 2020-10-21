# ScalarSubquery Expression

`ScalarSubquery` is a spark-sql-Expression-SubqueryExpression.md[SubqueryExpression] that returns a single row and a single column only.

`ScalarSubquery` represents a structured query that can be used as a "column".

IMPORTANT: Spark SQL uses the name of `ScalarSubquery` twice to represent a `SubqueryExpression` (this page) and  an spark-sql-Expression-ExecSubqueryExpression-ScalarSubquery.md[ExecSubqueryExpression]. You've been warned.

`ScalarSubquery` is <<creating-instance, created>> exclusively when `AstBuilder` is requested to spark-sql-AstBuilder.md#visitSubqueryExpression[parse a subquery expression].

[source, scala]
----
// FIXME DEMO

// Borrowed from ExpressionParserSuite.scala
// ScalarSubquery(table("tbl").select('max.function('val))) > 'current)
val sql = "(select max(val) from tbl) > current"

// 'a === ScalarSubquery(table("s").select('b))
val sql = "a = (select b from s)"

// Borrowed from PlanParserSuite.scala
// table("t").select(ScalarSubquery(table("s").select('max.function('b))).as("ss"))
val sql = "select (select max(b) from s) ss from t"

// table("t").where('a === ScalarSubquery(table("s").select('b))).select(star())
val sql = "select * from t where a = (select b from s)"

// table("t").groupBy('g)('g).where('a > ScalarSubquery(table("s").select('b)))
val sql = "select g from t group by g having a > (select b from s)"
----

=== [[creating-instance]] Creating ScalarSubquery Instance

`ScalarSubquery` takes the following when created:

* [[plan]] Subquery spark-sql-LogicalPlan.md[logical plan]
* [[children]] Child Expression.md[expressions] (default: no children)
* [[exprId]] Expression ID (as `ExprId` and defaults to a spark-sql-Expression-NamedExpression.md#newExprId[new ExprId])
