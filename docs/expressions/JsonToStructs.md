# JsonToStructs Unary Expression

`JsonToStructs` is a [unary expression](UnaryExpression.md) with [timezone](Expression.md#TimeZoneAwareExpression) support and [CodegenFallback](Expression.md#CodegenFallback).

`JsonToStructs` is <<creating-instance, created>> to represent spark-sql-functions.md#from_json[from_json] function.

```text
import org.apache.spark.sql.functions.from_json
val jsonCol = from_json($"json", new StructType())

import org.apache.spark.sql.catalyst.expressions.JsonToStructs
val jsonExpr = jsonCol.expr.asInstanceOf[JsonToStructs]
scala> println(jsonExpr.numberedTreeString)
00 jsontostructs('json, None)
01 +- 'json
```

`JsonToStructs` is a <<ExpectsInputTypes.md#, ExpectsInputTypes>> expression.

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
a| `JacksonParser` with <<rowSchema, rowSchema>> and [JSON options](../datasources/json/JsonFileFormat.md#JSONOptions)

| [[rowSchema]] `rowSchema`
a| [StructType](../StructType.md) that...FIXME

* <<schema, schema>> when of type `StructType`
* `StructType` of the elements in <<schema, schema>> when of type `ArrayType`
|===

=== [[creating-instance]] Creating JsonToStructs Instance

`JsonToStructs` takes the following when created:

* [[schema]] [DataType](../DataType.md)
* [[options]] Options
* [[child]] Child [expression](Expression.md)
* [[timeZoneId]] Optional time zone ID

`JsonToStructs` initializes the <<internal-registries, internal registries and counters>>.

=== [[validateSchemaLiteral]] Parsing Table Schema for String Literals -- `validateSchemaLiteral` Method

[source, scala]
----
validateSchemaLiteral(exp: Expression): StructType
----

`validateSchemaLiteral` requests [CatalystSqlParser](../sql/CatalystSqlParser.md) to [parseTableSchema](../sql/AbstractSqlParser.md#parseTableSchema) for [Literal](Literal.md) of [StringType](../DataType.md#StringType).

For any other non-``StringType`` [types](../DataType.md), `validateSchemaLiteral` reports a `AnalysisException`:

```text
Expected a string literal instead of [expression]
```
