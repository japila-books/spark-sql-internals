# Literal Leaf Expression

`Literal` is a [leaf expression](Expression.md#LeafExpression) that is <<creating-instance, created>> to represent a Scala <<value, value>> of a <<dataType, specific type>>.

[[properties]]
.Literal's Properties
[width="100%",cols="1,2",options="header"]
|===
| Property
| Description

| `foldable`
| [[foldable]] Enabled (i.e. `true`)

| `nullable`
| [[nullable]] Enabled when <<value, value>> is `null`
|===

=== [[create]] Creating Literal Instance -- `create` Object Method

[source, scala]
----
create(v: Any, dataType: DataType): Literal
----

`create` uses `CatalystTypeConverters` helper object to [convert](../CatalystTypeConverters.md#convertToCatalyst) the input `v` Scala value to a Catalyst rows or types and creates a <<creating-instance, Literal>> (with the Catalyst value and the input [DataType](../DataType.md)).

## Creating Instance

`Literal` takes the following when created:

* [[value]] Scala value (of type `Any`)
* [[dataType]] [DataType](../DataType.md)

=== [[doGenCode]] Generating Java Source Code (ExprCode) For Code-Generated Expression Evaluation -- `doGenCode` Method

[source, scala]
----
doGenCode(ctx: CodegenContext, ev: ExprCode): ExprCode
----

NOTE: `doGenCode` is part of <<Expression.md#doGenCode, Expression Contract>> to generate a Java source code (ExprCode) for code-generated expression evaluation.

`doGenCode`...FIXME
