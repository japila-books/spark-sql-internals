title: InSubquery

# InSubquery Expression

`InSubquery` is a spark-sql-Expression-ExecSubqueryExpression.md[ExecSubqueryExpression] that...FIXME

`InSubquery` is <<creating-instance, created>> when...FIXME

=== [[updateResult]] `updateResult` Method

[source, scala]
----
updateResult(): Unit
----

NOTE: `updateResult` is part of spark-sql-Expression-ExecSubqueryExpression.md#updateResult[ExecSubqueryExpression Contract] to...FIXME.

`updateResult`...FIXME

=== [[creating-instance]] Creating InSubquery Instance

`InSubquery` takes the following when created:

* [[child]] Child Expression.md[expression]
* [[plan]] SubqueryExec.md[SubqueryExec] physical operator
* [[exprId]] Expression ID (as `ExprId`)
* [[result]] `result` array (default: `null`)
* [[updated]] `updated` flag (default: `false`)
