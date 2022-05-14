# CreateNamedStruct

`CreateNamedStruct` is an [Expression](Expression.md).

## Creating Instance

`CreateNamedStruct` takes the following to be created:

* <span id="children"> Child [Expression](Expression.md)s

`CreateNamedStruct` is created when:

* `SerializerBuildHelper` utility is used to [createSerializerForObject](../SerializerBuildHelper.md#createSerializerForObject)
* `ResolveExpressionsWithNamePlaceholders` logical analysis rule is executed
* `ResolveUnion` logical analysis rule is executed
* [Catalyst DSL](../catalyst-dsl/index.md)'s `namedStruct` operator is used
* `ExpressionEncoder` is [created](../ExpressionEncoder.md#serializer)
* `RowEncoder` utility is used to [create a serializer for a StructType](../RowEncoder.md#serializerFor)
* `CreateStruct` utility is used to [create a CreateNamedStruct](CreateStruct.md#apply)
* `ObjectSerializerPruning` logical optimization is executed
* _many many others_

## <span id="nullable"> Never Nullable

```scala
nullable: Boolean
```

`nullable` is always disabled (`false`).

`nullable` is part of the [Expression](Expression.md#nullable) abstraction.

## <span id="nodePatterns"> Node Patterns

```scala
nodePatterns: Seq[TreePattern]
```

`nodePatterns` is [CREATE_NAMED_STRUCT](../catalyst/TreePattern.md#CREATE_NAMED_STRUCT).

`nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

## <span id="prettyName"> Pretty Name

```scala
prettyName: String
```

`prettyName` is either [function alias](../catalyst/TreeNode.md#getTagValue) for the `functionAliasName` tag (if defined) or **named_struct**.

`prettyName` is part of the [Expression](Expression.md#prettyName) abstraction.

## <span id="eval"> Interpreted Expression Evaluation

```scala
eval(
  input: InternalRow): Any
```

`eval` creates an [InternalRow](../InternalRow.md) with the result of [evaluation](Expression.md#eval) of all the [value expressions](#valExprs).

`eval` is part of the [Expression](Expression.md#eval) abstraction.

## <span id="doGenCode"> Code-Generated Expression Evaluation

```scala
doGenCode(
  ctx: CodegenContext,
  ev: ExprCode): ExprCode
```

`doGenCode` is part of the [Expression](Expression.md#doGenCode) abstraction.

```scala
import org.apache.spark.sql.functions.lit
val exprs = Seq("a", 1).map(lit).map(_.expr)

import org.apache.spark.sql.catalyst.dsl.expressions._
val ns = namedStruct(exprs: _*)

// doGenCode is used when Expression.genCode is executed

import org.apache.spark.sql.catalyst.expressions.codegen.CodegenContext
val ctx = new CodegenContext
val code = ns.genCode(ctx).code
```

```text
scala> println(code)
Object[] values_0 = new Object[1];


if (false) {
  values_0[0] = null;
} else {
  values_0[0] = 1;
}

final InternalRow value_0 = new org.apache.spark.sql.catalyst.expressions.GenericInternalRow(values_0);
values_0 = null;
```

## <span id="FunctionRegistry"> FunctionRegistry

`CreateNamedStruct` is registered in [FunctionRegistry](../FunctionRegistry.md#expressions) under the name of `named_struct` SQL function.

```scala
import org.apache.spark.sql.catalyst.FunctionIdentifier
val fid = FunctionIdentifier(funcName = "named_struct")
val className = spark.sessionState.functionRegistry.lookupFunction(fid).get.getClassName
```

```text
scala> println(className)
org.apache.spark.sql.catalyst.expressions.CreateNamedStruct
```

```scala
val q = sql("SELECT named_struct('id', 0)")
// analyzed so the function is resolved already (using FunctionRegistry)
val analyzedPlan = q.queryExecution.analyzed
```

```text
scala> println(analyzedPlan.numberedTreeString)
00 Project [named_struct(id, 0) AS named_struct(id, 0)#7]
01 +- OneRowRelation
```

```scala
val e = analyzedPlan.expressions.head.children.head
import org.apache.spark.sql.catalyst.expressions.CreateNamedStruct
assert(e.isInstanceOf[CreateNamedStruct])
```

## Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md) defines [namedStruct](../catalyst-dsl/index.md#expressions) operator to create a `CreateNamedStruct` expression.

```scala
import org.apache.spark.sql.catalyst.dsl.expressions._
val s = namedStruct()

import org.apache.spark.sql.catalyst.expressions.CreateNamedStruct
assert(s.isInstanceOf[CreateNamedStruct])

val s = namedStruct("*")
```

```text
scala> println(s)
named_struct(*)
```
