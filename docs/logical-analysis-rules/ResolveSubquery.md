# ResolveSubquery Logical Resolution Rule

`ResolveSubquery` is a *logical resolution* that <<resolveSubQueries, resolves subquery expressions>> (<<spark-sql-Expression-SubqueryExpression-ScalarSubquery.md#, ScalarSubquery>>, <<spark-sql-Expression-Exists.md#, Exists>> and <<spark-sql-Expression-In.md#, In>>) when <<apply, transforming a logical plan>> with the following logical operators:

. `Filter` operators with an `Aggregate` child operator

. Unary operators with the children resolved

`ResolveSubquery` is part of spark-sql-Analyzer.md#Resolution[Resolution] fixed-point batch of rules of the spark-sql-Analyzer.md[Spark Analyzer].

Technically, `ResolveSubquery` is a catalyst/Rule.md[Catalyst rule] for transforming spark-sql-LogicalPlan.md[logical plans], i.e. `Rule[LogicalPlan]`.

[source, scala]
----
// Use Catalyst DSL
import org.apache.spark.sql.catalyst.expressions._
val a = 'a.int

import org.apache.spark.sql.catalyst.plans.logical.LocalRelation
val rel = LocalRelation(a)

import org.apache.spark.sql.catalyst.expressions.Literal
val list = Seq[Literal](1)

// FIXME Use a correct query to demo ResolveSubquery
import org.apache.spark.sql.catalyst.plans.logical.Filter
import org.apache.spark.sql.catalyst.expressions.In
val plan = Filter(condition = In(value = a, list), child = rel)

scala> println(plan.numberedTreeString)
00 Filter a#9 IN (1)
01 +- LocalRelation <empty>, [a#9]

import spark.sessionState.analyzer.ResolveSubquery
val analyzedPlan = ResolveSubquery(plan)
scala> println(analyzedPlan.numberedTreeString)
00 Filter a#9 IN (1)
01 +- LocalRelation <empty>, [a#9]
----

=== [[resolveSubQueries]] Resolving Subquery Expressions (ScalarSubquery, Exists and In) -- `resolveSubQueries` Internal Method

[source, scala]
----
resolveSubQueries(plan: LogicalPlan, plans: Seq[LogicalPlan]): LogicalPlan
----

`resolveSubQueries` requests the input spark-sql-LogicalPlan.md[logical plan] to catalyst/QueryPlan.md#transformExpressions[transform expressions] (down the operator tree) as follows:

. For spark-sql-Expression-ExecSubqueryExpression-ScalarSubquery.md[ScalarSubquery] expressions with spark-sql-Expression-ExecSubqueryExpression-ScalarSubquery.md#plan[subquery plan] not spark-sql-LogicalPlan.md#resolved[resolved] and <<resolveSubQuery, resolveSubQuery>> to create resolved `ScalarSubquery` expressions

. For spark-sql-Expression-Exists.md[Exists] expressions with spark-sql-Expression-Exists.md#plan[subquery plan] not spark-sql-LogicalPlan.md#resolved[resolved] and <<resolveSubQuery, resolveSubQuery>> to create resolved `Exists` expressions

. For spark-sql-Expression-In.md[In] expressions with spark-sql-Expression-ListQuery.md[ListQuery] not spark-sql-Expression-ListQuery.md#resolved[resolved] and <<resolveSubQuery, resolveSubQuery>> to create resolved `In` expressions

NOTE: `resolveSubQueries` is used exclusively when `ResolveSubquery` is <<apply, executed>>.

=== [[resolveSubQuery]] `resolveSubQuery` Internal Method

[source, scala]
----
resolveSubQuery(
  e: SubqueryExpression,
  plans: Seq[LogicalPlan])(
  f: (LogicalPlan, Seq[Expression]) => SubqueryExpression): SubqueryExpression
----

`resolveSubQuery`...FIXME

NOTE: `resolveSubQuery` is used exclusively when `ResolveSubquery` is requested to <<resolveSubQueries, resolve subquery expressions (ScalarSubquery, Exists and In)>>.

=== [[apply]] Applying ResolveSubquery to Logical Plan (Executing ResolveSubquery) -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply` transforms the input spark-sql-LogicalPlan.md[logical plan] as follows:

. For spark-sql-LogicalPlan-Filter.md[Filter] operators with an spark-sql-LogicalPlan-Aggregate.md[Aggregate] operator (as the spark-sql-LogicalPlan-Filter.md#child[child] operator) and the spark-sql-LogicalPlan.md#childrenResolved[children resolved], `apply` <<resolveSubQueries, resolves subquery expressions (ScalarSubquery, Exists and In)>> with the `Filter` operator and the plans with the `Aggregate` operator and its single spark-sql-LogicalPlan-Aggregate.md#child[child]

. For spark-sql-LogicalPlan.md#UnaryNode[unary operators] with the spark-sql-LogicalPlan.md#childrenResolved[children resolved], `apply` <<resolveSubQueries, resolves subquery expressions (ScalarSubquery, Exists and In)>> with the unary operator and its single child

`apply` is part of [Rule](catalyst/Rule.md#apply) abstraction.
