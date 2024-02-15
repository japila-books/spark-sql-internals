---
title: LogicalQueryStage
---

# LogicalQueryStage Leaf Logical Operator

`LogicalQueryStage` is a [leaf logical operator](../logical-operators/LeafNode.md) for [Adaptive Query Execution](index.md).

## Creating Instance

`LogicalQueryStage` takes the following to be created:

* <span id="logicalPlan"> [Logical Plan](../logical-operators/LogicalPlan.md)
* <span id="physicalPlan"> [Physical Plan](../physical-operators/SparkPlan.md)

`LogicalQueryStage` is created when:

* [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md#replaceWithQueryStagesInLogicalPlan) physical operator is executed

## Query Optimization

`LogicalQueryStage` is a "target" of the following logical optimizations:

* [AQEPropagateEmptyRelation](../logical-optimizations/AQEPropagateEmptyRelation.md)
* [DynamicJoinSelection](../logical-optimizations/DynamicJoinSelection.md)

## Query Planning

`LogicalQueryStage` is planned by [LogicalQueryStageStrategy](../execution-planning-strategies/LogicalQueryStageStrategy.md) execution planning strategy.

## Computing Runtime Statistics { #computeStats }

??? note "LeafNode"

    ```scala
    computeStats(): Statistics
    ```

    `computeStats` is part of the [LeafNode](../logical-operators/LeafNode.md#computeStats) abstraction.

`computeStats` tries to find the first [QueryStageExec](../physical-operators/QueryStageExec.md) leaf physical operators in the [physical plan](#physicalPlan) that is then requested for the [statistics](../physical-operators/QueryStageExec.md#computeStats).

`computeStats` prints out the following DEBUG messages to the logs based on the availability of the statistics.

```text
Physical stats available as [physicalStats] for plan: [physicalPlan]
```

```text
Physical stats not available for plan: [physicalPlan]
```

In the end, `computeStats` gives the statistics of the physical operator or requests the [logical plan](#logicalPlan) for [them](../cost-based-optimization/LogicalPlanStats.md#stats).

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.adaptive.LogicalQueryStage` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
logger.LogicalQueryStage.name = org.apache.spark.sql.execution.adaptive.LogicalQueryStage
logger.LogicalQueryStage.level = all
```

Refer to [Logging](../spark-logging.md).
