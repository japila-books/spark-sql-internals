# BoundReference Leaf Expression -- Reference to Value in Internal Binary Row

`BoundReference` is a [leaf expression](Expression.md#LeafExpression) that <<eval, evaluates to a value in an internal binary row>> at a specified <<ordinal, position>> and of a given <<dataType, data type>>.

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

You can also create a `BoundReference` using Catalyst DSL's [at](../spark-sql-catalyst-dsl.md#at) method.

```text
import org.apache.spark.sql.catalyst.dsl.expressions._
val boundRef = 'hello.string.at(4)
scala> println(boundRef)
input[4, string, true]
```

=== [[eval]] Evaluating Expression -- `eval` Method

[source, scala]
----
eval(input: InternalRow): Any
----

`eval` is part of the [Expression](Expression.md#eval) abstraction.

`eval` gives the value at <<ordinal, position>> from the given [InternalRow](../InternalRow.md) that is of a correct type.

Internally, `eval` returns `null` if the value at the <<ordinal, position>> is `null`.

Otherwise, `eval` uses the methods of `InternalRow` per the defined <<dataType, data type>> to access the value.

.eval's DataType to InternalRow's Methods Mapping (in execution order)
[cols="1,m",options="header",width="100%"]
|===
| DataType
| InternalRow's Method

| [BooleanType](../DataType.md#BooleanType)
| getBoolean

| [ByteType](../DataType.md#ByteType)
| getByte

| [ShortType](../DataType.md#ShortType)
| getShort

| [IntegerType](../DataType.md#IntegerType) or [DateType](../DataType.md#DateType)
| getInt

| [LongType](../DataType.md#LongType) or [TimestampType](../DataType.md#TimestampType)
| getLong

| [FloatType](../DataType.md#FloatType)
| getFloat

| [DoubleType](../DataType.md#DoubleType)
| getDouble

| [StringType](../DataType.md#StringType)
| getUTF8String

| [BinaryType](../DataType.md#BinaryType)
| getBinary

| [CalendarIntervalType](../DataType.md#CalendarIntervalType)
| getInterval

| [DecimalType](../DataType.md#DecimalType)
| getDecimal

| [StructType](../DataType.md#StructType)
| getStruct

| [ArrayType](../DataType.md#ArrayType)
| getArray

| [MapType](../DataType.md#MapType)
| getMap

| _others_
| get(ordinal, dataType)
|===

## Creating Instance

`BoundReference` takes the following to be created:

* [[ordinal]] Ordinal, i.e. the position
* [[dataType]] [Data type](../DataType.md) of the value
* [[nullable]] `nullable` flag that controls whether the value can be `null` or not

=== [[doGenCode]] Generating Java Source Code (ExprCode) For Code-Generated Expression Evaluation -- `doGenCode` Method

[source, scala]
----
doGenCode(ctx: CodegenContext, ev: ExprCode): ExprCode
----

NOTE: `doGenCode` is part of <<Expression.md#doGenCode, Expression Contract>> to generate a Java source code (ExprCode) for code-generated expression evaluation.

`doGenCode`...FIXME

=== [[BindReferences]][[bindReference]] `BindReferences.bindReference` Method

[source, scala]
----
bindReference[A <: Expression](
  expression: A,
  input: AttributeSeq,
  allowFailures: Boolean = false): A
----

`bindReference`...FIXME

NOTE: `bindReference` is used when...FIXME
