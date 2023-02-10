# FileTable

`FileTable` is an [extension](#contract) of the [Table](../connector/Table.md) abstraction for [file-based tables](#implementations) with support for [read](../connector/SupportsRead.md) and [write](../connector/SupportsWrite.md).

## Contract

### <span id="fallbackFileFormat"> Fallback FileFormat

```scala
fallbackFileFormat: Class[_ <: FileFormat]
```

Fallback V1 [FileFormat](FileFormat.md)

Used when `FallBackFileSourceV2` extended resolution rule is executed (to resolve an `InsertIntoStatement` with a [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md) with a `FileTable`)

### <span id="formatName"> Format Name

```scala
formatName: String
```

Name of the file table (_format_)

### <span id="inferSchema"> Schema Inference

```scala
inferSchema(
    files: Seq[FileStatus]): Option[StructType]
```

Infers schema of the given `files` (as Hadoop [FileStatus]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html)es)

Used when `FileTable` is requested for a [data schema](#dataSchema)

### <span id="supportsDataType"> supportsDataType

```scala
supportsDataType(
    dataType: DataType): Boolean = true
```

`supportsDataType` indicates whether a given [DataType](../types/DataType.md) is supported in read/write path or not.

Default: All [DataType](../types/DataType.md)s are supported by default

* `FileTable` is requested for a [schema](#schema)
* _others_ (in [FileTables](#implementations))

## Implementations

* `AvroTable`
* `CSVTable`
* `JsonTable`
* `OrcTable`
* [ParquetTable](parquet/ParquetTable.md)
* `TextTable`

## Creating Instance

`FileTable` takes the following to be created:

* <span id="sparkSession"> [SparkSession](../SparkSession.md)
* <span id="options"> Options
* <span id="paths"> Paths
* <span id="userSpecifiedSchema"> Optional user-defined [schema](../types/StructType.md) (`Option[StructType]`)

`FileTable` is an abstract class and cannot be created directly. It is created indirectly for the [concrete FileTables](#implementations).

## <span id="capabilities"> Table Capabilities

```scala
capabilities: java.util.Set[TableCapability]
```

`capabilities` is part of the [Table](../connector/Table.md#capabilities) abstraction.

---

`capabilities` are the following [TableCapabilities](../connector/TableCapability.md):

* [BATCH_READ](../connector/TableCapability.md#BATCH_READ)
* [BATCH_WRITE](../connector/TableCapability.md#BATCH_WRITE)
* [TRUNCATE](../connector/TableCapability.md#TRUNCATE)

## <span id="dataSchema"> Data Schema

```scala
dataSchema: StructType
```

`dataSchema` is a [schema](../types/StructType.md) of the data of the file-backed table

??? note "Lazy Value"
    `dataSchema` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and cached afterwards.

---

`dataSchema` is used when:

* `FileTable` is requested for a [schema](#schema)
* _others_ (in [FileTables](#implementations))

## <span id="partitioning"> Partitioning

```scala
partitioning: Array[Transform]
```

`partitioning` is part of the [Table](../connector/Table.md#partitioning) abstraction.

---

`partitioning`...FIXME

## <span id="properties"> Properties

```scala
properties: util.Map[String, String]
```

`properties` is part of the [Table](../connector/Table.md#properties) abstraction.

---

`properties` returns the [options](#options).

## <span id="schema"> Table Schema

```scala
schema: StructType
```

`schema` is part of the [Table](../connector/Table.md#schema) abstraction.

---

`schema`...FIXME

## <span id="fileIndex"> PartitioningAwareFileIndex

```scala
fileIndex: PartitioningAwareFileIndex
```

??? note "Lazy Value"
    `fileIndex` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`fileIndex` creates one of the following [PartitioningAwareFileIndex](PartitioningAwareFileIndex.md)s:

* `MetadataLogFileIndex` when reading from the results of a streaming query
* [InMemoryFileIndex](InMemoryFileIndex.md)

---

`fileIndex` is used when:

* [FileTable](FileTable.md#implementations)s are requested for [FileScanBuilder](FileScanBuilder.md#fileIndex)s
* `Dataset` is requested for the [inputFiles](../Dataset.md#inputFiles)
* `CacheManager` is requested to [lookupAndRefresh](../CacheManager.md#lookupAndRefresh)
* `FallBackFileSourceV2` is created
* `FileTable` is requested to [dataSchema](#dataSchema), [schema](#schema), [partitioning](#partitioning)
