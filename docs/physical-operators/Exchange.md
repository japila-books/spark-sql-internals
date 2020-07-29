# Exchange -- Unary Physical Operators for Data Exchange

`Exchange` is the base of SparkPlan.md#UnaryExecNode[unary physical operators] that exchange data among multiple threads or processes.

[[output]]
When requested for the catalyst/QueryPlan.md#output[output schema], `Exchange` simply uses the child physical operator's output schema.

[[implementations]]
.Exchanges
[cols="1,2",options="header",width="100%"]
|===
| Exchange
| Description

| [[BroadcastExchangeExec]] spark-sql-SparkPlan-BroadcastExchangeExec.md[BroadcastExchangeExec]
|

| [[ShuffleExchangeExec]] spark-sql-SparkPlan-ShuffleExchangeExec.md[ShuffleExchangeExec]
|
|===
