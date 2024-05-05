# RowEncoder

`RowEncoder` is part of the [Encoder framework](Encoder.md) and is used as the encoder of [DataFrame](DataFrame.md)s ([Dataset](dataset/index.md)s of [Row](Row.md)s).

!!! note
    `DataFrame` type is a type alias for `Dataset[Row]` that expects an `Encoder[Row]` available in scope which is `RowEncoder` itself.

## <span id="apply"> Creating ExpressionEncoder of Rows

```scala
apply(
  schema: StructType): ExpressionEncoder[Row]
```

`apply` creates a [BoundReference](expressions/BoundReference.md) to a nullable field of [ObjectType](types/DataType.md#ObjectType) (with [Row](Row.md)).

`apply` [creates a serializer for](#serializerFor) input objects as the `BoundReference` with the given [schema](types/StructType.md).

`apply` [creates a deserializer for](#serializerFor) a `GetColumnByOrdinal` expression with the given [schema](types/StructType.md).

In the end, `apply` creates an [ExpressionEncoder](ExpressionEncoder.md) for [Row](Row.md)s with the serializer and deserializer.

## <span id="serializerFor"> serializerFor

```scala
serializerFor(
  inputObject: Expression,
  inputType: DataType): Expression
```

`serializerFor` is a recursive method that decomposes non-primitive (_complex_) [DataType](types/DataType.md)s (e.g. `ArrayType`, `MapType` and [StructType](types/StructType.md)) to primitives.

---

For a [StructType](types/StructType.md), creates a [CreateNamedStruct](expressions/CreateNamedStruct.md) with serializer expressions for the (inner) fields.

For [native types](ScalaReflection.md#isNativeType), `serializerFor` returns the given `inputObject` expression (that ends recursion).

`serializerFor` handles the following [DataType](types/DataType.md)s in a custom way (and the given order):

1. `PythonUserDefinedType`
1. [UserDefinedType](types/UserDefinedType.md)
1. `TimestampType`
1. `DateType`
1. `DayTimeIntervalType`
1. `YearMonthIntervalType`
1. `DecimalType`
1. `StringType`
1. [ArrayType](types/ArrayType.md)
1. `MapType`

## Demo

```scala
import org.apache.spark.sql.types._
val schema = StructType(
  StructField("id", LongType, nullable = false) ::
  StructField("name", StringType, nullable = false) :: Nil)

import org.apache.spark.sql.catalyst.encoders.RowEncoder
val encoder = RowEncoder(schema)

assert(encoder.flat == false, "RowEncoder is never flat")
```
