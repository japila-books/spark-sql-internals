# CodegenContext

`CodegenContext` is a context with objects for [Whole-Stage Java Code Generation](index.md).

## Creating Instance

`CodegenContext` takes no arguments to be created.

`CodegenContext` is created when:

* `CodegenContext` is requested for a [new CodegenContext](#newCodeGenContext)
* `GenerateUnsafeRowJoiner` utility is used to create a `UnsafeRowJoiner`
* `WholeStageCodegenExec` unary physical operator is requested for a [Java source code for the child operator](../physical-operators/WholeStageCodegenExec.md#doCodeGen) (when `WholeStageCodegenExec` is [executed](../physical-operators/WholeStageCodegenExec.md#doExecute))

## <span id="newCodeGenContext"> newCodeGenContext

```scala
newCodeGenContext(): CodegenContext
```

`newCodeGenContext` creates a new [CodegenContext](#creating-instance).

`newCodeGenContext` is used when:

* `GenerateMutableProjection` utility is used to [create a MutableProjection](GenerateMutableProjection.md#create)
* `GenerateOrdering` utility is used to [create a BaseOrdering](GenerateOrdering.md#create)
* `GeneratePredicate` utility is used to [create a BaseOrdering](GeneratePredicate.md#create)
* `GenerateSafeProjection` utility is used to [create a Projection](GenerateSafeProjection.md#create)
* `GenerateUnsafeProjection` utility is used to [create an UnsafeProjection](GenerateUnsafeProjection.md#create)
* `GenerateColumnAccessor` utility is used to [create a ColumnarIterator](GenerateColumnAccessor.md#create)

## <span id="references"> references

```scala
references: mutable.ArrayBuffer[Any]
```

`CodegenContext` uses `references` collection for objects that could be passed into generated class.

A new reference is added:

* [addReferenceObj](#addReferenceObj)
* `CodegenFallback` is requested to [doGenCode](../expressions/CodegenFallback.md#doGenCode)

Used when:

* `WholeStageCodegenExec` unary physical operator is requested to [doExecute](../physical-operators/WholeStageCodegenExec.md#doExecute)
* `GenerateMutableProjection` utility is used to [create a MutableProjection](GenerateMutableProjection.md#create)
* `GenerateOrdering` utility is used to [create a BaseOrdering](GenerateOrdering.md#create)
* `GeneratePredicate` utility is used to [create a BaseOrdering](GeneratePredicate.md#create)
* `GenerateSafeProjection` utility is used to [create a Projection](GenerateSafeProjection.md#create)
* `GenerateUnsafeProjection` utility is used to [create an UnsafeProjection](GenerateUnsafeProjection.md#create)

### <span id="addReferenceObj"> addReferenceObj

```scala
addReferenceObj(
  objName: String,
  obj: Any,
  className: String = null): String
```

`addReferenceObj` adds the given `obj` to the [references](#references) registry and returns the following code text:

```text
(([clsName]) references[[idx]] /* [objName] */)
```

`addReferenceObj` is used when:

* `AvroDataToCatalyst` is requested to [doGenCode](../datasources/avro/AvroDataToCatalyst.md#doGenCode)
* `CatalystDataToAvro` is requested to [doGenCode](../datasources/avro/CatalystDataToAvro.md#doGenCode)
* `CastBase` is requested to `castToStringCode`, `castToDateCode`, `castToTimestampCode` and `castToTimestampNTZCode`
* Catalyst `Expression`s are requested to [doGenCode](../expressions/Expression.md#doGenCode)
* `BroadcastHashJoinExec` physical operator is requested to [prepareBroadcast](../physical-operators/BroadcastHashJoinExec.md#prepareBroadcast)
* `BroadcastNestedLoopJoinExec` physical operator is requested to [prepareBroadcast](../physical-operators/BroadcastNestedLoopJoinExec.md#prepareBroadcast)
* `ShuffledHashJoinExec` physical operator is requested to [prepareRelation](../physical-operators/ShuffledHashJoinExec.md#prepareRelation)
* `SortExec` physical operator is requested to [doProduce](../physical-operators/SortExec.md#doProduce)
* `SortMergeJoinExec` physical operator is requested to [doProduce](../physical-operators/SortMergeJoinExec.md#doProduce)
* `HashAggregateExec` physical operator is requested to [doProduceWithKeys](../physical-operators/HashAggregateExec.md#doProduceWithKeys)
* `CodegenSupport` is requested to [metricTerm](../physical-operators/CodegenSupport.md#metricTerm)
* `HashMapGenerator` is requested to [initializeAggregateHashMap](../HashMapGenerator.md#initializeAggregateHashMap)

## <span id="generateExpressions"> generateExpressions

```scala
generateExpressions(
  expressions: Seq[Expression],
  doSubexpressionElimination: Boolean = false): Seq[ExprCode]
```

`generateExpressions` generates a Java source code for Code-Generated Evaluation of multiple Catalyst [Expression](../expressions/Expression.md)s (with optional subexpression elimination).

---

With the given `doSubexpressionElimination` enabled, `generateExpressions` [subexpressionElimination](#subexpressionElimination) (with the given `expressions`).

In the end, `generateExpressions` requests every [Expression](../expressions/Expression.md) (in the given `expressions`) for a [Java source code for code-generated (non-interpreted) expression evaluation](../expressions/Expression.md#genCode).

---

`generateExpressions` is used when:

* `GenerateMutableProjection` is requested to [create a MutableProjection](GenerateMutableProjection.md#create)
* `GeneratePredicate` is requested to [create](GeneratePredicate.md#create)
* `GenerateUnsafeProjection` is requested to [create](GenerateUnsafeProjection.md#create)
* `HashAggregateExec` physical operator is requested for a [Java source code for whole-stage consume path with grouping keys](../physical-operators/HashAggregateExec.md#doConsumeWithKeys)

## Demo

### Adding State

```scala
import org.apache.spark.sql.catalyst.expressions.codegen._
val ctx = new CodegenContext

val input = ctx.addMutableState(
  "scala.collection.Iterator",
  "input",
  v => s"$v = inputs[0];")
```

### CodegenContext.subexpressionElimination

```scala
import org.apache.spark.sql.catalyst.expressions.codegen.CodegenContext
val ctx = new CodegenContext

// Use Catalyst DSL
import org.apache.spark.sql.catalyst.dsl.expressions._
val expressions = "hello".expr.as("world") :: "hello".expr.as("world") :: Nil

// FIXME Use a real-life query to extract the expressions

// CodegenContext.subexpressionElimination (where the elimination all happens) is a private method
// It is used exclusively in CodegenContext.generateExpressions which is public
// and does the elimination when it is enabled

// Note the doSubexpressionElimination flag is on
// Triggers the subexpressionElimination private method
ctx.generateExpressions(expressions, doSubexpressionElimination = true)

// subexpressionElimination private method uses ctx.equivalentExpressions
val commonExprs = ctx.equivalentExpressions.getAllEquivalentExprs

assert(commonExprs.length > 0, "No common expressions found")
```
