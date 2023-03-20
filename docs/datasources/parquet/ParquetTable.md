# ParquetTable

`ParquetTable` is a [FileTable](../FileTable.md).

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

```scala
formatName: String
```

`formatName` is part of the [FileTable](../FileTable.md#formatName) abstraction.

---

`formatName` is the following text:

```text
Parquet
```

## <span id="inferSchema"> Schema Inference

```scala
inferSchema(
  files: Seq[FileStatus]): Option[StructType]
```

`inferSchema` is part of the [FileTable](../FileTable.md#inferSchema) abstraction.

---

`inferSchema` [infers the schema](ParquetUtils.md#inferSchema) (with the [options](#options) and the input Hadoop `FileStatus`es).

## <span id="newScanBuilder"> newScanBuilder

```scala
newScanBuilder(
  options: CaseInsensitiveStringMap): ParquetScanBuilder
```

`newScanBuilder` is part of the [FileTable](../FileTable.md#newScanBuilder) abstraction.

---

`newScanBuilder` creates a [ParquetScanBuilder](ParquetScanBuilder.md) with the following:

* [fileIndex](../FileTable.md#fileIndex)
* [schema](../FileTable.md#schema)
* [dataSchema](../FileTable.md#dataSchema)
* [options](#options)

## <span id="newWriteBuilder"> newWriteBuilder

```scala
newWriteBuilder(
  info: LogicalWriteInfo): WriteBuilder
```

`newWriteBuilder` is part of the [FileTable](../FileTable.md#newWriteBuilder) abstraction.

---

`newWriteBuilder` creates a [WriteBuilder](../../connector/WriteBuilder.md) that creates a [ParquetWrite](ParquetWrite.md) (when requested to [build a Write](../../connector/WriteBuilder.md#build)).

## <span id="supportsDataType"> supportsDataType

```scala
supportsDataType(
  dataType: DataType): Boolean
```

`supportsDataType` is part of the [FileTable](../FileTable.md#supportsDataType) abstraction.

---

`supportsDataType` supports all [AtomicType](../../types/AtomicType.md)s and the following complex [DataType](../../types/DataType.md)s with `AtomicType`s:

* [StructType](../../types/StructType.md)
* [ArrayType](../../types/ArrayType.md)
* `MapType`
* [UserDefinedType](../../types/UserDefinedType.md)
