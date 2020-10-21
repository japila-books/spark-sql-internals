# OffsetWindowFunction &mdash; Unevaluable Window Function Expressions

`OffsetWindowFunction` is the <<contract, base>> of <<extensions, window function expressions>> that are [unevaluable](Unevaluable.md) and `ImplicitCastInputTypes`.

[[contract]]
[source, scala]
----
package org.apache.spark.sql.catalyst.expressions

abstract class OffsetWindowFunction ... {
  // only required properties (vals and methods) that have no implementation
  // the others follow
  val default: Expression
  val direction: SortDirection
  val input: Expression
  val offset: Expression
}
----

.(Subset of) OffsetWindowFunction Contract
[cols="1m,2",options="header",width="100%"]
|===
| Property
| Description

| default
| [[default]]

| direction
| [[direction]]

| input
| [[input]]

| offset
| [[offset]]
|===

[[children]]
`OffsetWindowFunction` uses the <<input, input>>, <<offset, offset>> and <<default, default>> expressions as the [children](../catalyst/TreeNode.md#children).

[[foldable]]
`OffsetWindowFunction` is not <<Expression.md#foldable, foldable>>.

[[nullable]]
`OffsetWindowFunction` is <<Expression.md#nullable, nullable>> when the <<default, default>> is not defined or the <<default, default>> or the <<input, input>> expressions are.

[[dataType]]
When requested for the <<Expression.md#dataType, dataType>>, `OffsetWindowFunction` simply requests the <<input, input>> expression for the data type.

[[dataType]]
When requested for the <<spark-sql-Expression-ExpectsInputTypes.md#inputTypes, inputTypes>>, `OffsetWindowFunction` returns the `AnyDataType`, [IntegerType](../DataType.md#IntegerType) with the [data type](Expression.md#dataType) of the <<input, input>> expression and the [NullType](../DataType.md#NullType).

[[toString]]
`OffsetWindowFunction` uses the following *text representation* (i.e. `toString`):

```text
[prettyName]([input], [offset], [default])
```

[[extensions]]
.OffsetWindowFunctions (Direct Implementations)
[cols="1,2",options="header",width="100%"]
|===
| OffsetWindowFunction
| Description

| Lag
| [[Lag]]

| Lead
| [[Lead]]
|===

=== [[frame]] `frame` Lazy Property

[source, scala]
----
frame: WindowFrame
----

NOTE: `frame` is part of the <<spark-sql-Expression-WindowFunction.md#frame, WindowFunction Contract>> to define the `WindowFrame` for function expression execution.

`frame`...FIXME

=== [[checkInputDataTypes]] Verifying Input Data Types -- `checkInputDataTypes` Method

[source, scala]
----
checkInputDataTypes(): TypeCheckResult
----

NOTE: `checkInputDataTypes` is part of the <<Expression.md#checkInputDataTypes, Expression Contract>> to verify (check the correctness of) the input data types.

`checkInputDataTypes`...FIXME
