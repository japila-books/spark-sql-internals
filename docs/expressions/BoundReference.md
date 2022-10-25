# BoundReference

`BoundReference` is a [leaf expression](Expression.md#LeafExpression) that [evaluates to a value](#eval) (of the given [data type](#dataType)) that is at the specified [position](#ordinal) in the given [InternalRow](../InternalRow.md).

## Creating Instance

`BoundReference` takes the following to be created:

* <span id="ordinal"> Position (ordinal)
* <span id="dataType"> [Data type](../types/DataType.md) of values
* <span id="nullable"> `nullable` flag

`BoundReference` is created when:

* `Encoders` utility is used to [create a generic ExpressionEncoder](../Encoders.md#genericSerializer)
* `ScalaReflection` utility is used to [serializerForType](../ScalaReflection.md#serializerForType)
* `ExpressionEncoder` utility is used to [tuple](../ExpressionEncoder.md#tuple)
* `RowEncoder` utility is used to [create a RowEncoder](../RowEncoder.md#apply)
* `BindReferences` utility is used to [bind an AttributeReference](../BindReferences.md#bindReference)
* `UnsafeProjection` utility is used to [create an UnsafeProjection](UnsafeProjection.md#create)
* _others_

## <span id="doGenCode"> Code-Generated Expression Evaluation

```scala
doGenCode(
  ctx: CodegenContext,
  ev: ExprCode): ExprCode
```

`doGenCode` is part of the [Expression](Expression.md#doGenCode) abstraction.

---

`doGenCode`...FIXME

---

```scala
import org.apache.spark.sql.catalyst.expressions.BoundReference
import org.apache.spark.sql.types.LongType
val boundRef = BoundReference(ordinal = 0, dataType = LongType, nullable = true)

// doGenCode is used when Expression.genCode is executed

import org.apache.spark.sql.catalyst.expressions.codegen.CodegenContext
val ctx = new CodegenContext
val code = boundRef.genCode(ctx).code
```

```text
scala> println(code)
boolean isNull_0 = i.isNullAt(0);
long value_0 = isNull_0 ?
  -1L : (i.getLong(0));
```

## <span id="eval"> Interpreted Expression Evaluation

```scala
eval(
  input: InternalRow): Any
```

`eval` is part of the [Expression](Expression.md#eval) abstraction.

---

`eval` gives the value at [position](#ordinal) from the given [InternalRow](../InternalRow.md).

---

`eval` returns `null` if the value at the [position](#ordinal) is `null`. Otherwise, `eval` uses the methods of `InternalRow` per the defined [data type](#dataType) to access the value.

## <span id="toString"> String Representation

```scala
toString: String
```

`toString` is part of the [Expression](Expression.md#toString) abstraction.

---

`toString` is the following text:

```text
input[[ordinal], [dataType], [nullable]]
```

## <span id="catalyst-dsl"><span id="at"> Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md)'s [at](../catalyst-dsl/index.md#at) can be used to create a `BoundReference`.

```scala
import org.apache.spark.sql.catalyst.dsl.expressions._
val boundRef = 'id.string.at(4)

import org.apache.spark.sql.catalyst.expressions.BoundReference
assert(boundRef.isInstanceOf[BoundReference])
```

## Demo

```scala
import org.apache.spark.sql.catalyst.expressions.BoundReference
import org.apache.spark.sql.types.LongType
val boundRef = BoundReference(ordinal = 0, dataType = LongType, nullable = true)
```

```text
scala> println(boundRef)
input[0, bigint, true]
```

```scala
import org.apache.spark.sql.catalyst.InternalRow
val row = InternalRow(1L, "hello")
val value = boundRef.eval(row).asInstanceOf[Long]
assert(value == 1L)
```
