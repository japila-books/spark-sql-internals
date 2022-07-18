# Expression

`Expression` is an [extension](#contract) of the [TreeNode](../catalyst/TreeNode.md) abstraction for [executable expressions](#implementations) (in the [Catalyst Tree Manipulation Framework](../catalyst/index.md)).

```scala
abstract class Expression
extends TreeNode[Expression]
```

`Expression` is an executable [TreeNode](../catalyst/TreeNode.md) that can be evaluated and produce a JVM object (for an [InternalRow](../InternalRow.md)) in the faster [code-generated](#genCode) or the slower [interpreted](#eval) modes.

## Contract

### <span id="dataType"> Evaluation Result DataType

```scala
dataType: DataType
```

The [DataType](../types/DataType.md) of the result of evaluating this expression

### <span id="doGenCode"> Generating Java Source Code

```scala
doGenCode(
  ctx: CodegenContext,
  ev: ExprCode): ExprCode
```

Generates a Java source code (for [Whole-Stage Java Code Generation](../whole-stage-code-generation/index.md))

Used when:

* `Expression` is requested to [generate a Java code](#genCode)

### <span id="eval"> Interpreted Expression Evaluation

```scala
eval(
  input: InternalRow = null): Any
```

**Interpreted expression evaluation** that evaluates this expression to a JVM object for a given [InternalRow](../InternalRow.md) (and skipping [generating a corresponding Java code](#genCode))

`eval` is a slower "relative" of the [code-generated expression evaluation](#genCode)

### <span id="nullable"> nullable

```scala
nullable: Boolean
```

## Implementations

### <span id="BinaryExpression"> BinaryExpression

### <span id="LeafExpression"> LeafExpression

### <span id="TernaryExpression"> TernaryExpression

### Other Expressions

* [CodegenFallback](CodegenFallback.md)
* [ExpectsInputTypes](ExpectsInputTypes.md)
* [NamedExpression](NamedExpression.md)
* [Nondeterministic](Nondeterministic.md)
* [Predicate](Predicate.md)
* [UnaryExpression](UnaryExpression.md)
* [Unevaluable](Unevaluable.md)
* _others_

## <span id="genCode"> Code-Generated Expression Evaluation

```scala
genCode(
  ctx: CodegenContext): ExprCode
```

`genCode` returns a `ExprCode` with a Java source code for expression evaluation (on an input [InternalRow](../InternalRow.md)).

Similar to [doGenCode](#doGenCode) but supports expression reuse using [Subexpression Elimination](../subexpression-elimination.md).

`genCode` is a faster "relative" of the [interpreted expression evaluation](#eval).

`genCode` is used when:

* `CodegenContext` is requested to [subexpressionEliminationForWholeStageCodegen](../whole-stage-code-generation/CodegenContext.md#subexpressionEliminationForWholeStageCodegen), [subexpressionElimination](../whole-stage-code-generation/CodegenContext.md#subexpressionElimination) and [generateExpressions](../whole-stage-code-generation/CodegenContext.md#generateExpressions)
* `GenerateSafeProjection` utility is used to [create a Projection](../whole-stage-code-generation/GenerateSafeProjection.md#create)
* _others_

### <span id="reduceCodeSize"> reduceCodeSize

```scala
reduceCodeSize(
  ctx: CodegenContext,
  eval: ExprCode): Unit
```

`reduceCodeSize` does its work only when all of the following are met:

1. Length of the generated code is above [spark.sql.codegen.methodSplitThreshold](../configuration-properties.md#spark.sql.codegen.methodSplitThreshold)

1. [INPUT_ROW](../whole-stage-code-generation/CodegenContext.md#INPUT_ROW) (of the input `CodegenContext`) is defined

1. [currentVars](../whole-stage-code-generation/CodegenContext.md#currentVars) (of the input `CodegenContext`) is not defined

??? Question "This needs your help"
    FIXME When would the above not be met? What's so special about such an expression?

`reduceCodeSize` sets the `value` of the input `ExprCode` to the [fresh term name](../whole-stage-code-generation/CodegenContext.md#freshName) for the `value` name.

In the end, `reduceCodeSize` sets the code of the input `ExprCode` to the following:

```text
[javaType] [newValue] = [funcFullName]([INPUT_ROW]);
```

The `funcFullName` is the [fresh term name](../whole-stage-code-generation/CodegenContext.md#freshName) for the [name of the current expression node](../catalyst/TreeNode.md#nodeName).

## <span id="deterministic"> deterministic Flag

`Expression` is **deterministic** when evaluates to the same result for the same input(s). An expression is deterministic if all the [child expressions](../catalyst/TreeNode.md#children) are.

!!! note
    A deterministic expression is like a [pure function](https://en.wikipedia.org/wiki/Pure_function) in functional programming languages.

```scala
val e = $"a".expr

import org.apache.spark.sql.catalyst.expressions.Expression
assert(e.isInstanceOf[Expression])
assert(e.deterministic)
```

## Demo

```scala
// evaluating an expression
// Use Literal expression to create an expression from a Scala object
import org.apache.spark.sql.catalyst.expressions.{Expression, Literal}
val e: Expression = Literal("hello")

import org.apache.spark.sql.catalyst.expressions.EmptyRow
val v: Any = e.eval(EmptyRow)

// Convert to Scala's String
import org.apache.spark.unsafe.types.UTF8String
val s = v.asInstanceOf[UTF8String].toString
assert(s == "hello")
```
