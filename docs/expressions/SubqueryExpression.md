title: SubqueryExpression

# SubqueryExpression -- Expressions With Logical Query Plans

`SubqueryExpression` is the <<contract, contract>> for spark-sql-Expression-PlanExpression.md[expressions with logical query plans] (i.e. `PlanExpression[LogicalPlan]`).

[[contract]]
[source, scala]
----
package org.apache.spark.sql.catalyst.expressions

abstract class SubqueryExpression(
    plan: LogicalPlan,
    children: Seq[Expression],
    exprId: ExprId) extends PlanExpression[LogicalPlan] {
  // only required methods that have no implementation
  // the others follow
  override def withNewPlan(plan: LogicalPlan): SubqueryExpression
}
----

.(Subset of) SubqueryExpression Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| [[withNewPlan]] `withNewPlan`
a| Used when:

* `CTESubstitution` substitution analyzer rule is requested to `substituteCTE`

* `ResolveReferences` logical resolution rule is requested to spark-sql-Analyzer-ResolveReferences.md#dedupRight[dedupRight] and spark-sql-Analyzer-ResolveReferences.md#dedupOuterReferencesInSubquery[dedupOuterReferencesInSubquery]

* `ResolveSubquery` logical resolution rule is requested to spark-sql-Analyzer-ResolveSubquery.md#resolveSubQuery[resolveSubQuery]

* `UpdateOuterReferences` logical rule is spark-sql-Analyzer-UpdateOuterReferences.md#apply[executed]

* `ResolveTimeZone` logical resolution rule is spark-sql-ResolveTimeZone.md#apply[executed]

* `SubqueryExpression` is requested for a <<canonicalize, canonicalized version>>

* `OptimizeSubqueries` logical query optimization is spark-sql-Optimizer-OptimizeSubqueries.md#apply[executed]

* `CacheManager` is requested to spark-sql-CacheManager.md#useCachedData[replace logical query segments with cached query plans]
|===

[[implementations]]
.SubqueryExpressions
[cols="1,2",options="header",width="100%"]
|===
| SubqueryExpression
| Description

| [[Exists]] spark-sql-Expression-Exists.md[Exists]
|

| [[ListQuery]] spark-sql-Expression-ListQuery.md[ListQuery]
|

| [[ScalarSubquery]] spark-sql-Expression-ExecSubqueryExpression-ScalarSubquery.md[ScalarSubquery]
|
|===

[[resolved]]
`SubqueryExpression` is expressions/Expression.md#resolved[resolved] when the expressions/Expression.md#childrenResolved[children are resolved] and the <<plan, subquery logical plan>> is spark-sql-LogicalPlan.md#resolved[resolved].

[[references]]
`references`...FIXME

[[semanticEquals]]
`semanticEquals`...FIXME

[[canonicalize]]
`canonicalize`...FIXME

=== [[hasInOrExistsSubquery]] `hasInOrExistsSubquery` Object Method

[source, scala]
----
hasInOrExistsSubquery(e: Expression): Boolean
----

`hasInOrExistsSubquery`...FIXME

NOTE: `hasInOrExistsSubquery` is used when...FIXME

=== [[hasCorrelatedSubquery]] `hasCorrelatedSubquery` Object Method

[source, scala]
----
hasCorrelatedSubquery(e: Expression): Boolean
----

`hasCorrelatedSubquery`...FIXME

NOTE: `hasCorrelatedSubquery` is used when...FIXME

=== [[hasSubquery]] `hasSubquery` Utility

[source, scala]
----
hasSubquery(
  e: Expression): Boolean
----

`hasSubquery`...FIXME

NOTE: `hasSubquery` is used when...FIXME

=== [[creating-instance]] Creating SubqueryExpression Instance

`SubqueryExpression` takes the following when created:

* [[plan]] Subquery spark-sql-LogicalPlan.md[logical plan]
* [[children]] Child expressions/Expression.md[expressions]
* [[exprId]] Expression ID (as `ExprId`)
