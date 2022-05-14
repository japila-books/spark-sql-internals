# PartitioningAwareFileIndex

`PartitioningAwareFileIndex` is an [extension](#contract) of the [FileIndex](FileIndex.md) abstraction for [indices](#implementations) that are aware of partitioned tables.

## Contract

### <span id="leafDirToChildrenFiles"> leafDirToChildrenFiles

```scala
leafDirToChildrenFiles: Map[Path, Array[FileStatus]]
```

Used for [files matching filters](#listFiles), [all files](#allFiles) and [infer partitioning](#inferPartitioning)

### <span id="leafFiles"> Leaf Files

```scala
leafFiles: mutable.LinkedHashMap[Path, FileStatus]
```

Used for [all files](#allFiles) and [base locations](#basePaths)

### <span id="partitionSpec"> PartitionSpec

```scala
partitionSpec(): PartitionSpec
```

Partition specification with partition columns and values, and directories (as Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html)s)

Used for a [partition schema](#partitionSchema), to [list the files matching filters](#listFiles) and [all files](#allFiles)

## Implementations

* [InMemoryFileIndex](InMemoryFileIndex.md)
* `MetadataLogFileIndex` ([Spark Structured Streaming]({{ book.structured_streaming }}/datasources/file/MetadataLogFileIndex))

## Creating Instance

`PartitioningAwareFileIndex` takes the following to be created:

* <span id="sparkSession"> [SparkSession](../SparkSession.md)
* <span id="parameters"> Options for partition discovery (`Map[String, String]`)
* <span id="userSpecifiedSchema"> Optional User-Defined [Schema](../types/StructType.md)
* <span id="fileStatusCache"> `FileStatusCache` (default: `NoopCache`)

??? note "Abstract Class"
    `PartitioningAwareFileIndex` is an abstract class and cannot be created directly. It is created indirectly for the [concrete PartitioningAwareFileIndexes](#implementations).

## <span id="allFiles"> All Files

```scala
allFiles(): Seq[FileStatus]
```

`allFiles`...FIXME

`allFiles` is used when:

* `DataSource` is requested to [getOrInferFileFormatSchema](../DataSource.md#getOrInferFileFormatSchema) and [resolveRelation](../DataSource.md#resolveRelation)
* `PartitioningAwareFileIndex` is requested for [files matching filters](#listFiles), [input files](#inputFiles), and [size](#sizeInBytes)
* `FileTable` is requested for a [data schema](../connector/FileTable.md#dataSchema)

## <span id="listFiles"> Files Matching Filters

```scala
listFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression]): Seq[PartitionDirectory]
```

`listFiles`...FIXME

`listFiles` is part of the [FileIndex](FileIndex.md#listFiles) abstraction.

## <span id="partitionSchema"> Partition Schema

```scala
partitionSchema: StructType
```

`partitionSchema` gives the `partitionColumns` of the [partition specification](#partitionSpec).

`partitionSchema` is part of the [FileIndex](FileIndex.md#partitionSchema) abstraction.

## <span id="inputFiles"> Input Files

```scala
inputFiles: Array[String]
```

`inputFiles` requests [all the files](#allFiles) for their location (as Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html)s converted to `String`s).

`inputFiles` is part of the [FileIndex](FileIndex.md#inputFiles) abstraction.

## <span id="sizeInBytes"> Size

```scala
sizeInBytes: Long
```

`sizeInBytes` sums up the length (in bytes) of [all the files](#allFiles).

`sizeInBytes` is part of the [FileIndex](FileIndex.md#sizeInBytes) abstraction.

## <span id="inferPartitioning"> Inferring Partitioning

```scala
inferPartitioning(): PartitionSpec
```

`inferPartitioning`...FIXME

`inferPartitioning` is used by the [PartitioningAwareFileIndexes](#implementations).

## <span id="basePaths"> Base Locations

```scala
basePaths: Set[Path]
```

`basePaths`...FIXME

`basePaths` is used to [infer partitioning](#inferPartitioning).
