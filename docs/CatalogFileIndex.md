# CatalogFileIndex

:hadoop-version: 2.10.0
:java-version: 8
:url-hadoop-javadoc: https://hadoop.apache.org/docs/r{hadoop-version}/api
:java-api: https://docs.oracle.com/javase/{java-version}/docs/api

`CatalogFileIndex` is a FileIndex.md[FileIndex] that is <<creating-instance, created>> when:

* `HiveMetastoreCatalog` is requested to hive/HiveMetastoreCatalog.md#convertToLogicalRelation[convert a HiveTableRelation to a LogicalRelation]

* `DataSource` is requested to spark-sql-DataSource.md#resolveRelation[create a BaseRelation for a FileFormat]

=== [[creating-instance]] Creating CatalogFileIndex Instance

`CatalogFileIndex` takes the following to be created:

* [[sparkSession]] SparkSession.md[SparkSession]
* [[table]] spark-sql-CatalogTable.md[CatalogTable]
* [[sizeInBytes]] Size (in bytes)

`CatalogFileIndex` initializes the <<internal-properties, internal properties>>.

=== [[listFiles]] Partition Files -- `listFiles` Method

[source, scala]
----
listFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression]): Seq[PartitionDirectory]
----

NOTE: `listFiles` is part of the FileIndex.md#listFiles[FileIndex] contract.

`listFiles` <<filterPartitions, lists the partitions>> for the input partition filters and then requests them for the PartitioningAwareFileIndex.md#listFiles[underlying partition files].

=== [[inputFiles]] `inputFiles` Method

[source, scala]
----
inputFiles: Array[String]
----

NOTE: `inputFiles` is part of the FileIndex.md#inputFiles[FileIndex] contract.

`inputFiles` <<filterPartitions, lists all the partitions>> and then requests them for the PartitioningAwareFileIndex.md#inputFiles[input files].

=== [[rootPaths]] `rootPaths` Method

[source, scala]
----
rootPaths: Seq[Path]
----

NOTE: `rootPaths` is part of the FileIndex.md#rootPaths[FileIndex] contract.

`rootPaths` simply returns the <<baseLocation, baseLocation>> converted to a Hadoop {url-hadoop-javadoc}/org/apache/hadoop/fs/Path.html[Path].

=== [[filterPartitions]] Listing Partitions By Given Predicate Expressions -- `filterPartitions` Method

[source, scala]
----
filterPartitions(
  filters: Seq[Expression]): InMemoryFileIndex
----

`filterPartitions` requests the <<table, CatalogTable>> for the spark-sql-CatalogTable.md#partitionColumnNames[partition columns].

For a partitioned table, `filterPartitions` starts tracking time. `filterPartitions` requests the SessionState.md#catalog[SessionCatalog] for the spark-sql-SessionCatalog.md#listPartitionsByFilter[partitions by filter] and creates a PrunedInMemoryFileIndex.md[PrunedInMemoryFileIndex] (with the partition listing time).

For an unpartitioned table (no partition columns defined), `filterPartitions` simply returns a InMemoryFileIndex.md[InMemoryFileIndex] (with the <<rootPaths, rootPaths>> and no user-specified schema).

[NOTE]
====
`filterPartitions` is used when:

* `HiveMetastoreCatalog` is requested to hive/HiveMetastoreCatalog.md#convertToLogicalRelation[convert a HiveTableRelation to a LogicalRelation]

* `CatalogFileIndex` is requested to <<listFiles, listFiles>> and <<inputFiles, inputFiles>>

* spark-sql-SparkOptimizer-PruneFileSourcePartitions.md[PruneFileSourcePartitions] logical optimization is executed
====

=== [[internal-properties]] Internal Properties

[cols="30m,70",options="header",width="100%"]
|===
| Name
| Description

| baseLocation
a| [[baseLocation]] Base location (as a Java {java-api}/java/net/URI.html[URI]) as defined in the <<table, CatalogTable>> metadata (under the spark-sql-CatalogStorageFormat.md#locationUri[locationUri] of the spark-sql-CatalogTable.md#storage[storage])

Used when `CatalogFileIndex` is requested to <<filterPartitions, filter the partitions>> and for the <<rootPaths, root paths>>

| hadoopConf
a| [[hadoopConf]] Hadoop {url-hadoop-javadoc}/org/apache/hadoop/conf/Configuration.html[Configuration]

Used when `CatalogFileIndex` is requested to <<filterPartitions, filter the partitions>>

|===
