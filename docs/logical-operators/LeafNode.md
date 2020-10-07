# LeafNode &mdash; Base Logical Operator with No Child Operators and Optional Statistics

`LeafNode` is the base of <<extensions, logical operators>> that have no [child](../catalyst/TreeNode.md#children) operators.

`LeafNode` that wants to survive analysis has to define <<computeStats, computeStats>> as it throws an `UnsupportedOperationException` by default.

[[extensions]]
.LeafNodes (Direct Implementations)
[cols="1,2",options="header",width="100%"]
|===
| LeafNode
| Description

| <<spark-sql-LogicalPlan-AnalysisBarrier.md#, AnalysisBarrier>>
| [[AnalysisBarrier]]

| <<spark-sql-LogicalPlan-DataSourceV2Relation.md#, DataSourceV2Relation>>
| [[DataSourceV2Relation]]

| <<spark-sql-LogicalPlan-ExternalRDD.md#, ExternalRDD>>
| [[ExternalRDD]]

| hive/HiveTableRelation.md[HiveTableRelation]
| [[HiveTableRelation]]

| [InMemoryRelation](InMemoryRelation.md)
| [[InMemoryRelation]]

| <<spark-sql-LogicalPlan-LocalRelation.md#, LocalRelation>>
| [[LocalRelation]]

| <<spark-sql-LogicalPlan-LogicalRDD.md#, LogicalRDD>>
| [[LogicalRDD]]

| <<spark-sql-LogicalPlan-LogicalRelation.md#, LogicalRelation>>
| [[LogicalRelation]]

| <<spark-sql-LogicalPlan-OneRowRelation.md#, OneRowRelation>>
| [[OneRowRelation]]

| <<spark-sql-LogicalPlan-Range.md#, Range>>
| [[Range]]

| <<spark-sql-LogicalPlan-UnresolvedCatalogRelation.md#, UnresolvedCatalogRelation>>
| [[UnresolvedCatalogRelation]]

| <<spark-sql-LogicalPlan-UnresolvedInlineTable.md#, UnresolvedInlineTable>>
| [[UnresolvedInlineTable]]

| <<spark-sql-LogicalPlan-UnresolvedRelation.md#, UnresolvedRelation>>
| [[UnresolvedRelation]]

| <<spark-sql-LogicalPlan-UnresolvedTableValuedFunction.md#, UnresolvedTableValuedFunction>>
| [[UnresolvedTableValuedFunction]]
|===

=== [[computeStats]] Computing Statistics -- `computeStats` Method

[source, scala]
----
computeStats(): Statistics
----

`computeStats` simply throws an `UnsupportedOperationException`.

NOTE: Logical operators, e.g. spark-sql-LogicalPlan-ExternalRDD.md[ExternalRDD], spark-sql-LogicalPlan-LogicalRDD.md[LogicalRDD] and `DataSourceV2Relation`, or relations, e.g. `HadoopFsRelation` or `BaseRelation`, use spark-sql-properties.md#spark.sql.defaultSizeInBytes[spark.sql.defaultSizeInBytes] internal property for the default estimated size if the statistics could not be computed.

`computeStats` is used when `SizeInBytesOnlyStatsPlanVisitor` uses the [default case](SizeInBytesOnlyStatsPlanVisitor.md#default) to compute the size statistic (in bytes) for a spark-sql-LogicalPlan.md[logical operator].
