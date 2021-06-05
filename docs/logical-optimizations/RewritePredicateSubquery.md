# RewritePredicateSubquery Logical Optimization

`RewritePredicateSubquery` is a [base logical optimization](../catalyst/Optimizer.md#batches) that <<apply, transforms Filter operators with Exists and In (with ListQuery) expressions to Join operators>> as follows:

* `Filter` operators with `Exists` and `In` with `ListQuery` expressions give *left-semi joins*

* `Filter` operators with `Not` with `Exists` and `In` with `ListQuery` expressions give *left-anti joins*

NOTE: Prefer `EXISTS` (over `Not` with `In` with `ListQuery` subquery expression) if performance matters since https://github.com/apache/spark/blob/master/sql/catalyst/src/main/scala/org/apache/spark/sql/catalyst/optimizer/subquery.scala?utf8=%E2%9C%93#L110[they say] "that will almost certainly be planned as a Broadcast Nested Loop join".

`RewritePredicateSubquery` is part of the [RewriteSubquery](../catalyst/Optimizer.md#RewriteSubquery) once-executed batch in the standard batches of the [Logical Optimizer](../catalyst/Optimizer.md).

`RewritePredicateSubquery` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[source, scala]
----
// FIXME Examples of RewritePredicateSubquery
// 1. Filters with Exists and In (with ListQuery) expressions
// 2. NOTs

// Based on RewriteSubquerySuite
// FIXME Contribute back to RewriteSubquerySuite
import org.apache.spark.sql.catalyst.plans.logical.LogicalPlan
import org.apache.spark.sql.catalyst.rules.RuleExecutor
object Optimize extends RuleExecutor[LogicalPlan] {
  import org.apache.spark.sql.catalyst.optimizer._
  val batches = Seq(
    Batch("Column Pruning", FixedPoint(100), ColumnPruning),
    Batch("Rewrite Subquery", Once,
      RewritePredicateSubquery,
      ColumnPruning,
      CollapseProject,
      RemoveRedundantProject))
}

val q = ...
val optimized = Optimize.execute(q.analyze)
----

`RewritePredicateSubquery` is part of the [RewriteSubquery](../catalyst/Optimizer.md#RewriteSubquery) once-executed batch in the standard batches of the [Logical Optimizer](../catalyst/Optimizer.md).

=== [[rewriteExistentialExpr]] `rewriteExistentialExpr` Internal Method

[source, scala]
----
rewriteExistentialExpr(
  exprs: Seq[Expression],
  plan: LogicalPlan): (Option[Expression], LogicalPlan)
----

`rewriteExistentialExpr`...FIXME

NOTE: `rewriteExistentialExpr` is used when...FIXME

=== [[dedupJoin]] `dedupJoin` Internal Method

[source, scala]
----
dedupJoin(joinPlan: LogicalPlan): LogicalPlan
----

`dedupJoin`...FIXME

NOTE: `dedupJoin` is used when...FIXME

=== [[getValueExpression]] `getValueExpression` Internal Method

[source, scala]
----
getValueExpression(e: Expression): Seq[Expression]
----

`getValueExpression`...FIXME

NOTE: `getValueExpression` is used when...FIXME

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply` transforms Filter.md[Filter] unary operators in the input spark-sql-LogicalPlan.md[logical plan].

`apply` [splits conjunctive predicates](../PredicateHelper.md#splitConjunctivePredicates) in the Filter.md#condition[condition expression] (i.e. expressions separated by `And` expression) and then partitions them into two collections of expressions spark-sql-Expression-SubqueryExpression.md#hasInOrExistsSubquery[with and without In or Exists subquery expressions].

`apply` creates a Filter.md#creating-instance[Filter] operator for condition (sub)expressions without subqueries (combined with `And` expression) if available or takes the Filter.md#child[child] operator (of the input `Filter` unary operator).

In the end, `apply` creates a new logical plan with Join.md[Join] operators for spark-sql-Expression-Exists.md[Exists] and spark-sql-Expression-In.md[In] expressions (and their negations) as follows:

* For spark-sql-Expression-Exists.md[Exists] predicate expressions, `apply` <<rewriteExistentialExpr, rewriteExistentialExpr>> and creates a Join.md#creating-instance[Join] operator with [LeftSemi](../joins.md#LeftSemi) join type. In the end, `apply` <<dedupJoin, dedupJoin>>

* For `Not` expressions with a spark-sql-Expression-Exists.md[Exists] predicate expression, `apply` <<rewriteExistentialExpr, rewriteExistentialExpr>> and creates a Join.md#creating-instance[Join] operator with [LeftAnti](../joins.md#LeftAnti) join type. In the end, `apply` <<dedupJoin, dedupJoin>>

* For spark-sql-Expression-In.md[In] predicate expressions with a spark-sql-Expression-ListQuery.md[ListQuery] subquery expression, `apply` <<getValueExpression, getValueExpression>> followed by <<rewriteExistentialExpr, rewriteExistentialExpr>> and creates a Join.md#creating-instance[Join] operator with [LeftSemi](../joins.md#LeftSemi) join type. In the end, `apply` <<dedupJoin, dedupJoin>>

* For `Not` expressions with a spark-sql-Expression-In.md[In] predicate expression with a spark-sql-Expression-ListQuery.md[ListQuery] subquery expression, `apply` <<getValueExpression, getValueExpression>>, <<rewriteExistentialExpr, rewriteExistentialExpr>> followed by [splitting conjunctive predicates](../PredicateHelper.md#splitConjunctivePredicates) and creates a Join.md#creating-instance[Join] operator with [LeftAnti](../joins.md#LeftAnti) join type. In the end, `apply` <<dedupJoin, dedupJoin>>

* For other predicate expressions, `apply` <<rewriteExistentialExpr, rewriteExistentialExpr>> and creates a Project.md#creating-instance[Project] unary operator with a Filter.md#creating-instance[Filter] operator

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
