# FileStatusCache

`FileStatusCache` is an [abstraction](#contract) of Spark application-wide [FileStatus Caches](#implementations) for [Partition File Metadata Caching](../partition-file-metadata-caching/index.md).

`FileStatusCache` is created using [FileStatusCache.getOrCreate](#getOrCreate) factory.

`FileStatusCache` is used to create an [InMemoryFileIndex](InMemoryFileIndex.md#fileStatusCache).

## Contract

### <span id="getLeafFiles"> getLeafFiles

```scala
getLeafFiles(
  path: Path): Option[Array[FileStatus]]
```

Default: `None` (undefined)

See:

* [SharedInMemoryCache](SharedInMemoryCache.md#getLeafFiles)

Used when:

* `InMemoryFileIndex` is requested to [listLeafFiles](InMemoryFileIndex.md#listLeafFiles)

### <span id="invalidateAll"> invalidateAll

```scala
invalidateAll(): Unit
```

See:

* [SharedInMemoryCache](SharedInMemoryCache.md#invalidateAll)

Used when:

* `CatalogFileIndex` is requested to [refresh](CatalogFileIndex.md#refresh)
* `InMemoryFileIndex` is requested to [refresh](InMemoryFileIndex.md#refresh)

### <span id="putLeafFiles"> putLeafFiles

```scala
putLeafFiles(
  path: Path,
  leafFiles: Array[FileStatus]): Unit
```

See:

* [SharedInMemoryCache](SharedInMemoryCache.md#putLeafFiles)

Used when:

* `InMemoryFileIndex` is requested to [listLeafFiles](InMemoryFileIndex.md#listLeafFiles)

## Implementations

* `NoopCache`
* [SharedInMemoryCache](SharedInMemoryCache.md)

## <span id="getOrCreate"> Looking Up FileStatusCache

```scala
getOrCreate(
  session: SparkSession): FileStatusCache
```

`getOrCreate` creates a [SharedInMemoryCache](SharedInMemoryCache.md) when all the following hold:

* [spark.sql.hive.manageFilesourcePartitions](../configuration-properties.md#spark.sql.hive.manageFilesourcePartitions) is enabled
* [spark.sql.hive.filesourcePartitionFileCacheSize](../configuration-properties.md#spark.sql.hive.filesourcePartitionFileCacheSize) is greater than `0`

`getOrCreate` requests the `SharedInMemoryCache` to [createForNewClient](SharedInMemoryCache.md#createForNewClient).

Otherwise, `getOrCreate` returns the `NoopCache` (that does no caching).

---

`getOrCreate` is used when:

* `CatalogFileIndex` is requested for the [FileStatusCache](CatalogFileIndex.md#fileStatusCache)
* `DataSource` is requested to [create an InMemoryFileIndex](../DataSource.md#createInMemoryFileIndex)
* `FileTable` is requested for the [PartitioningAwareFileIndex](FileTable.md#fileIndex) (for a non-streaming file-based datasource)
