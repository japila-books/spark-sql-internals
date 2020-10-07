# HiveExternalCatalog

:hive-version: 2.3.6
:hadoop-version: 2.10.0
:url-hive-javadoc: https://hive.apache.org/javadocs/r{hive-version}/api
:url-hadoop-javadoc: https://hadoop.apache.org/docs/r{hadoop-version}/api

`HiveExternalCatalog` is an [external catalog of permanent relational entities](../ExternalCatalog.md).

`HiveExternalCatalog` is used for `SparkSession` with ../SparkSession-Builder.md#enableHiveSupport[Hive support enabled].

.HiveExternalCatalog and SharedState
image::../images/spark-sql-HiveExternalCatalog.png[align="center"]

`HiveExternalCatalog` is <<creating-instance, created>> when `SharedState` is requested for the ../SharedState.md#externalCatalog[ExternalCatalog] (and ../StaticSQLConf.md#spark.sql.catalogImplementation[spark.sql.catalogImplementation] internal configuration property is `hive`).

NOTE: The <<hadoopConf, Hadoop configuration>> to create a `HiveExternalCatalog` is the default Hadoop configuration from Spark Core's `SparkContext.hadoopConfiguration` with the Spark properties with `spark.hadoop` prefix.

`HiveExternalCatalog` uses an <<client, HiveClient>> to interact with a Hive metastore.

[source, scala]
----
import org.apache.spark.sql.internal.StaticSQLConf
val catalogType = spark.conf.get(StaticSQLConf.CATALOG_IMPLEMENTATION.key)
scala> println(catalogType)
hive

// Alternatively...
scala> spark.sessionState.conf.getConf(StaticSQLConf.CATALOG_IMPLEMENTATION)
res1: String = hive

// Or you could use the property key by name
scala> spark.conf.get("spark.sql.catalogImplementation")
res1: String = hive

val metastore = spark.sharedState.externalCatalog
scala> :type metastore
org.apache.spark.sql.catalyst.catalog.ExternalCatalog

// Since Hive is enabled HiveExternalCatalog is the metastore
scala> println(metastore)
org.apache.spark.sql.hive.HiveExternalCatalog@25e95d04
----

[TIP]
====
Use ../StaticSQLConf.md#spark.sql.warehouse.dir[spark.sql.warehouse.dir] Spark property to change the location of Hive's `hive.metastore.warehouse.dir` property, i.e. the location of the Hive local/embedded metastore database (using Derby).

Refer to ../SharedState.md[SharedState] to learn about (the low-level details of) Spark SQL support for Apache Hive.

See also the official https://cwiki.apache.org/confluence/display/Hive/AdminManual+MetastoreAdmin[Hive Metastore Administration] document.
====

[[logging]]
[TIP]
====
Enable `ALL` logging level for `org.apache.spark.sql.hive.HiveExternalCatalog` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.hive.HiveExternalCatalog=ALL
```

Refer to ../spark-logging.md[Logging].
====

=== [[creating-instance]] Creating HiveExternalCatalog Instance

`HiveExternalCatalog` takes the following to be created:

* [[conf]] Spark configuration (`SparkConf`)
* [[hadoopConf]] Hadoop {url-hadoop-javadoc}/org/apache/hadoop/conf/Configuration.html[Configuration]

=== [[client]] HiveClient -- `client` Lazy Property

[source, scala]
----
client: HiveClient
----

`client` is a HiveClient.md[HiveClient] to access a Hive metastore.

`client` is created lazily (when first requested) using HiveUtils.md#newClientForMetadata[HiveUtils] utility (with the <<conf, SparkConf>> and <<hadoopConf, Hadoop Configuration>>).

[NOTE]
====
`client` is also used when:

* `HiveSessionStateBuilder` is requested for a HiveSessionStateBuilder.md#resourceLoader[HiveSessionResourceLoader]

* ../spark-sql-thrift-server.md[Spark Thrift Server] is used

* `SaveAsHiveFile` is used to ../hive/SaveAsHiveFile.md#getExternalTmpPath[getExternalTmpPath]
====

=== [[getRawTable]] `getRawTable` Method

[source, scala]
----
getRawTable(
  db: String,
  table: String): CatalogTable
----

`getRawTable` returns the [CatalogTable](../CatalogTable.md) metadata of the input table.

Internally, `getRawTable` requests the <<client, HiveClient>> for the HiveClient.md#getTable[table metadata from a Hive metastore].

NOTE: `getRawTable` is used when `HiveExternalCatalog` is requested to <<renameTable, renameTable>>, <<alterTable, alterTable>>, <<alterTableStats, alterTableStats>>, <<getTable, getTable>>, <<alterPartitions, alterPartitions>> and <<listPartitionsByFilter, listPartitionsByFilter>>.

=== [[doAlterTableStats]] `doAlterTableStats` Method

[source, scala]
----
doAlterTableStats(
  db: String,
  table: String,
  stats: Option[CatalogStatistics]): Unit
----

`doAlterTableStats`...FIXME

`doAlterTableStats` is part of the [ExternalCatalog](../ExternalCatalog.md#doAlterTableStats) abstraction.

=== [[listPartitionsByFilter]] `listPartitionsByFilter` Method

[source, scala]
----
listPartitionsByFilter(
  db: String,
  table: String,
  predicates: Seq[Expression],
  defaultTimeZoneId: String): Seq[CatalogTablePartition]
----

`listPartitionsByFilter`...FIXME

`listPartitionsByFilter` is part of the [ExternalCatalog](../ExternalCatalog.md#listPartitionsByFilter) abstraction.

=== [[alterPartitions]] `alterPartitions` Method

[source, scala]
----
alterPartitions(
  db: String,
  table: String,
  newParts: Seq[CatalogTablePartition]): Unit
----

`alterPartitions`...FIXME

`alterPartitions` is part of the [ExternalCatalog](../ExternalCatalog.md#alterPartitions) abstraction.

=== [[getTable]] `getTable` Method

[source, scala]
----
getTable(
  db: String,
  table: String): CatalogTable
----

`getTable`...FIXME

`getTable` is part of the [ExternalCatalog](../ExternalCatalog.md#getTable) abstraction.

=== [[doAlterTable]] `doAlterTable` Method

[source, scala]
----
doAlterTable(
  tableDefinition: CatalogTable): Unit
----

`doAlterTable`...FIXME

`doAlterTable` is part of the [ExternalCatalog](../ExternalCatalog.md#doAlterTable) abstraction.

=== [[getPartition]] `getPartition` Method

[source, scala]
----
getPartition(
  db: String,
  table: String,
  spec: TablePartitionSpec): CatalogTablePartition
----

`getPartition`...FIXME

`getPartition` is part of the [ExternalCatalog](../ExternalCatalog.md#getPartition) abstraction.

=== [[getPartitionOption]] `getPartitionOption` Method

[source, scala]
----
getPartitionOption(
  db: String,
  table: String,
  spec: TablePartitionSpec): Option[CatalogTablePartition]
----

`getPartitionOption`...FIXME

`getPartitionOption` is part of the [ExternalCatalog](../ExternalCatalog.md#getPartitionOption) abstraction.

=== [[listPartitions]] Retrieving CatalogTablePartition of Table -- `listPartitions` Method

[source, scala]
----
listPartitions(
  db: String,
  table: String,
  partialSpec: Option[TablePartitionSpec] = None): Seq[CatalogTablePartition]
----

`listPartitions`...FIXME

`listPartitions` is part of the [ExternalCatalog](../ExternalCatalog.md#listPartitions) abstraction.

=== [[doCreateTable]] `doCreateTable` Method

[source, scala]
----
doCreateTable(
  tableDefinition: CatalogTable,
  ignoreIfExists: Boolean): Unit
----

`doCreateTable`...FIXME

`doCreateTable` is part of the [ExternalCatalog](../ExternalCatalog.md#doCreateTable) abstraction.

=== [[doAlterTableDataSchema]] `doAlterTableDataSchema` Method

[source, scala]
----
doAlterTableDataSchema(
  db: String,
  table: String,
  newDataSchema: StructType): Unit
----

`doAlterTableDataSchema`...FIXME

`doAlterTableDataSchema` is part of the [ExternalCatalog](../ExternalCatalog.md#doAlterTableDataSchema) abstraction.

=== [[createTable]] `createTable` Method

[source, scala]
----
createTable(
  tableDefinition: CatalogTable,
  ignoreIfExists: Boolean): Unit
----

`createTable`...FIXME

`createTable` is part of the [ExternalCatalog](../ExternalCatalog.md#createTable) abstraction.

=== [[createDataSourceTable]] `createDataSourceTable` Internal Method

[source, scala]
----
createDataSourceTable(
  table: CatalogTable,
  ignoreIfExists: Boolean): Unit
----

`createDataSourceTable`...FIXME

`createDataSourceTable` is used when `HiveExternalCatalog` is requested to [createTable](#createTable).

=== [[saveTableIntoHive]] `saveTableIntoHive` Internal Method

[source, scala]
----
saveTableIntoHive(
  tableDefinition: CatalogTable,
  ignoreIfExists: Boolean): Unit
----

`saveTableIntoHive`...FIXME

NOTE: `saveTableIntoHive` is used when `HiveExternalCatalog` is requested to <<createDataSourceTable, createDataSourceTable>>.

=== [[restoreTableMetadata]] `restoreTableMetadata` Internal Method

[source, scala]
----
restoreTableMetadata(
  inputTable: CatalogTable): CatalogTable
----

`restoreTableMetadata`...FIXME

[NOTE]
====
`restoreTableMetadata` is used when `HiveExternalCatalog` is requested for:

* <<getTable, getTable>>

* <<doAlterTableStats, doAlterTableStats>>

* <<alterPartitions, alterPartitions>>

* <<listPartitionsByFilter, listPartitionsByFilter>>
====

=== [[tableMetaToTableProps]] `tableMetaToTableProps` Internal Method

[source, scala]
----
tableMetaToTableProps(
  table: CatalogTable): Map[String, String]
tableMetaToTableProps(
  table: CatalogTable,
  schema: StructType): Map[String, String]
----

`tableMetaToTableProps`...FIXME

NOTE: `tableMetaToTableProps` is used when `HiveExternalCatalog` is requested to <<doAlterTableDataSchema, doAlterTableDataSchema>> and <<doCreateTable, doCreateTable>> (and <<createDataSourceTable, createDataSourceTable>>).

=== [[restoreDataSourceTable]] Restoring Data Source Table -- `restoreDataSourceTable` Internal Method

[source, scala]
----
restoreDataSourceTable(
  table: CatalogTable,
  provider: String): CatalogTable
----

`restoreDataSourceTable`...FIXME

NOTE: `restoreDataSourceTable` is used exclusively when `HiveExternalCatalog` is requested to <<restoreTableMetadata, restoreTableMetadata>> (for regular data source table with provider specified in table properties).

=== [[restoreHiveSerdeTable]] Restoring Hive Serde Table -- `restoreHiveSerdeTable` Internal Method

[source, scala]
----
restoreHiveSerdeTable(
  table: CatalogTable): CatalogTable
----

`restoreHiveSerdeTable`...FIXME

NOTE: `restoreHiveSerdeTable` is used exclusively when `HiveExternalCatalog` is requested to <<restoreTableMetadata, restoreTableMetadata>> (when there is no provider specified in table properties, which means this is a Hive serde table).

=== [[getBucketSpecFromTableProperties]] `getBucketSpecFromTableProperties` Internal Method

[source, scala]
----
getBucketSpecFromTableProperties(
  metadata: CatalogTable): Option[BucketSpec]
----

`getBucketSpecFromTableProperties`...FIXME

NOTE: `getBucketSpecFromTableProperties` is used when `HiveExternalCatalog` is requested to <<restoreHiveSerdeTable, restoreHiveSerdeTable>> or <<restoreDataSourceTable, restoreDataSourceTable>>.

=== [[columnStatKeyPropName]] Building Property Name for Column and Statistic Key -- `columnStatKeyPropName` Internal Method

[source, scala]
----
columnStatKeyPropName(
  columnName: String,
  statKey: String): String
----

`columnStatKeyPropName` builds a property name of the form *spark.sql.statistics.colStats.[columnName].[statKey]* for the input `columnName` and `statKey`.

NOTE: `columnStatKeyPropName` is used when `HiveExternalCatalog` is requested to <<statsToProperties, statsToProperties>> and <<statsFromProperties, statsFromProperties>>.

=== [[statsToProperties]] Converting Table Statistics to Properties -- `statsToProperties` Internal Method

[source, scala]
----
statsToProperties(
  stats: CatalogStatistics,
  schema: StructType): Map[String, String]
----

`statsToProperties` converts the ../spark-sql-CatalogStatistics.md[table statistics] to properties (i.e. key-value pairs that will be persisted as properties in the table metadata to a Hive metastore using the <<client, Hive client>>).

`statsToProperties` adds the following properties to the properties:

* *spark.sql.statistics.totalSize* with ../spark-sql-CatalogStatistics.md#sizeInBytes[total size (in bytes)]
* (if defined) *spark.sql.statistics.numRows* with ../spark-sql-CatalogStatistics.md#rowCount[number of rows]

`statsToProperties` takes the ../spark-sql-CatalogStatistics.md#colStats[column statistics] and for every column (field) in `schema` ../spark-sql-ColumnStat.md#toMap[converts the column statistics to properties] and adds the properties (as <<columnStatKeyPropName, column statistic property>>) to the properties.

[NOTE]
====
`statsToProperties` is used when `HiveExternalCatalog` is requested for:

* <<doAlterTableStats, doAlterTableStats>>

* <<alterPartitions, alterPartitions>>
====

=== [[statsFromProperties]] Restoring Table Statistics from Properties (from Hive Metastore) -- `statsFromProperties` Internal Method

[source, scala]
----
statsFromProperties(
  properties: Map[String, String],
  table: String,
  schema: StructType): Option[CatalogStatistics]
----

`statsFromProperties` collects statistics-related `properties`, i.e. the properties with their keys with *spark.sql.statistics* prefix.

`statsFromProperties` returns `None` if there are no keys with the `spark.sql.statistics` prefix in `properties`.

If there are keys with `spark.sql.statistics` prefix, `statsFromProperties` ../spark-sql-ColumnStat.md#creating-instance[creates] a `ColumnStat` that is the column statistics for every column in `schema`.

For every column name in `schema` `statsFromProperties` collects all the keys that start with `spark.sql.statistics.colStats.[name]` prefix (after having checked that the key `spark.sql.statistics.colStats.[name].version` exists that is a marker that the column statistics exist in the statistics properties) and ../spark-sql-ColumnStat.md#fromMap[converts] them to a `ColumnStat` (for the column name).

In the end, `statsFromProperties` creates a ../spark-sql-CatalogStatistics.md#creating-instance[CatalogStatistics] with the following properties:

* ../spark-sql-CatalogStatistics.md#sizeInBytes[sizeInBytes] as *spark.sql.statistics.totalSize* property
* ../spark-sql-CatalogStatistics.md#rowCount[rowCount] as *spark.sql.statistics.numRows* property
* ../spark-sql-CatalogStatistics.md#colStats[colStats] as the collection of the column names and their `ColumnStat` (calculated above)

NOTE: `statsFromProperties` is used when `HiveExternalCatalog` is requested for restoring <<restoreTableMetadata, table>> and <<restorePartitionMetadata, partition>> metadata.

=== [[restorePartitionMetadata]] `restorePartitionMetadata` Internal Method

[source, scala]
----
restorePartitionMetadata(
  partition: CatalogTablePartition,
  table: CatalogTable): CatalogTablePartition
----

`restorePartitionMetadata`...FIXME

[NOTE]
====
`restorePartitionMetadata` is used when `HiveExternalCatalog` is requested for:

* <<getPartition, getPartition>>

* <<getPartitionOption, getPartitionOption>>
====
