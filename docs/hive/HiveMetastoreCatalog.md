# HiveMetastoreCatalog &mdash; Legacy SessionCatalog for Converting Hive Metastore Relations to Data Source Relations

`HiveMetastoreCatalog` is a [session-scoped catalog of relational entities](../SessionCatalog.md) that knows how to <<convertToLogicalRelation, convert Hive metastore relations to data source relations>>.

`HiveMetastoreCatalog` is used by [HiveSessionCatalog](HiveSessionCatalog.md#metastoreCatalog) for [RelationConversions](RelationConversions.md) logical evaluation rule.

`HiveMetastoreCatalog` is <<creating-instance, created>> when `HiveSessionStateBuilder` is requested for a HiveSessionStateBuilder.md#catalog[SessionCatalog] (and creates a [HiveSessionCatalog](HiveSessionCatalog.md#metastoreCatalog)).

![HiveMetastoreCatalog, HiveSessionCatalog and HiveSessionStateBuilder](../images/spark-sql-HiveMetastoreCatalog.png)

## Creating Instance

`HiveMetastoreCatalog` takes the following to be created:

* [[sparkSession]] [SparkSession](../SparkSession.md)

## <span id="convert"> Converting HiveTableRelation to LogicalRelation

```scala
convert(
  relation: HiveTableRelation): LogicalRelation
```

`convert`...FIXME

`convert` is used when:

* [RelationConversions](RelationConversions.md) logical rule is executed (for a `InsertIntoStatement` over a [HiveTableRelation](HiveTableRelation.md) or a [HiveTableRelation](HiveTableRelation.md))
* `OptimizedCreateHiveTableAsSelectCommand` logical command is executed

### <span id="convertToLogicalRelation"> convertToLogicalRelation

```scala
convertToLogicalRelation(
  relation: HiveTableRelation,
  options: Map[String, String],
  fileFormatClass: Class[_ <: FileFormat],
  fileType: String): LogicalRelation
```

`convertToLogicalRelation` branches based on whether the input HiveTableRelation.md[HiveTableRelation] is <<convertToLogicalRelation-partitioned, partitioned>> or <<convertToLogicalRelation-not-partitioned, not>>.

[[convertToLogicalRelation-partitioned]]
When the `HiveTableRelation` is HiveTableRelation.md#isPartitioned[partitioned], `convertToLogicalRelation` uses [spark.sql.hive.manageFilesourcePartitions](configuration-properties.md#spark.sql.hive.manageFilesourcePartitions) configuration property to compute the root paths. With the property enabled, the root path is simply the [table location](../CatalogTable.md#location) (aka _locationUri_). Otherwise, the root paths are the `locationUri` of the [partitions](../ExternalCatalog.md#listPartitions) (using the [shared ExternalCatalog](../SharedState.md#externalCatalog)).

`convertToLogicalRelation` creates a new ../LogicalRelation.md[LogicalRelation] with a [HadoopFsRelation](../files/HadoopFsRelation.md) (with no bucketing specification among things) unless a `LogicalRelation` for the table is already in a <<getCached, cache>>.

[[convertToLogicalRelation-not-partitioned]]
When the `HiveTableRelation` is not partitioned, `convertToLogicalRelation`...FIXME

In the end, `convertToLogicalRelation` replaces `exprIds` in the ../LogicalRelation.md#output[table relation output (schema)].

NOTE: `convertToLogicalRelation` is used when RelationConversions.md[RelationConversions] logical evaluation rule is executed (with Hive tables in `parquet` as well as `native` and `hive` ORC storage formats).

### <span id="inferIfNeeded"> inferIfNeeded

```scala
inferIfNeeded(
  relation: HiveTableRelation,
  options: Map[String, String],
  fileFormat: FileFormat,
  fileIndexOpt: Option[FileIndex] = None): CatalogTable
```

`inferIfNeeded`...FIXME

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
a| [[catalogProxy]] [SessionCatalog](../SessionCatalog.md) (of the <<sparkSession, SparkSession>>).

Used when `HiveMetastoreCatalog` is requested to <<getCached, getCached>>, <<convertToLogicalRelation, convertToLogicalRelation>>

|===
