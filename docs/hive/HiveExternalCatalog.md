# HiveExternalCatalog

`HiveExternalCatalog` is an [ExternalCatalog](../ExternalCatalog.md) for `SparkSession` with [Hive support enabled](../SparkSession-Builder.md#enableHiveSupport).

![HiveExternalCatalog and SharedState](../images/spark-sql-HiveExternalCatalog.png)

`HiveExternalCatalog` uses an [HiveClient](#client) to interact with a Hive metastore.

## Creating Instance

`HiveExternalCatalog` takes the following to be created:

* <span id="conf"> `SparkConf` ([Spark Core]({{ book.spark_core }}/SparkConf))
* <span id="hadoopConf"> `Configuration` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html))

`HiveExternalCatalog` is created when:

* `SharedState` is requested for the [ExternalCatalog](../SharedState.md#externalCatalog) (and [spark.sql.catalogImplementation](../StaticSQLConf.md#spark.sql.catalogImplementation) is `hive`).

## <span id="restoreTableMetadata"> restoreTableMetadata

```scala
restoreTableMetadata(
  inputTable: CatalogTable): CatalogTable
```

`restoreTableMetadata`...FIXME

---

`restoreTableMetadata` is used when:

* `HiveExternalCatalog` is requested for [table metadata](#getTable), the [metadata of tables](#getTablesByName) and [listPartitionsByFilter](#listPartitionsByFilter)

### <span id="restoreHiveSerdeTable"> restoreHiveSerdeTable

```scala
restoreHiveSerdeTable(
  table: CatalogTable): CatalogTable
```

`restoreHiveSerdeTable`...FIXME

### <span id="restoreDataSourceTable"> restoreDataSourceTable

```scala
restoreDataSourceTable(
  table: CatalogTable,
  provider: String): CatalogTable
```

`restoreDataSourceTable`...FIXME

### <span id="getBucketSpecFromTableProperties"> Looking Up BucketSpec in Table Properties

```scala
getBucketSpecFromTableProperties(
  metadata: CatalogTable): Option[BucketSpec]
```

`getBucketSpecFromTableProperties` looks up the value of `spark.sql.sources.schema.numBuckets` property (among the [properties](../CatalogTable.md#properties)) in the given [CatalogTable](../CatalogTable.md) metadata.

If found, `getBucketSpecFromTableProperties` creates a [BucketSpec](../bucketing/BucketSpec.md) with the following:

BucketSpec | Metadata Property
-----------|------------------
 [numBuckets](../bucketing/BucketSpec.md#numBuckets) | `spark.sql.sources.schema.numBuckets`
 [bucketColumnNames](../bucketing/BucketSpec.md#bucketColumnNames) | `spark.sql.sources.schema.numBucketCols`<br>`spark.sql.sources.schema.bucketCol.N`
 [sortColumnNames](../bucketing/BucketSpec.md#sortColumnNames) | `spark.sql.sources.schema.numSortCols`<br>`spark.sql.sources.schema.sortCol.N`

## <span id="restorePartitionMetadata"> restorePartitionMetadata

```scala
restorePartitionMetadata(
  partition: CatalogTablePartition,
  table: CatalogTable): CatalogTablePartition
```

`restorePartitionMetadata`...FIXME

---

`restorePartitionMetadata` is used when:

* `HiveExternalCatalog` is requested to [getPartition](#getPartition) and [getPartitionOption](#getPartitionOption)

## <span id="statsFromProperties"> Restoring Table Statistics from Table Properties (from Hive Metastore)

```scala
statsFromProperties(
  properties: Map[String, String],
  table: String): Option[CatalogStatistics]
```

`statsFromProperties` collects statistics-related `spark.sql.statistics`-prefixed properties.

For no keys with the prefix, `statsFromProperties` returns `None`.

If there are keys with `spark.sql.statistics` prefix, `statsFromProperties` creates a [CatalogColumnStat](../cost-based-optimization/CatalogColumnStat.md#fromMap) for every column in the `schema`.

For every column name in `schema`, `statsFromProperties` collects all the keys that start with `spark.sql.statistics.colStats.[name]` prefix (after having checked that the key `spark.sql.statistics.colStats.[name].version` exists that is a marker that the column statistics exist in the statistics properties) and [converts](../cost-based-optimization/ColumnStat.md#fromMap) them to a `ColumnStat` (for the column name).

In the end, `statsFromProperties` creates a [CatalogStatistics](../CatalogStatistics.md) as follows:

Catalog Statistic | Value
------------------|------
 [sizeInBytes](../CatalogStatistics.md#sizeInBytes) | `spark.sql.statistics.totalSize`
 [rowCount](../CatalogStatistics.md#rowCount) | `spark.sql.statistics.numRows` property
 [colStats](../CatalogStatistics.md#colStats) | Column Names and their [CatalogColumnStat](../cost-based-optimization/CatalogColumnStat.md)s

---

`statsFromProperties` is used when:

* `HiveExternalCatalog` is requested to [restore metadata of a table](#restoreTableMetadata) or a [partition](#restorePartitionMetadata)

## Demo

```scala
import org.apache.spark.sql.internal.StaticSQLConf
val catalogType = spark.conf.get(StaticSQLConf.CATALOG_IMPLEMENTATION.key)
assert(catalogType == "hive")
```

```scala
assert(spark.sessionState.conf.getConf(StaticSQLConf.CATALOG_IMPLEMENTATION) == "hive")
```

```scala
assert(spark.conf.get("spark.sql.catalogImplementation") == "hive")
```

```scala
val metastore = spark.sharedState.externalCatalog
import org.apache.spark.sql.catalyst.catalog.ExternalCatalog
assert(metastore.isInstanceOf[ExternalCatalog])
```

```text
scala> println(metastore)
org.apache.spark.sql.catalyst.catalog.ExternalCatalogWithListener@277ffb17

scala> println(metastore.unwrapped)
org.apache.spark.sql.hive.HiveExternalCatalog@4eda3af9
```

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.hive.HiveExternalCatalog` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
logger.HiveExternalCatalog.name = org.apache.spark.sql.hive.HiveExternalCatalog
logger.HiveExternalCatalog.level = all
```

Refer to [Logging](../spark-logging.md).

<!---
## Review Me

NOTE: The <<hadoopConf, Hadoop configuration>> to create a `HiveExternalCatalog` is the default Hadoop configuration from Spark Core's `SparkContext.hadoopConfiguration` with the Spark properties with `spark.hadoop` prefix.

[TIP]
====
Use ../StaticSQLConf.md#spark.sql.warehouse.dir[spark.sql.warehouse.dir] Spark property to change the location of Hive's `hive.metastore.warehouse.dir` property, i.e. the location of the Hive local/embedded metastore database (using Derby).

Refer to ../SharedState.md[SharedState] to learn about (the low-level details of) Spark SQL support for Apache Hive.

See also the official https://cwiki.apache.org/confluence/display/Hive/AdminManual+MetastoreAdmin[Hive Metastore Administration] document.
====

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

`statsToProperties` converts the ../CatalogStatistics.md[table statistics] to properties (i.e. key-value pairs that will be persisted as properties in the table metadata to a Hive metastore using the <<client, Hive client>>).

`statsToProperties` adds the following properties to the properties:

* *spark.sql.statistics.totalSize* with ../CatalogStatistics.md#sizeInBytes[total size (in bytes)]
* (if defined) *spark.sql.statistics.numRows* with ../CatalogStatistics.md#rowCount[number of rows]

`statsToProperties` takes the ../CatalogStatistics.md#colStats[column statistics] and for every column (field) in `schema` [converts the column statistics to properties](../cost-based-optimization/ColumnStat.md#toMap) and adds the properties (as <<columnStatKeyPropName, column statistic property>>) to the properties.

[NOTE]
====
`statsToProperties` is used when `HiveExternalCatalog` is requested for:

* <<doAlterTableStats, doAlterTableStats>>

* <<alterPartitions, alterPartitions>>
====
-->
