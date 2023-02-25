# BasicStatsPlanVisitor &mdash; Computing Statistics for Cost-Based Optimization

`BasicStatsPlanVisitor` is a [LogicalPlanVisitor](LogicalPlanVisitor.md) that computes the [statistics](Statistics.md) of a logical query plan for [cost-based optimization](../cost-based-optimization/index.md).

`BasicStatsPlanVisitor` is used exclusively when a [logical operator is requested for the statistics](LogicalPlanStats.md#stats) with [cost-based optimization enabled](LogicalPlanStats.md#stats-cbo-enabled).

`BasicStatsPlanVisitor` comes with custom <<handlers, handlers>> for a few logical operators and falls back to [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md) for the others.

[[handlers]]
.BasicStatsPlanVisitor's Visitor Handlers
[cols="1,1,2",options="header",width="100%"]
|===
| Logical Operator
| Handler
| Behaviour

| [[Aggregate]] Aggregate.md[Aggregate]
| [[visitAggregate]] [visitAggregate](LogicalPlanVisitor.md#visitAggregate)
| Requests `AggregateEstimation` for statistics estimates and query hints or falls back to [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md)

| [[Filter]] `Filter`
| [[visitFilter]] [visitFilter](LogicalPlanVisitor.md#visitFilter)
| Requests `FilterEstimation` for statistics estimates and query hints or falls back to [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md)

| [[Join]] Join.md[Join]
| [[visitJoin]] [visitJoin](LogicalPlanVisitor.md#visitJoin)
| Requests `JoinEstimation` for [statistics estimates and query hints](JoinEstimation.md#estimate) or falls back to [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md)

| [[Project]] Project.md[Project]
| [[visitProject]] [visitProject](LogicalPlanVisitor.md#visitProject)
| Requests `ProjectEstimation` for statistics estimates and query hints or falls back to [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md)
|===
