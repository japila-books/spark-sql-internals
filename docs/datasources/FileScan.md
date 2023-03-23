# FileScan

`FileScan` is an [extension](#contract) of the [Scan](../connector/Scan.md) abstraction for [scans](#implementations) in [Batch](../connector/Batch.md) queries.

## <span id="SupportsReportStatistics"> SupportsReportStatistics

`FileScan` is a [SupportsReportStatistics](../connector/SupportsReportStatistics.md).

## Contract

### <span id="dataFilters"> DataFilters

```scala
dataFilters: Seq[Expression]
```

[Expression](../expressions/Expression.md)s

Used when:

* `FileScan` is requested for [normalized DataFilters](#normalizedDataFilters), [metadata](#getMetaData), [partitions](#partitions)

### <span id="fileIndex"> FileIndex

```scala
fileIndex: PartitioningAwareFileIndex
```

[PartitioningAwareFileIndex](PartitioningAwareFileIndex.md)

### <span id="getFileUnSplittableReason"> getFileUnSplittableReason

```scala
getFileUnSplittableReason(
  path: Path): String
```

### <span id="partitionFilters"> Partition Filters

```scala
partitionFilters: Seq[Expression]
```

[Expression](../expressions/Expression.md)s

### <span id="readDataSchema"> Read Data Schema

```scala
readDataSchema: StructType
```

[StructType](../types/StructType.md)

!!! note "Three Schemas"
    Beside the read data schema of a `FileScan`, there are two others:

    1. [readPartitionSchema](#readPartitionSchema)
    1. [readSchema](#readSchema)

### <span id="readPartitionSchema"> Read Partition Schema

```scala
readPartitionSchema: StructType
```

### <span id="seqToString"> seqToString

```scala
seqToString(
  seq: Seq[Any]): String
```

### <span id="sparkSession"> sparkSession

```scala
sparkSession: SparkSession
```

[SparkSession](../SparkSession.md) associated with this `FileScan`

### <span id="withFilters"> withFilters

```scala
withFilters(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression]): FileScan
```

## Implementations

* [ParquetScan](parquet/ParquetScan.md)
* _others_

## <span id="description"> description

```scala
description(): String
```

`description` is part of the [Scan](../connector/Scan.md#description) abstraction.

---

`description`...FIXME

## <span id="planInputPartitions"> Planning Input Partitions

```scala
planInputPartitions(): Array[InputPartition]
```

`planInputPartitions` is part of the [Batch](../connector/Batch.md#planInputPartitions) abstraction.

---

`planInputPartitions` is [partitions](#partitions).

### <span id="partitions"> File Partitions

```scala
partitions: Seq[FilePartition]
```

`partitions` requests the [PartitioningAwareFileIndex](#fileIndex) for the [partition directories](PartitioningAwareFileIndex.md#listFiles) (_selectedPartitions_).

For every selected partition directory, `partitions` requests the Hadoop [FileStatus]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html)es that are [split](PartitionedFileUtil.md#splitFiles) (if [isSplitable](#isSplitable)) to [maxSplitBytes](FilePartition.md#maxSplitBytes) and sorted by size (in reversed order).

In the end, `partitions` returns the [FilePartition](FilePartition.md#getFilePartitions)s.

## <span id="estimateStatistics"> estimateStatistics

```scala
estimateStatistics(): Statistics
```

`estimateStatistics` is part of the [SupportsReportStatistics](../connector/SupportsReportStatistics.md#estimateStatistics) abstraction.

---

`estimateStatistics`...FIXME

## <span id="toBatch"> Converting to Batch

```scala
toBatch: Batch
```

`toBatch` is part of the [Scan](../connector/Scan.md#toBatch) abstraction.

---

`toBatch` is this [FileScan](#implementations).

## <span id="readSchema"> Read Schema

```scala
readSchema(): StructType
```

`readSchema` is part of the [Scan](../connector/Scan.md#readSchema) abstraction.

---

`readSchema` is the [readDataSchema](#readDataSchema) with the [readPartitionSchema](#readPartitionSchema).

## <span id="isSplitable"> isSplitable

```scala
isSplitable(
  path: Path): Boolean
```

`isSplitable` is disabled by default (`false`).

FileScan | isSplitable
---------|------------
 `AvroScan` | `true`
 [ParquetScan](parquet/ParquetScan.md) | [isSplitable](parquet/ParquetScan.md#isSplitable)

---

Used when:

* `FileScan` is requested to [getFileUnSplittableReason](#getFileUnSplittableReason) and [partitions](#partitions)

## <span id="SupportsMetadata"> SupportsMetadata

`FileScan` is a [SupportsMetadata](../connector/SupportsMetadata.md).

### <span id="getMetaData"> Metadata

```scala
getMetaData(): Map[String, String]
```

`getMetaData` is part of the [SupportsMetadata](../connector/SupportsMetadata.md#getMetaData) abstraction.

---

`getMetaData` returns the following metadata:

Name | Description
-----|------------
 `Format` | The lower-case name of this [FileScan](#implementations) (with `Scan` removed)
 `ReadSchema` | [catalogString](../types/StructType.md#catalogString) of the [Read Data Schema](#readDataSchema)
 `PartitionFilters` | [Partition Filters](#partitionFilters)
 `DataFilters` | [Data Filters](#dataFilters)
 `Location` | [PartitioningAwareFileIndex](#fileIndex) followed by [root paths](FileIndex.md#rootPaths) (with their number in the file listing up to [spark.sql.maxMetadataStringLength](../configuration-properties.md#spark.sql.maxMetadataStringLength))
