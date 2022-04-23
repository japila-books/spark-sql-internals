# ParquetTable

`ParquetTable` is a [FileTable](../../connector/FileTable.md).

## Creating Instance

`ParquetTable` takes the following to be created:

* <span id="name"> Name
* <span id="sparkSession"> [SparkSession](../../SparkSession.md)
* <span id="options"> Case-insensitive options
* <span id="paths"> Paths
* <span id="userSpecifiedSchema"> User-specified [schema](../../types/StructType.md)
* <span id="fallbackFileFormat"> Fallback [FileFormat](../FileFormat.md)

`ParquetTable` is created when:

* `ParquetDataSourceV2` is requested to [getTable](ParquetDataSourceV2.md#getTable)

## <span id="formatName"> formatName

```scala
formatName: String
```

`formatName` is `Parquet`.

`formatName` is part of the [FileTable](../../connector/FileTable.md#formatName) abstraction.

## <span id="inferSchema"> inferSchema

```scala
inferSchema(
  files: Seq[FileStatus]): Option[StructType]
```

`inferSchema` [infers the schema](ParquetUtils.md#inferSchema) (with the [options](#options) and the input Hadoop `FileStatus`es).

`inferSchema` is part of the [FileTable](../../connector/FileTable.md#inferSchema) abstraction.

## <span id="newScanBuilder"> newScanBuilder

```scala
newScanBuilder(
  options: CaseInsensitiveStringMap): ParquetScanBuilder
```

`newScanBuilder` creates a [ParquetScanBuilder](ParquetScanBuilder.md) (with the [fileIndex](../../connector/FileTable.md#fileIndex), the [schema](../../connector/FileTable.md#schema) and the [dataSchema](../../connector/FileTable.md#dataSchema)).

`newScanBuilder` is part of the [FileTable](../../connector/FileTable.md#newScanBuilder) abstraction.

## <span id="newWriteBuilder"> newWriteBuilder

```scala
newWriteBuilder(
  info: LogicalWriteInfo): WriteBuilder
```

`newWriteBuilder` creates a [WriteBuilder](../../connector/WriteBuilder.md) with [build](../../connector/WriteBuilder.md#build) that, when executed, creates a [ParquetWrite](ParquetWrite.md).

`newWriteBuilder` is part of the [FileTable](../../connector/FileTable.md#newWriteBuilder) abstraction.
