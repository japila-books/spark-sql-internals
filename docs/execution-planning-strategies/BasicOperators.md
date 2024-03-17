---
title: BasicOperators
---

# BasicOperators Execution Planning Strategy

`BasicOperators` is an [execution planning strategy](SparkStrategy.md) for [basic conversions](#conversions) of [logical operators](../logical-operators/LogicalPlan.md) to their [physical counterparts](../physical-operators/SparkPlan.md).

## Conversions

Logical Operator | Physical Operator
---------|---------
 [CollectMetrics](../logical-operators/CollectMetrics.md) | [CollectMetricsExec](../physical-operators/CollectMetricsExec.md)
 [DataWritingCommand](../logical-operators/DataWritingCommand.md) | [DataWritingCommandExec](../physical-operators/DataWritingCommandExec.md)
 [DeserializeToObject](../logical-operators/DeserializeToObject.md) | [DeserializeToObjectExec](../physical-operators/DeserializeToObjectExec.md)
 [Expand](../logical-operators/Expand.md) | [ExpandExec](../physical-operators/ExpandExec.md)
 [ExternalRDD](../logical-operators/ExternalRDD.md) | [ExternalRDDScanExec](../physical-operators/ExternalRDDScanExec.md)
 [FlatMapGroupsWithState](../logical-operators/FlatMapGroupsWithState.md) | `CoGroupExec` or `MapGroupsExec`
 ... | ...
 [Generate](../logical-operators/Generate.md) | [GenerateExec](../physical-operators/GenerateExec.md)
 [LogicalRDD](../logical-operators/LogicalRDD.md) | `RDDScanExec`
 MemoryPlan ([Spark Structured Streaming]({{ book.structured_streaming }}/datasources/memory/MemoryPlan/)) | [LocalTableScanExec](../physical-operators/LocalTableScanExec.md)
 `Range` | [RangeExec](../physical-operators/RangeExec.md)
 [RebalancePartitions](../logical-operators/RebalancePartitions.md) | [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md)
 [Repartition](../logical-operators/Repartition.md) | [CoalesceExec](../physical-operators/CoalesceExec.md) or [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) based on [shuffle](../logical-operators/Repartition.md#shuffle) flag
 [RepartitionByExpression](../logical-operators/RepartitionByExpression.md) | [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md)
 [RunnableCommand](../logical-operators/RunnableCommand.md) | [ExecutedCommandExec](../physical-operators/ExecutedCommandExec.md)
 [WriteFiles](../logical-operators/WriteFiles.md) | [WriteFilesExec](../physical-operators/WriteFilesExec.md)

!!! tip
    Refer to the source code of [BasicOperators]({{ spark.github }}/sql/core/src/main/scala/org/apache/spark/sql/execution/SparkStrategies.scala#L775-L943) to confirm the most up-to-date operator mapping.
