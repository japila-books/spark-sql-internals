# Command &mdash; Eagerly-Executed Logical Operator

`Command` is the *marker interface* for spark-sql-LogicalPlan.md[logical operators] that represent non-query commands that are executed early in the [query plan lifecycle](../QueryExecution.md#query-plan-lifecycle) (unlike logical plans in general).

NOTE: `Command` is executed when a `Dataset` is requested for the spark-sql-Dataset.md#logicalPlan[logical plan] (which is after the query has been [analyzed](../QueryExecution.md#analyzed)).

[[output]]
`Command` has no catalyst/QueryPlan.md#output[output schema] by default.

[[children]]
`Command` has no child logical operators (which makes it similar to spark-sql-LogicalPlan-LeafNode.md[leaf logical operators]).

[[implementations]]
.Commands (Direct Implementations)
[cols="30m,70",options="header",width="100%"]
|===
| Command
| Description

| spark-sql-LogicalPlan-DataWritingCommand.md[DataWritingCommand]
| [[DataWritingCommand]]

| spark-sql-LogicalPlan-RunnableCommand.md[RunnableCommand]
| [[RunnableCommand]]

|===
