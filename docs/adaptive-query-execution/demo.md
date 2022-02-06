# Demo: Adaptive Query Execution

This demo shows [Adaptive Query Execution](index.md) in action.

## Before you begin

Enable [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md#logging) logger.

## Enable AQE

```scala
import org.apache.spark.sql.internal.SQLConf
val conf = SQLConf.get
assert(conf.adaptiveExecutionEnabled, "Adaptive Query Execution is disabled by default")
```

Enable [Adaptive Query Execution](index.md) using the [spark.sql.adaptive.enabled](../configuration-properties.md#spark.sql.adaptive.enabled) configuration property (or its type-safe [ADAPTIVE_EXECUTION_ENABLED](../SQLConf.md#ADAPTIVE_EXECUTION_ENABLED)).

```scala
conf.setConf(SQLConf.ADAPTIVE_EXECUTION_ENABLED, true)
```

## Query

```scala
val q = spark.range(6).repartition(2)
```

```scala
q.explain(extended = true)
```

```text
== Parsed Logical Plan ==
Repartition 2, true
+- Range (0, 6, step=1, splits=Some(16))

== Analyzed Logical Plan ==
id: bigint
Repartition 2, true
+- Range (0, 6, step=1, splits=Some(16))

== Optimized Logical Plan ==
Repartition 2, true
+- Range (0, 6, step=1, splits=Some(16))

== Physical Plan ==
AdaptiveSparkPlan isFinalPlan=false
+- Exchange RoundRobinPartitioning(2), REPARTITION_WITH_NUM, [id=#6]
   +- Range (0, 6, step=1, splits=16)
```

## Query Execution

```scala
q.tail(1)
```

```text
21/04/28 15:06:25 DEBUG InsertAdaptiveSparkPlan: Adaptive execution enabled for plan: CollectTail 1
+- Exchange RoundRobinPartitioning(2), REPARTITION_WITH_NUM, [id=#68]
   +- Range (0, 6, step=1, splits=16)
```

## Explain Query

```scala
q.explain(extended = true)
```

```text
== Parsed Logical Plan ==
Repartition 2, true
+- Range (0, 6, step=1, splits=Some(16))

== Analyzed Logical Plan ==
id: bigint
Repartition 2, true
+- Range (0, 6, step=1, splits=Some(16))

== Optimized Logical Plan ==
Repartition 2, true
+- Range (0, 6, step=1, splits=Some(16))

== Physical Plan ==
AdaptiveSparkPlan isFinalPlan=true
+- == Final Plan ==
   ShuffleQueryStage 0
   +- Exchange RoundRobinPartitioning(2), REPARTITION_WITH_NUM, [id=#105]
      +- *(1) Range (0, 6, step=1, splits=16)
+- == Initial Plan ==
   Exchange RoundRobinPartitioning(2), REPARTITION_WITH_NUM, [id=#6]
   +- Range (0, 6, step=1, splits=16)
```

_That's it. Congratulations!_
