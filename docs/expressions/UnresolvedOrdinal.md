# UnresolvedOrdinal Unevaluable Leaf Expression

`UnresolvedOrdinal` is a <<Expression.md#LeafExpression, leaf expression>> that represents a single integer literal in <<Sort.md#, Sort>> logical operators (in <<Sort.md#order, SortOrder>> ordering expressions) and in <<Aggregate.md#, Aggregate>> logical operators (in <<Aggregate.md#groupingExpressions, grouping expressions>>) in a logical plan.

`UnresolvedOrdinal` is <<creating-instance, created>> when `SubstituteUnresolvedOrdinals` logical resolution rule is executed.

[source, scala]
----
// Note "order by 1" clause
val sqlText = "select id from VALUES 1, 2, 3 t1(id) order by 1"
val logicalPlan = spark.sql(sqlText).queryExecution.logical
scala> println(logicalPlan.numberedTreeString)
00 'Sort [1 ASC NULLS FIRST], true
01 +- 'Project ['id]
02    +- 'SubqueryAlias t1
03       +- 'UnresolvedInlineTable [id], [List(1), List(2), List(3)]

import org.apache.spark.sql.catalyst.analysis.SubstituteUnresolvedOrdinals
val rule = new SubstituteUnresolvedOrdinals(spark.sessionState.conf)

val logicalPlanWithUnresolvedOrdinals = rule.apply(logicalPlan)
scala> println(logicalPlanWithUnresolvedOrdinals.numberedTreeString)
00 'Sort [unresolvedordinal(1) ASC NULLS FIRST], true
01 +- 'Project ['id]
02    +- 'SubqueryAlias t1
03       +- 'UnresolvedInlineTable [id], [List(1), List(2), List(3)]

import org.apache.spark.sql.catalyst.plans.logical.Sort
val sortOp = logicalPlanWithUnresolvedOrdinals.collect { case s: Sort => s }.head
val sortOrder = sortOp.order.head

import org.apache.spark.sql.catalyst.analysis.UnresolvedOrdinal
val unresolvedOrdinalExpr = sortOrder.child.asInstanceOf[UnresolvedOrdinal]
scala> println(unresolvedOrdinalExpr)
unresolvedordinal(1)
----

[[creating-instance]]
[[ordinal]]
`UnresolvedOrdinal` takes a single `ordinal` integer when created.

`UnresolvedOrdinal` is an [unevaluable expression](Unevaluable.md).

[[resolved]]
`UnresolvedOrdinal` can never be <<Expression.md#resolved, resolved>> (and is replaced at <<analysis-phase, analysis phase>>).

[[analysis-phase]]
NOTE: `UnresolvedOrdinal` is resolved when [ResolveOrdinalInOrderByAndGroupBy](../logical-analysis-rules/ResolveOrdinalInOrderByAndGroupBy.md) logical resolution rule is executed.

NOTE: `UnresolvedOrdinal` in GROUP BY ordinal position is not allowed for a select list with a star (`*`).
