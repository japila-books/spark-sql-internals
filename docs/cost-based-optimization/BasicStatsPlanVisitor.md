# BasicStatsPlanVisitor &mdash; Computing Statistics for Cost-Based Optimization

`BasicStatsPlanVisitor` is a [LogicalPlanVisitor](LogicalPlanVisitor.md) that computes the [statistics](Statistics.md) of a logical query plan in [Cost-Based Optimization](../cost-based-optimization/index.md).

`BasicStatsPlanVisitor` is used exclusively when a [logical operator is requested for the statistics](LogicalPlanStats.md#stats) with [cost-based optimization enabled](LogicalPlanStats.md#stats-cbo-enabled).

`BasicStatsPlanVisitor` comes with custom [handlers](#visitor-handlers) for a few logical operators and falls back to [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md) for the others.

## Visitor Handlers

 Logical Operator | Handler | Behaviour
------------------|---------|----------
 [Aggregate](../logical-operators/Aggregate.md) | [visitAggregate](LogicalPlanVisitor.md#visitAggregate) | Requests `AggregateEstimation` for statistics estimates and query hints or falls back to [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md)
 `Filter` | [visitFilter](LogicalPlanVisitor.md#visitFilter) | Requests `FilterEstimation` for statistics estimates and query hints or falls back to [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md)
 [Join](../logical-operators/Join.md) | [visitJoin](LogicalPlanVisitor.md#visitJoin) | Requests `JoinEstimation` for [statistics estimates and query hints](JoinEstimation.md#estimate) or falls back to [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md)
 [Project](../logical-operators/Project.md) | [visitProject](LogicalPlanVisitor.md#visitProject) | Requests `ProjectEstimation` for statistics estimates and query hints or falls back to [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md)
