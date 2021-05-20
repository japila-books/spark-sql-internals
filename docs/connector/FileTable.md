# FileTable

`FileTable` is an [extension](#contract) of the [Table](Table.md) abstraction for [file-backed tables](#implementations) with support for [read](SupportsRead.md) and [write](SupportsWrite.md).

## Contract

### <span id="fallbackFileFormat"> fallbackFileFormat

```scala
fallbackFileFormat: Class[_ <: FileFormat]
```

Fallback V1 [FileFormat](../datasources/FileFormat.md)

Used when `FallBackFileSourceV2` extended resolution rule is executed (to resolve an `InsertIntoStatement` with a [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md) with a `FileTable`)

### <span id="formatName"> formatName

```scala
formatName: String
```

Name of the file table (_format_)

### <span id="inferSchema"> inferSchema

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
* [ParquetTable](../datasources/parquet/ParquetTable.md)
* `TextTable`

## Creating Instance

`FileTable` takes the following to be created:

* <span id="sparkSession"> [SparkSession](../SparkSession.md)
* <span id="options"> Options
* <span id="paths"> Paths
* <span id="userSpecifiedSchema"> Optional user-defined [schema](../StructType.md) (`Option[StructType]`)

`FileTable` is an abstract class and cannot be created directly. It is created indirectly for the [concrete FileTables](#implementations).

## <span id="capabilities"> Table Capabilities

```scala
capabilities: java.util.Set[TableCapability]
```

`capabilities` are the following [TableCapabilities](TableCapability.md):

* [BATCH_READ](TableCapability.md#BATCH_READ)
* [BATCH_WRITE](TableCapability.md#BATCH_WRITE)
* [TRUNCATE](TableCapability.md#TRUNCATE)

`capabilities` is part of the [Table](Table.md#capabilities) abstraction.

## <span id="dataSchema"> dataSchema

```scala
dataSchema: StructType
```

`dataSchema` is a [schema](../StructType.md) of the data of the file-backed table

??? note "Lazy Value"
    `dataSchema` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and cached afterwards.

`dataSchema` is used when:

* `FileTable` is requested for a [schema](#schema)
* _others_ (in [FileTables](#implementations))

## fileIndex

```scala
fileIndex: PartitioningAwareFileIndex
```

`fileIndex`...FIXME

`fileIndex` is used when...FIXME

## partitioning

```scala
partitioning: Array[Transform]
```

`partitioning`...FIXME

`partitioning` is part of the [Table](Table.md#partitioning) abstraction.

## properties

```scala
properties: util.Map[String, String]
```

`properties` is simply the [options](#options).

`properties` is part of the [Table](Table.md#properties) abstraction.

## <span id="schema"> schema

```scala
schema: StructType
```

`schema`...FIXME

`schema` is part of the [Table](Table.md#schema) abstraction.
