# PartitioningAwareFileIndex

:hadoop-version: 2.10.0
:url-hadoop-javadoc: https://hadoop.apache.org/docs/r{hadoop-version}/api

`PartitioningAwareFileIndex` is an <<contract, extension>> of the FileIndex.md[FileIndex] contract for <<implementations, indices>> that are aware of partitioned tables.

[[contract]]
.PartitioningAwareFileIndex Contract (Abstract Methods Only)
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| leafDirToChildrenFiles
a| [[leafDirToChildrenFiles]]

[source, scala]
----
leafDirToChildrenFiles: Map[Path, Array[FileStatus]]
----

Used when `PartitioningAwareFileIndex` is requested to <<listFiles, listFiles>>, <<allFiles, allFiles>>, and <<inferPartitioning, inferPartitioning>>

| leafFiles
a| [[leafFiles]]

[source, scala]
----
leafFiles: LinkedHashMap[Path, FileStatus]
----

Used when `PartitioningAwareFileIndex` is requested for <<allFiles, all files>> and <<basePaths, base paths>>

| partitionSpec
a| [[partitionSpec]]

[source, scala]
----
partitionSpec(): PartitionSpec
----

Partition specification (partition columns, their directories as Hadoop {url-hadoop-javadoc}/org/apache/hadoop/fs/Path.html[Paths] and partition values)

Used when `PartitioningAwareFileIndex` is requested for the <<partitionSchema, partition schema>>, <<listFiles, files>>, and <<allFiles, all files>>

|===

[[implementations]]
[[extensions]]
.PartitioningAwareFileIndexes (Direct Implementations and Extensions Only)
[cols="30,70",options="header",width="100%"]
|===
| PartitioningAwareFileIndex
| Description

| InMemoryFileIndex.md[InMemoryFileIndex]
| [[InMemoryFileIndex]]

| `MetadataLogFileIndex`
| [[MetadataLogFileIndex]] Spark Structured Streaming

|===

=== [[creating-instance]] Creating PartitioningAwareFileIndex Instance

`PartitioningAwareFileIndex` takes the following to be created:

* [[sparkSession]] SparkSession.md[SparkSession]
* [[parameters]] Options for partition discovery
* [[userSpecifiedSchema]] Optional user-defined spark-sql-StructType.md[schema]
* [[fileStatusCache]] `FileStatusCache` (default: `NoopCache`)

`PartitioningAwareFileIndex` initializes the <<internal-properties, internal properties>>.

NOTE: `PartitioningAwareFileIndex` is an abstract class and cannot be created directly. It is created indirectly for the <<implementations, concrete PartitioningAwareFileIndices>>.

=== [[listFiles]] `listFiles` Method

[source, scala]
----
listFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression]): Seq[PartitionDirectory]
----

NOTE: `listFiles` is part of the FileIndex.md#listFiles[FileIndex] contract.

`listFiles`...FIXME

=== [[partitionSchema]] `partitionSchema` Method

[source, scala]
----
partitionSchema: StructType
----

NOTE: `partitionSchema` is part of the FileIndex.md#partitionSchema[FileIndex] contract.

`partitionSchema` simply returns the partition columns (as a spark-sql-StructType.md[StructType]) of the <<partitionSpec, partition specification>>.

=== [[inputFiles]] `inputFiles` Method

[source, scala]
----
inputFiles: Array[String]
----

NOTE: `inputFiles` is part of the FileIndex.md#inputFiles[FileIndex] contract.

`inputFiles` simply returns the location of <<allFiles, all the files>>.

=== [[sizeInBytes]] `sizeInBytes` Method

[source, scala]
----
sizeInBytes: Long
----

NOTE: `sizeInBytes` is part of the FileIndex.md#sizeInBytes[FileIndex] contract.

`sizeInBytes` simply sums up the length (in bytes) of <<allFiles, all the files>>.

=== [[allFiles]] `allFiles` Method

[source, scala]
----
allFiles(): Seq[FileStatus]
----

`allFiles`...FIXME

[NOTE]
====
`allFiles` is used when:

* `DataSource` is requested to spark-sql-DataSource.md#getOrInferFileFormatSchema[getOrInferFileFormatSchema], spark-sql-DataSource.md#resolveRelation[resolveRelation]

* `PartitioningAwareFileIndex` is requested to <<listFiles, listFiles>>, <<inputFiles, inputFiles>>, and <<sizeInBytes, sizeInBytes>>

* Spark Structured Streaming's `FileStreamSource` is used
====

=== [[inferPartitioning]] `inferPartitioning` Method

[source, scala]
----
inferPartitioning(): PartitionSpec
----

`inferPartitioning`...FIXME

NOTE: `inferPartitioning` is used when InMemoryFileIndex.md#partitionSpec[InMemoryFileIndex] and Spark Structured Streaming's `MetadataLogFileIndex` are requested for the <<partitionSpec, partitionSpec>>.

=== [[basePaths]] `basePaths` Internal Method

[source, scala]
----
basePaths: Set[Path]
----

`basePaths`...FIXME

NOTE: `basePaths` is used when `PartitioningAwareFileIndex` is requested to <<inferPartitioning, inferPartitioning>>.

=== [[internal-properties]] Internal Properties

[cols="30m,70",options="header",width="100%"]
|===
| Name
| Description

| hadoopConf
a| [[hadoopConf]] Hadoop {url-hadoop-javadoc}/org/apache/hadoop/conf/Configuration.html[Configuration]

|===
