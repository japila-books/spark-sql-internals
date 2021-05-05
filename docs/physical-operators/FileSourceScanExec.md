# FileSourceScanExec Leaf Physical Operator

`FileSourceScanExec` is a [leaf physical operator](LeafExecNode.md) (as a [DataSourceScanExec](DataSourceScanExec.md)) that represents a scan over collections of files (incl. Hive tables).

`FileSourceScanExec` is <<creating-instance, created>> exclusively for a LogicalRelation.md[LogicalRelation] logical operator with a [HadoopFsRelation](../HadoopFsRelation.md) when [FileSourceStrategy](../execution-planning-strategies/FileSourceStrategy.md) execution planning strategy is executed.

```text
// Create a bucketed data source table
// It is one of the most complex examples of a LogicalRelation with a HadoopFsRelation
val tableName = "bucketed_4_id"
spark
  .range(100)
  .withColumn("part", $"id" % 2)
  .write
  .partitionBy("part")
  .bucketBy(4, "id")
  .sortBy("id")
  .mode("overwrite")
  .saveAsTable(tableName)
val q = spark.table(tableName)

val sparkPlan = q.queryExecution.executedPlan
scala> :type sparkPlan
org.apache.spark.sql.execution.SparkPlan

scala> println(sparkPlan.numberedTreeString)
00 *(1) FileScan parquet default.bucketed_4_id[id#7L,part#8L] Batched: true, Format: Parquet, Location: CatalogFileIndex[file:/Users/jacek/dev/oss/spark/spark-warehouse/bucketed_4_id], PartitionCount: 2, PartitionFilters: [], PushedFilters: [], ReadSchema: struct<id:bigint>, SelectedBucketsCount: 4 out of 4

import org.apache.spark.sql.execution.FileSourceScanExec
val scan = sparkPlan.collectFirst { case exec: FileSourceScanExec => exec }.get

scala> :type scan
org.apache.spark.sql.execution.FileSourceScanExec

scala> scan.metadata.toSeq.sortBy(_._1).map { case (k, v) => s"$k -> $v" }.foreach(println)
Batched -> true
Format -> Parquet
Location -> CatalogFileIndex[file:/Users/jacek/dev/oss/spark/spark-warehouse/bucketed_4_id]
PartitionCount -> 2
PartitionFilters -> []
PushedFilters -> []
ReadSchema -> struct<id:bigint>
SelectedBucketsCount -> 4 out of 4
```

[[inputRDDs]]
`FileSourceScanExec` uses the single <<inputRDD, input RDD>> as the [input RDDs](CodegenSupport.md#inputRDDs) (in [Whole-Stage Java Code Generation](../whole-stage-code-generation/index.md)).

When <<doExecute, executed>>, `FileSourceScanExec` operator creates a [FileScanRDD](../rdds/FileScanRDD.md) (for <<createBucketedReadRDD, bucketed>> and <<createNonBucketedReadRDD, non-bucketed reads>>).

```text
scala> :type scan
org.apache.spark.sql.execution.FileSourceScanExec

val rdd = scan.execute
scala> println(rdd.toDebugString)
(6) MapPartitionsRDD[7] at execute at <console>:28 []
 |  FileScanRDD[2] at execute at <console>:27 []

import org.apache.spark.sql.execution.datasources.FileScanRDD
assert(rdd.dependencies.head.rdd.isInstanceOf[FileScanRDD])
```

`FileSourceScanExec` supports [bucket pruning](../bucketing.md#bucket-pruning) so it only scans the bucket files required for a query.

```text
scala> :type scan
org.apache.spark.sql.execution.FileSourceScanExec

import org.apache.spark.sql.execution.datasources.FileScanRDD
val rdd = scan.inputRDDs.head.asInstanceOf[FileScanRDD]

import org.apache.spark.sql.execution.datasources.FilePartition
val bucketFiles = for {
  FilePartition(bucketId, files) <- rdd.filePartitions
  f <- files
} yield s"Bucket $bucketId => $f"

scala> println(bucketFiles.size)
51

scala> bucketFiles.foreach(println)
Bucket 0 => path: file:///Users/jacek/dev/oss/spark/spark-warehouse/bucketed_4_id/part=0/part-00004-5301d371-01c3-47d4-bb6b-76c3c94f3699_00000.c000.snappy.parquet, range: 0-423, partition values: [0]
Bucket 0 => path: file:///Users/jacek/dev/oss/spark/spark-warehouse/bucketed_4_id/part=0/part-00001-5301d371-01c3-47d4-bb6b-76c3c94f3699_00000.c000.snappy.parquet, range: 0-423, partition values: [0]
...
Bucket 3 => path: file:///Users/jacek/dev/oss/spark/spark-warehouse/bucketed_4_id/part=1/part-00005-5301d371-01c3-47d4-bb6b-76c3c94f3699_00003.c000.snappy.parquet, range: 0-423, partition values: [1]
Bucket 3 => path: file:///Users/jacek/dev/oss/spark/spark-warehouse/bucketed_4_id/part=1/part-00000-5301d371-01c3-47d4-bb6b-76c3c94f3699_00003.c000.snappy.parquet, range: 0-431, partition values: [1]
Bucket 3 => path: file:///Users/jacek/dev/oss/spark/spark-warehouse/bucketed_4_id/part=1/part-00007-5301d371-01c3-47d4-bb6b-76c3c94f3699_00003.c000.snappy.parquet, range: 0-423, partition values: [1]
```

`FileSourceScanExec` uses a `HashPartitioning` or the default `UnknownPartitioning` as the <<outputPartitioning, output partitioning scheme>>.

`FileSourceScanExec` is a <<ColumnarBatchScan, ColumnarBatchScan>> and <<supportsBatch, supports batch decoding>> only when the [FileFormat](../HadoopFsRelation.md#fileFormat) (of the <<relation, HadoopFsRelation>>) [supports it](../datasources/FileFormat.md#supportBatch).

`FileSourceScanExec` supports <<pushedDownFilters, data source filters>> that are printed out to the console (at <<logging, INFO>> logging level) and available as <<metadata, metadata>> (e.g. in web UI or spark-sql-dataset-operators.md#explain[explain]).

```text
Pushed Filters: [pushedDownFilters]
```

As a DataSourceScanExec.md[DataSourceScanExec], `FileSourceScanExec` uses *Scan* for the prefix of the DataSourceScanExec.md#nodeName[node name].

[source, scala]
----
val fileScanExec: FileSourceScanExec = ... // see the example earlier
assert(fileScanExec.nodeName startsWith "Scan")
----

.FileSourceScanExec in web UI (Details for Query)
image::images/spark-sql-FileSourceScanExec-webui-query-details.png[align="center"]

[[nodeNamePrefix]]
`FileSourceScanExec` uses *File* for DataSourceScanExec.md#nodeNamePrefix[nodeNamePrefix] (that is used for the DataSourceScanExec.md#simpleString[simple node description] in query plans).

[source, scala]
----
val fileScanExec: FileSourceScanExec = ... // see the example earlier
assert(fileScanExec.nodeNamePrefix == "File")

scala> println(fileScanExec.simpleString)
FileScan csv [id#20,name#21,city#22] Batched: false, Format: CSV, Location: InMemoryFileIndex[file:/Users/jacek/dev/oss/datasets/people.csv], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<id:string,name:string,city:string>
----

[[internal-registries]]
.FileSourceScanExec's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1m,2",options="header",width="100%"]
|===
| Name
| Description

| metadata
a| [[metadata]]

[source, scala]
----
metadata: Map[String, String]
----

Metadata

NOTE: `metadata` is part of DataSourceScanExec.md#metadata[DataSourceScanExec] contract.

| pushedDownFilters
a| [[pushedDownFilters]] [Data source filters](../Filter.md) that are <<dataFilters, dataFilters>> expressions [converted to their respective filters](../execution-planning-strategies/DataSourceStrategy.md#translateFilter)

[TIP]
====
Enable <<logging, INFO>> logging level to see <<pushedDownFilters, pushedDownFilters>> printed out to the console.

```
Pushed Filters: [pushedDownFilters]
```
====

Used when `FileSourceScanExec` is requested for the <<metadata, metadata>> and <<inputRDD, input RDD>>
|===

[[logging]]
[TIP]
====
Enable `ALL` logging level for `org.apache.spark.sql.execution.FileSourceScanExec` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.execution.FileSourceScanExec=ALL
```

Refer to spark-logging.md[Logging].
====

## Creating Instance

`FileSourceScanExec` takes the following when created:

* [[relation]] [HadoopFsRelation](../HadoopFsRelation.md)
* [[output]] Output schema [attributes](../expressions/Attribute.md)
* [[requiredSchema]] [Schema](../StructType.md)
* [[partitionFilters]] `partitionFilters` [expressions](../expressions/Expression.md)
* [[optionalBucketSet]] Bucket IDs for bucket pruning (`Option[BitSet]`)
* [[dataFilters]] `dataFilters` [expressions](../expressions/Expression.md)
* [[tableIdentifier]] Optional `TableIdentifier`

=== [[createNonBucketedReadRDD]] Creating RDD for Non-Bucketed Reads -- `createNonBucketedReadRDD` Internal Method

[source, scala]
----
createNonBucketedReadRDD(
  readFile: (PartitionedFile) => Iterator[InternalRow],
  selectedPartitions: Seq[PartitionDirectory],
  fsRelation: HadoopFsRelation): RDD[InternalRow]
----

`createNonBucketedReadRDD` calculates the maximum size of partitions (`maxSplitBytes`) based on the following properties:

* [spark.sql.files.maxPartitionBytes](../configuration-properties.md#spark.sql.files.maxPartitionBytes)

* [spark.sql.files.openCostInBytes](../configuration-properties.md#spark.sql.files.openCostInBytes)

`createNonBucketedReadRDD` sums up the size of all the files (with the extra [spark.sql.files.openCostInBytes](../configuration-properties.md#spark.sql.files.openCostInBytes)) for the given `selectedPartitions` and divides the sum by the "default parallelism" (i.e. number of CPU cores assigned to a Spark application) that gives `bytesPerCore`.

The maximum size of partitions is then the minimum of [spark.sql.files.maxPartitionBytes](../configuration-properties.md#spark.sql.files.maxPartitionBytes) and the bigger of [spark.sql.files.openCostInBytes](../configuration-properties.md#spark.sql.files.openCostInBytes) and the `bytesPerCore`.

`createNonBucketedReadRDD` prints out the following INFO message to the logs:

```text
Planning scan with bin packing, max size: [maxSplitBytes] bytes, open cost is considered as scanning [openCostInBytes] bytes.
```

For every file (as Hadoop's `FileStatus`) in every partition (as `PartitionDirectory` in the given `selectedPartitions`), `createNonBucketedReadRDD` <<getBlockLocations, gets the HDFS block locations>> to create [PartitionedFiles](../PartitionedFile.md) (possibly split per the maximum size of partitions if the [FileFormat](../HadoopFsRelation.md#fileFormat) of the [HadoopFsRelation](#fsRelation) is [splittable](../datasources/FileFormat.md#isSplitable)). The partitioned files are then sorted by number of bytes to read (aka _split size_) in decreasing order (from the largest to the smallest).

`createNonBucketedReadRDD` "compresses" multiple splits per partition if together they are smaller than the `maxSplitBytes` ("Next Fit Decreasing") that gives the necessary partitions (file blocks as [FilePartitions](../rdds/FileScanRDD.md#FilePartition)).

In the end, `createNonBucketedReadRDD` creates a [FileScanRDD](../rdds/FileScanRDD.md) (with the given `(PartitionedFile) => Iterator[InternalRow]` read function and the partitions).

`createNonBucketedReadRDD` is used when `FileSourceScanExec` physical operator is requested for the [input RDD](#inputRDD) (and neither the optional [bucketing specification](../HadoopFsRelation.md#bucketSpec) of the [HadoopFsRelation](#relation) is defined nor [bucketing is enabled](../SQLConf.md#bucketingEnabled)).

## <span id="inputRDD"> Input RDD

```scala
inputRDD: RDD[InternalRow]
```

!!! note "lazy value"
    `inputRDD` is a Scala lazy value which is computed once when accessed and cached afterwards.

`inputRDD` is an input `RDD` that is used when `FileSourceScanExec` physical operator is requested for [inputRDDs](#inputRDDs) and to [execute](#doExecute).

When created, `inputRDD` requests [HadoopFsRelation](#relation) to get the underlying [FileFormat](../HadoopFsRelation.md#fileFormat) that is in turn requested to [build a data reader with partition column values appended](../datasources/FileFormat.md#buildReaderWithPartitionValues) (with the input parameters from the properties of `HadoopFsRelation` and [pushedDownFilters](#pushedDownFilters)).

In case the `HadoopFsRelation` has [bucketing specification](../HadoopFsRelation.md#bucketSpec) specified and [bucketing support is enabled](../bucketing.md#spark.sql.sources.bucketing.enabled), `inputRDD` [creates a FileScanRDD with bucketing](#createBucketedReadRDD) (with the bucketing specification, the reader, [selectedPartitions](#selectedPartitions) and the `HadoopFsRelation` itself). Otherwise, `inputRDD` [createNonBucketedReadRDD](#createNonBucketedReadRDD).

### <span id="dynamicallySelectedPartitions"> Dynamically Selected Partitions

```scala
dynamicallySelectedPartitions: Array[PartitionDirectory]
```

!!! note "lazy value"
    `dynamicallySelectedPartitions` is a Scala lazy value which is computed once when accessed and cached afterwards.

`dynamicallySelectedPartitions`...FIXME

`dynamicallySelectedPartitions` is used when `FileSourceScanExec` is requested for [inputRDD](#inputRDD).

### <span id="selectedPartitions"> Selected Partitions

```scala
selectedPartitions: Seq[PartitionDirectory]
```

!!! note "lazy value"
    `selectedPartitions` is a Scala lazy value which is computed once when accessed and cached afterwards.

`selectedPartitions`...FIXME

=== [[outputPartitioning]] Output Partitioning Scheme -- `outputPartitioning` Attribute

[source, scala]
----
outputPartitioning: Partitioning
----

`outputPartitioning` is part of the [SparkPlan](SparkPlan.md#outputPartitioning) abstraction.

`outputPartitioning` can be one of the following:

* [HashPartitioning](Partitioning.md#HashPartitioning) (with the [bucket column names](../BucketSpec.md#bucketColumnNames) and the [number of buckets](../BucketSpec.md#numBuckets) of the [bucketing specification](../HadoopFsRelation.md#bucketSpec) of the [HadoopFsRelation](#relation)) when [bucketing is enabled](../SQLConf.md#bucketingEnabled) and the [HadoopFsRelation](#relation) has a [bucketing specification](../HadoopFsRelation.md#bucketSpec) defined

* [UnknownPartitioning](Partitioning.md#UnknownPartitioning) (with `0` partitions) otherwise

=== [[createBucketedReadRDD]] Creating FileScanRDD with Bucketing Support -- `createBucketedReadRDD` Internal Method

[source, scala]
----
createBucketedReadRDD(
  bucketSpec: BucketSpec,
  readFile: (PartitionedFile) => Iterator[InternalRow],
  selectedPartitions: Seq[PartitionDirectory],
  fsRelation: HadoopFsRelation): RDD[InternalRow]
----

`createBucketedReadRDD` prints the following INFO message to the logs:

```
Planning with [numBuckets] buckets
```

`createBucketedReadRDD` maps the available files of the input `selectedPartitions` into [PartitionedFiles](../PartitionedFile.md). For every file, `createBucketedReadRDD` <<getBlockLocations, getBlockLocations>> and <<getBlockHosts, getBlockHosts>>.

`createBucketedReadRDD` then groups the `PartitionedFiles` by bucket ID.

NOTE: Bucket ID is of the format *_0000n*, i.e. the bucket ID prefixed with up to four ``0``s.

`createBucketedReadRDD` prunes (filters out) the bucket files for the bucket IDs that are not listed in the <<optionalBucketSet, bucket IDs for bucket pruning>>.

`createBucketedReadRDD` creates a [FilePartition](../rdds/FileScanRDD.md#FilePartition) (_file block_) for every bucket ID and the (pruned) bucket `PartitionedFiles`.

In the end, `createBucketedReadRDD` creates a [FileScanRDD](../rdds/FileScanRDD.md) (with the input `readFile` for the [read function](../rdds/FileScanRDD.md#readFunction) and the file blocks (`FilePartitions`) for every bucket ID for [partitions](../rdds/FileScanRDD.md#filePartitions))

[TIP]
====
Use `RDD.toDebugString` to see `FileScanRDD` in the RDD execution plan (aka RDD lineage).

[source, scala]
----
// Create a bucketed table
spark.range(8).write.bucketBy(4, "id").saveAsTable("b1")

scala> sql("desc extended b1").where($"col_name" like "%Bucket%").show
+--------------+---------+-------+
|      col_name|data_type|comment|
+--------------+---------+-------+
|   Num Buckets|        4|       |
|Bucket Columns|   [`id`]|       |
+--------------+---------+-------+

val bucketedTable = spark.table("b1")

val lineage = bucketedTable.queryExecution.toRdd.toDebugString
scala> println(lineage)
(4) MapPartitionsRDD[26] at toRdd at <console>:26 []
 |  FileScanRDD[25] at toRdd at <console>:26 []
----
====

NOTE: `createBucketedReadRDD` is used exclusively when `FileSourceScanExec` physical operator is requested for the <<inputRDD, inputRDD>> (and the optional [bucketing specification](../HadoopFsRelation.md#bucketSpec) of the [HadoopFsRelation](#relation) is defined and [bucketing is enabled](../SQLConf.md#bucketingEnabled)).

=== [[supportsBatch]] `supportsBatch` Attribute

[source, scala]
----
supportsBatch: Boolean
----

`supportsBatch` is enabled (`true`) only when the [FileFormat](../HadoopFsRelation.md#fileFormat) (of the <<relation, HadoopFsRelation>>) [supports vectorized decoding](../datasources/FileFormat.md#supportBatch). Otherwise, `supportsBatch` is disabled (i.e. `false`).

!!! note
    [FileFormat](../datasources/FileFormat.md) does not support vectorized decoding by default (i.e. [supportBatch](../datasources/FileFormat.md#supportBatch) flag is disabled). Only [ParquetFileFormat](../datasources/parquet/ParquetFileFormat.md) and [OrcFileFormat](../datasources/orc/OrcFileFormat.md) have support for it under certain conditions.

`supportsBatch` is part of the [ColumnarBatchScan](ColumnarBatchScan.md#supportsBatch) abstraction.

=== [[ColumnarBatchScan]] FileSourceScanExec As ColumnarBatchScan

`FileSourceScanExec` is a [ColumnarBatchScan](ColumnarBatchScan.md) and <<supportsBatch, supports batch decoding>> only when the [FileFormat](../HadoopFsRelation.md#fileFormat) (of the <<relation, HadoopFsRelation>>) [supports it](../datasources/FileFormat.md#supportBatch).

`FileSourceScanExec` has <<needsUnsafeRowConversion, needsUnsafeRowConversion>> flag enabled for `ParquetFileFormat` data sources exclusively.

`FileSourceScanExec` has <<vectorTypes, vectorTypes>>...FIXME

==== [[needsUnsafeRowConversion]] `needsUnsafeRowConversion` Flag

[source, scala]
----
needsUnsafeRowConversion: Boolean
----

`needsUnsafeRowConversion` is enabled (i.e. `true`) when the following conditions all hold:

1. [FileFormat](../HadoopFsRelation.md#fileFormat) of the [HadoopFsRelation](#relation) is [ParquetFileFormat](../datasources/parquet/ParquetFileFormat.md)

1. [spark.sql.parquet.enableVectorizedReader](../configuration-properties.md#spark.sql.parquet.enableVectorizedReader) configuration property is enabled

Otherwise, `needsUnsafeRowConversion` is disabled (i.e. `false`).

NOTE: `needsUnsafeRowConversion` is used when `FileSourceScanExec` is <<doExecute, executed>> (and <<supportsBatch, supportsBatch>> flag is off).

`needsUnsafeRowConversion` is part of the [ColumnarBatchScan](ColumnarBatchScan.md#needsUnsafeRowConversion) abstraction.

==== [[vectorTypes]] Fully-Qualified Class Names (Types) of Concrete ColumnVectors -- `vectorTypes` Method

[source, scala]
----
vectorTypes: Option[Seq[String]]
----

`vectorTypes` simply requests the [FileFormat](../HadoopFsRelation.md#fileFormat) of the [HadoopFsRelation](#relation) for [vectorTypes](../datasources/FileFormat.md#vectorTypes).

`vectorTypes` is part of the [ColumnarBatchScan](ColumnarBatchScan.md#vectorTypes) abstraction.

=== [[doExecute]] Executing Physical Operator (Generating RDD[InternalRow]) -- `doExecute` Method

[source, scala]
----
doExecute(): RDD[InternalRow]
----

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute` branches off per <<supportsBatch, supportsBatch>> flag.

!!! note
    [supportsBatch](#supportsBatch) flag can be enabled for [ParquetFileFormat](../datasources/parquet/ParquetFileFormat.md) and [OrcFileFormat](../datasources/orc/OrcFileFormat.md) built-in file formats (under certain conditions).

With <<supportsBatch, supportsBatch>> flag enabled, `doExecute` creates a <<WholeStageCodegenExec.md#, WholeStageCodegenExec>> physical operator (with the `FileSourceScanExec` for the <<WholeStageCodegenExec.md#child, child physical operator>> and WholeStageCodegenExec.md#codegenStageId[codegenStageId] as `0`) and SparkPlan.md#execute[executes] it right after.

With <<supportsBatch, supportsBatch>> flag disabled, `doExecute` creates an `unsafeRows` RDD to scan over which is different per <<needsUnsafeRowConversion, needsUnsafeRowConversion>> flag.

If <<needsUnsafeRowConversion, needsUnsafeRowConversion>> flag is on, `doExecute` takes the <<inputRDD, inputRDD>> and creates a new RDD by applying a function to each partition (using `RDD.mapPartitionsWithIndexInternal`):

1. Creates a [UnsafeProjection](../expressions/UnsafeProjection.md#create) for the [schema](../catalyst/QueryPlan.md#schema)

1. Initializes the [UnsafeProjection](../expressions/Projection.md#initialize)

1. Maps over the rows in a partition iterator using the `UnsafeProjection` projection

Otherwise, `doExecute` simply takes the <<inputRDD, inputRDD>> as the `unsafeRows` RDD (with no changes).

`doExecute` takes the [numOutputRows](ColumnarBatchScan.md#numOutputRows) metric and creates a new RDD by mapping every element in the `unsafeRows` and incrementing the `numOutputRows` metric.

[TIP]
====
Use `RDD.toDebugString` to review the RDD lineage and "reverse-engineer" the values of the <<supportsBatch, supportsBatch>> and <<needsUnsafeRowConversion, needsUnsafeRowConversion>> flags given the number of RDDs.

With <<supportsBatch, supportsBatch>> off and <<needsUnsafeRowConversion, needsUnsafeRowConversion>> on you should see two more RDDs in the RDD lineage.
====

=== [[outputOrdering]] Output Data Ordering -- `outputOrdering` Attribute

[source, scala]
----
outputOrdering: Seq[SortOrder]
----

`outputOrdering` is part of the [SparkPlan](SparkPlan.md#outputOrdering) abstraction.

`outputOrdering` is a `SortOrder` expression for every [sort column](../BucketSpec.md#sortColumnNames) in `Ascending` order only when all the following hold:

* [bucketing is enabled](../SQLConf.md#bucketingEnabled)

* [HadoopFsRelation](#relation) has a [bucketing specification](../HadoopFsRelation.md#bucketSpec) defined

* All the buckets have a single file in it

Otherwise, `outputOrdering` is simply empty (`Nil`).

=== [[updateDriverMetrics]] `updateDriverMetrics` Internal Method

[source, scala]
----
updateDriverMetrics(): Unit
----

`updateDriverMetrics` updates the following <<metrics, performance metrics>>:

* <<numFiles, numFiles>> metric with the total of all the sizes of the files in the <<selectedPartitions, selectedPartitions>>

* <<metadataTime, metadataTime>> metric with the time spent in the <<selectedPartitions, selectedPartitions>>

In the end, `updateDriverMetrics` requests the `SQLMetrics` object to spark-sql-SQLMetric.md#postDriverMetricUpdates[posts the metric updates].

NOTE: `updateDriverMetrics` is used exclusively when `FileSourceScanExec` physical operator is requested for the <<inputRDD, input RDD>> (the very first time).

=== [[getBlockLocations]] `getBlockLocations` Internal Method

[source, scala]
----
getBlockLocations(file: FileStatus): Array[BlockLocation]
----

`getBlockLocations` simply requests the given Hadoop https://hadoop.apache.org/docs/r2.7.3/api/index.html?org/apache/hadoop/fs/LocatedFileStatus.html[FileStatus] for the block locations (`getBlockLocations`) if it is a Hadoop https://hadoop.apache.org/docs/r2.7.3/api/index.html?org/apache/hadoop/fs/LocatedFileStatus.html[LocatedFileStatus]. Otherwise, `getBlockLocations` returns an empty array.

NOTE: `getBlockLocations` is used when `FileSourceScanExec` physical operator is requested to <<createBucketedReadRDD, createBucketedReadRDD>> and <<createNonBucketedReadRDD, createNonBucketedReadRDD>>.

## <span id="metrics"> Performance Metrics

Key            | Name (in web UI)        | Description
---------------|-------------------------|---------
 metadataTime  | metadata time (ms)      |
 numFiles      | number of files         |
 numOutputRows | number of output rows   |
 scanTime      | scan time               |
