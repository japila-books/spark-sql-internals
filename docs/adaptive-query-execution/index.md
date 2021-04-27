# Adaptive Query Execution (AQE)

**Adaptive Query Execution** (aka **Adaptive Query Optimisation**, **Adaptive Optimisation**, or **AQE** in short) is an optimisation of a [physical query execution plan](../physical-operators/SparkPlan.md) in the middle of query execution for alternative execution plans at runtime.

Adaptive Query Execution can only be used for queries with [exchanges](../physical-operators/Exchange.md) or [sub-queries](../expressions/SubqueryExpression.md).

Adaptive Query Execution re-optimizes the query plan based on runtime statistics.

Quoting the description of a [talk](#references) by the authors of Adaptive Query Execution:

> At runtime, the adaptive execution mode can change shuffle join to broadcast join if it finds the size of one table is less than the broadcast threshold. It can also handle skewed input data for join and change the partition number of the next stage to better fit the data scale. In general, adaptive execution decreases the effort involved in tuning SQL query parameters and improves the execution performance by choosing a better execution plan and parallelism at runtime.

Adaptive Query Execution is disabled by default and can be enabled using [spark.sql.adaptive.enabled](../configuration-properties.md#spark.sql.adaptive.enabled) configuration property.

Adaptive Query Execution is based on [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md) physical operator (and the [adaptive optimizations](../physical-operators/AdaptiveSparkPlanExec.md#queryStageOptimizerRules)).

!!! note
    Adaptive Query Execution is disabled for `CacheManager` to [cacheQuery](../CacheManager.md#cacheQuery) and [recacheByCondition](../CacheManager.md#recacheByCondition)

!!! important "Structured Streaming Not Supported"
    Adaptive Query Execution is not supported for streaming queries.

## SparkListenerSQLAdaptiveExecutionUpdates

Adaptive Query Execution notifies Spark listeners about a physical plan change using `SparkListenerSQLAdaptiveExecutionUpdate` and `SparkListenerSQLAdaptiveSQLMetricUpdates` events.

## Logging

Adaptive Query Execution uses [logOnLevel](../physical-operators/AdaptiveSparkPlanExec.md#logOnLevel) to print out diagnostic messages to the log.

## References

### Articles

* [An adaptive execution mode for Spark SQL](https://conferences.oreilly.com/strata/strata-sg/public/schedule/detail/62938) by Carson Wang (Intel), Yucai Yu (Intel) at Strata Data Conference in Singapore, December 7, 2017

### Videos

* [An Adaptive Execution Engine For Apache Spark SQL &mdash; Carson Wang](https://youtu.be/FZgojLWdjaw)
