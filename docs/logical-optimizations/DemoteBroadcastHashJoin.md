# DemoteBroadcastHashJoin Logical Optimization

`DemoteBroadcastHashJoin` is a logical optimization rule (`Rule[LogicalPlan]`) for [Adaptive Query Execution](../new-and-noteworthy/adaptive-query-execution.md).

`DemoteBroadcastHashJoin` uses [spark.sql.adaptive.nonEmptyPartitionRatioForBroadcastJoin](../spark-sql-properties.md#spark.sql.adaptive.nonEmptyPartitionRatioForBroadcastJoin) configuration property (when requested to [shouldDemote](#shouldDemote)).

## Creating Instance

`DemoteBroadcastHashJoin` takes the following to be created:

* <span id="conf"> [SQLConf](../SQLConf.md)

`DemoteBroadcastHashJoin` is created when [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md) physical operator is requested for the [logical optimizer](../physical-operators/AdaptiveSparkPlanExec.md#optimizer).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` transforms [Join](../logical-operators/Join.md) logical operators.

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

## <span id="shouldDemote"> shouldDemote Internal Method

```scala
shouldDemote(
  plan: LogicalPlan): Boolean
```

`shouldDemote` uses [spark.sql.adaptive.nonEmptyPartitionRatioForBroadcastJoin](../spark-sql-properties.md#spark.sql.adaptive.nonEmptyPartitionRatioForBroadcastJoin) configuration property.

`shouldDemote`...FIXME

`shouldDemote` is used when `DemoteBroadcastHashJoin` optimization is [executed](#apply).
