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

`UnboundedWindowFunctionFrame` is a [WindowFunctionFrame](#WindowFunctionFrame) that gives the same value for every row in a partition.

`UnboundedWindowFunctionFrame` is [created](#UnboundedWindowFunctionFrame-creating-instance) for [AggregateFunction](../expressions/AggregateFunction.md)s (in [AggregateExpression](../expressions/AggregateExpression.md)s) or [AggregateWindowFunction](../expressions/AggregateWindowFunction.md)s with no frame defined (i.e. no `rowsBetween` or `rangeBetween`) that boils down to using the WindowExec.md#entire-partition-frame[entire partition frame].

[[UnboundedWindowFunctionFrame-creating-instance]]
`UnboundedWindowFunctionFrame` takes the following when created:

* [[UnboundedWindowFunctionFrame-target]] Target [InternalRow](../InternalRow.md)
* [[UnboundedWindowFunctionFrame-processor]] [AggregateProcessor](AggregateProcessor.md)

==== [[UnboundedWindowFunctionFrame-prepare]] `prepare` Method

[source, scala]
----
prepare(rows: ExternalAppendOnlyUnsafeRowArray): Unit
----

`prepare` requests [AggregateProcessor](#UnboundedWindowFunctionFrame-processor) to [initialize](AggregateProcessor.md#initialize) passing in the number of `UnsafeRows` in the input `ExternalAppendOnlyUnsafeRowArray`.

`prepare` then requests `ExternalAppendOnlyUnsafeRowArray` to [generate an interator](../ExternalAppendOnlyUnsafeRowArray.md#generateIterator).

In the end, `prepare` requests [AggregateProcessor](UnboundedWindowFunctionFrame-processor) to [update](AggregateProcessor.md#update) passing in every `UnsafeRow` in the iterator one at a time.

==== [[UnboundedWindowFunctionFrame-write]] `write` Method

[source, scala]
----
write(index: Int, current: InternalRow): Unit
----

`write` simply requests <<UnboundedWindowFunctionFrame-processor, AggregateProcessor>> to AggregateProcessor.md#evaluate[evaluate] the <<UnboundedWindowFunctionFrame-target, target InternalRow>>.

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
| Used when `WindowExec` operator [fetches all UnsafeRows for a partition](WindowExec.md#fetchNextPartition) (passing in [ExternalAppendOnlyUnsafeRowArray](../ExternalAppendOnlyUnsafeRowArray.md) with all `UnsafeRows`).

| [[write]] `write`
| Used when the [Iterator[InternalRow\]](WindowExec.md#iterator) (from [executing](WindowExec.md#doExecute) `WindowExec`) is [requested a next row](WindowExec.md#next)
|===
