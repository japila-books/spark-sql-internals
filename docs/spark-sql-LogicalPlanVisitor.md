title: LogicalPlanVisitor

# LogicalPlanVisitor -- Contract for Computing Statistic Estimates and Query Hints of Logical Plan

`LogicalPlanVisitor` is the <<contract, contract>> that uses the <<visit, visitor design pattern>> to scan a logical query plan and compute [estimates of plan statistics and query hints](logical-operators/Statistics.md).

TIP: Read about the *visitor design pattern* in https://en.wikipedia.org/wiki/Visitor_pattern[Wikipedia].

[[visit]]
`LogicalPlanVisitor` defines `visit` method that dispatches computing the statistics of a logical plan to the <<handlers, corresponding handler methods>>.

[source, scala]
----
visit(p: LogicalPlan): T
----

NOTE: `T` stands for the type of a result to be computed (while visiting the query plan tree) and is currently always [Statistics](logical-operators/Statistics.md) only.

The <<implementations, concrete>> `LogicalPlanVisitor` is chosen per spark-sql-cost-based-optimization.md#spark.sql.cbo.enabled[spark.sql.cbo.enabled] configuration property. When turned on (i.e. `true`), `LogicalPlanStats` [uses](logical-operators/LogicalPlanStats.md#stats) <<BasicStatsPlanVisitor, BasicStatsPlanVisitor>> while <<SizeInBytesOnlyStatsPlanVisitor, SizeInBytesOnlyStatsPlanVisitor>> otherwise.

NOTE: spark-sql-properties.md#spark.sql.cbo.enabled[spark.sql.cbo.enabled] configuration property is off, i.e. `false` by default.

[[implementations]]
.LogicalPlanVisitors
[cols="1,2",options="header",width="100%"]
|===
| LogicalPlanVisitor
| Description

| [[BasicStatsPlanVisitor]] spark-sql-BasicStatsPlanVisitor.md[BasicStatsPlanVisitor]
|

| [[SizeInBytesOnlyStatsPlanVisitor]] spark-sql-SizeInBytesOnlyStatsPlanVisitor.md[SizeInBytesOnlyStatsPlanVisitor]
|
|===

[[contract]]
[[handlers]]
.LogicalPlanVisitor's Logical Operators and Their Handlers
[cols="1,2",options="header",width="100%"]
|===
| Logical Operator
| Handler

| [[Aggregate]] spark-sql-LogicalPlan-Aggregate.md[Aggregate]
| [[visitAggregate]] `visitAggregate`

| [[Distinct]] `Distinct`
| `visitDistinct`

| [[Except]] `Except`
| `visitExcept`

| [[Expand]] spark-sql-LogicalPlan-Expand.md[Expand]
| `visitExpand`

| [[Filter]] `Filter`
| [[visitFilter]] `visitFilter`

| [[Generate]] spark-sql-LogicalPlan-Generate.md[Generate]
| `visitGenerate`

| [[GlobalLimit]] [GlobalLimit](logical-operators/GlobalLimit.md)
| `visitGlobalLimit`

| [[Intersect]] `Intersect`
| [[visitIntersect]] `visitIntersect`

| [[Join]] spark-sql-LogicalPlan-Join.md[Join]
| [[visitJoin]] `visitJoin`

| [[LocalLimit]] `LocalLimit`
| `visitLocalLimit`

| [[Pivot]] spark-sql-LogicalPlan-Pivot.md[Pivot]
| `visitPivot`

| [[Project]] spark-sql-LogicalPlan-Project.md[Project]
| [[visitProject]] `visitProject`

| [[Repartition]] [Repartition](logical-operators/RepartitionOperation.md#Repartition)
| `visitRepartition`

| [[RepartitionByExpression]] [RepartitionByExpression](logical-operators/RepartitionOperation.md#RepartitionByExpression)
| `visitRepartitionByExpr`

| [[ResolvedHint]] spark-sql-LogicalPlan-ResolvedHint.md[ResolvedHint]
| `visitHint`

| [[Sample]] `Sample`
| `visitSample`

| [[ScriptTransformation]] `ScriptTransformation`
| `visitScriptTransform`

| [[Union]] `Union`
| `visitUnion`

| [[Window]] spark-sql-LogicalPlan-Window.md[Window]
| `visitWindow`

| [[LogicalPlan]] Other spark-sql-LogicalPlan.md[logical operators]
| `default`
|===
