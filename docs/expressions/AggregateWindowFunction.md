# AggregateWindowFunction &mdash; Declarative Window Aggregate Function Expressions

`AggregateWindowFunction` is the <<contract, extension>> of the [DeclarativeAggregate](DeclarativeAggregate.md) contract for <<extensions, declarative aggregate function expressions>> that are also [WindowFunction](WindowFunction.md) expressions.

[[contract]]
[source, scala]
----
package org.apache.spark.sql.catalyst.expressions

abstract class AggregateWindowFunction extends DeclarativeAggregate with WindowFunction {
  self: Product =>
  // No required properties (vals and methods) that have no implementation
}
----

[[dataType]]
`AggregateWindowFunction` uses [IntegerType](../DataType.md#IntegerType) as the [data type](Expression.md#dataType) of the result of evaluating itself.

[[nullable]]
`AggregateWindowFunction` is [nullable](Expression.md#nullable) by default.

[[frame]]
As a <<spark-sql-Expression-WindowFunction.md#, WindowFunction>> expression, `AggregateWindowFunction` uses a `SpecifiedWindowFrame` (with the `RowFrame` frame type, the `UnboundedPreceding` lower and the `CurrentRow` upper frame boundaries) as the <<spark-sql-Expression-WindowFunction.md#frame, frame>>.

[[mergeExpressions]]
`AggregateWindowFunction` is a <<spark-sql-Expression-DeclarativeAggregate.md#, DeclarativeAggregate>> expression that does not support <<spark-sql-Expression-DeclarativeAggregate.md#mergeExpressions, merging>> (two aggregation buffers together) and throws an `UnsupportedOperationException` whenever requested for it.

```text
Window Functions do not support merging.
```

[[extensions]]
.AggregateWindowFunctions (Direct Implementations)
[cols="1,2",options="header",width="100%"]
|===
| AggregateWindowFunction
| Description

| <<spark-sql-Expression-RankLike.md#, RankLike>>
| [[RankLike]]

| <<spark-sql-Expression-RowNumberLike.md#, RowNumberLike>>
| [[RowNumberLike]]

| <<spark-sql-Expression-SizeBasedWindowFunction.md#, SizeBasedWindowFunction>>
| [[SizeBasedWindowFunction]] Window functions that require the size of the current window for calculation
|===
