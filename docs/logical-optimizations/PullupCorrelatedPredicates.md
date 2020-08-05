# PullupCorrelatedPredicates Logical Optimization

`PullupCorrelatedPredicates` is a [base logical optimization](../catalyst/Optimizer.md#batches) that <<apply, transforms logical plans>> with the following operators:

. spark-sql-LogicalPlan-Filter.md[Filter] operators with an spark-sql-LogicalPlan-Aggregate.md[Aggregate] child operator

. spark-sql-LogicalPlan.md#UnaryNode[UnaryNode] operators

`PullupCorrelatedPredicates` is part of the [Pullup Correlated Expressions](../catalyst/Optimizer.md#Pullup-Correlated-Expressions) once-executed batch in the standard batches of the [Logical Optimizer](../catalyst/Optimizer.md).

`PullupCorrelatedPredicates` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[source, scala]
----
import org.apache.spark.sql.catalyst.optimizer.PullupCorrelatedPredicates

// FIXME
// Demo: Filter + Aggregate
// Demo: Filter + UnaryNode

val plan = ???
val optimizedPlan = PullupCorrelatedPredicates(plan)
----

`PullupCorrelatedPredicates` uses spark-sql-PredicateHelper.md[PredicateHelper] for...FIXME

=== [[pullOutCorrelatedPredicates]] `pullOutCorrelatedPredicates` Internal Method

[source, scala]
----
pullOutCorrelatedPredicates(
  sub: LogicalPlan,
  outer: Seq[LogicalPlan]): (LogicalPlan, Seq[Expression])
----

`pullOutCorrelatedPredicates`...FIXME

NOTE: `pullOutCorrelatedPredicates` is used exclusively when `PullupCorrelatedPredicates` is requested to <<rewriteSubQueries, rewriteSubQueries>>.

=== [[rewriteSubQueries]] `rewriteSubQueries` Internal Method

[source, scala]
----
rewriteSubQueries(plan: LogicalPlan, outerPlans: Seq[LogicalPlan]): LogicalPlan
----

`rewriteSubQueries`...FIXME

NOTE: `rewriteSubQueries` is used exclusively when `PullupCorrelatedPredicates` is <<apply, executed>> (i.e. applied to a spark-sql-LogicalPlan.md[logical plan]).

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of the <<catalyst/Rule.md#apply, Rule Contract>> to execute (apply) a rule on a [TreeNode](../catalyst/TreeNode.md) (e.g. <<spark-sql-LogicalPlan.md#, LogicalPlan>>).

`apply` transforms the input spark-sql-LogicalPlan.md[logical plan] as follows:

. For spark-sql-LogicalPlan-Filter.md[Filter] operators with an spark-sql-LogicalPlan-Aggregate.md[Aggregate] child operator, `apply` <<rewriteSubQueries, rewriteSubQueries>> with the `Filter` and the `Aggregate` and its spark-sql-LogicalPlan-Aggregate.md#child[child] as the outer plans

. For spark-sql-LogicalPlan.md#UnaryNode[UnaryNode] operators, `apply` <<rewriteSubQueries, rewriteSubQueries>> with the operator and its children as the outer plans
