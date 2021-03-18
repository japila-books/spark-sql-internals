# CatalogUtils Helper Object

`CatalogUtils` is a Scala object with the <<methods, methods>> to support [PreprocessTableCreation](logical-analysis-rules/PreprocessTableCreation.md) post-hoc logical resolution rule (among others).

[[methods]]
.CatalogUtils API
[cols="1m,2",options="header",width="100%"]
|===
| Name
| Description

| maskCredentials
a| [[maskCredentials]]

[source, scala]
----
maskCredentials(options: Map[String, String]): Map[String, String]
----

Used when:

* `CatalogStorageFormat` is requested to [convert the storage specification to a LinkedHashMap](CatalogStorageFormat.md#toLinkedHashMap)

* `CreateTempViewUsing` logical command is requested for the [argString](logical-operators/CreateTempViewUsing.md#argString)

| normalizeBucketSpec
a| [[normalizeBucketSpec]]

[source, scala]
----
normalizeBucketSpec(
  tableName: String,
  tableCols: Seq[String],
  bucketSpec: BucketSpec,
  resolver: Resolver): BucketSpec
----

Used exclusively when [PreprocessTableCreation](logical-analysis-rules/PreprocessTableCreation.md) post-hoc logical resolution rule is executed.

| normalizePartCols
a| [[normalizePartCols]]

[source, scala]
----
normalizePartCols(
  tableName: String,
  tableCols: Seq[String],
  partCols: Seq[String],
  resolver: Resolver): Seq[String]
----

Used exclusively when [PreprocessTableCreation](logical-analysis-rules/PreprocessTableCreation.md) post-hoc logical resolution rule is executed.

|===

=== [[normalizeColumnName]] `normalizeColumnName` Internal Method

[source, scala]
----
normalizeColumnName(
  tableName: String,
  tableCols: Seq[String],
  colName: String,
  colType: String,
  resolver: Resolver): String
----

`normalizeColumnName`...FIXME

NOTE: `normalizeColumnName` is used when `CatalogUtils` is requested to <<normalizePartCols, normalizePartCols>> and <<normalizeBucketSpec, normalizeBucketSpec>>.
