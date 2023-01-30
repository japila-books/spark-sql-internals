# HiveClientImpl

`HiveClientImpl` is a [HiveClient](HiveClient.md) that uses a [Hive metastore client](#client) to communicate with a Hive metastore.

## Creating Instance

`HiveClientImpl` takes the following to be created:

* <span id="version"> `HiveVersion`
* [Metastore Warehouse Directory](#warehouseDir)
* <span id="sparkConf"> `SparkConf` ([Spark Core]({{ book.spark_core }}/SparkConf))
* <span id="hadoopConf"> Hadoop Configuration (`Iterable[Map.Entry[String, String]]`)
* <span id="extraConfig"> Extra Configuration (`Map[String, String]`)
* <span id="initClassLoader"> Init `ClassLoader`
* <span id="clientLoader"> [IsolatedClientLoader](IsolatedClientLoader.md)

When created, `HiveClientImpl` prints out the following INFO message to the logs:

```text
Warehouse location for Hive client (version [fullVersion]) is [the value of hive.metastore.warehouse.dir]
```

`HiveClientImpl` is created when:

* `IsolatedClientLoader` is requested to [create a HiveClient](IsolatedClientLoader.md#createClient)

## <span id="warehouseDir"> Metastore Warehouse Directory

`HiveClientImpl` is given the directory of the default database of a Hive warehouse.

The directory is the value of `hive.metastore.warehouse.dir` configuration property (default: `/user/hive/warehouse`).

## <span id="client"> Hive Metastore Client

```scala
client: Hive
```

`client` is a Hive [metastore client]({{ hive.api }}/org/apache/hadoop/hive/ql/metadata/Hive.html) (for meta data/DDL operations using calls to the metastore).

## <span id="readHiveStats"> Creating CatalogStatistics

```scala
readHiveStats(
  properties: Map[String, String]): Option[CatalogStatistics]
```

`readHiveStats` creates a [CatalogStatistics](../CatalogStatistics.md) from the input Hive `properties` (with table and possibly partition parameters). `readHiveStats` uses the following Hive properties, if available and greater than 0.

Hive Property | Table Statistic
--------------|----------------
 `totalSize` or `rawDataSize` | [sizeInBytes](../CatalogStatistics.md#sizeInBytes)
 `numRows` | [rowCount](../CatalogStatistics.md#rowCount)

---

`readHiveStats` is used when:

* `HiveClientImpl` is requested for the metadata of a [table](#convertHiveTableToCatalogTable) or [partition](#fromHivePartition)

## <span id="convertHiveTableToCatalogTable"> convertHiveTableToCatalogTable

```scala
convertHiveTableToCatalogTable(
  h: Table): CatalogTable
```

`convertHiveTableToCatalogTable` creates a [CatalogTable](../CatalogTable.md) based on the given Hive [Table]({{ hive.api }}/org/apache/hadoop/hive/ql/metadata/Table.html) as follows:

CatalogTable | Hive Table
-------------|------------
 [Table Statistics](../CatalogTable.md#stats) | [readHiveStats](#readHiveStats)
 ... |

---

`convertHiveTableToCatalogTable` is used when:

* `HiveClientImpl` is requested to [getRawHiveTableOption](#getRawHiveTableOption) (and requests `RawHiveTableImpl` to `getRawHiveTableOption`), [getTablesByName](#getTablesByName), [getTableOption](#getTableOption)

## <span id="fromHivePartition"> fromHivePartition

```scala
fromHivePartition(
  hp: HivePartition): CatalogTablePartition
```

`fromHivePartition`...FIXME

---

`fromHivePartition` is used when:

* `HiveClientImpl` is requested to [getPartitionOption](#getPartitionOption), [getPartitions](#getPartitions), [getPartitionsByFilter](#getPartitionsByFilter)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.hive.client.HiveClientImpl` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
log4j.logger.org.apache.spark.sql.hive.client.HiveClientImpl=ALL
```

Refer to [Logging](../spark-logging.md).

<!---
## Review Me

`HiveClientImpl` is <<creating-instance, created>> exclusively when `IsolatedClientLoader` is requested to HiveUtils.md#newClientForMetadata[create a new Hive client]. When created, `HiveClientImpl` is given the location of the default database for the Hive metastore warehouse (i.e. <<warehouseDir, warehouseDir>> that is the value of ../spark-sql-hive-metastore.md#hive.metastore.warehouse.dir[hive.metastore.warehouse.dir] Hive-specific Hadoop configuration property).

NOTE: The Hadoop configuration is what [HiveExternalCatalog](HiveExternalCatalog.md) was given when created (which is the default Hadoop configuration from Spark Core's `SparkContext.hadoopConfiguration` with the Spark properties with `spark.hadoop` prefix).

=== [[getTableOption]] Retrieving Table Metadata From Hive Metastore -- `getTableOption` Method

[source, scala]
----
getTableOption(
  dbName: String,
  tableName: String): Option[CatalogTable]
----

NOTE: `getTableOption` is part of HiveClient.md#getTableOption[HiveClient] contract.

`getTableOption` prints out the following DEBUG message to the logs:

```text
Looking up [dbName].[tableName]
```

`getTableOption` <<getRawTableOption, getRawTableOption>> and converts the Hive table metadata to Spark's [CatalogTable](../CatalogTable.md)

=== [[renamePartitions]] `renamePartitions` Method

[source, scala]
----
renamePartitions(
  db: String,
  table: String,
  specs: Seq[TablePartitionSpec],
  newSpecs: Seq[TablePartitionSpec]): Unit
----

NOTE: `renamePartitions` is part of HiveClient.md#renamePartitions[HiveClient Contract] to...FIXME.

`renamePartitions`...FIXME

=== [[alterPartitions]] `alterPartitions` Method

[source, scala]
----
alterPartitions(
  db: String,
  table: String,
  newParts: Seq[CatalogTablePartition]): Unit
----

NOTE: `alterPartitions` is part of HiveClient.md#alterPartitions[HiveClient Contract] to...FIXME.

`alterPartitions`...FIXME

=== [[getPartitions]] `getPartitions` Method

[source, scala]
----
getPartitions(
  table: CatalogTable,
  spec: Option[TablePartitionSpec]): Seq[CatalogTablePartition]
----

NOTE: `getPartitions` is part of HiveClient.md#getPartitions[HiveClient Contract] to...FIXME.

`getPartitions`...FIXME

=== [[getPartitionsByFilter]] `getPartitionsByFilter` Method

[source, scala]
----
getPartitionsByFilter(
  table: CatalogTable,
  predicates: Seq[Expression]): Seq[CatalogTablePartition]
----

NOTE: `getPartitionsByFilter` is part of HiveClient.md#getPartitionsByFilter[HiveClient Contract] to...FIXME.

`getPartitionsByFilter`...FIXME

=== [[getPartitionOption]] `getPartitionOption` Method

[source, scala]
----
getPartitionOption(
  table: CatalogTable,
  spec: TablePartitionSpec): Option[CatalogTablePartition]
----

NOTE: `getPartitionOption` is part of HiveClient.md#getPartitionOption[HiveClient Contract] to...FIXME.

`getPartitionOption`...FIXME

=== [[fromHivePartition]] Retrieving Table Partition Metadata (Converting Table Partition Metadata from Hive Format to Spark SQL Format) -- `fromHivePartition` Method

[source, scala]
----
fromHivePartition(hp: HivePartition): CatalogTablePartition
----

`fromHivePartition` simply creates a [CatalogTablePartition](../CatalogTablePartition.md) with the following:

* [spec](../CatalogTablePartition.md#spec) from Hive's [Partition.getSpec]({{ hive.api }}/org/apache/hadoop/hive/ql/metadata/Partition.html#getSpec--) if available

* [storage](../CatalogTablePartition.md#storage) from Hive's [StorageDescriptor]({{ hive.api }}/org/apache/hadoop/hive/metastore/api/StorageDescriptor.html) of the table partition

* [parameters](../CatalogTablePartition.md#parameters) from Hive's [Partition.getParameters]({{ hive.api }}/org/apache/hadoop/hive/ql/metadata/Partition.html#getParameters--) if available

* [stats](../CatalogTablePartition.md#stats) from Hive's [Partition.getParameters]({{ hive.api }}/org/apache/hadoop/hive/ql/metadata/Partition.html#getParameters--) if available and [converted to table statistics format](#readHiveStats)

`fromHivePartition` is used when:

* `HiveClientImpl` is requested for [getPartitionOption](#getPartitionOption), [getPartitions](#getPartitions) and [getPartitionsByFilter](#getPartitionsByFilter).

## <span id="toHiveTable"> Converting Native Table Metadata to Hive's Table

```scala
toHiveTable(
  table: CatalogTable,
  userName: Option[String] = None): HiveTable
```

`toHiveTable` simply creates a new Hive `Table` and copies the properties from the input [CatalogTable](../CatalogTable.md).

`toHiveTable` is used when:

* `HiveUtils` is requested to [inferSchema](HiveUtils.md#inferSchema)

* `HiveClientImpl` is requested to <<createTable, createTable>>, <<alterTable, alterTable>>, <<renamePartitions, renamePartitions>>, <<alterPartitions, alterPartitions>>, <<getPartitionOption, getPartitionOption>>, <<getPartitions, getPartitions>> and <<getPartitionsByFilter, getPartitionsByFilter>>

* `HiveTableScanExec` physical operator is requested for the <<hiveQlTable, hiveQlTable>>

* InsertIntoHiveDirCommand.md[InsertIntoHiveDirCommand] and InsertIntoHiveTable.md[InsertIntoHiveTable] logical commands are executed

=== [[getSparkSQLDataType]] `getSparkSQLDataType` Internal Utility

[source, scala]
----
getSparkSQLDataType(hc: FieldSchema): DataType
----

`getSparkSQLDataType`...FIXME

NOTE: `getSparkSQLDataType` is used when...FIXME

=== [[toHivePartition]] Converting CatalogTablePartition to Hive Partition -- `toHivePartition` Utility

[source, scala]
----
toHivePartition(
  p: CatalogTablePartition,
  ht: Table): Partition
----

`toHivePartition` creates a Hive `org.apache.hadoop.hive.ql.metadata.Partition` for the input [CatalogTablePartition](../CatalogTablePartition.md) and the Hive `org.apache.hadoop.hive.ql.metadata.Table`.

`toHivePartition` is used when:

* `HiveClientImpl` is requested to [renamePartitions](#renamePartitions) or [alterPartitions](#alterPartitions)
* `HiveTableScanExec` physical operator is requested for the [raw Hive partitions](HiveTableScanExec.md#rawPartitions)

=== [[newSession]] Creating New HiveClientImpl -- `newSession` Method

[source, scala]
----
newSession(): HiveClientImpl
----

NOTE: `newSession` is part of the HiveClient.md#newSession[HiveClient] contract to...FIXME.

`newSession`...FIXME

=== [[getRawTableOption]] `getRawTableOption` Internal Method

[source, scala]
----
getRawTableOption(
  dbName: String,
  tableName: String): Option[Table]
----

`getRawTableOption` requests the <<client, Hive metastore client>> for the Hive's {url-hive-javadoc}/org/apache/hadoop/hive/ql/metadata/Table.html[metadata] of the input table.

NOTE: `getRawTableOption` is used when `HiveClientImpl` is requested to <<tableExists, tableExists>> and <<getTableOption, getTableOption>>.
-->
