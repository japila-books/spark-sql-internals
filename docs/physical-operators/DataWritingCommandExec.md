# DataWritingCommandExec Physical Operator

`DataWritingCommandExec` is a <<SparkPlan.md#, physical operator>> that is the execution environment for a <<cmd, DataWritingCommand>> logical command at <<doExecute, execution time>>.

`DataWritingCommandExec` is <<creating-instance, created>> exclusively when [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is requested to plan a <<DataWritingCommand.md#, DataWritingCommand>> logical command.

[[metrics]]
When requested for <<SparkPlan.md#metrics, performance metrics>>, `DataWritingCommandExec` simply requests the <<cmd, DataWritingCommand>> for <<DataWritingCommand.md#metrics, them>>.

[[internal-registries]]
.DataWritingCommandExec's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1m,2",options="header",width="100%"]
|===
| Name
| Description

| sideEffectResult
| [[sideEffectResult]] [InternalRow](../InternalRow.md)s (`Seq[InternalRow]`) that is the result of executing the [DataWritingCommand](#cmd) (with the [SparkPlan](#child))

Used when `DataWritingCommandExec` is requested to <<executeCollect, executeCollect>>, <<executeToIterator, executeToIterator>>, <<executeTake, executeTake>> and <<doExecute, doExecute>>
|===

=== [[creating-instance]] Creating DataWritingCommandExec Instance

`DataWritingCommandExec` takes the following when created:

* [[cmd]] <<DataWritingCommand.md#, DataWritingCommand>>
* [[child]] Child <<SparkPlan.md#, physical plan>>

=== [[executeCollect]] Executing Physical Operator and Collecting Results -- `executeCollect` Method

[source, scala]
----
executeCollect(): Array[InternalRow]
----

NOTE: `executeCollect` is part of the <<SparkPlan.md#executeCollect, SparkPlan Contract>> to execute the physical operator and collect results.

`executeCollect`...FIXME

=== [[executeToIterator]] `executeToIterator` Method

[source, scala]
----
executeToIterator: Iterator[InternalRow]
----

NOTE: `executeToIterator` is part of the <<SparkPlan.md#executeToIterator, SparkPlan Contract>> to...FIXME.

`executeToIterator`...FIXME

=== [[executeTake]] Taking First N UnsafeRows -- `executeTake` Method

[source, scala]
----
executeTake(limit: Int): Array[InternalRow]
----

NOTE: `executeTake` is part of the <<SparkPlan.md#executeTake, SparkPlan Contract>> to take the first n `UnsafeRows`.

`executeTake`...FIXME

=== [[doExecute]] Executing Physical Operator (Generating RDD[InternalRow]) -- `doExecute` Method

[source, scala]
----
doExecute(): RDD[InternalRow]
----

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute` simply requests the <<SparkPlan.md#sqlContext, SQLContext>> for the <<spark-sql-SQLContext.md#sparkContext, SparkContext>> that is then requested to distribute (`parallelize`) the <<sideEffectResult, sideEffectResult>> (over 1 partition).
