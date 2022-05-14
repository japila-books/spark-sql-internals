# InMemoryFileIndex

`InMemoryFileIndex` is a [PartitioningAwareFileIndex](PartitioningAwareFileIndex.md).

## Creating Instance

`InMemoryFileIndex` takes the following to be created:

* <span id="sparkSession"> [SparkSession](../SparkSession.md)
* <span id="rootPathsSpecified"> Root Paths (as Hadoop [Paths]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html))
* <span id="parameters"> Parameters (`Map[String, String]`)
* <span id="userSpecifiedSchema"> User-Defined Schema (`Option[StructType]`)
* <span id="fileStatusCache"> `FileStatusCache` (default: `NoopCache`)
* <span id="userSpecifiedPartitionSpec"> User-Defined Partition Spec (default: `undefined`)
* <span id="metadataOpsTimeNs"> `metadataOpsTimeNs` (`Option[Long]`, default: `undefined`)

While being created, `InMemoryFileIndex` [refresh0](#refresh0).

`InMemoryFileIndex` is created when:

* `HiveMetastoreCatalog` is requested to [inferIfNeeded](../hive/HiveMetastoreCatalog.md#inferIfNeeded)
* `CatalogFileIndex` is requested for the [partitions by the given predicate expressions](CatalogFileIndex.md#filterPartitions) for a non-partitioned Hive table
* `DataSource` is requested to [createInMemoryFileIndex](../DataSource.md#createInMemoryFileIndex)
* `FileTable` is requested for a [PartitioningAwareFileIndex](../connector/FileTable.md#fileIndex)

## <span id="refresh"> Refreshing Cached File Listings

```scala
refresh(): Unit
```

`refresh` requests the [FileStatusCache](#fileStatusCache) to `invalidateAll` and then [refresh0](#refresh0).

`refresh` is part of the [FileIndex](FileIndex.md#refresh) abstraction.

## <span id="refresh0"> Refreshing Cached File Listings (Internal)

```scala
refresh0(): Unit
```

`refresh0`...FIXME

`refresh0` is used when `InMemoryFileIndex` is [created](#creating-instance) and requested to [refresh](#refresh).

## <span id="rootPaths"> Root Paths

```scala
rootPaths: Seq[Path]
```

The [root paths](#rootPathsSpecified) with streaming metadata directories and files filtered out (e.g. `_spark_metadata` streaming metadata directories).

`rootPaths` is part of the [FileIndex](FileIndex.md#rootPaths) abstraction.
