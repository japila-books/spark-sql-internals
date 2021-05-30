# RowEncoder &mdash; Encoder for DataFrames

`RowEncoder` is part of the [Encoder framework](Encoder.md) and acts as the encoder for [DataFrame](DataFrame.md)s ([Dataset](Dataset.md)s of [Row](Row.md)s).

NOTE: `DataFrame` type is a mere type alias for `Dataset[Row]` that expects a `Encoder[Row]` available in scope which is indeed `RowEncoder` itself.

`RowEncoder` is an `object` in Scala with <<apply, apply>> and other factory methods.

`RowEncoder` can create `ExpressionEncoder[Row]` from a [schema](types/StructType.md) (using <<apply, apply method>>).

```text
import org.apache.spark.sql.types._
val schema = StructType(
  StructField("id", LongType, nullable = false) ::
  StructField("name", StringType, nullable = false) :: Nil)

import org.apache.spark.sql.catalyst.encoders.RowEncoder
scala> val encoder = RowEncoder(schema)
encoder: org.apache.spark.sql.catalyst.encoders.ExpressionEncoder[org.apache.spark.sql.Row] = class[id[0]: bigint, name[0]: string]

// RowEncoder is never flat
scala> encoder.flat
res0: Boolean = false
```

=== [[apply]] Creating ExpressionEncoder For Row Type -- `apply` method

[source, scala]
----
apply(schema: StructType): ExpressionEncoder[Row]
----

`apply` builds [ExpressionEncoder](ExpressionEncoder.md) of [Row](Row.md), i.e. `ExpressionEncoder[Row]`, from the input [StructType](types/index.md) (as `schema`).

Internally, `apply` creates a [BoundReference](expressions/BoundReference.md) for the [Row](Row.md) type and returns a `ExpressionEncoder[Row]` for the input `schema`, a `CreateNamedStruct` serializer (using <<serializerFor, `serializerFor` internal method>>), a deserializer for the schema, and the `Row` type.

=== [[serializerFor]] `serializerFor` Internal Method

[source, scala]
----
serializerFor(inputObject: Expression, inputType: DataType): Expression
----

`serializerFor` creates an `Expression` that <<apply, is assumed to be>> `CreateNamedStruct`.

`serializerFor` takes the input `inputType` and:

1. Returns the input `inputObject` as is for native types, i.e. `NullType`, `BooleanType`, `ByteType`, `ShortType`, `IntegerType`, `LongType`, `FloatType`, `DoubleType`, `BinaryType`, `CalendarIntervalType`.
+
CAUTION: FIXME What does being native type mean?

2. For ``UserDefinedType``s, it takes the UDT class from the `SQLUserDefinedType` annotation or `UDTRegistration` object and returns an expression with `Invoke` to call `serialize` method on a `NewInstance` of the UDT class.

3. For [TimestampType](types/DataType.md#TimestampType), it returns an expression with a [StaticInvoke](expressions/StaticInvoke.md) to call `fromJavaTimestamp` on `DateTimeUtils` class.

4. ...FIXME

CAUTION: FIXME Describe me.
