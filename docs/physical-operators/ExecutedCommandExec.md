title: ExecutedCommandExec

# ExecutedCommandExec Leaf Physical Operator for Command Execution

`ExecutedCommandExec` is a SparkPlan.md#LeafExecNode[leaf physical operator] for executing spark-sql-LogicalPlan-RunnableCommand.md[logical commands with side effects].

`ExecutedCommandExec` runs a command and caches the result in <<sideEffectResult, sideEffectResult>> internal attribute.

[[methods]]
.ExecutedCommandExec's Methods
[width="100%",cols="1,2",options="header"]
|===
| Method
| Description

| [[doExecute]] `doExecute`
| Executes `ExecutedCommandExec` physical operator (and produces a result as an RDD of spark-sql-InternalRow.md[internal binary rows]

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

`sideEffectResult` requests `RunnableCommand` to spark-sql-LogicalPlan-RunnableCommand.md#run[run] (that produces a `Seq[Row]`) and spark-sql-CatalystTypeConverters.md#createToCatalystConverter[converts the result to Catalyst types] using a Catalyst converter function for the catalyst/QueryPlan.md#schema[schema].

NOTE: `sideEffectResult` is used when `ExecutedCommandExec` is requested for <<executeCollect, executeCollect>>, <<executeToIterator, executeToIterator>>, <<executeTake, executeTake>>, <<doExecute, doExecute>>.
