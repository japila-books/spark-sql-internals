# HiveMetastoreCatalog -- Legacy SessionCatalog for Converting Hive Metastore Relations to Data Source Relations

`HiveMetastoreCatalog` is a ../spark-sql-SessionCatalog.md[session-scoped catalog of relational entities] that knows how to <<convertToLogicalRelation, convert Hive metastore relations to data source relations>>.

`HiveMetastoreCatalog` is used by HiveSessionCatalog.md#metastoreCatalog[HiveSessionCatalog] for RelationConversions.md[RelationConversions] logical evaluation rule.

`HiveMetastoreCatalog` is <<creating-instance, created>> when `HiveSessionStateBuilder` is requested for a HiveSessionStateBuilder.md#catalog[SessionCatalog] (and creates a HiveSessionCatalog.md#metastoreCatalog[HiveSessionCatalog]).

.HiveMetastoreCatalog, HiveSessionCatalog and HiveSessionStateBuilder
image::../images/spark-sql-HiveMetastoreCatalog.png[align="center"]

=== [[creating-instance]] Creating HiveMetastoreCatalog Instance

`HiveMetastoreCatalog` takes the following to be created:

* [[sparkSession]] ../SparkSession.md[SparkSession]

`HiveMetastoreCatalog` initializes the <<internal-properties, internal properties>>.

=== [[convertToLogicalRelation]] Converting HiveTableRelation to LogicalRelation -- `convertToLogicalRelation` Method

[source, scala]
----
convertToLogicalRelation(
  relation: HiveTableRelation,
  options: Map[String, String],
  fileFormatClass: Class[_ <: FileFormat],
  fileType: String): LogicalRelation
----

`convertToLogicalRelation` branches based on whether the input HiveTableRelation.md[HiveTableRelation] is <<convertToLogicalRelation-partitioned, partitioned>> or <<convertToLogicalRelation-not-partitioned, not>>.

[[convertToLogicalRelation-partitioned]]
When the `HiveTableRelation` is HiveTableRelation.md#isPartitioned[partitioned], `convertToLogicalRelation` uses configuration-properties.md#spark.sql.hive.manageFilesourcePartitions[spark.sql.hive.manageFilesourcePartitions] configuration property to compute the root paths. With the property enabled, the root path is simply the ../spark-sql-CatalogTable.md#location[table location] (aka _locationUri_). Otherwise, the root paths are the `locationUri` of the ../spark-sql-ExternalCatalog.md#listPartitions[partitions] (using the ../SharedState.md#externalCatalog[shared ExternalCatalog]).

`convertToLogicalRelation` creates a new ../spark-sql-LogicalPlan-LogicalRelation.md[LogicalRelation] with a ../spark-sql-BaseRelation-HadoopFsRelation.md[HadoopFsRelation] (with no bucketing specification among things) unless a `LogicalRelation` for the table is already in a <<getCached, cache>>.

[[convertToLogicalRelation-not-partitioned]]
When the `HiveTableRelation` is not partitioned, `convertToLogicalRelation`...FIXME

In the end, `convertToLogicalRelation` replaces `exprIds` in the ../spark-sql-LogicalPlan-LogicalRelation.md#output[table relation output (schema)].

NOTE: `convertToLogicalRelation` is used when RelationConversions.md[RelationConversions] logical evaluation rule is executed (with Hive tables in `parquet` as well as `native` and `hive` ORC storage formats).

=== [[inferIfNeeded]] `inferIfNeeded` Internal Method

[source, scala]
----
inferIfNeeded(
  relation: HiveTableRelation,
  options: Map[String, String],
  fileFormat: FileFormat,
  fileIndexOpt: Option[FileIndex] = None): CatalogTable
----

`inferIfNeeded`...FIXME

NOTE: `inferIfNeeded` is used when `HiveMetastoreCatalog` is requested to <<convertToLogicalRelation, convert a HiveTableRelation to a LogicalRelation over a HadoopFsRelation>>.

=== [[getCached]] `getCached` Internal Method

[source, scala]
----
getCached(
  tableIdentifier: QualifiedTableName,
  pathsInMetastore: Seq[Path],
  schemaInMetastore: StructType,
  expectedFileFormat: Class[_ <: FileFormat],
  partitionSchema: Option[StructType]): Option[LogicalRelation]
----

`getCached`...FIXME

NOTE: `getCached` is used when `HiveMetastoreCatalog` is requested to <<convertToLogicalRelation, convert a HiveTableRelation to a LogicalRelation over a HadoopFsRelation>>.

=== [[internal-properties]] Internal Properties

[cols="30m,70",options="header",width="100%"]
|===
| Name
| Description

| catalogProxy
a| [[catalogProxy]] ../spark-sql-SessionCatalog.md[SessionCatalog] (of the <<sparkSession, SparkSession>>).

Used when `HiveMetastoreCatalog` is requested to <<getCached, getCached>>, <<convertToLogicalRelation, convertToLogicalRelation>>

|===
