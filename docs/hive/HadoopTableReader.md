# HadoopTableReader

:hive-version: 2.3.6
:hadoop-version: 2.10.0
:url-hive-javadoc: https://hive.apache.org/javadocs/r{hive-version}/api
:url-hadoop-javadoc: https://hadoop.apache.org/docs/r{hadoop-version}/api

`HadoopTableReader` is a TableReader.md[TableReader] to create an `HadoopRDD` for scanning <<makeRDDForPartitionedTable, partitioned>> or <<makeRDDForTable, unpartitioned>> tables stored in Hadoop.

`HadoopTableReader` is used by HiveTableScanExec.md[HiveTableScanExec] physical operator when requested to HiveTableScanExec.md#doExecute[execute].

=== [[creating-instance]] Creating HadoopTableReader Instance

`HadoopTableReader` takes the following to be created:

* [[attributes]] Attributes
* [[partitionKeys]] Partition Keys (`Seq[Attribute]`)
* [[tableDesc]] Hive {url-hive-javadoc}/org/apache/hive/hcatalog/templeton/TableDesc.html[TableDesc]
* [[sparkSession]] SparkSession.md[SparkSession]
* [[hadoopConf]] Hadoop {url-hadoop-javadoc}/org/apache/hadoop/conf/Configuration.html[Configuration]

`HadoopTableReader` initializes the <<internal-properties, internal properties>>.

=== [[makeRDDForTable]] `makeRDDForTable` Method

[source, scala]
----
makeRDDForTable(
  hiveTable: HiveTable): RDD[InternalRow]
----

NOTE: `makeRDDForTable` is part of the TableReader.md#makeRDDForTable[TableReader] contract to...FIXME.

`makeRDDForTable` simply calls the private <<makeRDDForTable-private, makeRDDForTable>> with...FIXME

==== [[makeRDDForTable-private]] `makeRDDForTable` Method

[source, scala]
----
makeRDDForTable(
  hiveTable: HiveTable,
  deserializerClass: Class[_ <: Deserializer],
  filterOpt: Option[PathFilter]): RDD[InternalRow]
----

`makeRDDForTable`...FIXME

NOTE: `makeRDDForTable` is used when...FIXME

=== [[makeRDDForPartitionedTable]] `makeRDDForPartitionedTable` Method

[source, scala]
----
makeRDDForPartitionedTable(
  partitions: Seq[HivePartition]): RDD[InternalRow]
----

NOTE: `makeRDDForPartitionedTable` is part of the TableReader.md#makeRDDForPartitionedTable[TableReader] contract to...FIXME.

`makeRDDForPartitionedTable` simply calls the private <<makeRDDForPartitionedTable-private, makeRDDForPartitionedTable>> with...FIXME

==== [[makeRDDForPartitionedTable-private]] `makeRDDForPartitionedTable` Method

[source, scala]
----
makeRDDForPartitionedTable(
  partitionToDeserializer: Map[HivePartition, Class[_ <: Deserializer]],
  filterOpt: Option[PathFilter]): RDD[InternalRow]
----

`makeRDDForPartitionedTable`...FIXME

NOTE: `makeRDDForPartitionedTable` is used when...FIXME

=== [[createHadoopRdd]] Creating HadoopRDD -- `createHadoopRdd` Internal Method

[source, scala]
----
createHadoopRdd(
  tableDesc: TableDesc,
  path: String,
  inputFormatClass: Class[InputFormat[Writable, Writable]]): RDD[Writable]
----

`createHadoopRdd` <<initializeLocalJobConfFunc, initializeLocalJobConfFunc>> for the input `path` and `tableDesc`.

`createHadoopRdd` creates an `HadoopRDD` (with the <<_broadcastedHadoopConf, broadcast Hadoop Configuration>>, the input `inputFormatClass`, and the <<_minSplitsPerRDD, minimum number of partitions>>) and takes (_maps over_) the values.

NOTE: `createHadoopRdd` adds a `HadoopRDD` and a `MapPartitionsRDD` to a RDD lineage.

NOTE: `createHadoopRdd` is used when `HadoopTableReader` is requested to <<makeRDDForTable, makeRDDForTable>> and <<makeRDDForPartitionedTable, makeRDDForPartitionedTable>>.

=== [[initializeLocalJobConfFunc]] `initializeLocalJobConfFunc` Utility

[source, scala]
----
initializeLocalJobConfFunc(
  path: String,
  tableDesc: TableDesc)(
    jobConf: JobConf): Unit
----

`initializeLocalJobConfFunc`...FIXME

NOTE: `initializeLocalJobConfFunc` is used when `HadoopTableReader` is requested to <<createHadoopRdd, create an HadoopRDD>>.

=== [[internal-properties]] Internal Properties

[cols="30m,70",options="header",width="100%"]
|===
| Name
| Description

| _broadcastedHadoopConf
a| [[_broadcastedHadoopConf]] Hadoop {url-hadoop-javadoc}/org/apache/hadoop/conf/Configuration.html[Configuration] broadcast to executors

| _minSplitsPerRDD
a| [[_minSplitsPerRDD]] Minimum number of partitions for a <<createHadoopRdd, HadoopRDD>>:

* `0` for local mode
* The greatest of Hadoop's `mapreduce.job.maps` (default: `1`) and Spark Core's default minimum number of partitions for Hadoop RDDs (not higher than `2`)

|===
