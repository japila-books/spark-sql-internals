# LessThanOrEqual

`LessThanOrEqual` is a [binary comparison expression](BinaryComparison.md) and a `NullIntolerant`.

`LessThanOrEqual`'s [symbol](#symbol) representation is `<=`.

## Creating Instance

`LessThanOrEqual` takes the following to be created:

* <span id="left"> Left [Expression](Expression.md)
* <span id="right"> Right [Expression](Expression.md)

## <span id="symbol"> symbol

```scala
symbol: String
```

`symbol` is part of the [BinaryOperator](BinaryOperator.md#symbol) abstraction.

---

`symbol` is `<=`.

## <span id="nullSafeEval"> nullSafeEval

```scala
nullSafeEval(
  input1: Any,
  input2: Any): Any
```

`nullSafeEval` is part of the [BinaryOperator](BinaryOperator.md#nullSafeEval) abstraction.

---

`nullSafeEval` requests the [Ordering](BinaryComparison.md#ordering) to `lteq` the inputs.

## Catalyst DSL

`expressions` defines [<=](../catalyst-dsl/index.md#ExpressionConversions) operator to create a `LessThanOrEqual` expression.

```scala
import org.apache.spark.sql.catalyst.dsl.expressions._

// LessThanOrEqual
val e = col("a").expr <= 5

import org.apache.spark.sql.catalyst.expressions.LessThanOrEqual
val lessThanOrEqual = e.asInstanceOf[LessThanOrEqual]
```

!!! note "FIXME"

    ```scala
    import org.apache.spark.sql.catalyst.InternalRow
    val input = InternalRow(1, 2)
    ```

    ```text
    scala> lessThanOrEqual.eval(input)
    org.apache.spark.SparkUnsupportedOperationException: Cannot evaluate expression: 'a
    at org.apache.spark.sql.errors.QueryExecutionErrors$.cannotEvaluateExpressionError(QueryExecutionErrors.scala:73)
    at org.apache.spark.sql.catalyst.expressions.Unevaluable.eval(Expression.scala:344)
    at org.apache.spark.sql.catalyst.expressions.Unevaluable.eval$(Expression.scala:343)
    at org.apache.spark.sql.catalyst.analysis.UnresolvedAttribute.eval(unresolved.scala:131)
    at org.apache.spark.sql.catalyst.expressions.BinaryExpression.eval(Expression.scala:634)
    ... 54 elided
    ```
