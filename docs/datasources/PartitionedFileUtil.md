# PartitionedFileUtil

When requested for [split files](#splitFiles) of a file ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html)), `PartitionedFileUtil` uses [isSplitable](FileFormat.md#isSplitable) property of a [FileFormat](FileFormat.md) and creates one or more [PartitionedFile](PartitionedFile.md)s.

Only when [splitable](FileFormat.md#isSplitable), a file will have as many [PartitionedFile](PartitionedFile.md)s as the number of parts of [maxSplitBytes](FilePartition.md#maxSplitBytes) size.

## <span id="splitFiles"> Split Files

```scala
splitFiles(
  sparkSession: SparkSession,
  file: FileStatus,
  filePath: Path,
  isSplitable: Boolean,
  maxSplitBytes: Long,
  partitionValues: InternalRow): Seq[PartitionedFile]
```

`splitFiles` branches off based on the given `isSplitable` flag.

If splitable, `splitFiles` uses the given `maxSplitBytes` to split the given `file` into [PartitionedFile](PartitionedFile.md)s for every part file.

Otherwise, `splitFiles` [creates a single PartitionedFile](#getPartitionedFile) for the given `file` (with the given `filePath` and `partitionValues`).

---

`splitFiles` is used when:

* `FileSourceScanExec` is requested to [createReadRDD](../physical-operators/FileSourceScanExec.md#createReadRDD)
* `FileScan` is requested for the [partitions](FileScan.md#partitions)

## <span id="getPartitionedFile"> getPartitionedFile

```scala
getPartitionedFile(
  file: FileStatus,
  filePath: Path,
  partitionValues: InternalRow): PartitionedFile
```

`getPartitionedFile` [finds the BlockLocations](#getBlockLocations) of the given `FileStatus` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html)).

`getPartitionedFile` [finds the BlockHosts](#getBlockHosts) with the `BlockLocation`s.

In the end, `getPartitionedFile` creates a [PartitionedFile](PartitionedFile.md) with the following:

Argument | Value
---------|------
[partitionValues](PartitionedFile.md#partitionValues) | The given `partitionValues`
[filePath](PartitionedFile.md#filePath) | The URI of the given `filePath`
[start](PartitionedFile.md#start) | 0
[length](PartitionedFile.md#length) | The lenght of the `file`
[locations](PartitionedFile.md#locations) | Block hosts
[modificationTime](PartitionedFile.md#modificationTime) | The modification time of the `file`
[fileSize](PartitionedFile.md#fileSize) | The size of the `file`

---

`getPartitionedFile` is used when:

* `FileSourceScanExec` is requested to [create a FileScanRDD with Bucketing Support](../physical-operators/FileSourceScanExec.md#createBucketedReadRDD)
* `PartitionedFileUtil` is requested to [splitFiles](#splitFiles)
