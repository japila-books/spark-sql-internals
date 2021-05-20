# SizeBasedWindowFunction &mdash; Declarative Window Aggregate Functions with Window Size

`SizeBasedWindowFunction` is the <<contract, extension>> of the <<expressions/AggregateWindowFunction.md#, AggregateWindowFunction Contract>> for <<implementations, window functions>> that require the <<n, size of the current window>> for calculation.

[[contract]]
[source, scala]
----
package org.apache.spark.sql.catalyst.expressions

trait SizeBasedWindowFunction extends AggregateWindowFunction {
  // No required properties (vals and methods) that have no implementation
}
----

.SizeBasedWindowFunction Contract
[cols="1m,2",options="header",width="100%"]
|===
| Property
| Description

| n
| [[n]] Size of the current window as a <<spark-sql-Expression-AttributeReference.md#, AttributeReference>> expression with `++window__partition__size++` name, [IntegerType](../types/DataType.md#IntegerType) data type and not nullable
|===

[[implementations]]
.SizeBasedWindowFunctions (Direct Implementations)
[cols="1,2",options="header",width="100%"]
|===
| SizeBasedWindowFunction
| Description

| <<spark-sql-Expression-CumeDist.md#, CumeDist>>
| [[CumeDist]] Window function expression for <<spark-sql-functions.md#cume_dist, cume_dist>> standard function (Dataset API) and <<FunctionRegistry.md#expressions, cume_dist>> SQL function

| NTile
| [[NTile]]

| PercentRank
| [[PercentRank]]
|===
