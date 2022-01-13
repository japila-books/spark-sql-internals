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

| expressions/ScalaUDAF.md[ScalaUDAF]
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

* `AggregateProcessor` is [initialized](../physical-operators/AggregateProcessor.md) (for window aggregate functions)

* [AggregationIterator](../AggregationIterator.md), [ObjectAggregationIterator](../ObjectAggregationIterator.md), [TungstenAggregationIterator](../TungstenAggregationIterator.md) (for aggregate functions)

| [[inputAggBufferOffset]] `inputAggBufferOffset`
|

| [[merge]] `merge`
a|

Used when:

* `AggregationIterator` does [generateProcessRow](../AggregationIterator.md#generateProcessRow) (for aggregate functions)

| [[mutableAggBufferOffset]] `mutableAggBufferOffset`
|

| [[update]] `update`
a|

Used when:

* `AggregateProcessor` is [updated](../physical-operators/AggregateProcessor.md#update) (for window aggregate functions)
* [AggregationIterator](../AggregationIterator.md) (for aggregate functions)

| [[withNewInputAggBufferOffset]] `withNewInputAggBufferOffset`
|

| [[withNewMutableAggBufferOffset]] `withNewMutableAggBufferOffset`
|
|===
