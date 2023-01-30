---
title: Adaptive Query Execution
hide:
  - navigation
---

# Demo: Adaptive Query Execution

This demo shows the internals of [Adaptive Query Execution](../adaptive-query-execution/index.md).

## Before you begin

Enable the following loggers:

* [AQEOptimizer](../adaptive-query-execution/AQEOptimizer.md#logging)
* [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md#logging)
* [ShuffleQueryStageExec](../physical-operators/ShuffleQueryStageExec.md#logging)

## Query

Create a table.

```scala
sql("DROP TABLE IF EXISTS adaptive")
sql("CREATE TABLE adaptive USING parquet AS SELECT * FROM VALUES (1)")
```

Create a query with an [Exchange](../physical-operators/Exchange.md) so [Adaptive Query Execution](../adaptive-query-execution/index.md) can have a chance to step up (otherwise [spark.sql.adaptive.forceApply](../configuration-properties.md#spark.sql.adaptive.forceApply) would be required).

```scala
val q = spark.table("adaptive").repartition(2)
```

```scala
q.explain()
```

```text
== Physical Plan ==
AdaptiveSparkPlan isFinalPlan=false
+- Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=58]
   +- FileScan parquet default.adaptive[col1#14] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/adaptive], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<col1:int>
```

Note the value of the [isFinalPlan](../physical-operators/AdaptiveSparkPlanExec.md#isFinalPlan) flag that is `false`.

## Access AdaptiveSparkPlan

```scala
import org.apache.spark.sql.execution.adaptive.AdaptiveSparkPlanExec

val adaptiveExec = q.queryExecution.executedPlan.collectFirst { case op: AdaptiveSparkPlanExec => op }.get
assert(adaptiveExec.isInstanceOf[AdaptiveSparkPlanExec])
```

```text
println(adaptiveExec)
```

```text
AdaptiveSparkPlan isFinalPlan=false
+- Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=58]
   +- FileScan parquet default.adaptive[col1#14] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/adaptive], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<col1:int>
```

## Execute AdaptiveSparkPlan

Execute the query that in turn executes [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md) physical operator (and marks it as adaptively optimized using `isFinalPlan` flag).

```scala
val rdd = adaptiveExec.execute()
```

`ShuffleQueryStageExec` and `AQEOptimizer` loggers should print out the following messages to the logs:

```text
DEBUG ShuffleQueryStageExec: Materialize query stage ShuffleQueryStageExec: 0
TRACE AQEOptimizer: Fixed point reached for batch Propagate Empty Relations after 1 iterations.
TRACE AQEOptimizer: Fixed point reached for batch Dynamic Join Selection after 1 iterations.
TRACE AQEOptimizer: Fixed point reached for batch Eliminate Limits after 1 iterations.
TRACE AQEOptimizer: Fixed point reached for batch Optimize One Row Plan after 1 iterations.
```

```scala
println(rdd.toDebugString)
```

```text
(2) ShuffledRowRDD[5] at execute at <console>:1 []
 +-(2) MapPartitionsRDD[4] at execute at <console>:1 []
    |  MapPartitionsRDD[3] at execute at <console>:1 []
    |  MapPartitionsRDD[2] at execute at <console>:1 []
    |  MapPartitionsRDD[1] at execute at <console>:1 []
    |  FileScanRDD[0] at execute at <console>:1 []
```

Alternatively, you could use one of the high-level operators (e.g. `tail`).

```scala
q.tail(1)
```

## Explain Query

After execution, `AdaptiveSparkPlanExec` is [final](../physical-operators/AdaptiveSparkPlanExec.md#isFinalPlan) (and will never get [re-optimized](../physical-operators/AdaptiveSparkPlanExec.md#reOptimize)).

```scala
println(adaptiveExec)
```

```text
AdaptiveSparkPlan isFinalPlan=true
+- == Final Plan ==
   ShuffleQueryStage 0
   +- Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=15]
      +- *(1) ColumnarToRow
         +- FileScan parquet default.adaptive[id#0L] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/adaptive], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<id:bigint>
+- == Initial Plan ==
   Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=6]
   +- FileScan parquet default.adaptive[id#0L] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/adaptive], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<id:bigint>
```

Note the value of the [isFinalPlan](../physical-operators/AdaptiveSparkPlanExec.md#isFinalPlan) flag that is `true`.

```scala
q.explain()
```

```text
AdaptiveSparkPlan isFinalPlan=true
+- == Final Plan ==
   ShuffleQueryStage 0
   +- Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=15]
      +- *(1) ColumnarToRow
         +- FileScan parquet default.adaptive[id#0L] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/adaptive], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<id:bigint>
+- == Initial Plan ==
   Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=6]
   +- FileScan parquet default.adaptive[id#0L] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/adaptive], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<id:bigint>
```

## Internals

[AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md) is a leaf physical operator. That is why the following snippet gives a single physical operator in the [optimized physical query plan](../QueryExecution.md#executedPlan).

```scala
q.queryExecution.executedPlan.foreach(op => println(op.getClass.getName))
```

```text
org.apache.spark.sql.execution.adaptive.AdaptiveSparkPlanExec
```

Let's access the underlying `AdaptiveSparkPlanExec` and the [inputPlan](../physical-operators/AdaptiveSparkPlanExec.md#inputPlan) and [initialPlan](../physical-operators/AdaptiveSparkPlanExec.md#initialPlan) physical query plans.

```scala
import org.apache.spark.sql.execution.adaptive.AdaptiveSparkPlanExec

val adaptiveExec = q.queryExecution.executedPlan.collectFirst { case op: AdaptiveSparkPlanExec => op }.get
assert(adaptiveExec.isInstanceOf[AdaptiveSparkPlanExec])

val inputPlan = adaptiveExec.inputPlan
val initialPlan = adaptiveExec.initialPlan
```

Before execution, `AdaptiveSparkPlanExec` should not be [final](../physical-operators/AdaptiveSparkPlanExec.md#isFinalPlan).

```scala
println(adaptiveExec.numberedTreeString)
```

```text
00 AdaptiveSparkPlan isFinalPlan=false
01 +- Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=6]
02    +- FileScan parquet default.adaptive[id#0L] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/adaptive], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<id:bigint>
```

```scala
val rdd = adaptiveExec.execute()
```

```text
DEBUG ShuffleQueryStageExec: Materialize query stage ShuffleQueryStageExec: 0
TRACE AQEOptimizer: Fixed point reached for batch Propagate Empty Relations after 1 iterations.
TRACE AQEOptimizer: Fixed point reached for batch Dynamic Join Selection after 1 iterations.
TRACE AQEOptimizer: Fixed point reached for batch Eliminate Limits after 1 iterations.
TRACE AQEOptimizer: Fixed point reached for batch Optimize One Row Plan after 1 iterations.
```

```scala
println(rdd.toDebugString)
```

```text
(2) ShuffledRowRDD[5] at execute at <console>:1 []
 +-(2) MapPartitionsRDD[4] at execute at <console>:1 []
    |  MapPartitionsRDD[3] at execute at <console>:1 []
    |  MapPartitionsRDD[2] at execute at <console>:1 []
    |  MapPartitionsRDD[1] at execute at <console>:1 []
    |  FileScanRDD[0] at execute at <console>:1 []
```

Once executed, `AdaptiveSparkPlanExec` should be [final](../physical-operators/AdaptiveSparkPlanExec.md#isFinalPlan).

```scala
println(adaptiveExec.numberedTreeString)
```

```text
00 AdaptiveSparkPlan isFinalPlan=true
01 +- == Final Plan ==
02    ShuffleQueryStage 0
03    +- Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=15]
04       +- *(1) ColumnarToRow
05          +- FileScan parquet default.adaptive[id#0L] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/adaptive], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<id:bigint>
06 +- == Initial Plan ==
07    Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=6]
08    +- FileScan parquet default.adaptive[id#0L] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/adaptive], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<id:bigint>
```

!!! note
    There seems no way to dig deeper and access [QueryStageExec](../physical-operators/QueryStageExec.md)s though. _Feeling sad_

### Future Work

* Use `SparkListenerSQLAdaptiveExecutionUpdate` and `SparkListenerSQLAdaptiveSQLMetricUpdates` to intercept [changes in query plans](../physical-operators/AdaptiveSparkPlanExec.md#onUpdatePlan)
* Enable `ALL` for [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md#logging) logger with [spark.sql.adaptive.logLevel](../configuration-properties.md#spark.sql.adaptive.logLevel) to `TRACE`
