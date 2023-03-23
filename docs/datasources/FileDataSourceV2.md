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

### <span id="getTable"> Table

```scala
getTable(
  options: CaseInsensitiveStringMap): Table
getTable(
  options: CaseInsensitiveStringMap,
  schema: StructType): Table
getTable(
  schema: StructType,
  partitioning: Array[Transform],
  properties: Map[String, String]): Table // (1)!
```

1. Part of the [TableProvider](../connector/TableProvider.md#getTable) abstraction

A [Table](../connector/Table.md) of this table provider

See:

* [ParquetDataSourceV2](parquet/ParquetDataSourceV2.md#getTable)

Used when:

* `FileDataSourceV2` is requested for a table (as a [TableProvider](../connector/TableProvider.md#getTable)) and [inferSchema](#inferSchema)

## Implementations

* `AvroDataSourceV2`
* `CSVDataSourceV2`
* `JsonDataSourceV2`
* `OrcDataSourceV2`
* [ParquetDataSourceV2](parquet/ParquetDataSourceV2.md)
* `TextDataSourceV2`

## <span id="DataSourceRegister"> DataSourceRegister

`FileDataSourceV2` is a [DataSourceRegister](../DataSourceRegister.md).

## <span id="inferSchema"> Schema Inference

```scala
inferSchema(
  options: CaseInsensitiveStringMap): StructType
```

`inferSchema` is part of the [TableProvider](../connector/TableProvider.md#inferSchema) abstraction.

---

`inferSchema` requests the [Table](#t) for the [schema](../connector/Table.md#schema).

If not available, `inferSchema` [creates a Table](#getTable) and "saves" it for later (in [t](#t) registry).

## <span id="getTableName"> Table Name

```scala
getTableName(
  map: CaseInsensitiveStringMap,
  paths: Seq[String]): String
```

`getTableName` uses [short name](../DataSourceRegister.md#shortName) and the given `paths` to create the following table name (possibly redacting sensitive parts per [spark.sql.redaction.string.regex](../configuration-properties.md#spark.sql.redaction.string.regex)):

```text
[short name] [comma-separated paths]
```

## <span id="getPaths"> Paths

```scala
getPaths(
  map: CaseInsensitiveStringMap): Seq[String]
```

`getPaths` concatenates the values of the `paths` and `path` keys (from the given `map`).
