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

When [ResolveReferences](../logical-analysis-rules/ResolveReferences.md) logical evaluation is executed, every `MultiInstanceRelation` in a logical query plan is requested to <<newInstance, produce a new version of itself with globally unique expression ids>>.

[[implementations]]
.MultiInstanceRelations
[cols="1,2",options="header",width="100%"]
|===
| MultiInstanceRelation
| Description

| `ContinuousExecutionRelation`
| [[ContinuousExecutionRelation]] Used in Spark Structured Streaming

| DataSourceV2Relation.md[DataSourceV2Relation]
| [[DataSourceV2Relation]]

| ExternalRDD.md[ExternalRDD]
| [[ExternalRDD]]

| hive/HiveTableRelation.md[HiveTableRelation]
| [[HiveTableRelation]]

| [InMemoryRelation](../logical-operators/InMemoryRelation.md)
| [[InMemoryRelation]]

| LocalRelation.md[LocalRelation]
| [[LocalRelation]]

| LogicalRDD.md[LogicalRDD]
| [[LogicalRDD]]

| LogicalRelation.md[LogicalRelation]
| [[LogicalRelation]]

| Range.md[Range]
| [[Range]]

| View.md[View]
| [[View]]

| `StreamingExecutionRelation`
| [[StreamingExecutionRelation]] Used in Spark Structured Streaming

| `StreamingRelation`
| [[StreamingRelation]] Used in Spark Structured Streaming

| `StreamingRelationV2`
| [[StreamingRelationV2]] Used in Spark Structured Streaming
|===
