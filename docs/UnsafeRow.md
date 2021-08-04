# UnsafeRow

`UnsafeRow` is an [InternalRow](InternalRow.md) for mutable binary rows that are backed by raw memory outside JVM (instead of Java objects that are in JVM memory space and would lead to more frequent GCs).

`UnsafeRow` supports Java's [Externalizable](#Externalizable) and Kryo's [KryoSerializable](#KryoSerializable) serialization/deserialization protocols.

## Creating Instance

`UnsafeRow` takes the following to be created:

* <span id="numFields"> Number of fields

While being created, `UnsafeRow` calculates the [bitset width](#bitSetWidthInBytes) based on the [number of fields](#numFields).

`UnsafeRow` is created when:

* FIXME

## <span id="isMutable"> Mutable Data Types

The following [DataType](types/DataType.md)s are considered **mutable data types**:

* `BooleanType`
* `ByteType`
* `CalendarIntervalType`
* `DateType`
* `DecimalType`
* `DoubleType`
* `FloatType`
* `IntegerType`
* `LongType`
* `NullType`
* `ShortType`
* `TimestampType`
* `UserDefinedType` (over a mutable data type)

Mutable data types have fixed length and can be mutated in place.

Examples (possibly all) of the data types that are not mutable:

* [ArrayType](types/ArrayType.md)
* `BinaryType`
* `StringType`
* `MapType`
* `ObjectType`
* [StructType](types/StructType.md)

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

## Field Offsets

The fields of a data row are placed using **field offsets**.

## <span id="mutableFieldTypes"><span id="mutable-types"> Mutable Types

`UnsafeRow` considers a [data type](types/DataType.md) mutable if it is one of the following:

* [BooleanType](types/DataType.md#BooleanType)
* [ByteType](types/DataType.md#ByteType)
* [DateType](types/DataType.md#DateType)
* [DecimalType](types/DataType.md#DecimalType) (see [isMutable](#isMutable))
* [DoubleType](types/DataType.md#DoubleType)
* [FloatType](types/DataType.md#FloatType)
* [IntegerType](types/DataType.md#IntegerType)
* [LongType](types/DataType.md#LongType)
* [NullType](types/DataType.md#NullType)
* [ShortType](types/DataType.md#ShortType)
* [TimestampType](types/DataType.md#TimestampType)

## 8-Byte Word Alignment and Three Regions

`UnsafeRow` is composed of three regions:

1. **Null Bit Set Bitmap Region** (1 bit/field) for tracking `null` values
1. Fixed-Length 8-Byte **Values Region**
1. Variable-Length **Data Region**

`UnsafeRow` is always 8-byte word aligned and so their size is always a multiple of 8 bytes.

## Equality and Hashing

Equality comparision and hashing of rows can be performed on raw bytes since if two rows are identical so should be their bit-wise representation. No type-specific interpretation is required.

## <span id="baseObject"> baseObject

```java
Object baseObject
```

`baseObject` is assigned in [pointTo](#pointTo), [copyFrom](#copyFrom), [readExternal](#readExternal) and [read](#read). In most cases, `baseObject` is `byte[]` (except a variant of [pointTo](#pointTo) that allows for `Object`s).

## <span id="writeToStream"> writeToStream

```java
void writeToStream(
  OutputStream out,
  byte[] writeBuffer)
```

`writeToStream` branches off based on whether the [baseObject](#baseObject) is `byte[]` or not.

`writeToStream`...FIXME

`writeToStream` is used when:

* `SparkPlan` is requested to [compress RDD partitions (of UnsafeRows) to byte arrays](physical-operators/SparkPlan.md#getByteArrayRdd)
* `UnsafeRowSerializerInstance` is requested to [serializeStream](tungsten/UnsafeRowSerializerInstance.md#serializeStream)
* `Percentile` expression is requested to `serialize`

## <span id="pointTo"> pointTo

```java
void pointTo(
  byte[] buf,
  int sizeInBytes) // (1)
void pointTo(
  Object baseObject,
  long baseOffset,
  int sizeInBytes)
```

1. Uses `Platform.BYTE_ARRAY_OFFSET` as `baseOffset`

`pointTo`...FIXME

## <span id="copyFrom"> copyFrom

```java
void copyFrom(
  UnsafeRow row)
```

`copyFrom`...FIXME

`copyFrom` is used when:

* `ObjectAggregationIterator` is requested to [processInputs](ObjectAggregationIterator.md#processInputs) (using `SortBasedAggregator`)
* `TungstenAggregationIterator` is requested to [produce the next UnsafeRow](TungstenAggregationIterator.md#next) and [outputForEmptyGroupingKeyWithoutInput](TungstenAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput)

## Deserializing UnsafeRow

Regardless of whether [Java](#readExternal) or [Kryo](#read) are used for deserialization, they read values from the given `ObjectInput` to assign the internal registries.

 Registry | Value
----------|-------
 [baseOffset](#baseOffset)   | The offset of the first element in the storage allocation of a byte array (`BYTE_ARRAY_OFFSET`)
 [sizeInBytes](#sizeInBytes) | The first four bytes (Java's `int`) from the `ObjectInput`
 [numFields](#numFields)     | The next four bytes (Java's `int`) from the `ObjectInput`
 [bitSetWidthInBytes](#bitSetWidthInBytes) | Based on the [numFields](#numFields)
 [baseObject](#baseObject)   | `byte[]` (of [sizeInBytes](#sizeInBytes) size)

### <span id="read"> Kryo

```java
void read(
  Kryo kryo,
  Input in)
```

`read` is part of the `KryoSerializable` ([Kryo](https://github.com/EsotericSoftware/kryo#kryoserializable)) abstraction.

### <span id="readExternal"> Java

```java
void readExternal(
  ObjectInput in)
```

`readExternal` is part of the `Externalizable` ([Java]({{ java.api }}/java.base/java/io/Externalizable.html#readExternal(java.io.ObjectInput))) abstraction.

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

```scala
// a sample human-readable row representation
// id (long), txt (string), num (int)
val id: Long = 0
val txt: String = "hello world"
val num: Int = 110
val singleRow = Seq(id, txt, num)
val numFields = singleRow.size

// that's not enough and I learnt it a few lines down
val rowDataInBytes = Array(id.toByte) ++ txt.toArray.map(_.toByte) ++ Array(num.toByte)

import org.apache.spark.sql.catalyst.expressions.UnsafeRow
val row = new UnsafeRow(numFields)
```

[sizeInBytes](#sizeInBytes) should be a multiple of 8 and it's a coincidence that this [pointTo](#pointTo) does not catch it. Checking `sizeInBytes % 8 == 0` passes fine and that's why the demo fails later on.

```text
row.pointTo(rowDataInBytes, rowDataInBytes.length)
```

The following will certainly fail. Consider it a WIP.

```text
assert(row.getLong(0) == id)
```
