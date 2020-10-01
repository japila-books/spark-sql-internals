# FileScan

`FileScan` is an [extension](#contract) of the [Scan](connector/Scan.md) abstraction for [scans](#implementations) in `Batch` queries.

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

### <span id="isSplitable"> isSplitable

```scala
isSplitable(
    path: Path): Boolean
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
* `ParquetScan`
* `TextBasedFileScan`

## <span id="description"> description

```scala
description(): String
```

`description`...FIXME

`description` is part of the [Scan](connector/Scan.md#description) abstraction.

## <span id="partitions"> partitions

```scala
partitions: Seq[FilePartition]
```

`partitions`...FIXME

`partitions` is used when `FileScan` is requested to [planInputPartitions](#planInputPartitions).

## <span id="planInputPartitions"> planInputPartitions

```scala
planInputPartitions(): Array[InputPartition]
```

`planInputPartitions`...FIXME

`planInputPartitions` is part of the [Batch](connector/Batch.md#planInputPartitions) abstraction.

## <span id="estimateStatistics"> estimateStatistics

```scala
estimateStatistics(): Statistics
```

`estimateStatistics`...FIXME

`estimateStatistics` is part of the [SupportsReportStatistics](connector/SupportsReportStatistics.md#estimateStatistics) abstraction.

## <span id="toBatch"> toBatch

```scala
toBatch: Batch
```

`toBatch` is enabled (`true`) by default.

`toBatch` is part of the [Scan](connector/Scan.md#toBatch) abstraction.

## <span id="readSchema"> readSchema

```scala
readSchema(): StructType
```

`readSchema`...FIXME

`readSchema` is part of the [Scan](connector/Scan.md#readSchema) abstraction.
