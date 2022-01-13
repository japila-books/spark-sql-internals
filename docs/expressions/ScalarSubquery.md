# ScalarSubquery Expression

`ScalarSubquery` is a [SubqueryExpression](SubqueryExpression.md) that returns a single row and a single column only.

`ScalarSubquery` represents a structured query that can be used as a "column".

`ScalarSubquery` represents a [subquery expression](../sql/AstBuilder.md#visitSubqueryExpression) in a logical plan.

!!! important
    Spark SQL uses the name of `ScalarSubquery` twice to represent a `SubqueryExpression` (this page) and an [ExecSubqueryExpression](ExecSubqueryExpression-ScalarSubquery.md).

## Demo

```text
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
```
