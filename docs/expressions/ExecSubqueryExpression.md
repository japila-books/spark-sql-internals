title: ExecSubqueryExpression

# ExecSubqueryExpression -- Catalyst Expressions with SubqueryExec Physical Operators

`ExecSubqueryExpression` is the <<contract, contract>> for spark-sql-Expression-PlanExpression.md[Catalyst expressions that contain a physical plan] with spark-sql-SparkPlan-SubqueryExec.md[SubqueryExec] physical operator (i.e. `PlanExpression[SubqueryExec]`).

[[contract]]
[source, scala]
----
package org.apache.spark.sql.execution

abstract class ExecSubqueryExpression extends PlanExpression[SubqueryExec] {
  def updateResult(): Unit
}
----

.ExecSubqueryExpression Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| `updateResult`
| [[updateResult]] Used exclusively when a SparkPlan.md[physical operator] is requested to SparkPlan.md#waitForSubqueries[waitForSubqueries] (when SparkPlan.md#execute[executed] as part of SparkPlan.md#Physical-Operator-Execution-Pipeline[Physical Operator Execution Pipeline]).
|===

[[implementations]]
.ExecSubqueryExpressions
[cols="1,2",options="header",width="100%"]
|===
| ExecSubqueryExpression
| Description

| [[InSubquery]] spark-sql-Expression-InSubquery.md[InSubquery]
|

| [[ScalarSubquery]] spark-sql-Expression-ExecSubqueryExpression-ScalarSubquery.md[ScalarSubquery]
|
|===
