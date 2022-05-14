# FileScan

`FileScan` is an [extension](#contract) of the [Scan](../connector/Scan.md) abstraction for [scans](#implementations) in `Batch` queries.

`FileScan` is with `SupportsReportStatistics`.

## Contract

### <span id="dataFilters"> dataFilters

```scala
dataFilters: Seq[Expression]
```

Used when...FIXME

### <span id="fileIndex"> fileIndex

```scala
fileIndex: PartitioningAwareFileIndex
```

Used when...FIXME

### <span id="getFileUnSplittableReason"> getFileUnSplittableReason

```scala
getFileUnSplittableReason(
  path: Path): String
```

Used when...FIXME

### <span id="partitionFilters"> partitionFilters

```scala
partitionFilters: Seq[Expression]
```

Used when...FIXME

### <span id="readDataSchema"> readDataSchema

```scala
readDataSchema: StructType
```

Used when...FIXME

### <span id="readPartitionSchema"> readPartitionSchema

```scala
readPartitionSchema: StructType
```

Used when...FIXME

### <span id="seqToString"> seqToString

```scala
seqToString(
  seq: Seq[Any]): String
```

Used when...FIXME

### <span id="sparkSession"> sparkSession

```scala
sparkSession: SparkSession
```

Used when...FIXME

### <span id="withFilters"> withFilters

```scala
withFilters(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression]): FileScan
```

Used when...FIXME

## Implementations

* `AvroScan`
* `OrcScan`
* [ParquetScan](parquet/ParquetScan.md)
* `TextBasedFileScan`

## <span id="description"> description

```scala
description(): String
```

`description`...FIXME

`description` is part of the [Scan](../connector/Scan.md#description) abstraction.

## <span id="planInputPartitions"> planInputPartitions

```scala
planInputPartitions(): Array[InputPartition]
```

`planInputPartitions` is [partitions](#partitions).

`planInputPartitions` is part of the [Batch](../connector/Batch.md#planInputPartitions) abstraction.

### <span id="partitions"> FilePartitions

```scala
partitions: Seq[FilePartition]
```

`partitions` requests the [PartitioningAwareFileIndex](#fileIndex) for the [partition directories](PartitioningAwareFileIndex.md#listFiles) (_selectedPartitions_).

For every selected partition directory, `partitions` requests the Hadoop [FileStatus]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html)es that are [split](../PartitionedFileUtil.md#splitFiles) (if [isSplitable](#isSplitable)) to [maxSplitBytes](FilePartition.md#maxSplitBytes) and sorted by size (in reversed order).

In the end, `partitions` returns the [FilePartition](FilePartition.md#getFilePartitions)s.

## <span id="estimateStatistics"> estimateStatistics

```scala
estimateStatistics(): Statistics
```

`estimateStatistics`...FIXME

`estimateStatistics` is part of the [SupportsReportStatistics](../connector/SupportsReportStatistics.md#estimateStatistics) abstraction.

## <span id="toBatch"> toBatch

```scala
toBatch: Batch
```

`toBatch` is enabled (`true`) by default.

`toBatch` is part of the [Scan](../connector/Scan.md#toBatch) abstraction.

## <span id="readSchema"> readSchema

```scala
readSchema(): StructType
```

`readSchema`...FIXME

`readSchema` is part of the [Scan](../connector/Scan.md#readSchema) abstraction.

## <span id="isSplitable"> isSplitable

```scala
isSplitable(
  path: Path): Boolean
```

`isSplitable` is `false`.

Used when:

* `FileScan` is requested to [getFileUnSplittableReason](#getFileUnSplittableReason) and [partitions](#partitions)
