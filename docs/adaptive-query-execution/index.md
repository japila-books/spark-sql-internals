# Adaptive Query Execution (AQE)

**Adaptive Query Execution** (aka **Adaptive Query Optimisation**, **Adaptive Optimisation**, or **AQE** in short) is an optimisation of a [physical query execution plan](../physical-operators/SparkPlan.md) in the middle of query execution for alternative execution plans at runtime.

As of Spark 3.2 (cf. [SPARK-33679](https://issues.apache.org/jira/browse/SPARK-33679)), Adaptive Query Execution is enabled by default based on [spark.sql.adaptive.enabled](../configuration-properties.md#spark.sql.adaptive.enabled) configuration property.

Adaptive Query Execution can only be used for queries with [exchanges](../physical-operators/Exchange.md) or [sub-queries](../expressions/SubqueryExpression.md).

Adaptive Query Execution re-optimizes the query plan based on runtime statistics.

Quoting the description of a [talk](#references) by the authors of Adaptive Query Execution:

> At runtime, the adaptive execution mode can change shuffle join to broadcast join if it finds the size of one table is less than the broadcast threshold. It can also handle skewed input data for join and change the partition number of the next stage to better fit the data scale. In general, adaptive execution decreases the effort involved in tuning SQL query parameters and improves the execution performance by choosing a better execution plan and parallelism at runtime.

## InsertAdaptiveSparkPlan Physical Optimization

Adaptive Query Execution is applied to a physical query plan using the [InsertAdaptiveSparkPlan](InsertAdaptiveSparkPlan.md) physical optimization.

## AdaptiveSparkPlanExec Physical Operator

Adaptive Query Execution is based on [AdaptiveSparkPlanExec](AdaptiveSparkPlanExec.md) physical operator (and the [adaptive optimizations](AdaptiveSparkPlanExec.md#queryStageOptimizerRules)).

## SparkListenerSQLAdaptiveExecutionUpdates

Adaptive Query Execution notifies Spark listeners about a physical plan change using `SparkListenerSQLAdaptiveExecutionUpdate` and `SparkListenerSQLAdaptiveSQLMetricUpdates` events.

## Logging

Adaptive Query Execution uses [logOnLevel](AdaptiveSparkPlanExec.md#logOnLevel) to print out diagnostic messages to the log.

## Unsupported

### CacheManager

Adaptive Query Execution can change number of shuffle partitions and [CacheManager](../CacheManager.md#forceDisableConfigs) makes sure that this configuration is disabled (for to [cacheQuery](../CacheManager.md#cacheQuery) and [recacheByCondition](../CacheManager.md#recacheByCondition))

### Structured Streaming

Adaptive Query Execution can change number of shuffle partitions and so is not supported for streaming queries ([Spark Structured Streaming]({{ book.structured_streaming }})).

## References

### Videos

* [An Adaptive Execution Engine For Apache Spark SQL &mdash; Carson Wang](https://youtu.be/FZgojLWdjaw)
