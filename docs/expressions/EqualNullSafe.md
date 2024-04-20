---
title: EqualNullSafe
---

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

`EqualNullSafe` is created when:

* `AstBuilder` is requested to [parse a comparison](../sql/AstBuilder.md#visitComparison) (for `<=>` operator) and [withPredicate](../sql/AstBuilder.md#withPredicate)
* `Column.<=>` operator is used
* _others_

## Interpreted Expression Evaluation { #eval }

??? note "Expression"

    ```scala
    eval(
      input: InternalRow): Any
    ```

    `eval` is part of the [Expression](Expression.md#eval) abstraction.

`eval` requests the [left](#left) and [right](#right) expressions to [evaluate](Expression.md#eval) with the given [InternalRow](../InternalRow.md).

For all the two expressions evaluated to `null`s, `eval` returns `true`.

For either expression evaluated to `null`, `eval` returns `false`.

Otherwise, `eval` uses ordering on the [data type](Expression.md#dataType) of the [left](#left) expression.

## Generating Java Source Code for Code-Generated Expression Evaluation { #doGenCode }

??? note "Expression"

    ```scala
    doGenCode(
      ctx: CodegenContext,
      ev: ExprCode): ExprCode
    ```

    `doGenCode` is part of the [Expression](Expression.md#doGenCode) abstraction.

`doGenCode` requests the [left](#left) and [right](#right) expressions to [generate a source code for expression evaluation](Expression.md#genCode).

`doGenCode` requests the given [CodegenContext](../whole-stage-code-generation/CodegenContext.md) to [generate code for equal expression](../whole-stage-code-generation/CodegenContext.md#genEqual).

In the end, `doGenCode` updates the given `ExprCode` to use the code to evaluate the expression.

```text
import org.apache.spark.sql.catalyst.dsl.expressions._
val right = 'right
val left = 'left
val c = right <=> left

import org.apache.spark.sql.catalyst.expressions.EqualNullSafe
val e = c.expr.asInstanceOf[EqualNullSafe]

import org.apache.spark.sql.catalyst.expressions.codegen.CodegenContext
val ctx = new CodegenContext

// FIXME
scala> e.genCode(ctx)
org.apache.spark.sql.catalyst.analysis.UnresolvedException: Invalid call to dataType on unresolved object
  at org.apache.spark.sql.catalyst.analysis.UnresolvedAttribute.dataType(unresolved.scala:227)
  at org.apache.spark.sql.catalyst.expressions.Expression.$anonfun$genCode$3(Expression.scala:201)
  at scala.Option.getOrElse(Option.scala:201)
  at org.apache.spark.sql.catalyst.expressions.Expression.genCode(Expression.scala:196)
  at org.apache.spark.sql.catalyst.expressions.EqualNullSafe.doGenCode(predicates.scala:1115)
  at org.apache.spark.sql.catalyst.expressions.Expression.$anonfun$genCode$3(Expression.scala:201)
  at scala.Option.getOrElse(Option.scala:201)
  at org.apache.spark.sql.catalyst.expressions.Expression.genCode(Expression.scala:196)
  ... 42 elided
```

## Symbol

??? note "BinaryOperator"

    ```scala
    symbol: String
    ```

    `symbol` is part of the [BinaryOperator](BinaryOperator.md#symbol) abstraction.

`symbol` is `<=>`.

## nullable

??? note "Expression"

    ```scala
    nullable: Boolean
    ```

    `nullable` is part of the [Expression](Expression.md#nullable) abstraction.

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
