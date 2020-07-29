# OptimizeIn Logical Optimization

`OptimizeIn` is a [base logical optimization](../Optimizer.md#batches) that <<apply, transforms logical plans with In predicate expressions>> as follows:

. Replaces an `In` expression that has an spark-sql-Expression-In.md#list[empty list] and the spark-sql-Expression-In.md#value[value] expression not expressions/Expression.md#nullable[nullable] to `false`

. Eliminates duplicates of spark-sql-Expression-Literal.md[Literal] expressions in an spark-sql-Expression-In.md[In] predicate expression that is spark-sql-Expression-In.md#inSetConvertible[inSetConvertible]

. Replaces an `In` predicate expression that is spark-sql-Expression-In.md#inSetConvertible[inSetConvertible] with spark-sql-Expression-InSet.md[InSet] expressions when the number of spark-sql-Expression-Literal.md[literal] expressions in the spark-sql-Expression-In.md#list[list] expression is greater than spark-sql-properties.md#spark.sql.optimizer.inSetConversionThreshold[spark.sql.optimizer.inSetConversionThreshold] internal configuration property (default: `10`)

`OptimizeIn` is part of the [Operator Optimization before Inferring Filters](../Optimizer.md#Operator_Optimization_before_Inferring_Filters) fixed-point batch in the standard batches of the [Logical Optimizer](../Optimizer.md).

`OptimizeIn` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[source, scala]
----
// Use Catalyst DSL to define a logical plan

// HACK: Disable symbolToColumn implicit conversion
// It is imported automatically in spark-shell (and makes demos impossible)
// implicit def symbolToColumn(s: Symbol): org.apache.spark.sql.ColumnName
trait ThatWasABadIdea
implicit def symbolToColumn(ack: ThatWasABadIdea) = ack

import org.apache.spark.sql.catalyst.dsl.expressions._
import org.apache.spark.sql.catalyst.dsl.plans._

import org.apache.spark.sql.catalyst.plans.logical.LocalRelation
val rel = LocalRelation('a.int, 'b.int, 'c.int)

import org.apache.spark.sql.catalyst.expressions.{In, Literal}
val plan = rel
  .where(In('a, Seq[Literal](1, 2, 3)))
  .analyze
scala> println(plan.numberedTreeString)
00 Filter a#6 IN (1,2,3)
01 +- LocalRelation <empty>, [a#6, b#7, c#8]

// In --> InSet
spark.conf.set("spark.sql.optimizer.inSetConversionThreshold", 0)

import org.apache.spark.sql.catalyst.optimizer.OptimizeIn
val optimizedPlan = OptimizeIn(plan)
scala> println(optimizedPlan.numberedTreeString)
00 Filter a#6 INSET (1,2,3)
01 +- LocalRelation <empty>, [a#6, b#7, c#8]
----

## <span id="apply"> Executing Rule

```scala
apply(plan: LogicalPlan): LogicalPlan
```

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
