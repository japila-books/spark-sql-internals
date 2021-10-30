# BoundReference Leaf Expression

`BoundReference` is a [leaf expression](Expression.md#LeafExpression) that [evaluates to a value in an internal binary row](#eval) at a specified [position](#ordinal) and of a given [data type](#dataType).

```text
import org.apache.spark.sql.catalyst.expressions.BoundReference
import org.apache.spark.sql.types.LongType
val boundRef = BoundReference(ordinal = 0, dataType = LongType, nullable = true)

scala> println(boundRef.toString)
input[0, bigint, true]

import org.apache.spark.sql.catalyst.InternalRow
val row = InternalRow(1L, "hello")

val value = boundRef.eval(row).asInstanceOf[Long]
```

You can also create a `BoundReference` using Catalyst DSL's [at](../catalyst-dsl/index.md#at) method.

```text
import org.apache.spark.sql.catalyst.dsl.expressions._
val boundRef = 'hello.string.at(4)
scala> println(boundRef)
input[4, string, true]
```

## Creating Instance

`BoundReference` takes the following to be created:

* [[ordinal]] Ordinal, i.e. the position
* [[dataType]] [Data type](../types/DataType.md) of the value
* [[nullable]] `nullable` flag that controls whether the value can be `null` or not

## <span id="eval"> Evaluating Expression

```scala
eval(
  input: InternalRow): Any
```

`eval` gives the value at <<ordinal, position>> from the given [InternalRow](../InternalRow.md) that is of a correct type.

Internally, `eval` returns `null` if the value at the <<ordinal, position>> is `null`.

Otherwise, `eval` uses the methods of `InternalRow` per the defined <<dataType, data type>> to access the value.

.eval's DataType to InternalRow's Methods Mapping (in execution order)
[cols="1,m",options="header",width="100%"]
|===
| DataType
| InternalRow's Method

| [BooleanType](../types/DataType.md#BooleanType)
| getBoolean

| [ByteType](../types/DataType.md#ByteType)
| getByte

| [ShortType](../types/DataType.md#ShortType)
| getShort

| [IntegerType](../types/DataType.md#IntegerType) or [DateType](../types/DataType.md#DateType)
| getInt

| [LongType](../types/DataType.md#LongType) or [TimestampType](../types/DataType.md#TimestampType)
| getLong

| [FloatType](../types/DataType.md#FloatType)
| getFloat

| [DoubleType](../types/DataType.md#DoubleType)
| getDouble

| [StringType](../types/DataType.md#StringType)
| getUTF8String

| [BinaryType](../types/DataType.md#BinaryType)
| getBinary

| [CalendarIntervalType](../types/DataType.md#CalendarIntervalType)
| getInterval

| [DecimalType](../types/DataType.md#DecimalType)
| getDecimal

| [StructType](../types/DataType.md#StructType)
| getStruct

| [ArrayType](../types/ArrayType.md)
| getArray

| [MapType](../types/DataType.md#MapType)
| getMap

| _others_
| get(ordinal, dataType)
|===

`eval` is part of the [Expression](Expression.md#eval) abstraction.
