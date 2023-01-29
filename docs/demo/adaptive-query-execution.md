---
title: Adaptive Query Execution
hide:
  - navigation
---

# Demo: Adaptive Query Execution

This demo shows [Adaptive Query Execution](../adaptive-query-execution/index.md) in action.

## Before you begin

Enable [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md#logging) logger.

## Query

```scala
val q = spark.range(6).repartition(2)
```

```scala
q.explain()
```

```text
== Physical Plan ==
AdaptiveSparkPlan isFinalPlan=false
+- Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=6]
   +- Range (0, 6, step=1, splits=16)
```

## Access AdaptiveSparkPlan

```scala
import org.apache.spark.sql.execution.adaptive.AdaptiveSparkPlanExec

val adaptiveExec = q.queryExecution.executedPlan.collectFirst { case op: AdaptiveSparkPlanExec => op }.get
assert(adaptiveExec.isInstanceOf[AdaptiveSparkPlanExec])
```

```text
scala> println(adaptiveExec)
AdaptiveSparkPlan isFinalPlan=false
+- Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=22]
   +- Range (0, 6, step=1, splits=16)
```

## Execute AdaptiveSparkPlan

```scala
adaptiveExec.execute()
```

Alternatively, you could use one of the high-level operators (e.g. `tail`).

```scala
q.tail(1)
```

## Explain Query

After execution, `AdaptiveSparkPlanExec` is [final](../physical-operators/AdaptiveSparkPlanExec.md#isFinalPlan) (and will never [re-optimize](../physical-operators/AdaptiveSparkPlanExec.md#reOptimize)).

```text
scala> println(adaptiveExec)
AdaptiveSparkPlan isFinalPlan=true
+- == Final Plan ==
   ShuffleQueryStage 0
   +- Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=27]
      +- *(1) Range (0, 6, step=1, splits=16)
+- == Initial Plan ==
   Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=22]
   +- Range (0, 6, step=1, splits=16)
```

```scala
q.explain()
```

```text
scala> q.explain()
== Physical Plan ==
AdaptiveSparkPlan isFinalPlan=true
+- == Final Plan ==
   ShuffleQueryStage 0
   +- Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=27]
      +- *(1) Range (0, 6, step=1, splits=16)
+- == Initial Plan ==
   Exchange RoundRobinPartitioning(2), REPARTITION_BY_NUM, [plan_id=22]
   +- Range (0, 6, step=1, splits=16)
```
