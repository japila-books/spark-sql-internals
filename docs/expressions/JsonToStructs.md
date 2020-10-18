title: JsonToStructs

# JsonToStructs Unary Expression

`JsonToStructs` is a <<spark-sql-Expression-UnaryExpression.md#, unary expression>> with expressions/Expression.md#TimeZoneAwareExpression[timezone] support and expressions/Expression.md#CodegenFallback[CodegenFallback].

`JsonToStructs` is <<creating-instance, created>> to represent spark-sql-functions.md#from_json[from_json] function.

[source, scala]
----
import org.apache.spark.sql.functions.from_json
val jsonCol = from_json($"json", new StructType())

import org.apache.spark.sql.catalyst.expressions.JsonToStructs
val jsonExpr = jsonCol.expr.asInstanceOf[JsonToStructs]
scala> println(jsonExpr.numberedTreeString)
00 jsontostructs('json, None)
01 +- 'json
----

`JsonToStructs` is a <<spark-sql-Expression-ExpectsInputTypes.md#, ExpectsInputTypes>> expression.

[[FAILFAST]]
[NOTE]
====
`JsonToStructs` uses <<parser, JacksonParser>> in `FAILFAST` mode that simply fails early when a corrupted/malformed record is found (and hence does not support `columnNameOfCorruptRecord` JSON option).
====

[[properties]]
.JsonToStructs's Properties
[width="100%",cols="1,2",options="header"]
|===
| Property
| Description

| [[converter]] `converter`
| Function that converts `Seq[InternalRow]` into...FIXME

| [[nullable]] `nullable`
| Enabled (i.e. `true`)

| [[parser]] `parser`
a| `JacksonParser` with <<rowSchema, rowSchema>> and [JSON options](../spark-sql-JsonFileFormat.md#JSONOptions)

| [[rowSchema]] `rowSchema`
a| [StructType](../StructType.md) that...FIXME

* <<schema, schema>> when of type `StructType`
* `StructType` of the elements in <<schema, schema>> when of type `ArrayType`
|===

=== [[creating-instance]] Creating JsonToStructs Instance

`JsonToStructs` takes the following when created:

* [[schema]] spark-sql-DataType.md[DataType]
* [[options]] Options
* [[child]] Child expressions/Expression.md[expression]
* [[timeZoneId]] Optional time zone ID

`JsonToStructs` initializes the <<internal-registries, internal registries and counters>>.

=== [[validateSchemaLiteral]] Parsing Table Schema for String Literals -- `validateSchemaLiteral` Method

[source, scala]
----
validateSchemaLiteral(exp: Expression): StructType
----

`validateSchemaLiteral` requests spark-sql-CatalystSqlParser.md[CatalystSqlParser] to spark-sql-AbstractSqlParser.md#parseTableSchema[parseTableSchema] for spark-sql-Expression-Literal.md[Literal] of spark-sql-DataType.md#StringType[StringType].

For any other non-``StringType`` spark-sql-DataType.md[types], `validateSchemaLiteral` reports a `AnalysisException`:

```
Expected a string literal instead of [expression]
```
