# FileIndex

`FileIndex` is an [abstraction](#contract) of [file indices](#implementations) for [root paths](#rootPaths) and [partition schema](#partitionSchema) that make up a relation.

`FileIndex` is an optimization technique that is used with a [HadoopFsRelation](HadoopFsRelation.md) to avoid expensive file listings (esp. on object storages like [Amazon S3](https://aws.amazon.com/s3/) or [Google Cloud Storage](https://cloud.google.com/storage))

## Contract

### <span id="inputFiles"> inputFiles

```scala
inputFiles: Array[String]
```

File names to read when scanning this relation

Used when:

* `CatalogFileIndex` is requested for the [input files](CatalogFileIndex.md#inputFiles)
* `HadoopFsRelation` is requested for the [input files](HadoopFsRelation.md#inputFiles)

### <span id="listFiles"> listFiles

```scala
listFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression]): Seq[PartitionDirectory]
```

File names (grouped into partitions when the data is partitioned)

Used when:

* `FileSourceScanExec` physical operator is requested for [selectedPartitions](physical-operators/FileSourceScanExec.md#selectedPartitions)
* `HiveMetastoreCatalog` is requested to [inferIfNeeded](hive/HiveMetastoreCatalog.md#inferIfNeeded)
* [OptimizeMetadataOnlyQuery](logical-optimizations/OptimizeMetadataOnlyQuery.md) logical optimization is executed
* `CatalogFileIndex` is requested for the [files](CatalogFileIndex.md#listFiles)

### <span id="metadataOpsTimeNs"> metadataOpsTimeNs

```scala
metadataOpsTimeNs: Option[Long] = None
```

Metadata operation time for listing files (in nanoseconds)

Used when `FileSourceScanExec` physical operator is requested for [selectedPartitions](physical-operators/FileSourceScanExec.md#selectedPartitions)

### <span id="partitionSchema"> partitionSchema

```scala
partitionSchema: StructType
```

Partition schema ([StructType](StructType.md))

Used when:

* `CatalogFileIndex` is requested to [filterPartitions](CatalogFileIndex.md#filterPartitions)
* `DataSource` is requested to [getOrInferFileFormatSchema](spark-sql-DataSource.md#getOrInferFileFormatSchema) and [resolve a FileFormat-based relation](spark-sql-DataSource.md#resolveRelation)

### <span id="refresh"> refresh

```scala
refresh(): Unit
```

Refreshes the file listings that may have been cached

Used when:

* `CacheManager` is requested to [lookupAndRefresh](CacheManager.md#lookupAndRefresh)
* [InsertIntoHadoopFsRelationCommand](logical-operators/InsertIntoHadoopFsRelationCommand.md) is executed
* `LogicalRelation` logical operator is requested to [refresh](logical-operators/LogicalRelation.md#refresh) (for a [HadoopFsRelation](HadoopFsRelation.md))

### <span id="rootPaths"> rootPaths

```scala
rootPaths: Seq[Path]
```

Root paths from which the catalog gets the files (as Hadoop {url-hadoop-javadoc}/org/apache/hadoop/fs/Path.html[Paths]). There could be a single root path of the entire table (with partition directories) or individual partitions.

Used when:

* `HiveMetastoreCatalog` is requested for a [LogicalRelation over a HadoopFsRelation cached](hive/HiveMetastoreCatalog.md#getCached) (when requested to [convert a HiveTableRelation](hive/HiveMetastoreCatalog.md#convertToLogicalRelation))

* `CacheManager` is requested to [lookupAndRefresh](CacheManager.md#lookupAndRefresh)

* `FileSourceScanExec` physical operator is requested for the [metadata](physical-operators/FileSourceScanExec.md#metadata)

* `DDLUtils` utility is used to [verifyNotReadPath](spark-sql-DDLUtils.md#verifyNotReadPath)

* [DataSourceAnalysis](logical-analysis-rules/DataSourceAnalysis.md) logical resolution rule is executed (for a [InsertIntoTable](logical-operators/InsertIntoTable.md) with a [HadoopFsRelation](HadoopFsRelation.md))

### <span id="sizeInBytes"> Estimated Size

```scala
sizeInBytes: Long
```

Estimated size of the data of the relation (in bytes)

Used when:

* `HadoopFsRelation` is requested for the [estimated size](HadoopFsRelation.md#sizeInBytes)
* [PruneFileSourcePartitions](logical-optimizations/PruneFileSourcePartitions.md) logical optimization is executed

## Implementations

* [CatalogFileIndex](CatalogFileIndex.md)
* [PartitioningAwareFileIndex](PartitioningAwareFileIndex.md)
