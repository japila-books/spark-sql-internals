# FilePartition

`FilePartition` is a `Partition` ([Apache Spark]({{ book.spark_core }}/rdd/Partition)).

`FilePartition` is an [InputPartition](../connector/InputPartition.md) with a [collection of file blocks](#files) (that should be read by a single task).

`FilePartition` is used in the following:

* `FileSourceScanExec` physical operator is requested to [createBucketedReadRDD](../physical-operators/FileSourceScanExec.md#createBucketedReadRDD) and [createReadRDD](../physical-operators/FileSourceScanExec.md#createReadRDD)
* `FileScan` is requested to [plan input partitions](FileScan.md#planInputPartitions) (for [BatchScanExec](../physical-operators/BatchScanExec.md) physical operator)

## Creating Instance

`FilePartition` takes the following to be created:

* <span id="index"> Partition Index
* <span id="files"> [PartitionedFile](PartitionedFile.md)s

`FilePartition` is created when:

* `FileSourceScanExec` physical operator is requested to [createBucketedReadRDD](../physical-operators/FileSourceScanExec.md#createBucketedReadRDD)
* `FilePartition` is requested to [getFilePartitions](#getFilePartitions)

## <span id="getFilePartitions"> getFilePartitions

```scala
getFilePartitions(
  sparkSession: SparkSession,
  partitionedFiles: Seq[PartitionedFile],
  maxSplitBytes: Long): Seq[FilePartition]
```

`getFilePartitions`...FIXME

---

`getFilePartitions` is used when:

* `FileSourceScanExec` physical operator is requested to [createReadRDD](../physical-operators/FileSourceScanExec.md#createReadRDD)
* `FileScan` is requested for the [partitions](FileScan.md#partitions)

## <span id="preferredLocations"> preferredLocations

??? note "Signature"

    ```scala
    preferredLocations(): Array[String]
    ```

    `preferredLocations` is part of the [InputPartition](../connector/InputPartition.md#preferredLocations) abstraction.

`preferredLocations`...FIXME

## <span id="maxSplitBytes"> maxSplitBytes

```scala
maxSplitBytes(
  sparkSession: SparkSession,
  selectedPartitions: Seq[PartitionDirectory]): Long
```

---

`maxSplitBytes` can be adjusted based on the following configuration properties:

* [spark.sql.files.maxPartitionBytes](../configuration-properties.md#spark.sql.files.maxPartitionBytes)
* [spark.sql.files.openCostInBytes](../configuration-properties.md#spark.sql.files.openCostInBytes)
* [spark.sql.files.minPartitionNum](../configuration-properties.md#spark.sql.files.minPartitionNum) (default: [Default Parallelism of Leaf Nodes](../SparkSession.md#leafNodeDefaultParallelism))

---

`maxSplitBytes` calculates the total size of all the files (in the given `PartitionDirectory`ies) with [spark.sql.files.openCostInBytes](../configuration-properties.md#spark.sql.files.openCostInBytes) overhead added (to the size of every file).

??? note "PartitionDirectory"
    `PartitionDirectory` is a collection of `FileStatus`es ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html)) along with partition values (if there are any).

`maxSplitBytes` calculates how many bytes to allow per partition (`bytesPerCore`) that is the total size of all the files divided by [spark.sql.files.minPartitionNum](../configuration-properties.md#spark.sql.files.minPartitionNum) configuration property.

In the end, `maxSplitBytes` is [spark.sql.files.maxPartitionBytes](../configuration-properties.md#spark.sql.files.maxPartitionBytes) unless
the maximum of [spark.sql.files.openCostInBytes](../configuration-properties.md#spark.sql.files.openCostInBytes) and `bytesPerCore` is even smaller.

---

`maxSplitBytes` is used when:

* `FileSourceScanExec` physical operator is requested to [create an RDD for scanning](../physical-operators/FileSourceScanExec.md#createReadRDD) (and creates a [FileScanRDD](../rdds/FileScanRDD.md))
* `FileScan` is requested for [partitions](FileScan.md#partitions)
