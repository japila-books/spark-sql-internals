# FileTable

`FileTable` is an [extension](#contract) of the [Table](Table.md) abstraction for [file-backed tables](#implementations) with support for [read](SupportsRead.md) and [write](SupportsWrite.md).

## Contract

### fallbackFileFormat

```scala
fallbackFileFormat: Class[_ <: FileFormat]
```

Used when...FIXME

### formatName

```scala
formatName: String
```

Used when...FIXME

### inferSchema

```scala
inferSchema(
    files: Seq[FileStatus]): Option[StructType]
```

Used when...FIXME

### supportsDataType

```scala
supportsDataType(
    dataType: DataType): Boolean = true
```

`supportsDataType` indicates whether a given [DataType](../DataType.md) is supported in read/write path or not.
All data types are supported by default.

Used when...FIXME

## Implementations

* `AvroTable`
* `CSVTable`
* `JsonTable`
* `OrcTable`
* `ParquetTable`
* `TextTable`

## Creating Instance

`FileTable` takes the following to be created:

* <span id="sparkSession"> [SparkSession](../SparkSession.md)
* <span id="options"> Case-Insensitive Map
* <span id="paths"> Paths
* <span id="userSpecifiedSchema"> Optional user-defined [schema](../StructType.md) (`Option[StructType]`)

`FileTable` is an abstract class and cannot be created directly. It is created indirectly for the [concrete FileTables](#implementations).

## capabilities

```scala
capabilities: java.util.Set[TableCapability]
```

`capabilities` is `BATCH_READ`, `BATCH_WRITE` and `TRUNCATE`.

`capabilities` is part of the [Table](Table.md#capabilities) abstraction.

## dataSchema

```scala
dataSchema: StructType
```

`dataSchema`...FIXME

`dataSchema` is used when...FIXME

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

## schema

```scala
schema: StructType
```

`schema`...FIXME

`schema` is part of the [Table](Table.md#schema) abstraction.
