# ExecutedCommandExec Leaf Physical Operator

`ExecutedCommandExec` is a [leaf physical operator](LeafExecNode.md) for executing [logical commands with side effects](../logical-operators/RunnableCommand.md).

`ExecutedCommandExec` runs a command and caches the result in <<sideEffectResult, sideEffectResult>> internal attribute.

[[methods]]
.ExecutedCommandExec's Methods
[width="100%",cols="1,2",options="header"]
|===
| Method
| Description

| [[doExecute]] `doExecute`
| Executes `ExecutedCommandExec` physical operator (and produces a result as an RDD of [InternalRow](../InternalRow.md)s

| [[executeCollect]] `executeCollect`
|

| [[executeTake]] `executeTake`
|

| [[executeToIterator]] `executeToIterator`
|
|===

=== [[sideEffectResult]] Executing Logical RunnableCommand and Caching Result As InternalRows -- `sideEffectResult` Internal Lazy Attribute

[source, scala]
----
sideEffectResult: Seq[InternalRow]
----

`sideEffectResult` requests `RunnableCommand` to RunnableCommand.md#run[run] (that produces a `Seq[Row]`) and [converts the result to Catalyst types](../CatalystTypeConverters.md#createToCatalystConverter) using a Catalyst converter function for the [schema](../catalyst/QueryPlan.md#schema).

`sideEffectResult` is used when `ExecutedCommandExec` is requested to [executeCollect](#executeCollect), [executeToIterator](#executeToIterator), [executeTake](#executeTake), [doExecute](#doExecute).
