# FileIndex

:hadoop-version: 2.10.0
:url-hadoop-javadoc: https://hadoop.apache.org/docs/r{hadoop-version}/api

`FileIndex` is the <<contract, abstraction>> of <<implementations, file indices>> that knows the <<rootPaths, root paths>> and <<partitionSchema, partition schema>> of a relation.

`FileIndex` is associated with a spark-sql-BaseRelation-HadoopFsRelation.md[HadoopFsRelation].

[[contract]]
.FileIndex Contract
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| inputFiles
a| [[inputFiles]]

[source, scala]
----
inputFiles: Array[String]
----

File names to read when scanning this relation

Used when:

* `CatalogFileIndex` is requested for the CatalogFileIndex.md#inputFiles[input files]

* `HadoopFsRelation` is requested for the spark-sql-BaseRelation-HadoopFsRelation.md#inputFiles[input files]

| listFiles
a| [[listFiles]]

[source, scala]
----
listFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression]): Seq[PartitionDirectory]
----

File names (grouped into partitions when the data is partitioned)

Used when:

* `FileSourceScanExec` physical operator is requested for spark-sql-SparkPlan-FileSourceScanExec.md#selectedPartitions[selectedPartitions]

* `HiveMetastoreCatalog` is requested to hive/HiveMetastoreCatalog.md#inferIfNeeded[inferIfNeeded]

* spark-sql-SparkOptimizer-OptimizeMetadataOnlyQuery.md[OptimizeMetadataOnlyQuery] logical optimization is executed

* `CatalogFileIndex` is requested for the CatalogFileIndex.md#listFiles[files]

| metadataOpsTimeNs
a| [[metadataOpsTimeNs]]

[source, scala]
----
metadataOpsTimeNs: Option[Long] = None
----

Metadata operation time for listing files (in nanoseconds)

Used when `FileSourceScanExec` leaf physical operator is requested for <<spark-sql-SparkPlan-FileSourceScanExec.md#selectedPartitions, selectedPartitions>>

| partitionSchema
a| [[partitionSchema]]

[source, scala]
----
partitionSchema: StructType
----

Used when:

* `CatalogFileIndex` is requested to <<CatalogFileIndex.md#filterPartitions, filterPartitions>>

* `DataSource` is requested to <<spark-sql-DataSource.md#getOrInferFileFormatSchema, getOrInferFileFormatSchema>> and <<spark-sql-DataSource.md#resolveRelation, resolve a FileFormat-based relation>>

| refresh
a| [[refresh]]

[source, scala]
----
refresh(): Unit
----

Refreshes cached file listings

Used when:

* `CacheManager` is requested to <<spark-sql-CacheManager.md#lookupAndRefresh, lookupAndRefresh>>

* <<spark-sql-LogicalPlan-InsertIntoHadoopFsRelationCommand.md#, InsertIntoHadoopFsRelationCommand>> is executed

* `LogicalRelation` leaf logical operator is requested to <<spark-sql-LogicalPlan-LogicalRelation.md#refresh, refresh>> (for a <<spark-sql-BaseRelation-HadoopFsRelation.md#, HadoopFsRelation>>)

| rootPaths
a| [[rootPaths]]

[source, scala]
----
rootPaths: Seq[Path]
----

Root paths from which the catalog gets the files (as Hadoop {url-hadoop-javadoc}/org/apache/hadoop/fs/Path.html[Paths]). There could be a single root path of the entire table (with partition directories) or individual partitions.

Used when:

* `HiveMetastoreCatalog` is requested for a hive/HiveMetastoreCatalog.md#getCached[LogicalRelation over a HadoopFsRelation cached] (when requested to hive/HiveMetastoreCatalog.md#convertToLogicalRelation[convert a HiveTableRelation])

* `CacheManager` is requested to spark-sql-CacheManager.md#lookupAndRefresh[lookupAndRefresh]

* `FileSourceScanExec` physical operator is requested for the spark-sql-SparkPlan-FileSourceScanExec.md#metadata[metadata]

* `DDLUtils` utility is used to spark-sql-DDLUtils.md#verifyNotReadPath[verifyNotReadPath]

* spark-sql-Analyzer-DataSourceAnalysis.md[DataSourceAnalysis] logical resolution rule is executed (for a InsertIntoTable.md[InsertIntoTable] with a spark-sql-BaseRelation-HadoopFsRelation.md[HadoopFsRelation])

| sizeInBytes
a| [[sizeInBytes]]

[source, scala]
----
sizeInBytes: Long
----

Estimated size of the data of the relation (in bytes)

Used when:

* `HadoopFsRelation` is requested for the <<spark-sql-BaseRelation-HadoopFsRelation.md#sizeInBytes, estimated size>>

* spark-sql-SparkOptimizer-PruneFileSourcePartitions.md[PruneFileSourcePartitions] logical optimization is executed

|===

[[implementations]]
.FileIndexes (Direct Implementations and Extensions Only)
[cols="30,70",options="header",width="100%"]
|===
| FileIndex
| Description

| CatalogFileIndex.md[CatalogFileIndex]
| [[CatalogFileIndex]]

| PartitioningAwareFileIndex.md[PartitioningAwareFileIndex]
| [[PartitioningAwareFileIndex]]

|===
