# CatalogFileIndex

`CatalogFileIndex` is a [FileIndex](FileIndex.md).

## Creating Instance

`CatalogFileIndex` takes the following to be created:

* <span id="sparkSession"> [SparkSession](SparkSession.md)
* <span id="table"> [CatalogTable](CatalogTable.md)
* <span id="sizeInBytes"> Estimated Size

`CatalogFileIndex` is created when:

* `HiveMetastoreCatalog` is requested to [convert a HiveTableRelation to a LogicalRelation](hive/HiveMetastoreCatalog.md#convertToLogicalRelation)
* `DataSource` is requested to [create a BaseRelation for a FileFormat](DataSource.md#resolveRelation)

## <span id="listFiles"> Listing Files

```scala
listFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression]): Seq[PartitionDirectory]
```

`listFiles` [lists the partitions](#filterPartitions) for the input partition filters and then requests them for the [underlying partition files](PartitioningAwareFileIndex.md#listFiles).

`listFiles` is part of the [FileIndex](FileIndex.md#listFiles) abstraction.

## <span id="inputFiles"> Input Files

```scala
inputFiles: Array[String]
```

`inputFiles` [lists all the partitions](#filterPartitions) and then requests them for the [input files](PartitioningAwareFileIndex.md#inputFiles).

`inputFiles` is part of the [FileIndex](FileIndex.md#inputFiles) abstraction.

## <span id="rootPaths"> Root Paths

```scala
rootPaths: Seq[Path]
```

`rootPaths` returns the [base location](#baseLocation) converted to a Hadoop [Path]({{ hadoop.javadoc }}/org/apache/hadoop/fs/Path.html).

`rootPaths` is part of the [FileIndex](FileIndex.md#rootPaths) abstraction.

## <span id="filterPartitions"> Listing Partitions By Given Predicate Expressions

```scala
filterPartitions(
  filters: Seq[Expression]): InMemoryFileIndex
```

`filterPartitions` requests the [CatalogTable](#table) for the [partition columns](CatalogTable.md#partitionColumnNames).

For a partitioned table, `filterPartitions` starts tracking time. `filterPartitions` requests the [SessionCatalog](SessionState.md#catalog) for the [partitions by filter](SessionCatalog.md#listPartitionsByFilter) and creates a [PrunedInMemoryFileIndex](PrunedInMemoryFileIndex.md) (with the partition listing time).

For an unpartitioned table (no partition columns defined), `filterPartitions` simply returns a [InMemoryFileIndex](InMemoryFileIndex.md) (with the [base location](#rootPaths) and no user-specified schema).

`filterPartitions` is used when:

* `HiveMetastoreCatalog` is requested to [convert a HiveTableRelation to a LogicalRelation](hive/HiveMetastoreCatalog.md#convertToLogicalRelation)
* `CatalogFileIndex` is requested to [listFiles](#listFiles) and [inputFiles](#inputFiles)
* [PruneFileSourcePartitions](logical-optimizations/PruneFileSourcePartitions.md) logical optimization is executed

## Internal Properties

### <span id="baseLocation"> Base Location

Base location (as a Java [URI]({{ java.javadoc }}/java/net/URI.html)) as defined in the [CatalogTable](#table) metadata (under the [locationUri](spark-sql-CatalogStorageFormat.md#locationUri) of the [storage](CatalogTable.md#storage))

Used when `CatalogFileIndex` is requested to [filter the partitions](#filterPartitions) and for the [root paths](#rootPaths)

### <span id="hadoopConf"> Hadoop Configuration

Hadoop [Configuration]({{ hadoop.javadoc }}/org/apache/hadoop/conf/Configuration.html)

Used when `CatalogFileIndex` is requested to [filter the partitions](#filterPartitions)
