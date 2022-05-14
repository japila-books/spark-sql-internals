# FileIndex

`FileIndex` is an [abstraction](#contract) of [file indices](#implementations) for [root paths](#rootPaths) and [partition schema](#partitionSchema) that make up a relation.

`FileIndex` is an optimization technique that is used with a [HadoopFsRelation](HadoopFsRelation.md) to avoid expensive file listings (esp. on object storages like [Amazon S3](https://aws.amazon.com/s3/) or [Google Cloud Storage](https://cloud.google.com/storage))

## Contract

### <span id="inputFiles"> Input Files

```scala
inputFiles: Array[String]
```

File names to read when scanning this relation

Used when:

* `Dataset` is requested for [inputFiles](../Dataset.md#inputFiles)
* `HadoopFsRelation` is requested for [input files](HadoopFsRelation.md#inputFiles)

### <span id="listFiles"> Listing Files

```scala
listFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression]): Seq[PartitionDirectory]
```

File names (grouped into partitions when the data is partitioned)

Used when:

* `HiveMetastoreCatalog` is requested to [convert a HiveTableRelation to a LogicalRelation](../hive/HiveMetastoreCatalog.md#convert)
* `FileSourceScanExec` physical operator is requested for [selectedPartitions](../physical-operators/FileSourceScanExec.md#selectedPartitions)
* [OptimizeMetadataOnlyQuery](../logical-optimizations/OptimizeMetadataOnlyQuery.md) logical optimization is executed
* `FileScan` is requested for [partitions](FileScan.md#partitions)

### <span id="metadataOpsTimeNs"> Metadata Duration

```scala
metadataOpsTimeNs: Option[Long] = None
```

Metadata operation time for listing files (in nanoseconds)

Used when `FileSourceScanExec` physical operator is requested for [partitions](../physical-operators/FileSourceScanExec.md#selectedPartitions)

### <span id="partitionSchema"> Partitions

```scala
partitionSchema: StructType
```

Partition schema ([StructType](../types/StructType.md))

Used when:

* `DataSource` is requested to [getOrInferFileFormatSchema](../DataSource.md#getOrInferFileFormatSchema) and [resolve a FileFormat-based relation](../DataSource.md#resolveRelation)
* `FallBackFileSourceV2` logical resolution rule is executed
* [FileScanBuilder](FileScanBuilder.md) is created
* `FileTable` is requested for [dataSchema](../connector/FileTable.md#dataSchema) and [partitioning](../connector/FileTable.md#partitioning)

### <span id="refresh"> Refreshing Cached File Listings

```scala
refresh(): Unit
```

Refreshes the file listings that may have been cached

Used when:

* `CacheManager` is requested to [recacheByPath](../CacheManager.md#recacheByPath)
* [InsertIntoHadoopFsRelationCommand](../logical-operators/InsertIntoHadoopFsRelationCommand.md) is executed
* `LogicalRelation` logical operator is requested to [refresh](../logical-operators/LogicalRelation.md#refresh) (for a [HadoopFsRelation](HadoopFsRelation.md))

### <span id="rootPaths"> Root Paths

```scala
rootPaths: Seq[Path]
```

Root paths from which the catalog gets the files (as Hadoop `Path`s). There could be a single root path of the entire table (with partition directories) or individual partitions.

Used when:

* `HiveMetastoreCatalog` is requested for a [cached LogicalRelation](../hive/HiveMetastoreCatalog.md#getCached) (when requested to [convert a HiveTableRelation](../hive/HiveMetastoreCatalog.md#convertToLogicalRelation))
* `OptimizedCreateHiveTableAsSelectCommand` is executed
* `CacheManager` is requested to [recache by path](../CacheManager.md#recacheByPath)
* `FileSourceScanExec` physical operator is requested for the [metadata](../physical-operators/FileSourceScanExec.md#metadata) and [verboseStringWithOperatorId](../physical-operators/FileSourceScanExec.md#verboseStringWithOperatorId)
* `DDLUtils` utility is used to `verifyNotReadPath`
* [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) logical resolution rule is executed (for an `InsertIntoStatement` over a [HadoopFsRelation](HadoopFsRelation.md))
* `FileScan` is requested for a [description](FileScan.md#description)

### <span id="sizeInBytes"> Estimated Size

```scala
sizeInBytes: Long
```

Estimated size of the data of the relation (in bytes)

Used when:

* `HadoopFsRelation` is requested for the [estimated size](HadoopFsRelation.md#sizeInBytes)
* `FileScan` is requested for [statistics](FileScan.md#estimateStatistics)

## Implementations

* [CatalogFileIndex](CatalogFileIndex.md)
* [PartitioningAwareFileIndex](PartitioningAwareFileIndex.md)
