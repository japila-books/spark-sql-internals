# MultiInstanceRelation

`MultiInstanceRelation` is a <<contact, contact>> of spark-sql-LogicalPlan.md[logical operators] which a <<newInstance, single instance>> might appear multiple times in a logical query plan.

[[newInstance]]
[[contract]]
[source, scala]
----
package org.apache.spark.sql.catalyst.analysis

trait MultiInstanceRelation {
  def newInstance(): LogicalPlan
}
----

When `ResolveReferences` logical evaluation is spark-sql-Analyzer-ResolveReferences.md#apply[executed], every `MultiInstanceRelation` in a logical query plan is requested to <<newInstance, produce a new version of itself with globally unique expression ids>>.

[[implementations]]
.MultiInstanceRelations
[cols="1,2",options="header",width="100%"]
|===
| MultiInstanceRelation
| Description

| `ContinuousExecutionRelation`
| [[ContinuousExecutionRelation]] Used in Spark Structured Streaming

| spark-sql-LogicalPlan-DataSourceV2Relation.md[DataSourceV2Relation]
| [[DataSourceV2Relation]]

| spark-sql-LogicalPlan-ExternalRDD.md[ExternalRDD]
| [[ExternalRDD]]

| hive/HiveTableRelation.md[HiveTableRelation]
| [[HiveTableRelation]]

| spark-sql-LogicalPlan-InMemoryRelation.md[InMemoryRelation]
| [[InMemoryRelation]]

| spark-sql-LogicalPlan-LocalRelation.md[LocalRelation]
| [[LocalRelation]]

| spark-sql-LogicalPlan-LogicalRDD.md[LogicalRDD]
| [[LogicalRDD]]

| spark-sql-LogicalPlan-LogicalRelation.md[LogicalRelation]
| [[LogicalRelation]]

| spark-sql-LogicalPlan-Range.md[Range]
| [[Range]]

| spark-sql-LogicalPlan-View.md[View]
| [[View]]

| `StreamingExecutionRelation`
| [[StreamingExecutionRelation]] Used in Spark Structured Streaming

| `StreamingRelation`
| [[StreamingRelation]] Used in Spark Structured Streaming

| `StreamingRelationV2`
| [[StreamingRelationV2]] Used in Spark Structured Streaming
|===
