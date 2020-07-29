# HiveClientImpl

:hive-version: 2.3.6
:hadoop-version: 2.10.0
:url-hive-javadoc: https://hive.apache.org/javadocs/r{hive-version}/api
:url-hadoop-javadoc: https://hadoop.apache.org/docs/r{hadoop-version}/api

`HiveClientImpl` is a HiveClient.md[HiveClient] that uses a <<client, Hive metastore client>> (for meta data/DDL operations using calls to a Hive metastore).

`HiveClientImpl` is <<creating-instance, created>> exclusively when `IsolatedClientLoader` is requested to HiveUtils.md#newClientForMetadata[create a new Hive client]. When created, `HiveClientImpl` is given the location of the default database for the Hive metastore warehouse (i.e. <<warehouseDir, warehouseDir>> that is the value of ../spark-sql-hive-metastore.md#hive.metastore.warehouse.dir[hive.metastore.warehouse.dir] Hive-specific Hadoop configuration property).

NOTE: The location of the default database for the Hive metastore warehouse is `/user/hive/warehouse` by default.

NOTE: The Hadoop configuration is what HiveExternalCatalog.md#creating-instance[HiveExternalCatalog] was given when created (which is the default Hadoop configuration from Spark Core's `SparkContext.hadoopConfiguration` with the Spark properties with `spark.hadoop` prefix).

[[logging]]
[TIP]
====
Enable `ALL` logging level for `org.apache.spark.sql.hive.client.HiveClientImpl` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.hive.client.HiveClientImpl=ALL
```

Refer to ../spark-logging.md[Logging].
====

=== [[creating-instance]] Creating HiveClientImpl Instance

`HiveClientImpl` takes the following to be created:

* [[version]] `HiveVersion`
* [[warehouseDir]] Location of the default database for the Hive metastore warehouse if defined (aka `warehouseDir`)
* [[sparkConf]] `SparkConf`
* [[hadoopConf]] Hadoop configuration
* [[extraConfig]] Extra configuration
* [[initClassLoader]] Initial `ClassLoader`
* [[clientLoader]] IsolatedClientLoader.md[IsolatedClientLoader]

`HiveClientImpl` initializes the <<internal-properties, internal properties>>.

=== [[client]] Hive Metastore Client -- `client` Internal Method

[source, scala]
----
client: Hive
----

`client` is a Hive {url-hive-javadoc}/org/apache/hadoop/hive/ql/metadata/Hive.html[metastore client] (for meta data/DDL operations using calls to the metastore).

=== [[getTableOption]] Retrieving Table Metadata From Hive Metastore -- `getTableOption` Method

[source, scala]
----
getTableOption(
  dbName: String,
  tableName: String): Option[CatalogTable]
----

NOTE: `getTableOption` is part of HiveClient.md#getTableOption[HiveClient] contract.

`getTableOption` prints out the following DEBUG message to the logs:

```
Looking up [dbName].[tableName]
```

`getTableOption` <<getRawTableOption, getRawTableOption>> and converts the Hive table metadata to Spark's ../spark-sql-CatalogTable.md[CatalogTable]

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

=== [[readHiveStats]] Creating Table Statistics from Hive's Table or Partition Parameters -- `readHiveStats` Internal Method

[source, scala]
----
readHiveStats(properties: Map[String, String]): Option[CatalogStatistics]
----

`readHiveStats` creates a ../spark-sql-CatalogStatistics.md#creating-instance[CatalogStatistics] from the input Hive table or partition parameters (if available and greater than 0).

.Table Statistics and Hive Parameters
[cols="1,2",options="header",width="100%"]
|===
| Hive Parameter
| Table Statistics

| `totalSize`
| ../spark-sql-CatalogStatistics.md#sizeInBytes[sizeInBytes]

| `rawDataSize`
| ../spark-sql-CatalogStatistics.md#sizeInBytes[sizeInBytes]

| `numRows`
| ../spark-sql-CatalogStatistics.md#rowCount[rowCount]
|===

NOTE: `totalSize` Hive parameter has a higher precedence over `rawDataSize` for ../spark-sql-CatalogStatistics.md#sizeInBytes[sizeInBytes] table statistic.

NOTE: `readHiveStats` is used when `HiveClientImpl` is requested for the metadata of a <<getTableOption, table>> or <<fromHivePartition, table partition>>.

=== [[fromHivePartition]] Retrieving Table Partition Metadata (Converting Table Partition Metadata from Hive Format to Spark SQL Format) -- `fromHivePartition` Method

[source, scala]
----
fromHivePartition(hp: HivePartition): CatalogTablePartition
----

`fromHivePartition` simply creates a ../spark-sql-CatalogTablePartition.md#creating-instance[CatalogTablePartition] with the following:

* ../spark-sql-CatalogTablePartition.md#spec[spec] from Hive's ++http://hive.apache.org/javadocs/r2.3.2/api/org/apache/hadoop/hive/ql/metadata/Partition.html#getSpec--++[Partition.getSpec] if available

* ../spark-sql-CatalogTablePartition.md#storage[storage] from Hive's http://hive.apache.org/javadocs/r2.3.2/api/org/apache/hadoop/hive/metastore/api/StorageDescriptor.html[StorageDescriptor] of the table partition

* ../spark-sql-CatalogTablePartition.md#parameters[parameters] from Hive's ++http://hive.apache.org/javadocs/r2.3.2/api/org/apache/hadoop/hive/ql/metadata/Partition.html#getParameters--++[Partition.getParameters] if available

* ../spark-sql-CatalogTablePartition.md#stats[stats] from Hive's ++http://hive.apache.org/javadocs/r2.3.2/api/org/apache/hadoop/hive/ql/metadata/Partition.html#getParameters--++[Partition.getParameters] if available and <<readHiveStats, converted to table statistics format>>

NOTE: `fromHivePartition` is used when `HiveClientImpl` is requested for <<getPartitionOption, getPartitionOption>>, <<getPartitions, getPartitions>> and <<getPartitionsByFilter, getPartitionsByFilter>>.

=== [[toHiveTable]] Converting Native Table Metadata to Hive's Table -- `toHiveTable` Method

[source, scala]
----
toHiveTable(table: CatalogTable, userName: Option[String] = None): HiveTable
----

`toHiveTable` simply creates a new Hive `Table` and copies the properties from the input <<spark-sql-CatalogTable.md#, CatalogTable>>.

[NOTE]
====
`toHiveTable` is used when:

* `HiveUtils` is requested to HiveUtils.md#inferSchema[inferSchema]

* `HiveClientImpl` is requested to <<createTable, createTable>>, <<alterTable, alterTable>>, <<renamePartitions, renamePartitions>>, <<alterPartitions, alterPartitions>>, <<getPartitionOption, getPartitionOption>>, <<getPartitions, getPartitions>> and <<getPartitionsByFilter, getPartitionsByFilter>>

* `HiveTableScanExec` physical operator is requested for the <<hiveQlTable, hiveQlTable>>

* InsertIntoHiveDirCommand.md[InsertIntoHiveDirCommand] and InsertIntoHiveTable.md[InsertIntoHiveTable] logical commands are executed
====

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

`toHivePartition` creates a Hive `org.apache.hadoop.hive.ql.metadata.Partition` for the input ../spark-sql-CatalogTablePartition.md[CatalogTablePartition] and the Hive `org.apache.hadoop.hive.ql.metadata.Table`.

[NOTE]
====
`toHivePartition` is used when:

* `HiveClientImpl` is requested to <<renamePartitions, renamePartitions>> or <<alterPartitions, alterPartitions>>

* `HiveTableScanExec` physical operator is requested for the HiveTableScanExec.md#rawPartitions[raw Hive partitions]
====

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
