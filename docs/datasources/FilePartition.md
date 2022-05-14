# FilePartition

## <span id="maxSplitBytes"> maxSplitBytes

```scala
maxSplitBytes(
  sparkSession: SparkSession,
  selectedPartitions: Seq[PartitionDirectory]): Long
```

`maxSplitBytes`...FIXME

`maxSplitBytes` is used when:

* `FileSourceScanExec` physical operator is requested to [createReadRDD](../physical-operators/FileSourceScanExec.md#createReadRDD)
* `FileScan` is requested for [partitions](FileScan.md#partitions)
