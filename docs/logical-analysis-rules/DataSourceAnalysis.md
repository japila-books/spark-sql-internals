# DataSourceAnalysis PostHoc Logical Resolution Rule

`DataSourceAnalysis` is a [post-hoc logical resolution rule](../Analyzer.md#postHocResolutionRules) that the [default](../BaseSessionStateBuilder.md#analyzer) and [Hive-specific](../hive/HiveSessionStateBuilder.md#analyzer) logical query plan analyzers use to <<apply, FIXME>>.

[[resolutions]]
.DataSourceAnalysis's Logical Resolutions (Conversions)
[cols="1,1,2",options="header",width="100%"]
|===
| Source Operator
| Target Operator
| Description

| <<CreateTable.md#, CreateTable>> [small]#(isDatasourceTable + no query)#
| <<CreateDataSourceTableCommand.md#, CreateDataSourceTableCommand>>
| [[CreateTable-no-query]]

| <<CreateTable.md#, CreateTable>> [small]#(isDatasourceTable + a resolved query)#
| <<CreateDataSourceTableAsSelectCommand.md#, CreateDataSourceTableAsSelectCommand>>
| [[CreateTable-query]]

| <<InsertIntoTable.md#, InsertIntoTable>> with [InsertableRelation](../InsertableRelation.md)
| <<InsertIntoDataSourceCommand.md#, InsertIntoDataSourceCommand>>
| [[InsertIntoTable-InsertableRelation]]

| InsertIntoDir.md[InsertIntoDir] [small]#(non-hive provider)#
| <<InsertIntoDataSourceDirCommand.md#, InsertIntoDataSourceDirCommand>>
| [[InsertIntoDir]]

| [InsertIntoTable](../logical-operators/InsertIntoTable.md) with [HadoopFsRelation](../HadoopFsRelation.md)
| [InsertIntoHadoopFsRelationCommand](../logical-operators/InsertIntoHadoopFsRelationCommand.md)
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

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
