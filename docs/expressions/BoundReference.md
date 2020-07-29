title: BoundReference

# BoundReference Leaf Expression -- Reference to Value in Internal Binary Row

`BoundReference` is a expressions/Expression.md#LeafExpression[leaf expression] that <<eval, evaluates to a value in an internal binary row>> at a specified <<ordinal, position>> and of a given <<dataType, data type>>.

[[creating-instance]]
`BoundReference` takes the following when created:

* [[ordinal]] Ordinal, i.e. the position
* [[dataType]] spark-sql-DataType.md[Data type] of the value
* [[nullable]] `nullable` flag that controls whether the value can be `null` or not

[source, scala]
----
import org.apache.spark.sql.catalyst.expressions.BoundReference
import org.apache.spark.sql.types.LongType
val boundRef = BoundReference(ordinal = 0, dataType = LongType, nullable = true)

scala> println(boundRef.toString)
input[0, bigint, true]

import org.apache.spark.sql.catalyst.InternalRow
val row = InternalRow(1L, "hello")

val value = boundRef.eval(row).asInstanceOf[Long]
----

You can also create a `BoundReference` using Catalyst DSL's spark-sql-catalyst-dsl.md#at[at] method.

[source, scala]
----
import org.apache.spark.sql.catalyst.dsl.expressions._
val boundRef = 'hello.string.at(4)
scala> println(boundRef)
input[4, string, true]
----

=== [[eval]] Evaluating Expression -- `eval` Method

[source, scala]
----
eval(input: InternalRow): Any
----

NOTE: `eval` is part of <<expressions/Expression.md#eval, Expression Contract>> for the *interpreted (non-code-generated) expression evaluation*, i.e. evaluating a Catalyst expression to a JVM object for a given <<spark-sql-InternalRow.md#, internal binary row>>.

`eval` gives the value at <<ordinal, position>> from the `input` spark-sql-InternalRow.md[internal binary row] that is of a correct type.

Internally, `eval` returns `null` if the value at the <<ordinal, position>> is `null`.

Otherwise, `eval` uses the methods of `InternalRow` per the defined <<dataType, data type>> to access the value.

.eval's DataType to InternalRow's Methods Mapping (in execution order)
[cols="1,m",options="header",width="100%"]
|===
| DataType
| InternalRow's Method

| spark-sql-DataType.md#BooleanType[BooleanType]
| getBoolean

| spark-sql-DataType.md#ByteType[ByteType]
| getByte

| spark-sql-DataType.md#ShortType[ShortType]
| getShort

| spark-sql-DataType.md#IntegerType[IntegerType] or spark-sql-DataType.md#DateType[DateType]
| getInt

| spark-sql-DataType.md#LongType[LongType] or spark-sql-DataType.md#TimestampType[TimestampType]
| getLong

| spark-sql-DataType.md#FloatType[FloatType]
| getFloat

| spark-sql-DataType.md#DoubleType[DoubleType]
| getDouble

| spark-sql-DataType.md#StringType[StringType]
| getUTF8String

| spark-sql-DataType.md#BinaryType[BinaryType]
| getBinary

| spark-sql-DataType.md#CalendarIntervalType[CalendarIntervalType]
| getInterval

| spark-sql-DataType.md#DecimalType[DecimalType]
| getDecimal

| spark-sql-DataType.md#StructType[StructType]
| getStruct

| spark-sql-DataType.md#ArrayType[ArrayType]
| getArray

| spark-sql-DataType.md#MapType[MapType]
| getMap

| _others_
| get(ordinal, dataType)
|===

=== [[doGenCode]] Generating Java Source Code (ExprCode) For Code-Generated Expression Evaluation -- `doGenCode` Method

[source, scala]
----
doGenCode(ctx: CodegenContext, ev: ExprCode): ExprCode
----

NOTE: `doGenCode` is part of <<expressions/Expression.md#doGenCode, Expression Contract>> to generate a Java source code (ExprCode) for code-generated expression evaluation.

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
