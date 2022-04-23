# ParquetDataSourceV2

`ParquetDataSourceV2` is the [FileDataSourceV2](../../FileDataSourceV2.md) of [parquet](index.md) data source.

## DataSourceRegister

`ParquetDataSourceV2` is registered in `META-INF/services/org.apache.spark.sql.sources.DataSourceRegister` (for `DataSource` utility to [look up a data source](../../DataSource.md#lookupDataSource) for [parquet](#shortName) alias).

## Creating Instance

`ParquetDataSourceV2` takes no arguments to be created.

`ParquetDataSourceV2` is created when:

* `DataSource` utility is used to [look up a DataSource](../../DataSource.md#lookupDataSource) (for `parquet` alias)

## <span id="getTable"> getTable

```scala
getTable(
  options: CaseInsensitiveStringMap): Table
getTable(
  options: CaseInsensitiveStringMap,
  schema: StructType): Table
```

`getTable` [getPaths](#getPaths) from the given `options`.

`getTable` [getTableName](#getTableName) (from the given `options` and the paths).

`getTable` [getOptionsWithoutPaths](#getOptionsWithoutPaths).

In the end, `getTable` creates a [ParquetTable](ParquetTable.md).

`getTable` is part of the [FileDataSourceV2](../../FileDataSourceV2.md#getTable) abstraction.

## <span id="shortName"> shortName

```scala
shortName(): String
```

`shortName` is `parquet`.

`shortName` is part of the [DataSourceRegister](../../DataSourceRegister.md#shortName) abstraction.

## <span id="fallbackFileFormat"> fallbackFileFormat

```scala
fallbackFileFormat: Class[_ <: FileFormat]
```

`fallbackFileFormat` is [ParquetFileFormat](ParquetFileFormat.md).

`fallbackFileFormat` is part of the [FileDataSourceV2](../../FileDataSourceV2.md#fallbackFileFormat) abstraction.
