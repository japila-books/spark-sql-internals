title: ExecSubqueryExpression

# ExecSubqueryExpression -- Catalyst Expressions with SubqueryExec Physical Operators

`ExecSubqueryExpression` is the <<contract, contract>> for link:spark-sql-Expression-PlanExpression.adoc[Catalyst expressions that contain a physical plan] with link:spark-sql-SparkPlan-SubqueryExec.adoc[SubqueryExec] physical operator (i.e. `PlanExpression[SubqueryExec]`).

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
| [[updateResult]] Used exclusively when a link:SparkPlan.md[physical operator] is requested to link:SparkPlan.md#waitForSubqueries[waitForSubqueries] (when link:SparkPlan.md#execute[executed] as part of link:SparkPlan.md#Physical-Operator-Execution-Pipeline[Physical Operator Execution Pipeline]).
|===

[[implementations]]
.ExecSubqueryExpressions
[cols="1,2",options="header",width="100%"]
|===
| ExecSubqueryExpression
| Description

| [[InSubquery]] link:spark-sql-Expression-InSubquery.adoc[InSubquery]
|

| [[ScalarSubquery]] link:spark-sql-Expression-ExecSubqueryExpression-ScalarSubquery.adoc[ScalarSubquery]
|
|===
