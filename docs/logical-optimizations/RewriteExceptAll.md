# RewriteExceptAll Logical Optimization Rule -- Rewriting Except (ALL) Operators

`RewriteExceptAll` is a catalyst/Rule.md[Catalyst rule] for transforming spark-sql-LogicalPlan.md[logical plans] (i.e. `Rule[LogicalPlan]`).

[[apply]]
When catalyst/Rule.md#apply[executed], `RewriteExceptAll` transforms an spark-sql-LogicalPlan-Except.md[Except (ALL)] logical operator to...FIXME

`RewriteExceptAll` requires that the number of columns of the left- and right-side of the `Except` operator are the same or throws an `AssertionError`.

`RewriteExceptAll` is a part of the [Replace Operators](../Optimizer.md#Replace-Operators) fixed-point rule batch of the base [Logical Optimizer](../Optimizer.md).

[[demo]]
.Demo: RewriteExceptAll
```
import org.apache.spark.sql.catalyst.dsl.expressions._
import org.apache.spark.sql.catalyst.dsl.plans._

// Using hacks to disable two Catalyst DSL implicits
implicit def symbolToColumn(ack: ThatWasABadIdea) = ack
implicit class StringToColumn(val sc: StringContext) {}

import org.apache.spark.sql.catalyst.plans.logical.LocalRelation
val t1 = LocalRelation('a.int, 'b.int)
val t2 = LocalRelation('C.int, 'D.int).where('C > 10)

val plan = t1.except(t2, isAll = true)

import org.apache.spark.sql.catalyst.optimizer.RewriteExceptAll
val optimizedPlan = RewriteExceptAll(plan)
scala> println(optimizedPlan.numberedTreeString)
00 'Project [a#20, b#21]
01 +- 'Generate replicaterows(sum#27L, a#20, b#21), false, [a#20, b#21]
02    +- 'Filter (sum#27L > 0)
03       +- 'Aggregate [a#20, b#21], [a#20, b#21, sum(vcol#24L) AS sum#27L]
04          +- 'Union
05             :- Project [1 AS vcol#24L, a#20, b#21]
06             :  +- LocalRelation <empty>, [a#20, b#21]
07             +- 'Project [-1 AS vcol#25L, C#22, D#23]
08                +- 'Filter ('C > 10)
09                   +- LocalRelation <empty>, [C#22, D#23]
```
