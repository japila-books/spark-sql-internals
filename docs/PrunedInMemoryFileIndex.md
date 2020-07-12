# PrunedInMemoryFileIndex

:hadoop-version: 2.10.0
:url-hadoop-javadoc: https://hadoop.apache.org/docs/r{hadoop-version}/api

`PrunedInMemoryFileIndex` is a link:InMemoryFileIndex.adoc[InMemoryFileIndex] for a <<partitionSpec, partitioned table>> at an <<tableBasePath, HDFS location>>.

`PrunedInMemoryFileIndex` may be given the <<metadataOpsTimeNs, time of the partition metadata listing>>.

`PrunedInMemoryFileIndex` is <<creating-instance, created>> when `CatalogFileIndex` is requested to link:CatalogFileIndex.adoc#filterPartitions[filter the partitions of a partitioned table].

[[logging]]
[TIP]
====
Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.PrunedInMemoryFileIndex` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.execution.datasources.PrunedInMemoryFileIndex=ALL
```

Refer to link:spark-logging.adoc[Logging].
====

=== [[creating-instance]] Creating PrunedInMemoryFileIndex Instance

`PrunedInMemoryFileIndex` takes the following to be created:

* [[sparkSession]] link:SparkSession.md[SparkSession]
* [[tableBasePath]] Location of the Hive metastore table (as a Hadoop {url-hadoop-javadoc}/org/apache/hadoop/fs/Path.html[Path])
* [[fileStatusCache]] `FileStatusCache`
* [[partitionSpec]] `PartitionSpec` (from a Hive metastore)
* [[metadataOpsTimeNs]] Optional time of the partition metadata listing
