# LogicalQueryStage Leaf Logical Operator

`LogicalQueryStage` is a [leaf logical operator](../logical-operators/LeafNode.md) for [Adaptive Query Execution](../adaptive-query-execution/index.md).

## Query Optimization

`LogicalQueryStage` is a "target" of FIXME logical optimization.

## Query Planning

`LogicalQueryStage` is planned by [LogicalQueryStageStrategy](../execution-planning-strategies/LogicalQueryStageStrategy.md) execution planning strategy.

## Creating Instance

`LogicalQueryStage` takes the following to be created:

* <span id="logicalPlan"> [Logical Plan](../logical-operators/LogicalPlan.md)
* <span id="physicalPlan"> [Physical Plan](../physical-operators/SparkPlan.md)

`LogicalQueryStage` is created when [AdaptiveSparkPlanExec](../adaptive-query-execution/AdaptiveSparkPlanExec.md) physical operator is executed.

## <span id="computeStats"> Computing Statistics

```scala
computeStats(): Statistics
```

`computeStats` tries to find the first [QueryStageExec](../adaptive-query-execution/QueryStageExec.md) leaf physical operators in the [physical plan](#physicalPlan) that is then requested for the [statistics](../adaptive-query-execution/QueryStageExec.md#computeStats).

`computeStats` prints out the following DEBUG messages to the logs based on the availability of the statistics.

```text
Physical stats available as [physicalStats] for plan: [physicalPlan]
```

```text
Physical stats not available for plan: [physicalPlan]
```

In the end, `computeStats` gives the statistics of the physical operator or requests the [logical plan](#logicalPlan) for [them](../logical-operators/LogicalPlanStats.md#stats).

`computeStats` is part of the [LeafNode](../logical-operators/LeafNode.md#computeStats) abstraction.
