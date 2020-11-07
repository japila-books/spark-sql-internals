# OptimizeIn Logical Optimization

`OptimizeIn` is a [base logical optimization](../catalyst/Optimizer.md#batches) that <<apply, transforms logical plans with In predicate expressions>> as follows:

1. Replaces an `In` expression that has an [empty list](../expressions/In.md#list) and the [value](../expressions/In.md#value) expression not [nullable](../expressions/Expression.md#nullable) to `false`

1. Eliminates duplicates of [Literal](../expressions/Literal.md) expressions in an [In](../expressions/In.md) predicate expression that is [inSetConvertible](../expressions/In.md#inSetConvertible)

1. Replaces an `In` predicate expression that is [inSetConvertible](../expressions/In.md#inSetConvertible) with [InSet](../expressions/InSet.md) expressions when the number of [literal](../expressions/Literal.md) expressions in the [list](../expressions/In.md#list) expression is greater than [spark.sql.optimizer.inSetConversionThreshold](../configuration-properties.md#spark.sql.optimizer.inSetConversionThreshold) internal configuration property

`OptimizeIn` is part of the [Operator Optimization before Inferring Filters](../catalyst/Optimizer.md#Operator_Optimization_before_Inferring_Filters) fixed-point batch in the standard batches of the [Logical Optimizer](../catalyst/Optimizer.md).

`OptimizeIn` is simply a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md), i.e. `Rule[LogicalPlan]`.

```text
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
```

## <span id="apply"> Executing Rule

```scala
apply(plan: LogicalPlan): LogicalPlan
```

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
