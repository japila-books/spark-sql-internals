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

In the end, `maxSplitBytes` takes the minimum of the following:

* [spark.sql.files.maxPartitionBytes](../configuration-properties.md#spark.sql.files.maxPartitionBytes)
* Maximum of [filesOpenCostInBytes](../SQLConf.md#filesOpenCostInBytes) and `bytesPerCore`

---

`maxSplitBytes` is used when:

* `FileSourceScanExec` physical operator is requested to [createReadRDD](../physical-operators/FileSourceScanExec.md#createReadRDD)
* `FileScan` is requested for [partitions](FileScan.md#partitions)
