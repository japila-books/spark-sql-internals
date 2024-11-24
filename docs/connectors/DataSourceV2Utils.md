---
title: DataSourceV2Utils
---

# DataSourceV2Utils Utility

`DataSourceV2Utils` is an utility to [extractSessionConfigs](#extractSessionConfigs) and [getTableFromProvider](#getTableFromProvider) for batch and streaming reads and writes.

## extractSessionConfigs { #extractSessionConfigs }

```scala
extractSessionConfigs(
  source: TableProvider,
  conf: SQLConf): Map[String, String]
```

!!! note
    `extractSessionConfigs` supports data sources with [SessionConfigSupport](../connector/SessionConfigSupport.md) only.

`extractSessionConfigs` requests the `SessionConfigSupport` data source for the [custom key prefix for configuration options](../connector/SessionConfigSupport.md#keyPrefix) that is used to find all configuration options with the keys in the format of *spark.datasource.[keyPrefix]* in the given [SQLConf](../SQLConf.md#getAllConfs).

`extractSessionConfigs` returns the matching keys with the **spark.datasource.[keyPrefix]** prefix removed (i.e. `spark.datasource.keyPrefix.k1` becomes `k1`).

`extractSessionConfigs` is used when:

* `DataFrameReader` is requested to [load data](../DataFrameReader.md#load)
* `DataFrameWriter` is requested to [save data](../DataFrameWriter.md#save)
* (Spark Structured Streaming) `DataStreamReader` is requested to load data from a streaming data source
* (Spark Structured Streaming) `DataStreamWriter` is requested to start a streaming query

## Creating Table (using TableProvider) { #getTableFromProvider }

```scala
getTableFromProvider(
  provider: TableProvider,
  options: CaseInsensitiveStringMap,
  userSpecifiedSchema: Option[StructType]): Table
```

`getTableFromProvider` creates a [Table](../connector/Table.md) for the given [TableProvider](../connector/TableProvider.md), options and user-defined schema.

---

`getTableFromProvider` is used when:

* `DataFrameWriter` is requested to [save data](../DataFrameWriter.md#save)
* `DataSourceV2Utils` is requested to [loadV2Source](#loadV2Source)
* `DataStreamReader` ([Spark Structured Streaming]({{ book.structured_streaming }}/DataStreamReader)) is requested to load data from a streaming data source
* `DataStreamWriter` ([Spark Structured Streaming]({{ book.structured_streaming }}/DataStreamWriter)) is requested to start a streaming query

## Load V2 Source { #loadV2Source }

```scala
loadV2Source(
  sparkSession: SparkSession,
  provider: TableProvider,
  userSpecifiedSchema: Option[StructType],
  extraOptions: CaseInsensitiveMap[String],
  source: String,
  paths: String*): Option[DataFrame]
```

`loadV2Source` [extractSessionConfigs](DataSourceV2Utils.md#extractSessionConfigs) and [adds the given paths](#getOptionsWithPaths) if specified.

For the given [TableProvider](../connector/TableProvider.md) being a [SupportsCatalogOptions](../connector/catalog/SupportsCatalogOptions.md), `loadV2Source`...FIXME

In the end, for a [SupportsRead](../connector/SupportsRead.md) table with [BATCH_READ](../connector/TableCapability.md#BATCH_READ) capability, `loadV2Source` creates a `DataFrame` with [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md#create) logical operator. Otherwise, `loadV2Source` gives no `DataFrame` (`None`).

---

`loadV2Source` is used when:

* [DataFrameReader.load](../DataFrameReader.md#load) operator is used
* [CreateTempViewUsing](../logical-operators/CreateTempViewUsing.md) logical operator is executed
