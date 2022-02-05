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

* [AQEPropagateEmptyRelation](AQEPropagateEmptyRelation.md)
* [DynamicJoinSelection](DynamicJoinSelection.md)

## Query Planning

`LogicalQueryStage` is planned by [LogicalQueryStageStrategy](../execution-planning-strategies/LogicalQueryStageStrategy.md) execution planning strategy.

## <span id="computeStats"> Statistics

```scala
computeStats(): Statistics
```

`computeStats` tries to find the first [QueryStageExec](QueryStageExec.md) leaf physical operators in the [physical plan](#physicalPlan) that is then requested for the [statistics](QueryStageExec.md#computeStats).

`computeStats` prints out the following DEBUG messages to the logs based on the availability of the statistics.

```text
Physical stats available as [physicalStats] for plan: [physicalPlan]
```

```text
Physical stats not available for plan: [physicalPlan]
```

In the end, `computeStats` gives the statistics of the physical operator or requests the [logical plan](#logicalPlan) for [them](../logical-operators/LogicalPlanStats.md#stats).

`computeStats` is part of the [LeafNode](../logical-operators/LeafNode.md#computeStats) abstraction.

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.adaptive.LogicalQueryStage` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.adaptive.LogicalQueryStage=ALL
```

Refer to [Logging](../spark-logging.md).
