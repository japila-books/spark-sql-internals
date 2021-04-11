# UnsafeRow

`UnsafeRow` is an [InternalRow](InternalRow.md) for mutable binary rows that are backed by raw memory outside JVM (instead of Java objects).

`UnsafeRow` supports Java's [Externalizable](#Externalizable) and Kryo's [KryoSerializable](#KryoSerializable) serialization/deserialization protocols.

## <span id="KryoSerializable"> KryoSerializable SerDe Protocol

Learn more in [KryoSerializable](https://github.com/EsotericSoftware/kryo#kryoserializable).

## <span id="Externalizable"> Java's Externalizable SerDe Protocol

Learn more in [java.io.Externalizable]({{ java.api }}/java.base/java/io/Externalizable.html).

## <span id="sizeInBytes"> sizeInBytes

`UnsafeRow` knows its size (in bytes).

```text
scala> println(unsafeRow.getSizeInBytes)
32
```

## Demo

```text
// Use ExpressionEncoder for simplicity
import org.apache.spark.sql.catalyst.encoders.ExpressionEncoder
val stringEncoder = ExpressionEncoder[String]
val row = stringEncoder.toRow("hello world")

import org.apache.spark.sql.catalyst.expressions.UnsafeRow
val unsafeRow = row match { case ur: UnsafeRow => ur }

scala> unsafeRow.getBytes
res0: Array[Byte] = Array(0, 0, 0, 0, 0, 0, 0, 0, 11, 0, 0, 0, 16, 0, 0, 0, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0, 0, 0, 0, 0)

scala> unsafeRow.getUTF8String(0)
res1: org.apache.spark.unsafe.types.UTF8String = hello world
```

## Field Offsets

The fields of a data row are placed using **field offsets**.

## <span id="mutableFieldTypes"><span id="mutable-types"> Mutable Types

`UnsafeRow` considers a [data type](DataType.md) mutable if it is one of the following:

* [BooleanType](DataType.md#BooleanType)
* [ByteType](DataType.md#ByteType)
* [DateType](DataType.md#DateType)
* [DecimalType](DataType.md#DecimalType) (see [isMutable](#isMutable))
* [DoubleType](DataType.md#DoubleType)
* [FloatType](DataType.md#FloatType)
* [IntegerType](DataType.md#IntegerType)
* [LongType](DataType.md#LongType)
* [NullType](DataType.md#NullType)
* [ShortType](DataType.md#ShortType)
* [TimestampType](DataType.md#TimestampType)

## 8-Byte Word Alignment and Three Regions

`UnsafeRow` is composed of three regions:

1. **Null Bit Set Bitmap Region** (1 bit/field) for tracking `null` values
1. Fixed-Length 8-Byte **Values Region**
1. Variable-Length **Data Region**

`UnsafeRow` is always 8-byte word aligned and so their size is always a multiple of 8 bytes.

## Equality and Hashing

Equality comparision and hashing of rows can be performed on raw bytes since if two rows are identical so should be their bit-wise representation. No type-specific interpretation is required.
