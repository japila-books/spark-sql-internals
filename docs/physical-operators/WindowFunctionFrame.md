# WindowFunctionFrame

`WindowFunctionFrame` is a <<contract, contract>> for...FIXME

[[implementations]]
.WindowFunctionFrame's Implementations
[width="100%",cols="1,2",options="header"]
|===
| Name
| Description

| `OffsetWindowFunctionFrame`
|

| [[SlidingWindowFunctionFrame]] `SlidingWindowFunctionFrame`
|

| `UnboundedFollowingWindowFunctionFrame`
|

| `UnboundedPrecedingWindowFunctionFrame`
|

| <<UnboundedWindowFunctionFrame, UnboundedWindowFunctionFrame>>
|
|===

=== [[UnboundedWindowFunctionFrame]] `UnboundedWindowFunctionFrame`

`UnboundedWindowFunctionFrame` is a <<WindowFunctionFrame, WindowFunctionFrame>> that gives the same value for every row in a partition.

`UnboundedWindowFunctionFrame` is <<UnboundedWindowFunctionFrame-creating-instance, created>> for spark-sql-Expression-AggregateFunction.md[AggregateFunctions] (in [AggregateExpression](../expressions/AggregateExpression.md)s) or spark-sql-Expression-AggregateWindowFunction.md[AggregateWindowFunctions] with no frame defined (i.e. no `rowsBetween` or `rangeBetween`) that boils down to using the spark-sql-SparkPlan-WindowExec.md#entire-partition-frame[entire partition frame].

[[UnboundedWindowFunctionFrame-creating-instance]]
`UnboundedWindowFunctionFrame` takes the following when created:

* [[UnboundedWindowFunctionFrame-target]] Target [InternalRow](../InternalRow.md)
* [[UnboundedWindowFunctionFrame-processor]] spark-sql-AggregateProcessor.md[AggregateProcessor]

==== [[UnboundedWindowFunctionFrame-prepare]] `prepare` Method

[source, scala]
----
prepare(rows: ExternalAppendOnlyUnsafeRowArray): Unit
----

`prepare` requests <<UnboundedWindowFunctionFrame-processor, AggregateProcessor>> to spark-sql-AggregateProcessor.md#initialize[initialize] passing in the number of `UnsafeRows` in the input `ExternalAppendOnlyUnsafeRowArray`.

`prepare` then requests `ExternalAppendOnlyUnsafeRowArray` to spark-sql-ExternalAppendOnlyUnsafeRowArray.md#generateIterator[generate an interator].

In the end, `prepare` requests <<UnboundedWindowFunctionFrame-processor, AggregateProcessor>> to spark-sql-AggregateProcessor.md#update[update] passing in every `UnsafeRow` in the iterator one at a time.

==== [[UnboundedWindowFunctionFrame-write]] `write` Method

[source, scala]
----
write(index: Int, current: InternalRow): Unit
----

`write` simply requests <<UnboundedWindowFunctionFrame-processor, AggregateProcessor>> to spark-sql-AggregateProcessor.md#evaluate[evaluate] the <<UnboundedWindowFunctionFrame-target, target InternalRow>>.

=== [[contract]] WindowFunctionFrame Contract

[source, scala]
----
package org.apache.spark.sql.execution.window

abstract class WindowFunctionFrame {
  def prepare(rows: ExternalAppendOnlyUnsafeRowArray): Unit
  def write(index: Int, current: InternalRow): Unit
}
----

NOTE: `WindowFunctionFrame` is a `private[window]` contract.

.WindowFunctionFrame Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| [[prepare]] `prepare`
| Used exclusively when `WindowExec` operator spark-sql-SparkPlan-WindowExec.md#fetchNextPartition[fetches all UnsafeRows for a partition] (passing in spark-sql-ExternalAppendOnlyUnsafeRowArray.md[ExternalAppendOnlyUnsafeRowArray] with all `UnsafeRows`).

| [[write]] `write`
| Used exclusively when the spark-sql-SparkPlan-WindowExec.md#iterator[Iterator[InternalRow\]] (from spark-sql-SparkPlan-WindowExec.md#doExecute[executing] `WindowExec`) is spark-sql-SparkPlan-WindowExec.md#next[requested a next row].
|===
