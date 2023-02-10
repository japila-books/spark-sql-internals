# ParquetDataSourceV2

`ParquetDataSourceV2` is the [FileDataSourceV2](../FileDataSourceV2.md) of [Parquet Data Source](index.md).

## Creating Instance

`ParquetDataSourceV2` takes no arguments to be created.

`ParquetDataSourceV2` is created when:

* `DataSource` utility is used to [look up a DataSource](../../DataSource.md#lookupDataSource) for `parquet` alias

## <span id="getTable"> Creating Table

```scala
getTable(
  options: CaseInsensitiveStringMap): Table
getTable(
  options: CaseInsensitiveStringMap,
  schema: StructType): Table
```

`getTable` is part of the [FileDataSourceV2](../FileDataSourceV2.md#getTable) abstraction.

---

`getTable` creates a [ParquetTable](ParquetTable.md) with the following:

Property | Value
---------|------
[name](ParquetTable.md#name) | [Table name](../FileDataSourceV2.md#getTableName) from the [paths](#getPaths) (and based on the given `options`)
[paths](ParquetTable.md#paths) | [Paths](../FileDataSourceV2.md#getPaths) (in the given `options`)
[userSpecifiedSchema](ParquetTable.md#userSpecifiedSchema) | The given `schema`
[fallbackFileFormat](ParquetTable.md#fallbackFileFormat) | [ParquetFileFormat](#fallbackFileFormat)

## <span id="shortName"> shortName

```scala
shortName(): String
```

`shortName` is part of the [DataSourceRegister](../../DataSourceRegister.md#shortName) abstraction.

---

`shortName` is the following text:

```text
parquet
```

## <span id="fallbackFileFormat"> fallbackFileFormat

```scala
fallbackFileFormat: Class[_ <: FileFormat]
```

`fallbackFileFormat` is part of the [FileDataSourceV2](../FileDataSourceV2.md#fallbackFileFormat) abstraction.

---

`fallbackFileFormat` is [ParquetFileFormat](ParquetFileFormat.md).
