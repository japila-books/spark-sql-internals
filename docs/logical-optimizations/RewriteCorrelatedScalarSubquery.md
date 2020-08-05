# RewriteCorrelatedScalarSubquery Logical Optimization

`RewriteCorrelatedScalarSubquery` is a [base logical optimization](../catalyst/Optimizer.md#batches) that <<apply, transforms logical plans>> with the following operators:

. FIXME

`RewriteCorrelatedScalarSubquery` is part of the [Operator Optimization before Inferring Filters](../catalyst/Optimizer.md#Operator_Optimization_before_Inferring_Filters) fixed-point batch in the standard batches of the [Logical Optimizer](../catalyst/Optimizer.md).

`RewriteCorrelatedScalarSubquery` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[source, scala]
----
import org.apache.spark.sql.catalyst.optimizer.RewriteCorrelatedScalarSubquery

// FIXME
// Demo: Filter + Aggregate
// Demo: Filter + UnaryNode

val plan = ???
val optimizedPlan = RewriteCorrelatedScalarSubquery(plan)
----

=== [[evalExpr]] `evalExpr` Internal Method

[source, scala]
----
evalExpr(expr: Expression, bindings: Map[ExprId, Option[Any]]) : Option[Any]
----

`evalExpr`...FIXME

NOTE: `evalExpr` is used exclusively when `RewriteCorrelatedScalarSubquery` is...FIXME

=== [[evalAggOnZeroTups]] `evalAggOnZeroTups` Internal Method

[source, scala]
----
evalAggOnZeroTups(expr: Expression) : Option[Any]
----

`evalAggOnZeroTups`...FIXME

NOTE: `evalAggOnZeroTups` is used exclusively when `RewriteCorrelatedScalarSubquery` is...FIXME

=== [[evalSubqueryOnZeroTups]] `evalSubqueryOnZeroTups` Internal Method

[source, scala]
----
evalSubqueryOnZeroTups(plan: LogicalPlan) : Option[Any]
----

`evalSubqueryOnZeroTups`...FIXME

NOTE: `evalSubqueryOnZeroTups` is used exclusively when `RewriteCorrelatedScalarSubquery` is requsted to <<constructLeftJoins, constructLeftJoins>>.

=== [[constructLeftJoins]] `constructLeftJoins` Internal Method

[source, scala]
----
constructLeftJoins(
  child: LogicalPlan,
  subqueries: ArrayBuffer[ScalarSubquery]): LogicalPlan
----

`constructLeftJoins`...FIXME

NOTE: `constructLeftJoins` is used exclusively when `RewriteCorrelatedScalarSubquery` logical optimization is <<apply, executed>> (i.e. applied to <<spark-sql-LogicalPlan-Aggregate.md#, Aggregate>>, <<spark-sql-LogicalPlan-Project.md#, Project>> or <<spark-sql-LogicalPlan-Filter.md#, Filter>> logical operators with correlated scalar subqueries)

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply` transforms the input spark-sql-LogicalPlan.md[logical plan] as follows:

. For spark-sql-LogicalPlan-Aggregate.md[Aggregate] operators, `apply`...FIXME

. For spark-sql-LogicalPlan-Project.md[Project] operators, `apply`...FIXME

. For spark-sql-LogicalPlan-Filter.md[Filter] operators, `apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

=== [[extractCorrelatedScalarSubqueries]] Extracting ScalarSubquery Expressions with Children -- `extractCorrelatedScalarSubqueries` Internal Method

[source, scala]
----
extractCorrelatedScalarSubqueries[E <: Expression](
  expression: E,
  subqueries: ArrayBuffer[ScalarSubquery]): E
----

`extractCorrelatedScalarSubqueries` finds all spark-sql-Expression-ExecSubqueryExpression-ScalarSubquery.md[ScalarSubquery] expressions with at least one spark-sql-Expression-ExecSubqueryExpression-ScalarSubquery.md#children[child] in the input `expression` and adds them to the input `subqueries` collection.

`extractCorrelatedScalarSubqueries` traverses the input `expression` down (the expression tree) and, every time a `ScalarSubquery` with at least one child is found, returns the head of the output attributes of the spark-sql-Expression-ExecSubqueryExpression-ScalarSubquery.md#plan[subquery plan].

In the end, `extractCorrelatedScalarSubqueries` returns the rewritten expression.

NOTE: `extractCorrelatedScalarSubqueries` uses https://docs.scala-lang.org/overviews/collections/concrete-mutable-collection-classes.html[scala.collection.mutable.ArrayBuffer] and mutates an instance inside (i.e. adds `ScalarSubquery` expressions) that makes for two output values, i.e. the rewritten expression and the `ScalarSubquery` expressions.

NOTE: `extractCorrelatedScalarSubqueries` is used exclusively when `RewriteCorrelatedScalarSubquery` is <<apply, executed>> (i.e. applied to a spark-sql-LogicalPlan.md[logical plan]).
