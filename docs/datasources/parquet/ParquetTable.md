# ParquetTable

`ParquetTable` is a [FileTable](../FileTable.md) of [ParquetDataSourceV2](ParquetDataSourceV2.md) in [Parquet Data Source](index.md).

`ParquetTable` uses [ParquetScanBuilder](#newScanBuilder) for scanning and [ParquetWrite](#newWriteBuilder) for writing.

## Creating Instance

`ParquetTable` takes the following to be created:

* <span id="name"> Name
* <span id="sparkSession"> [SparkSession](../../SparkSession.md)
* <span id="options"> Case-insensitive options
* <span id="paths"> Paths
* <span id="userSpecifiedSchema"> User-specified [schema](../../types/StructType.md)
* <span id="fallbackFileFormat"> Fallback [FileFormat](../FileFormat.md)

`ParquetTable` is created when:

* `ParquetDataSourceV2` is requested for a [Table](ParquetDataSourceV2.md#getTable)

## <span id="formatName"> Format Name

??? note "Signature"

    ```scala
    formatName: String
    ```

    `formatName` is part of the [FileTable](../FileTable.md#formatName) abstraction.

`formatName` is the following text:

```text
Parquet
```

## <span id="inferSchema"> Schema Inference

??? note "Signature"

    ```scala
    inferSchema(
      files: Seq[FileStatus]): Option[StructType]
    ```

    `inferSchema` is part of the [FileTable](../FileTable.md#inferSchema) abstraction.

`inferSchema` [infers the schema](ParquetUtils.md#inferSchema) (with the [options](#options) and the input Hadoop `FileStatus`es).

## <span id="newScanBuilder"> Creating ScanBuilder

??? note "Signature"

    ```scala
    newScanBuilder(
      options: CaseInsensitiveStringMap): ParquetScanBuilder
    ```

    `newScanBuilder` is part of the [SupportsRead](../../connector/SupportsRead.md#newScanBuilder) abstraction.

`newScanBuilder` creates a [ParquetScanBuilder](ParquetScanBuilder.md) with the following:

* [fileIndex](../FileTable.md#fileIndex)
* [schema](../FileTable.md#schema)
* [dataSchema](../FileTable.md#dataSchema)
* [options](#options)

## <span id="newWriteBuilder"> Creating WriteBuilder

??? note "Signature"

    ```scala
    newWriteBuilder(
      info: LogicalWriteInfo): WriteBuilder
    ```

    `newWriteBuilder` is part of the [SupportsWrite](../../connector/SupportsWrite.md#newWriteBuilder) abstraction.

`newWriteBuilder` creates a [WriteBuilder](../../connector/WriteBuilder.md) that creates a [ParquetWrite](ParquetWrite.md) (when requested to [build a Write](../../connector/WriteBuilder.md#build)).

## <span id="supportsDataType"> supportsDataType

??? note "Signature"

    ```scala
    supportsDataType(
      dataType: DataType): Boolean
    ```

    `supportsDataType` is part of the [FileTable](../FileTable.md#supportsDataType) abstraction.

`supportsDataType` supports all [AtomicType](../../types/AtomicType.md)s and the following complex [DataType](../../types/DataType.md)s with `AtomicType`s:

* [ArrayType](../../types/ArrayType.md)
* `MapType`
* [StructType](../../types/StructType.md)
* [UserDefinedType](../../types/UserDefinedType.md)
