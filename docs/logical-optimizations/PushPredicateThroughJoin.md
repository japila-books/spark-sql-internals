# PushPredicateThroughJoin Logical Optimization

`PushPredicateThroughJoin` is a link:catalyst/Rule.md[Catalyst rule] for transforming link:spark-sql-LogicalPlan.adoc[logical plans] (i.e. `Rule[LogicalPlan]`).

When <<apply, executed>>, `PushPredicateThroughJoin`...FIXME

`PushPredicateThroughJoin` is a part of the link:spark-sql-Optimizer.adoc#Operator-Optimization-before-Inferring-Filters[Operator Optimization before Inferring Filters] and link:spark-sql-Optimizer.adoc#Operator-Optimization-after-Inferring-Filters[Operator Optimization after Inferring Filters] fixed-point rule batches of the base link:spark-sql-Optimizer.adoc[Catalyst Optimizer].

[[demo]]
.Demo: PushPredicateThroughJoin
```
import org.apache.spark.sql.catalyst.dsl.expressions._
import org.apache.spark.sql.catalyst.dsl.plans._

// Using hacks to disable two Catalyst DSL implicits
implicit def symbolToColumn(ack: ThatWasABadIdea) = ack
implicit class StringToColumn(val sc: StringContext) {}

import org.apache.spark.sql.catalyst.plans.logical.LocalRelation
val t1 = LocalRelation('a.int, 'b.int)
val t2 = LocalRelation('C.int, 'D.int).where('C > 10)

val plan = t1.join(t2)...FIXME

import org.apache.spark.sql.catalyst.optimizer.PushPredicateThroughJoin
val optimizedPlan = PushPredicateThroughJoin(plan)
scala> println(optimizedPlan.numberedTreeString)
...FIXME
```

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

=== [[split]] `split` Internal Method

[source, scala]
----
split(
  condition: Seq[Expression],
  left: LogicalPlan,
  right: LogicalPlan): (Seq[Expression], Seq[Expression], Seq[Expression])
----

`split` splits (_partitions_) the given condition expressions into link:expressions/Expression.md#deterministic[deterministic] or not.

`split` further splits (_partitions_) the deterministic expressions (_pushDownCandidates_) into expressions that reference the link:catalyst/QueryPlan.md#outputSet[output expressions] of the left logical operator (_leftEvaluateCondition_) or not (_rest_).

`split` further splits (_partitions_) the expressions that do not reference left output expressions into expressions that reference the link:catalyst/QueryPlan.md#outputSet[output expressions] of the right logical operator (_rightEvaluateCondition_) or not (_commonCondition_).

In the end, `split` returns the _leftEvaluateCondition_, _rightEvaluateCondition_, and _commonCondition_ with the non-deterministic condition expressions.

NOTE: `split` is used when `PushPredicateThroughJoin` is <<apply, executed>>.
