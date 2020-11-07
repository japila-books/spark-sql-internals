# LeafNode &mdash; Base Logical Operator with No Child Operators and Optional Statistics

`LeafNode` is the base of <<extensions, logical operators>> that have no [child](../catalyst/TreeNode.md#children) operators.

`LeafNode` that wants to survive analysis has to define <<computeStats, computeStats>> as it throws an `UnsupportedOperationException` by default.

[[extensions]]
.LeafNodes (Direct Implementations)
[cols="1,2",options="header",width="100%"]
|===
| LeafNode
| Description

| <<AnalysisBarrier.md#, AnalysisBarrier>>
| [[AnalysisBarrier]]

| <<DataSourceV2Relation.md#, DataSourceV2Relation>>
| [[DataSourceV2Relation]]

| <<ExternalRDD.md#, ExternalRDD>>
| [[ExternalRDD]]

| hive/HiveTableRelation.md[HiveTableRelation]
| [[HiveTableRelation]]

| [InMemoryRelation](InMemoryRelation.md)
| [[InMemoryRelation]]

| <<LocalRelation.md#, LocalRelation>>
| [[LocalRelation]]

| <<LogicalRDD.md#, LogicalRDD>>
| [[LogicalRDD]]

| <<LogicalRelation.md#, LogicalRelation>>
| [[LogicalRelation]]

| <<OneRowRelation.md#, OneRowRelation>>
| [[OneRowRelation]]

| <<Range.md#, Range>>
| [[Range]]

| <<UnresolvedCatalogRelation.md#, UnresolvedCatalogRelation>>
| [[UnresolvedCatalogRelation]]

| <<UnresolvedInlineTable.md#, UnresolvedInlineTable>>
| [[UnresolvedInlineTable]]

| <<UnresolvedRelation.md#, UnresolvedRelation>>
| [[UnresolvedRelation]]

| <<UnresolvedTableValuedFunction.md#, UnresolvedTableValuedFunction>>
| [[UnresolvedTableValuedFunction]]
|===

=== [[computeStats]] Computing Statistics -- `computeStats` Method

[source, scala]
----
computeStats(): Statistics
----

`computeStats` simply throws an `UnsupportedOperationException`.

!!! note
    Logical operators (e.g. [ExternalRDD](ExternalRDD.md), [LogicalRDD](LogicalRDD.md) and [DataSourceV2Relation](DataSourceV2Relation.md)), or relations (e.g. `HadoopFsRelation` or `BaseRelation`), use [spark.sql.defaultSizeInBytes](../configuration-properties.md#spark.sql.defaultSizeInBytes) internal property for the default estimated size if the statistics could not be computed.

`computeStats` is used when `SizeInBytesOnlyStatsPlanVisitor` uses the [default case](SizeInBytesOnlyStatsPlanVisitor.md#default) to compute the size statistic (in bytes) for a [logical operator](LogicalPlan.md).
