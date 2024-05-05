# FileSourceScanExec Physical Operator

`FileSourceScanExec` is a [DataSourceScanExec](DataSourceScanExec.md) that represents a scan over a [HadoopFsRelation](#relation).

## Creating Instance

`FileSourceScanExec` takes the following to be created:

* <span id="relation"> [HadoopFsRelation](../files/HadoopFsRelation.md)
* <span id="output"> Output [Attribute](../expressions/Attribute.md)s
* <span id="requiredSchema"> Required [Schema](../types/StructType.md)
* [Partition Filters](#partitionFilters)
* <span id="optionalBucketSet"> `optionalBucketSet`
* <span id="optionalNumCoalescedBuckets"> `optionalNumCoalescedBuckets`
* [Data Filters](#dataFilters)
* <span id="tableIdentifier"> `TableIdentifier`
* <span id="disableBucketedScan"> `disableBucketedScan` flag (default: `false`)

`FileSourceScanExec` is created when:

* [FileSourceStrategy](../execution-planning-strategies/FileSourceStrategy.md) execution planning strategy is executed (for [LogicalRelation](../logical-operators/LogicalRelation.md)s over a [HadoopFsRelation](../files/HadoopFsRelation.md))

### <span id="dataFilters"> Data Filters

`FileSourceScanExec` is given Data Filters ([Expression](../expressions/Expression.md)s) when [created](#creating-instance).

The Data Filters are [data columns](../files/HadoopFsRelation.md#dataSchema) of the [HadoopFsRelation](#relation) (that are not [partition columns](../files/HadoopFsRelation.md#partitionSchema) that are part of [Partition Filters](#partitionFilters)) in [FileSourceStrategy](../execution-planning-strategies/FileSourceStrategy.md) execution planning strategy.

### <span id="partitionFilters"> Partition Filters

`FileSourceScanExec` is given Partition Filters ([Expression](../expressions/Expression.md)s) when [created](#creating-instance).

The Partition Filters are the [PushedDownFilters](../execution-planning-strategies/DataSourceStrategy.md#getPushedDownFilters) (based on the [partition columns](../files/HadoopFsRelation.md#partitionSchema) of the [HadoopFsRelation](#relation)) in [FileSourceStrategy](../execution-planning-strategies/FileSourceStrategy.md) execution planning strategy.

## <span id="nodeNamePrefix"> Node Name Prefix

??? note "Signature"

    ```scala
    nodeNamePrefix: String
    ```

    `nodeNamePrefix` is part of the [DataSourceScanExec](DataSourceScanExec.md#nodeNamePrefix) abstraction.

`nodeNamePrefix` is always **File**.

```text
val fileScanExec: FileSourceScanExec = ... // see the example earlier
assert(fileScanExec.nodeNamePrefix == "File")

scala> println(fileScanExec.simpleString)
FileScan csv [id#20,name#21,city#22] Batched: false, Format: CSV, Location: InMemoryFileIndex[file:/Users/jacek/dev/oss/datasets/people.csv], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<id:string,name:string,city:string>
```

## <span id="metrics"> Performance Metrics

Key              | Name (in web UI)               | Description
-----------------|--------------------------------|---------
 filesSize       | size of files read             |
 metadataTime    | metadata time (ms)             |
 numFiles        | number of files                |
 numOutputRows   | number of output rows          |

![FileSourceScanExec in web UI (Details for Query)](../images/spark-sql-FileSourceScanExec-webui-query-details.png)

### <span id="metrics-supportsColumnar"> Columnar Scan Metrics

The following performance metrics are available only with [supportsColumnar](#supportsColumnar) enabled.

Key              | Name (in web UI)               | Description
-----------------|--------------------------------|---------
 scanTime        | scan time                      |

### <span id="metrics-partitionSchema"> Partition Scan Metrics

The following performance metrics are available only when [partitions](../files/HadoopFsRelation.md#partitionSchemaOption) are used

Key              | Name (in web UI)               | Description
-----------------|--------------------------------|---------
 numPartitions   | number of partitions read      |
 pruningTime     | dynamic partition pruning time |

### <span id="staticMetrics"> Dynamic Partition Pruning Scan Metrics

The following performance metrics are available only for [isDynamicPruningFilter](#isDynamicPruningFilter) among the [partition filters](#partitionFilters).

Key              | Name (in web UI)               | Description
-----------------|--------------------------------|---------
 staticFilesNum  | static number of files read    |
 staticFilesSize | static size of files read      |

## <span id="metadata"> Metadata

```scala
metadata: Map[String, String]
```

`metadata` is part of the [DataSourceScanExec](DataSourceScanExec.md#metadata) abstraction.

`metadata`...FIXME

## <span id="inputRDDs"> inputRDDs

```scala
inputRDDs(): Seq[RDD[InternalRow]]
```

`inputRDDs` is part of the [DataSourceScanExec](DataSourceScanExec.md#inputRDDs) abstraction.

`inputRDDs` is the single [input RDD](#inputRDD).

## <span id="inputRDD"> Input RDD

```scala
inputRDD: RDD[InternalRow]
```

!!! note "lazy value"
    `inputRDD` is a Scala lazy value which is computed once when accessed and never changes afterwards.

`inputRDD` is an input `RDD` that is used when `FileSourceScanExec` physical operator is requested for [inputRDDs](#inputRDDs) and to [execute](#doExecute).

When created, `inputRDD` requests [HadoopFsRelation](#relation) to get the underlying [FileFormat](../files/HadoopFsRelation.md#fileFormat) that is in turn requested to [build a data reader with partition column values appended](../files/FileFormat.md#buildReaderWithPartitionValues) (with the input parameters from the properties of `HadoopFsRelation` and [pushedDownFilters](#pushedDownFilters)).

In case the `HadoopFsRelation` has [bucketing specification](../files/HadoopFsRelation.md#bucketSpec) specified and [bucketing support is enabled](../bucketing/index.md#spark.sql.sources.bucketing.enabled), `inputRDD` [creates a FileScanRDD with bucketing](#createBucketedReadRDD) (with the bucketing specification, the reader, [selectedPartitions](#selectedPartitions) and the `HadoopFsRelation` itself). Otherwise, `inputRDD` [createNonBucketedReadRDD](#createNonBucketedReadRDD).

### <span id="createReadRDD"> Creating RDD for Non-Bucketed Read

```scala
createReadRDD(
  readFile: (PartitionedFile) => Iterator[InternalRow],
  selectedPartitions: Array[PartitionDirectory],
  fsRelation: HadoopFsRelation): RDD[InternalRow]
```

`createReadRDD` prints out the following INFO message to the logs (with [maxSplitBytes](../files/FilePartition.md#maxSplitBytes) hint and [openCostInBytes](../configuration-properties.md#spark.sql.files.openCostInBytes)):

```text
Planning scan with bin packing, max size: [maxSplitBytes] bytes,
open cost is considered as scanning [openCostInBytes] bytes.
```

`createReadRDD` determines whether [Bucketing](../bucketing/index.md) is enabled or not (based on [spark.sql.sources.bucketing.enabled](../configuration-properties.md#spark.sql.sources.bucketing.enabled)) for bucket pruning.

??? note "Bucket Pruning"
    **Bucket Pruning** is an optimization to filter out data files from scanning (based on [optionalBucketSet](#optionalBucketSet)).

    With [Bucketing](../bucketing/index.md) disabled or [optionalBucketSet](#optionalBucketSet) undefined, all files are included in scanning.

`createReadRDD` [splits files](../files/PartitionedFileUtil.md#splitFiles) to be scanned (in the given `selectedPartitions`), possibly applying bucket pruning (with [Bucketing](../bucketing/index.md) enabled). `createReadRDD` uses the following:

* [isSplitable](../files/FileFormat.md#isSplitable) property of the [FileFormat](../files/FileFormat.md) of the [HadoopFsRelation](#relation)
* [maxSplitBytes](../files/FilePartition.md#maxSplitBytes) hint

`createReadRDD` sorts the split files (by length in reverse order).

In the end, creates a [FileScanRDD](../rdds/FileScanRDD.md) with the following:

Property | Value
---------|------
[readFunction](../rdds/FileScanRDD.md#readFunction) | Input `readFile` function
[filePartitions](../rdds/FileScanRDD.md#filePartitions) | [Partitions](../files/FilePartition.md#getFilePartitions)
[readSchema](../rdds/FileScanRDD.md#readSchema) | [requiredSchema](#requiredSchema) with [partitionSchema](../files/HadoopFsRelation.md#partitionSchema) of the input [HadoopFsRelation](../files/HadoopFsRelation.md)
[metadataColumns](../rdds/FileScanRDD.md#metadataColumns) | [metadataColumns](#metadataColumns)

### <span id="dynamicallySelectedPartitions"> Dynamically Selected Partitions

```scala
dynamicallySelectedPartitions: Array[PartitionDirectory]
```

!!! note "lazy value"
    `dynamicallySelectedPartitions` is a Scala lazy value which is computed once when accessed and cached afterwards.

`dynamicallySelectedPartitions`...FIXME

### <span id="selectedPartitions"> Selected Partitions

```scala
selectedPartitions: Seq[PartitionDirectory]
```

!!! note "lazy value"
    `selectedPartitions` is a Scala lazy value which is computed once when accessed and cached afterwards.

`selectedPartitions`...FIXME

## <span id="bucketedScan"> bucketedScan Flag

```scala
bucketedScan: Boolean
```

!!! note "lazy value"
    `selectedPartitions` is a Scala lazy value which is computed once when accessed and cached afterwards.

`bucketedScan`...FIXME

`bucketedScan` is used when:

* FIXME

## <span id="outputOrdering"> Output Data Ordering Requirements

```scala
outputOrdering: Seq[SortOrder]
```

`outputOrdering` is part of the [SparkPlan](SparkPlan.md#outputOrdering) abstraction.

!!! danger
    Review Me

`outputOrdering` is a [SortOrder](../expressions/SortOrder.md) expression for every [sort column](../bucketing/BucketSpec.md#sortColumnNames) in `Ascending` order only when the following all hold:

* [bucketing is enabled](../SQLConf.md#bucketingEnabled)
* [HadoopFsRelation](#relation) has a [bucketing specification](../files/HadoopFsRelation.md#bucketSpec) defined
* All the buckets have a single file in it

Otherwise, `outputOrdering` is simply empty (`Nil`).

## <span id="outputPartitioning"> Output Data Partitioning Requirements

```scala
outputPartitioning: Partitioning
```

`outputPartitioning` is part of the [SparkPlan](SparkPlan.md#outputPartitioning) abstraction.

!!! danger
    Review Me

`outputPartitioning` can be one of the following:

* [HashPartitioning](Partitioning.md#HashPartitioning) (with the [bucket column names](../bucketing/BucketSpec.md#bucketColumnNames) and the [number of buckets](../bucketing/BucketSpec.md#numBuckets) of the [bucketing specification](../files/HadoopFsRelation.md#bucketSpec) of the [HadoopFsRelation](#relation)) when [bucketing is enabled](../SQLConf.md#bucketingEnabled) and the [HadoopFsRelation](#relation) has a [bucketing specification](../files/HadoopFsRelation.md#bucketSpec) defined

* [UnknownPartitioning](Partitioning.md#UnknownPartitioning) (with `0` partitions) otherwise

## <span id="vectorTypes"> Fully-Qualified Class Names of ColumnVectors

```scala
vectorTypes: Option[Seq[String]]
```

`vectorTypes` is part of the [SparkPlan](SparkPlan.md#vectorTypes) abstraction.

!!! danger
    Review Me

`vectorTypes` simply requests the [FileFormat](../files/HadoopFsRelation.md#fileFormat) of the [HadoopFsRelation](#relation) for [vectorTypes](../files/FileFormat.md#vectorTypes).

## <span id="doExecuteColumnar"> doExecuteColumnar

```scala
doExecuteColumnar(): RDD[ColumnarBatch]
```

`doExecuteColumnar` is part of the [SparkPlan](SparkPlan.md#doExecuteColumnar) abstraction.

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

---

!!! danger
    Review Me

`doExecute` branches off per [supportsBatch](#supportsBatch) flag.

!!! note
    [supportsBatch](#supportsBatch) flag can be enabled for [ParquetFileFormat](../parquet/ParquetFileFormat.md) and `OrcFileFormat` built-in file formats (under certain conditions).

With [supportsBatch](#supportsBatch) flag enabled, `doExecute` creates a [WholeStageCodegenExec](WholeStageCodegenExec.md) physical operator (with the `FileSourceScanExec` as the [child physical operator](WholeStageCodegenExec.md#child) and [codegenStageId](WholeStageCodegenExec.md#codegenStageId) as `0`) and [executes](SparkPlan.md#execute) it right after.

With [supportsBatch](#supportsBatch) flag disabled, `doExecute` creates an `unsafeRows` RDD to scan over which is different per [needsUnsafeRowConversion](#needsUnsafeRowConversion) flag.

If [needsUnsafeRowConversion](#needsUnsafeRowConversion) flag is on, `doExecute` takes the [input RDD](#inputRDD) and creates a new RDD by applying a function to each partition (using `RDD.mapPartitionsWithIndexInternal`):

1. Creates a [UnsafeProjection](../expressions/UnsafeProjection.md#create) for the [schema](../catalyst/QueryPlan.md#schema)

1. Initializes the [UnsafeProjection](../expressions/Projection.md#initialize)

1. Maps over the rows in a partition iterator using the `UnsafeProjection` projection

Otherwise, `doExecute` simply takes the [input RDD](#inputRDD) as the `unsafeRows` RDD (with no changes).

`doExecute` takes the `numOutputRows` metric and creates a new RDD by mapping every element in the `unsafeRows` and incrementing the `numOutputRows` metric.

!!! tip
    Use `RDD.toDebugString` to review the RDD lineage and "reverse-engineer" the values of the [supportsBatch](#supportsBatch) and [needsUnsafeRowConversion](#needsUnsafeRowConversion) flags given the number of RDDs.

    With [supportsBatch](#supportsBatch) off and [needsUnsafeRowConversion](#needsUnsafeRowConversion) on you should see two more RDDs in the RDD lineage.

## <span id="createBucketedReadRDD"> Creating FileScanRDD with Bucketing Support

```scala
createBucketedReadRDD(
  bucketSpec: BucketSpec,
  readFile: (PartitionedFile) => Iterator[InternalRow],
  selectedPartitions: Array[PartitionDirectory],
  fsRelation: HadoopFsRelation): RDD[InternalRow]
```

!!! danger
    Review Me

`createBucketedReadRDD` prints the following INFO message to the logs:

```text
Planning with [numBuckets] buckets
```

`createBucketedReadRDD` maps the available files of the input `selectedPartitions` into [PartitionedFiles](../files/PartitionedFile.md). For every file, `createBucketedReadRDD` [getBlockLocations](#getBlockLocations) and [getBlockHosts](#getBlockHosts).

`createBucketedReadRDD` then groups the `PartitionedFiles` by bucket ID.

!!! NOTE
    Bucket ID is of the format *_0000n*, i.e. the bucket ID prefixed with up to four ``0``s.

`createBucketedReadRDD` prunes (filters out) the bucket files for the bucket IDs that are not listed in the [bucket IDs for bucket pruning](#optionalBucketSet).

`createBucketedReadRDD` creates a [FilePartition](../rdds/FileScanRDD.md#FilePartition) (_file block_) for every bucket ID and the (pruned) bucket `PartitionedFiles`.

In the end, `createBucketedReadRDD` creates a [FileScanRDD](../rdds/FileScanRDD.md) (with the input `readFile` for the [read function](../rdds/FileScanRDD.md#readFunction) and the file blocks (`FilePartitions`) for every bucket ID for [partitions](../rdds/FileScanRDD.md#filePartitions))

!!! tip
    Use `RDD.toDebugString` to see `FileScanRDD` in the RDD execution plan (aka RDD lineage).

    ```text
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
    ```

`createBucketedReadRDD` is used when:

* `FileSourceScanExec` physical operator is requested for the [input RDD](#inputRDD) (and the optional [bucketing specification](../files/HadoopFsRelation.md#bucketSpec) of the [HadoopFsRelation](#relation) is defined and [bucketing is enabled](../SQLConf.md#bucketingEnabled))

## <span id="needsUnsafeRowConversion"> needsUnsafeRowConversion Flag

```scala
needsUnsafeRowConversion: Boolean
```

`needsUnsafeRowConversion` is enabled (i.e. `true`) when the following conditions all hold:

1. [FileFormat](../files/HadoopFsRelation.md#fileFormat) of the [HadoopFsRelation](#relation) is [ParquetFileFormat](../parquet/ParquetFileFormat.md)

1. [spark.sql.parquet.enableVectorizedReader](../configuration-properties.md#spark.sql.parquet.enableVectorizedReader) configuration property is enabled

Otherwise, `needsUnsafeRowConversion` is disabled (i.e. `false`).

`needsUnsafeRowConversion` is used when:

* `FileSourceScanExec` is [executed](#doExecute) (and [supportsBatch](#supportsBatch) flag is off)

## <span id="supportsColumnar"> supportsColumnar Flag

```scala
supportsColumnar: Boolean
```

`supportsColumnar` is part of the [SparkPlan](SparkPlan.md#supportsColumnar) abstraction.

`supportsColumnar`...FIXME

## Demo

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

As a [DataSourceScanExec](DataSourceScanExec.md), `FileSourceScanExec` uses **Scan** for the prefix of the [node name](DataSourceScanExec.md#nodeName).

```scala
val fileScanExec: FileSourceScanExec = ... // see the example earlier
assert(fileScanExec.nodeName startsWith "Scan")
```

When [executed](#doExecute), `FileSourceScanExec` operator creates a [FileScanRDD](../rdds/FileScanRDD.md) (for [bucketed](#createBucketedReadRDD) and [non-bucketed reads](#createNonBucketedReadRDD)).

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

`FileSourceScanExec` supports [bucket pruning](../bucketing/index.md#bucket-pruning) so it only scans the bucket files required for a query.

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

`FileSourceScanExec` uses a `HashPartitioning` or the default `UnknownPartitioning` as the [output partitioning scheme](#outputPartitioning).

`FileSourceScanExec` supports [data source filters](#pushedDownFilters) that are printed out to the console (at [INFO](#logging) logging level) and available as [metadata](#metadata) (e.g. in web UI or [explain](../dataset-operators.md#explain)).

```text
Pushed Filters: [pushedDownFilters]
```

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.FileSourceScanExec` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.FileSourceScanExec=ALL
```

Refer to [Logging](../spark-logging.md).
