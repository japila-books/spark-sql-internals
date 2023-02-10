# FileDataSourceV2 Table Providers

`FileDataSourceV2` is an [extension](#contract) of the [TableProvider](../connector/TableProvider.md) abstraction for [file-based table providers](#implementations).

## Contract

### <span id="fallbackFileFormat"> fallbackFileFormat

```scala
fallbackFileFormat: Class[_ <: FileFormat]
```

A V1 [FileFormat](FileFormat.md) class of this file-based data source

See:

* [ParquetDataSourceV2](parquet/ParquetDataSourceV2.md#fallbackFileFormat)

Used when:

* `DDLUtils` is requested to `checkDataColNames`
* `DataSource` is requested for the [providingClass](../DataSource.md#providingClass) (for resolving data source relation for catalog tables)
* `PreprocessTableCreation` logical analysis rule is [executed](../logical-analysis-rules/PreprocessTableCreation.md#fallBackV2ToV1)

### <span id="getTable"> getTable

```scala
getTable(
  options: CaseInsensitiveStringMap): Table
```

[Table](../connector/Table.md)

See:

* [ParquetDataSourceV2](parquet/ParquetDataSourceV2.md#getTable)

Used when:

* `FileDataSourceV2` is requested to [inferSchema](#inferSchema)

## Implementations

* `AvroDataSourceV2`
* `CSVDataSourceV2`
* `JsonDataSourceV2`
* `OrcDataSourceV2`
* [ParquetDataSourceV2](parquet/ParquetDataSourceV2.md)
* `TextDataSourceV2`

## <span id="DataSourceRegister"> DataSourceRegister

`FileDataSourceV2` is a [DataSourceRegister](../DataSourceRegister.md).
