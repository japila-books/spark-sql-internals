# ReplaceExceptWithFilter Logical Optimization Rule -- Rewriting Except (DISTINCT) Operators

`ReplaceExceptWithFilter` is a catalyst/Rule.md[Catalyst rule] for transforming spark-sql-LogicalPlan.md[logical plans] (i.e. `Rule[LogicalPlan]`).

[[apply]]
When catalyst/Rule.md#apply[executed], `ReplaceExceptWithFilter` transforms an Except.md[Except (distinct)] logical operator to...FIXME

`ReplaceExceptWithFilter` is a part of the [Replace Operators](../catalyst/Optimizer.md#Replace-Operators) fixed-point rule batch of the base [Logical Optimizer](../catalyst/Optimizer.md).

`ReplaceExceptWithFilter` can be turned off and on based on [spark.sql.optimizer.replaceExceptWithFilter](../configuration-properties.md#spark.sql.optimizer.replaceExceptWithFilter) configuration property.

[[demo]]
.Demo: ReplaceExceptWithFilter
```
import org.apache.spark.sql.catalyst.dsl.expressions._
import org.apache.spark.sql.catalyst.dsl.plans._

// Using hacks to disable two Catalyst DSL implicits
implicit def symbolToColumn(ack: ThatWasABadIdea) = ack
implicit class StringToColumn(val sc: StringContext) {}

import org.apache.spark.sql.catalyst.plans.logical.LocalRelation
val t1 = LocalRelation('a.int, 'b.int)
val t2 = t1.where('a > 5)

val plan = t1.except(t2, isAll = false)

import org.apache.spark.sql.catalyst.optimizer.ReplaceExceptWithFilter
val optimizedPlan = ReplaceExceptWithFilter(plan)
scala> println(optimizedPlan.numberedTreeString)
00 'Distinct
01 +- 'Filter NOT coalesce(('a > 5), false)
02    +- LocalRelation <empty>, [a#12, b#13]
```

=== [[isEligible]] `isEligible` Internal Predicate

[source, scala]
----
isEligible(
  left: LogicalPlan,
  right: LogicalPlan): Boolean
----

`isEligible` is positive (`true`) when the right logical operator is a Project.md[Project] with a Filter.md[Filter] child operator or simply a Filter.md[Filter] operator itself and <<verifyConditions, verifyConditions>>.

Otherwise, `isEligible` is negative (`false`).

NOTE: `isEligible` is used when `ReplaceExceptWithFilter` is <<apply, executed>>.

=== [[verifyConditions]] `verifyConditions` Internal Predicate

[source, scala]
----
verifyConditions(
  left: LogicalPlan,
  right: LogicalPlan): Boolean
----

`verifyConditions` is positive (`true`) when all of the following hold:

* FIXME

Otherwise, `verifyConditions` is negative (`false`).

NOTE: `verifyConditions` is used when `ReplaceExceptWithFilter` is <<apply, executed>> (when requested to <<isEligible, isEligible>>).
