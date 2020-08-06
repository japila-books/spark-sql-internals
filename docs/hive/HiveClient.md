# HiveClient

`HiveClient` is the <<contract, contract>> for retrieving metadata from a Hive metastore.

NOTE: HiveClientImpl.md[HiveClientImpl] is the only available `HiveClient` in Spark SQL.

`HiveClient` offers _safe_ variants of many methods that do not report exceptions when a relational entity is not found in a Hive metastore, e.g. <<getTableOption, getTableOption>> for <<getTable, getTable>>.

[[contract]]
[source, scala]
----
package org.apache.spark.sql.hive.client

trait HiveClient {
  // only required methods that have no implementation
  // FIXME List of the methods
  def alterPartitions(
      db: String,
      table: String,
      newParts: Seq[CatalogTablePartition]): Unit
  def getTableOption(dbName: String, tableName: String): Option[CatalogTable]
  def getPartitions(
      catalogTable: CatalogTable,
      partialSpec: Option[TablePartitionSpec] = None): Seq[CatalogTablePartition]
  def getPartitionsByFilter(
      catalogTable: CatalogTable,
      predicates: Seq[Expression]): Seq[CatalogTablePartition]
  def getPartitionOption(
      table: CatalogTable,
      spec: TablePartitionSpec): Option[CatalogTablePartition]
  def renamePartitions(
      db: String,
      table: String,
      specs: Seq[TablePartitionSpec],
      newSpecs: Seq[TablePartitionSpec]): Unit
}
----

.(Subset of) HiveClient Contract
[cols="1m,2",options="header",width="100%"]
|===
| Method
| Description

| alterPartitions
| [[alterPartitions]]

| `getPartitions`
a| [[getPartitions]]

[source, scala]
----
getPartitions(
  db: String,
  table: String,
  partialSpec: Option[TablePartitionSpec]): Seq[CatalogTablePartition]
getPartitions(
  catalogTable: CatalogTable,
  partialSpec: Option[TablePartitionSpec] = None): Seq[CatalogTablePartition]
----

Returns the <<spark-sql-CatalogTablePartition.md#, CatalogTablePartition>> of a table

Used exclusively when `HiveExternalCatalog` is requested to [list the partitions of a table](HiveExternalCatalog.md#listPartitions)

| getPartitionsByFilter
| [[getPartitionsByFilter]] Used when...FIXME

| getPartitionOption
| [[getPartitionOption]] Used when...FIXME

| getTableOption
a| [[getTableOption]]

[source, scala]
----
getTableOption(
  dbName: String,
  tableName: String): Option[CatalogTable]
----

Retrieves a table metadata from a Hive metastore

Used when `HiveClient` is requested for a <<getTable, table metadata>>

| renamePartitions
| [[renamePartitions]] Used when...FIXME

| version
| [[version]] Hive version

|===

=== [[getTable]] Retrieving Table Metadata From Hive Metastore -- `getTable` Method

[source, scala]
----
getTable(
  dbName: String,
  tableName: String): CatalogTable
----

`getTable` <<getTableOption, retrieves the table metadata from a Hive metastore>> if available or throws a `NoSuchTableException`.

`getTable` is used when:

* `HiveExternalCatalog` is requested for a [table metadata](HiveExternalCatalog.md#getRawTable)

* `HiveClient` is requested for <<getPartitionOption, getPartitionOption>> or <<getPartitions, getPartitions>>

* `HiveClientImpl` is requested for HiveClientImpl.md#renamePartitions[renamePartitions] or HiveClientImpl.md#alterPartitions[alterPartitions]
