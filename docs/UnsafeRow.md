# UnsafeRow

`UnsafeRow` is a [InternalRow](InternalRow.md) that represents a mutable internal raw-memory (and hence unsafe) binary row format.

In other words, `UnsafeRow` is an `InternalRow` that is backed by raw memory instead of Java objects.

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

[[sizeInBytes]]
`UnsafeRow` knows its *size in bytes*.

```text
scala> println(unsafeRow.getSizeInBytes)
32
```

`UnsafeRow` supports Java's <<Externalizable, Externalizable>> and Kryo's <<KryoSerializable, KryoSerializable>> serialization/deserialization protocols.

The fields of a data row are placed using *field offsets*.

[[mutableFieldTypes]]
[[mutable-types]]
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

`UnsafeRow` is composed of three regions:

. Null Bit Set Bitmap Region (1 bit/field) for tracking null values
. Fixed-Length 8-Byte Values Region
. Variable-Length Data Section

That gives the property of rows being always 8-byte word aligned and so their size is always a multiple of 8 bytes.

Equality comparision and hashing of rows can be performed on raw bytes since if two rows are identical so should be their bit-wise representation. No type-specific interpretation is required.

=== [[isMutable]] `isMutable` Static Predicate

[source, java]
----
static boolean isMutable(DataType dt)
----

`isMutable` is enabled (`true`) when the input [DataType](DataType.md) is among the [mutable field types](#mutableFieldTypes) or a [DecimalType](DataType.md#DecimalType).

Otherwise, `isMutable` is disabled (`false`).

[NOTE]
====
`isMutable` is used when:

* `UnsafeFixedWidthAggregationMap` is requested to <<spark-sql-UnsafeFixedWidthAggregationMap.md#supportsAggregationBufferSchema, supportsAggregationBufferSchema>>

* `SortBasedAggregationIterator` is requested for <<spark-sql-SortBasedAggregationIterator.md#newBuffer, newBuffer>>
====

=== [[KryoSerializable]] Kryo's KryoSerializable SerDe Protocol

TIP: Read up on https://github.com/EsotericSoftware/kryo#kryoserializable[KryoSerializable].

==== [[write]] Serializing JVM Object -- KryoSerializable's `write` Method

[source, java]
----
void write(Kryo kryo, Output out)
----

==== [[read]] Deserializing Kryo-Managed Object -- KryoSerializable's `read` Method

[source, java]
----
void read(Kryo kryo, Input in)
----

=== [[Externalizable]] Java's Externalizable SerDe Protocol

TIP: Read up on https://docs.oracle.com/javase/8/docs/api/java/io/Externalizable.html[java.io.Externalizable].

==== [[writeExternal]] Serializing JVM Object -- Externalizable's `writeExternal` Method

[source, java]
----
void writeExternal(ObjectOutput out)
throws IOException
----

==== [[readExternal]] Deserializing Java-Externalized Object -- Externalizable's `readExternal` Method

[source, java]
----
void readExternal(ObjectInput in)
throws IOException, ClassNotFoundException
----

=== [[pointTo]] `pointTo` Method

[source, java]
----
void pointTo(Object baseObject, long baseOffset, int sizeInBytes)
----

`pointTo`...FIXME

NOTE: `pointTo` is used when...FIXME
