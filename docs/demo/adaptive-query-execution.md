---
title: Adaptive Query Execution
hide:
  - navigation
---

# Demo: Adaptive Query Execution

This demo shows [Adaptive Query Execution](../adaptive-query-execution/index.md) in action.

## Before you begin

Enable the following loggers:

* [AQEOptimizer](../adaptive-query-execution/AQEOptimizer.md#logging)
* [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md#logging)

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

```scala
println(rdd.toDebugString)
```

```text
(2) ShuffledRowRDD[14] at execute at <console>:1 []
 +-(1) MapPartitionsRDD[13] at execute at <console>:1 []
    |  MapPartitionsRDD[12] at execute at <console>:1 []
    |  MapPartitionsRDD[11] at execute at <console>:1 []
    |  MapPartitionsRDD[10] at execute at <console>:1 []
    |  FileScanRDD[9] at execute at <console>:1 []
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
   +- Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=67]
      +- *(1) ColumnarToRow
         +- FileScan parquet default.adaptive[col1#14] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/adaptive], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<col1:int>
+- == Initial Plan ==
   Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=58]
   +- FileScan parquet default.adaptive[col1#14] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/adaptive], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<col1:int>
```

```scala
q.explain()
```

```text
== Physical Plan ==
AdaptiveSparkPlan isFinalPlan=true
+- == Final Plan ==
   ShuffleQueryStage 0
   +- Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=67]
      +- *(1) ColumnarToRow
         +- FileScan parquet default.adaptive[col1#14] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/adaptive], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<col1:int>
+- == Initial Plan ==
   Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=58]
   +- FileScan parquet default.adaptive[col1#14] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/adaptive], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<col1:int>
```
