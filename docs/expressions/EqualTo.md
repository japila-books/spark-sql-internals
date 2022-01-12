# EqualTo Predicate Expression

`EqualTo` is a [BinaryComparison](BinaryComparison.md) and `NullIntolerant` predicate expression that represents the following high-level operators in a logical plan:

* `=`, `==`, `<>`, `!=` SQL operators
* `Column.===`, `Column.=!=` and `Column.notEqual` operators

## Creating Instance

`EqualTo` takes the following to be created:

* <span id="left"> Left [Expression](Expression.md)
* <span id="right"> Right [Expression](Expression.md)

`EqualTo` is created when:

* `AstBuilder` is requested to [parse a comparison](../sql/AstBuilder.md#visitComparison) (for `=`, `==`, `<>`, `!=` operators) and [visitSimpleCase](../sql/AstBuilder.md#visitSimpleCase)
* `Column.===`, `Column.=!=` and `Column.notEqual` operators are used
* _others_

## <span id="symbol"> Symbol

```scala
symbol: String
```

`symbol` is part of the `BinaryOperator` abstraction.

`symbol` is `=` (_equal sign_).

## Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md) defines [===](../catalyst-dsl/index.md#ImplicitOperators) operator to create an `EqualTo` expression.

```scala
import org.apache.spark.sql.catalyst.dsl.expressions._
val right = 'right
val left = 'left
val e = right === left
```

```text
scala> e.explain(extended = true)
('right = 'left)
```

```text
scala> println(e.expr.sql)
(`right` = `left`)
```

```scala
import org.apache.spark.sql.catalyst.expressions.EqualTo
assert(e.expr.isInstanceOf[EqualTo])
```
