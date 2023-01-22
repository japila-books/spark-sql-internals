# ExternalCatalog

`ExternalCatalog` is an [abstraction](#contract) of [external system catalogs](#implementations) (aka _metadata registry_ or _metastore_) of permanent relational entities (i.e., databases, tables, partitions, and functions).

`ExternalCatalog` is available as ephemeral ([in-memory](#in-memory)) or persistent ([hive-aware](#hive)).

## Contract

### <span id="getPartition"> getPartition

```scala
getPartition(
  db: String,
  table: String,
  spec: TablePartitionSpec): CatalogTablePartition
```

[CatalogTablePartition](CatalogTablePartition.md) of a given table (in a database)

See:

* [HiveExternalCatalog](hive/HiveExternalCatalog.md#getPartition)

Used when:

* `ExternalCatalogWithListener` is requested to `getPartition`
* `SessionCatalog` is requested to [getPartition](SessionCatalog.md#getPartition)

### <span id="getPartitionOption"> getPartitionOption

```scala
getPartitionOption(
  db: String,
  table: String,
  spec: TablePartitionSpec): Option[CatalogTablePartition]
```

[CatalogTablePartition](CatalogTablePartition.md) of a given table (in a database)

See:

* [HiveExternalCatalog](hive/HiveExternalCatalog.md#getPartitionOption)

Used when:

* `ExternalCatalogWithListener` is requested to `getPartitionOption`
* `InsertIntoHiveTable` is requested to [processInsert](hive/InsertIntoHiveTable.md#processInsert)

### <span id="getTable"> getTable

```scala
getTable(
  db: String,
  table: String): CatalogTable
```

[CatalogTable](CatalogTable.md) of a given table (in a database)

See:

* [HiveExternalCatalog](hive/HiveExternalCatalog.md#getTable)

Used when:

* `ExternalCatalogWithListener` is requested to `getTable`
* `SessionCatalog` is requested to [alterTableDataSchema](SessionCatalog.md#alterTableDataSchema), [getTableRawMetadata](SessionCatalog.md#getTableRawMetadata) and [lookupRelation](SessionCatalog.md#lookupRelation)

### <span id="getTablesByName"> getTablesByName

```scala
getTablesByName(
  db: String,
  tables: Seq[String]): Seq[CatalogTable]
```

[CatalogTable](CatalogTable.md)s of the given tables (in a database)

See:

* [HiveExternalCatalog](hive/HiveExternalCatalog.md#getTablesByName)

Used when:

* `ExternalCatalogWithListener` is requested to `getTablesByName`
* `SessionCatalog` is requested to [getTablesByName](SessionCatalog.md#getTablesByName)

### <span id="listPartitionsByFilter"> listPartitionsByFilter

```scala
listPartitionsByFilter(
  db: String,
  table: String,
  predicates: Seq[Expression],
  defaultTimeZoneId: String): Seq[CatalogTablePartition]
```

[CatalogTablePartition](CatalogTablePartition.md)s

See:

* [HiveExternalCatalog](hive/HiveExternalCatalog.md#listPartitionsByFilter)

Used when:

* `ExternalCatalogWithListener` is requested to `getTablesByName`
* `SessionCatalog` is requested to [listPartitionsByFilter](SessionCatalog.md#listPartitionsByFilter)

## Implementations

* `ExternalCatalogWithListener`
* [HiveExternalCatalog](hive/HiveExternalCatalog.md)
* [InMemoryCatalog](InMemoryCatalog.md)

## Accessing ExternalCatalog

`ExternalCatalog` is available as [externalCatalog](SharedState.md#externalCatalog) of [SharedState](SparkSession.md#sharedState) (in `SparkSession`).

```text
scala> :type spark
org.apache.spark.sql.SparkSession

scala> :type spark.sharedState.externalCatalog
org.apache.spark.sql.catalyst.catalog.ExternalCatalog
```

<!---
## Review Me

[[features]]
.ExternalCatalog's Features per Relational Entity
[cols="2,^1,^1,^1,^1",options="header",width="100%"]
|===
| Feature
| Database
| Function
| Partition
| Table

| Alter
| <<alterDatabase, alterDatabase>>
| <<alterFunction, alterFunction>>
| <<alterPartitions, alterPartitions>>
| <<alterTable, alterTable>>, <<alterTableDataSchema, alterTableDataSchema>>, <<alterTableStats, alterTableStats>>

| Create
| <<createDatabase, createDatabase>>
| <<createFunction, createFunction>>
| <<createPartitions, createPartitions>>
| <<createTable, createTable>>

| Drop
| <<dropDatabase, dropDatabase>>
| <<dropFunction, dropFunction>>
| <<dropPartitions, dropPartitions>>
| <<dropTable, dropTable>>

| Get
| <<getDatabase, getDatabase>>
| <<getFunction, getFunction>>
| <<getPartition, getPartition>>, <<getPartitionOption, getPartitionOption>>
| <<getTable, getTable>>

| List
| <<listDatabases, listDatabases>>
| <<listFunctions, listFunctions>>
| <<listPartitionNames, listPartitionNames>>, <<listPartitions, listPartitions>>, <<listPartitionsByFilter, listPartitionsByFilter>>
| <<listTables, listTables>>

| Load
|
|
| <<loadDynamicPartitions, loadDynamicPartitions>>, <<loadPartition, loadPartition>>
| <<loadTable, loadTable>>

| Rename
|
| <<renameFunction, renameFunction>>
| <<renamePartitions, renamePartitions>>
| <<renameTable, renameTable>>

| Check Existence
| <<databaseExists, databaseExists>>
| <<functionExists, functionExists>>
|
| <<tableExists, tableExists>>

| Set
|
|
|
| <<setCurrentDatabase, setCurrentDatabase>>
|===

[[implementations]]
.ExternalCatalogs
[cols="1,2,2",options="header",width="100%"]
|===
| ExternalCatalog
| Alias
| Description

| [HiveExternalCatalog](hive/HiveExternalCatalog.md)
| [[hive]] `hive`
| A persistent system catalog using a Hive metastore.

| [InMemoryCatalog](InMemoryCatalog.md)
| [[in-memory]] `in-memory`
| An in-memory (ephemeral) system catalog that does not require setting up external systems (like a Hive metastore).

It is intended for testing or exploration purposes only and therefore should not be used in production.
|===

The <<implementations, concrete>> `ExternalCatalog` is chosen using SparkSession-Builder.md#enableHiveSupport[Builder.enableHiveSupport] that enables the Hive support (and sets StaticSQLConf.md#spark.sql.catalogImplementation[spark.sql.catalogImplementation] configuration property to <<hive, hive>> when the Hive classes are available).

[source, scala]
----
import org.apache.spark.sql.internal.StaticSQLConf
val catalogType = spark.conf.get(StaticSQLConf.CATALOG_IMPLEMENTATION.key)
scala> println(catalogType)
hive

scala> spark.sessionState.conf.getConf(StaticSQLConf.CATALOG_IMPLEMENTATION)
res1: String = hive
----

[TIP]
====
Set `spark.sql.catalogImplementation` to `in-memory` when starting `spark-shell` to use [InMemoryCatalog](InMemoryCatalog.md) external catalog.

[source, scala]
----
// spark-shell --conf spark.sql.catalogImplementation=in-memory

import org.apache.spark.sql.internal.StaticSQLConf
scala> spark.sessionState.conf.getConf(StaticSQLConf.CATALOG_IMPLEMENTATION)
res0: String = in-memory
----
====

[IMPORTANT]
====
You cannot change `ExternalCatalog` after `SparkSession` has been created using StaticSQLConf.md#spark.sql.catalogImplementation[spark.sql.catalogImplementation] configuration property as it is a static configuration.

[source, scala]
----
import org.apache.spark.sql.internal.StaticSQLConf
scala> spark.conf.set(StaticSQLConf.CATALOG_IMPLEMENTATION.key, "hive")
org.apache.spark.sql.AnalysisException: Cannot modify the value of a static config: spark.sql.catalogImplementation;
  at org.apache.spark.sql.RuntimeConfig.requireNonStaticConf(RuntimeConfig.scala:144)
  at org.apache.spark.sql.RuntimeConfig.set(RuntimeConfig.scala:41)
  ... 49 elided
----
====

[[addListener]]
`ExternalCatalog` is a `ListenerBus` of `ExternalCatalogEventListener` listeners that handle `ExternalCatalogEvent` events.

[TIP]
====
Use `addListener` and `removeListener` to register and de-register `ExternalCatalogEventListener` listeners, accordingly.

Read https://jaceklaskowski.gitbooks.io/mastering-apache-spark/spark-SparkListenerBus.html#ListenerBus[ListenerBus Event Bus Contract] in Mastering Apache Spark 2 gitbook to learn more about Spark Core's `ListenerBus` interface.
====

=== [[alterTableStats]] Altering Table Statistics -- `alterTableStats` Method

[source, scala]
----
alterTableStats(db: String, table: String, stats: Option[CatalogStatistics]): Unit
----

`alterTableStats`...FIXME

`alterTableStats` is used when `SessionCatalog` is requested for [altering the statistics of a table in a metastore](SessionCatalog.md#alterTableStats) (that can happen when any logical command is executed that could change the table statistics).

=== [[alterTable]] Altering Table -- `alterTable` Method

[source, scala]
----
alterTable(tableDefinition: CatalogTable): Unit
----

`alterTable`...FIXME

NOTE: `alterTable` is used exclusively when `SessionCatalog` is requested for [altering the statistics of a table in a metastore](SessionCatalog.md#alterTable).

=== [[createTable]] `createTable` Method

[source, scala]
----
createTable(tableDefinition: CatalogTable, ignoreIfExists: Boolean): Unit
----

`createTable`...FIXME

NOTE: `createTable` is used when...FIXME

=== [[alterTableDataSchema]] `alterTableDataSchema` Method

[source, scala]
----
alterTableDataSchema(db: String, table: String, newDataSchema: StructType): Unit
----

`alterTableDataSchema`...FIXME

`alterTableDataSchema` is used when `SessionCatalog` is requested to [alterTableDataSchema](SessionCatalog.md#alterTableDataSchema).
-->
