title: BasicStatsPlanVisitor

# BasicStatsPlanVisitor -- Computing Statistics for Cost-Based Optimization

`BasicStatsPlanVisitor` is a spark-sql-LogicalPlanVisitor.md[LogicalPlanVisitor] that computes the spark-sql-Statistics.md[statistics] of a logical query plan for spark-sql-cost-based-optimization.md[cost-based optimization] (i.e. when spark-sql-cost-based-optimization.md#spark.sql.cbo.enabled[cost-based optimization is enabled]).

NOTE: Cost-based optimization is enabled when spark-sql-properties.md#spark.sql.cbo.enabled[spark.sql.cbo.enabled] configuration property is on, i.e. `true`, and is disabled by default.

`BasicStatsPlanVisitor` is used exclusively when a spark-sql-LogicalPlanStats.md#stats[logical operator is requested for the statistics] with spark-sql-LogicalPlanStats.md#stats-cbo-enabled[cost-based optimization enabled].

`BasicStatsPlanVisitor` comes with custom <<handlers, handlers>> for a few logical operators and falls back to spark-sql-SizeInBytesOnlyStatsPlanVisitor.md[SizeInBytesOnlyStatsPlanVisitor] for the others.

[[handlers]]
.BasicStatsPlanVisitor's Visitor Handlers
[cols="1,1,2",options="header",width="100%"]
|===
| Logical Operator
| Handler
| Behaviour

| [[Aggregate]] spark-sql-LogicalPlan-Aggregate.md[Aggregate]
| [[visitAggregate]] spark-sql-LogicalPlanVisitor.md#visitAggregate[visitAggregate]
| Requests `AggregateEstimation` for spark-sql-AggregateEstimation.md#estimate[statistics estimates and query hints] or falls back to spark-sql-SizeInBytesOnlyStatsPlanVisitor.md[SizeInBytesOnlyStatsPlanVisitor]

| [[Filter]] `Filter`
| [[visitFilter]] spark-sql-LogicalPlanVisitor.md#visitFilter[visitFilter]
| Requests `FilterEstimation` for spark-sql-FilterEstimation.md#estimate[statistics estimates and query hints] or falls back to spark-sql-SizeInBytesOnlyStatsPlanVisitor.md[SizeInBytesOnlyStatsPlanVisitor]

| [[Join]] spark-sql-LogicalPlan-Join.md[Join]
| [[visitJoin]] spark-sql-LogicalPlanVisitor.md#visitJoin[visitJoin]
| Requests `JoinEstimation` for spark-sql-JoinEstimation.md#estimate[statistics estimates and query hints] or falls back to spark-sql-SizeInBytesOnlyStatsPlanVisitor.md[SizeInBytesOnlyStatsPlanVisitor]

| [[Project]] spark-sql-LogicalPlan-Project.md[Project]
| [[visitProject]] spark-sql-LogicalPlanVisitor.md#visitProject[visitProject]
| Requests `ProjectEstimation` for spark-sql-ProjectEstimation.md#estimate[statistics estimates and query hints] or falls back to spark-sql-SizeInBytesOnlyStatsPlanVisitor.md[SizeInBytesOnlyStatsPlanVisitor]
|===
