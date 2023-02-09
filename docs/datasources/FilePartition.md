# FilePartition

## <span id="maxSplitBytes"> maxSplitBytes

```scala
maxSplitBytes(
  sparkSession: SparkSession,
  selectedPartitions: Seq[PartitionDirectory]): Long
```

`maxSplitBytes` reads the following properties:

* [spark.sql.files.maxPartitionBytes](../configuration-properties.md#spark.sql.files.maxPartitionBytes)
* [spark.sql.files.openCostInBytes](../configuration-properties.md#spark.sql.files.openCostInBytes)
* [spark.sql.files.minPartitionNum](../configuration-properties.md#spark.sql.files.minPartitionNum) (default: [Default Parallelism of Leaf Nodes](../SparkSession.md#leafNodeDefaultParallelism))

`maxSplitBytes` uses the given `selectedPartitions` to calculate `totalBytes` based on the size of the files with [spark.sql.files.openCostInBytes](../configuration-properties.md#spark.sql.files.openCostInBytes) added (for each file).

`maxSplitBytes` calculates `bytesPerCore` to be `totalBytes` divided by [filesMinPartitionNum](../SQLConf.md#filesMinPartitionNum).

In the end, `maxSplitBytes` is [spark.sql.files.maxPartitionBytes](../configuration-properties.md#spark.sql.files.maxPartitionBytes) unless
the maximum of [spark.sql.files.openCostInBytes](../configuration-properties.md#spark.sql.files.openCostInBytes) and `bytesPerCore` is even smaller.

---

`maxSplitBytes` is used when:

* `FileSourceScanExec` physical operator is requested to [createReadRDD](../physical-operators/FileSourceScanExec.md#createReadRDD) (and creates a [FileScanRDD](../rdds/FileScanRDD.md))
* `FileScan` is requested for [partitions](FileScan.md#partitions)
