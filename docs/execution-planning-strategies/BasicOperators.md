# BasicOperators Execution Planning Strategy

`BasicOperators` is an [execution planning strategy](SparkStrategy.md) for [basic conversions](#conversions) of [logical operators](../logical-operators/LogicalPlan.md) to their [physical representatives](../physical-operators/SparkPlan.md).

## Conversions

Logical Operator | Physical Operator
---------|---------
 [DataWritingCommand](../logical-operators/DataWritingCommand.md) | [DataWritingCommandExec](../physical-operators/DataWritingCommandExec.md)
 [RunnableCommand](../logical-operators/RunnableCommand.md) | [ExecutedCommandExec](../physical-operators/ExecutedCommandExec.md)
 MemoryPlan ([Spark Structured Streaming]({{ book.structured_streaming }}/datasources/memory/MemoryPlan/)) | [LocalTableScanExec](../physical-operators/LocalTableScanExec.md)
 [DeserializeToObject](../logical-operators/DeserializeToObject.md) | [DeserializeToObjectExec](../physical-operators/DeserializeToObjectExec.md)
 ... | ...
 [CollectMetrics](../logical-operators/CollectMetrics.md) | [CollectMetricsExec](../physical-operators/CollectMetricsExec.md)

!!! tip
    Refer to the source code of [BasicOperators]({{ spark.github }}/sql/core/src/main/scala/org/apache/spark/sql/execution/SparkStrategies.scala#L680-L800) to confirm the most up-to-date operator mapping.
