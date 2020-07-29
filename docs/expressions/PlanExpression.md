title: PlanExpression

# PlanExpression -- Expressions with Query Plans

`PlanExpression` is the <<contract, contract>> for expressions/Expression.md[Catalyst expressions] that contain a catalyst/QueryPlan.md[QueryPlan].

[[contract]]
[source, scala]
----
package org.apache.spark.sql.catalyst.expressions

abstract class PlanExpression[T <: QueryPlan[_]] extends Expression {
  // only required methods that have no implementation
  // the others follow
  def exprId: ExprId
  def plan: T
  def withNewPlan(plan: T): PlanExpression[T]
}
----

.PlanExpression Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| `exprId`
| [[exprId]] Used when...FIXME

| `plan`
| [[plan]] Used when...FIXME

| `withNewPlan`
| [[withNewPlan]] Used when...FIXME
|===

[[implementations]]
.PlanExpressions
[cols="1,2",options="header",width="100%"]
|===
| PlanExpression
| Description

| [[ExecSubqueryExpression]] spark-sql-Expression-ExecSubqueryExpression.md[ExecSubqueryExpression]
|

| [[SubqueryExpression]] spark-sql-Expression-SubqueryExpression.md[SubqueryExpression]
|
|===
