# WriteTaskStatsTracker

`WriteTaskStatsTracker` is an [abstraction](#contract) of [WriteTaskStatsTrackers](#implementations) that are notified about and can collect the [WriteTaskStats](#getFinalStats) about [files](#newFile), [partitions](#newPartition) and [rows](#newRow) processed.

## Contract

### <span id="closeFile"> Closing File

```scala
closeFile(
  filePath: String): Unit
```

Used when:

* `FileFormatDataWriter` is requested to [releaseCurrentWriter](FileFormatDataWriter.md#releaseCurrentWriter)

### <span id="getFinalStats"> Final WriteTaskStats

```scala
getFinalStats(
  taskCommitTime: Long): WriteTaskStats
```

Creates a [WriteTaskStats](WriteTaskStats.md)

Used when:

* `FileFormatDataWriter` is requested to [commit a successful write](FileFormatDataWriter.md#commit)

### <span id="newFile"> New File

```scala
newFile(
  filePath: String): Unit
```

Used when:

* `SingleDirectoryDataWriter` is requested to [newOutputWriter](SingleDirectoryDataWriter.md#newOutputWriter)
* `BaseDynamicPartitionDataWriter` is requested to [renewCurrentWriter](BaseDynamicPartitionDataWriter.md#renewCurrentWriter)

### <span id="newPartition"> New Partition

```scala
newPartition(
  partitionValues: InternalRow): Unit
```

Used when:

* `DynamicPartitionDataSingleWriter` is requested to [write out a record](DynamicPartitionDataSingleWriter.md#write)
* `DynamicPartitionDataConcurrentWriter` is requested to [write out a record](DynamicPartitionDataConcurrentWriter.md#write)

### <span id="newRow"> New Row

```scala
newRow(
  filePath: String,
  row: InternalRow): Unit
```

Used when:

* `SingleDirectoryDataWriter` is requested to [write out a record](SingleDirectoryDataWriter.md#write)
* `BaseDynamicPartitionDataWriter` is requested to [write a record out](BaseDynamicPartitionDataWriter.md#writeRecord)

## Implementations

* [BasicWriteTaskStatsTracker](BasicWriteTaskStatsTracker.md)
