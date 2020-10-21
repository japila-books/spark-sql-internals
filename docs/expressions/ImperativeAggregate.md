# ImperativeAggregate &mdash; Aggregate Function Expressions with Imperative Methods

`ImperativeAggregate` is the <<contract, contract>> for [aggregate functions](AggregateFunction.md) that are expressed in terms of imperative <<initialize, initialize>>, <<update, update>>, and <<merge, merge>> methods (that operate on ``Row``-based aggregation buffers).

`ImperativeAggregate` is a [Catalyst expression](Expression.md) with [CodegenFallback](Expression.md#CodegenFallback).

[[implementations]]
.ImperativeAggregate's Direct Implementations
[width="100%",cols="1,2",options="header"]
|===
| Name
| Description

| `HyperLogLogPlusPlus`
|

| `PivotFirst`
|

| spark-sql-Expression-ScalaUDAF.md[ScalaUDAF]
|

| spark-sql-Expression-TypedImperativeAggregate.md[TypedImperativeAggregate]
|
|===

=== [[contract]] ImperativeAggregate Contract

[source, scala]
----
package org.apache.spark.sql.catalyst.expressions.aggregate

abstract class ImperativeAggregate {
  def initialize(mutableAggBuffer: InternalRow): Unit
  val inputAggBufferOffset: Int
  def merge(mutableAggBuffer: InternalRow, inputAggBuffer: InternalRow): Unit
  val mutableAggBufferOffset: Int
  def update(mutableAggBuffer: InternalRow, inputRow: InternalRow): Unit
  def withNewInputAggBufferOffset(newInputAggBufferOffset: Int): ImperativeAggregate
  def withNewMutableAggBufferOffset(newMutableAggBufferOffset: Int): ImperativeAggregate
}
----

.ImperativeAggregate Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| [[initialize]] `initialize`
a|

Used when:

* `AggregateProcessor` is spark-sql-AggregateProcessor.md[initialized] (for window aggregate functions)

* spark-sql-AggregationIterator.md[AggregationIterator], <<spark-sql-ObjectAggregationIterator.md#, ObjectAggregationIterator>>, spark-sql-TungstenAggregationIterator.md[TungstenAggregationIterator] (for aggregate functions)

| [[inputAggBufferOffset]] `inputAggBufferOffset`
|

| [[merge]] `merge`
a|

Used when:

* `AggregationIterator` does spark-sql-AggregationIterator.md#generateProcessRow[generateProcessRow] (for aggregate functions)

| [[mutableAggBufferOffset]] `mutableAggBufferOffset`
|

| [[update]] `update`
a|

Used when:

* `AggregateProcessor` is spark-sql-AggregateProcessor.md#update[updated] (for window aggregate functions)
* spark-sql-AggregationIterator.md[AggregationIterator] (for aggregate functions)

| [[withNewInputAggBufferOffset]] `withNewInputAggBufferOffset`
|

| [[withNewMutableAggBufferOffset]] `withNewMutableAggBufferOffset`
|
|===
