# BoundReference

`BoundReference` is a [LeafExpression](Expression.md#LeafExpression) that [gives (evaluates to)](#eval) the value of the given [InternalRow](../InternalRow.md) at a specified [position](#ordinal) (and of a given [data type](#dataType)).

## Creating Instance

`BoundReference` takes the following to be created:

* <span id="ordinal"> Position
* <span id="dataType"> [Data type](../types/DataType.md) of the value
* <span id="nullable"> `nullable` flag (whether the value can be `null` or not)

`BoundReference` is created when:

* `Encoders` utility is used to [genericSerializer](../Encoders.md#genericSerializer)
* `JavaTypeInference` utility is used to `serializerFor`
* `ExternalCatalogUtils` utility is used to [prunePartitionsByFilter](../ExternalCatalogUtils.md#prunePartitionsByFilter)
* `ScalaReflection` utility is used to [serializerForType](../ScalaReflection.md#serializerForType)
* `StructFilters` is used to `toRef`
* `ExpressionEncoder` utility is used to [tuple](../ExpressionEncoder.md#tuple)
* `RowEncoder` utility is used to [create a RowEncoder](../RowEncoder.md#apply)
* `BindReferences` utility is used to `bindReference`
* `UnsafeProjection` utility is used to [create an UnsafeProjection](UnsafeProjection.md#create)
* `FileSourceScanExec` physical operator is requested for [dynamicallySelectedPartitions](../physical-operators/FileSourceScanExec.md#dynamicallySelectedPartitions)
* _others_

## <span id="doGenCode"> Code-Generated Expression Evaluation

```scala
doGenCode(
  ctx: CodegenContext,
  ev: ExprCode): ExprCode
```

`doGenCode` is part of the [Expression](Expression.md#doGenCode) abstraction.

```text
import org.apache.spark.sql.catalyst.expressions.BoundReference
import org.apache.spark.sql.types.LongType
val boundRef = BoundReference(ordinal = 0, dataType = LongType, nullable = true)

// doGenCode is used when Expression.genCode is executed

import org.apache.spark.sql.catalyst.expressions.codegen.CodegenContext
val ctx = new CodegenContext
val code = boundRef.genCode(ctx).code

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

`eval` gives the value at [position](#ordinal) from the given [InternalRow](../InternalRow.md) that is of a correct type.

---

`eval` returns `null` if the value at the [position](#ordinal) is `null`. Otherwise, `eval` uses the methods of `InternalRow` per the defined [data type](#dataType) to access the value.

---

`eval` is part of the [Expression](Expression.md#eval) abstraction.

## <span id="catalyst-dsl"><span id="at"> Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md)'s [at](../catalyst-dsl/index.md#at) can be used to create a `BoundReference`.

```scala
import org.apache.spark.sql.catalyst.dsl.expressions._
val boundRef = 'id.string.at(4)
```

```text
scala> :type boundRef
org.apache.spark.sql.catalyst.expressions.BoundReference

scala> println(boundRef)
input[4, string, true]
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
```
