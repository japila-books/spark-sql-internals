# EqualNullSafe Predicate Expression

`EqualNullSafe` is a [BinaryComparison](BinaryComparison.md) predicate expression that represents the following high-level operators in a logical plan:

* `<=>` SQL operator
* `Column.<=>` operator

## Null Safeness

`EqualNullSafe` is safe for `null` values, i.e. is like [EqualTo](EqualTo.md) with the following "safeness":

* `true` if both operands are `null`
* `false` if either operand is `null`

## Creating Instance

`EqualNullSafe` takes the following to be created:

* <span id="left"> Left [Expression](Expression.md)
* <span id="right"> Right [Expression](Expression.md)

`EqualNullSafe` is created when:

* `AstBuilder` is requested to [parse a comparison](../sql/AstBuilder.md#visitComparison) (for `<=>` operator) and [withPredicate](../sql/AstBuilder.md#withPredicate)
* `Column.<=>` operator is used
* _others_

## <span id="symbol"> Symbol

```scala
symbol: String
```

`symbol` is part of the [BinaryOperator](BinaryOperator.md#symbol) abstraction.

`symbol` is `<=>`.

## <span id="nullable"> nullable

```scala
nullable: Boolean
```

`nullable` is part of the [Expression](Expression.md#nullable) abstraction.

`nullable` is always `false`.

## Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md) defines [<=>](../catalyst-dsl/index.md#ImplicitOperators) operator to create an `EqualNullSafe` expression.

```scala
import org.apache.spark.sql.catalyst.dsl.expressions._
val right = 'right
val left = 'left
val e = right <=> left
```

```text
scala> e.explain(extended = true)
('right <=> 'left)
```

```text
scala> println(e.expr.sql)
(`right` <=> `left`)
```

```scala
import org.apache.spark.sql.catalyst.expressions.EqualNullSafe
assert(e.expr.isInstanceOf[EqualNullSafe])
```
