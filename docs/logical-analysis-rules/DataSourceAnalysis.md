# DataSourceAnalysis PostHoc Logical Resolution Rule

`DataSourceAnalysis` is a [post-hoc logical resolution rule](../Analyzer.md#postHocResolutionRules) that the [default](../BaseSessionStateBuilder.md#analyzer) and [Hive-specific](../hive/HiveSessionStateBuilder.md#analyzer) logical query plan analyzers use to <<apply, FIXME>>.

[[resolutions]]
.DataSourceAnalysis's Logical Resolutions (Conversions)
[cols="1,1,2",options="header",width="100%"]
|===
| Source Operator
| Target Operator
| Description

| <<spark-sql-LogicalPlan-CreateTable.md#, CreateTable>> [small]#(isDatasourceTable + no query)#
| <<spark-sql-LogicalPlan-CreateDataSourceTableCommand.md#, CreateDataSourceTableCommand>>
| [[CreateTable-no-query]]

| <<spark-sql-LogicalPlan-CreateTable.md#, CreateTable>> [small]#(isDatasourceTable + a resolved query)#
| <<spark-sql-LogicalPlan-CreateDataSourceTableAsSelectCommand.md#, CreateDataSourceTableAsSelectCommand>>
| [[CreateTable-query]]

| <<InsertIntoTable.md#, InsertIntoTable>> with <<spark-sql-InsertableRelation.md#, InsertableRelation>>
| <<spark-sql-LogicalPlan-InsertIntoDataSourceCommand.md#, InsertIntoDataSourceCommand>>
| [[InsertIntoTable-InsertableRelation]]

| InsertIntoDir.md[InsertIntoDir] [small]#(non-hive provider)#
| <<spark-sql-LogicalPlan-InsertIntoDataSourceDirCommand.md#, InsertIntoDataSourceDirCommand>>
| [[InsertIntoDir]]

| <<InsertIntoTable.md#, InsertIntoTable>> with <<spark-sql-BaseRelation-HadoopFsRelation.md#, HadoopFsRelation>>
| <<spark-sql-LogicalPlan-InsertIntoHadoopFsRelationCommand.md#, InsertIntoHadoopFsRelationCommand>>
| [[InsertIntoTable-HadoopFsRelation]]
|===

Technically, `DataSourceAnalysis` is a catalyst/Rule.md[Catalyst rule] for transforming spark-sql-LogicalPlan.md[logical plans], i.e. `Rule[LogicalPlan]`.

[source, scala]
----
// FIXME Example of DataSourceAnalysis
import org.apache.spark.sql.execution.datasources.DataSourceAnalysis
val rule = DataSourceAnalysis(spark.sessionState.conf)

val plan = FIXME

rule(plan)
----

=== [[apply]] Executing Rule

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply`...FIXME

`apply` is part of the [Rule](catalyst/Rule.md#apply) abstraction.
