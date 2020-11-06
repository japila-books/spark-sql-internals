# DataSourceV2Utils Utility

`DataSourceV2Utils` is an utility to [extractSessionConfigs](#extractSessionConfigs) and [getTableFromProvider](#getTableFromProvider) for batch and streaming reads and writes.

## <span id="extractSessionConfigs"> extractSessionConfigs

```scala
extractSessionConfigs(
  source: TableProvider,
  conf: SQLConf): Map[String, String]
```

!!! note
    `extractSessionConfigs` supports data sources with [SessionConfigSupport](connector/SessionConfigSupport.md) only.

`extractSessionConfigs` requests the `SessionConfigSupport` data source for the [custom key prefix for configuration options](connector/SessionConfigSupport.md#keyPrefix) that is used to find all configuration options with the keys in the format of *spark.datasource.[keyPrefix]* in the given [SQLConf](SQLConf.md#getAllConfs).

`extractSessionConfigs` returns the matching keys with the **spark.datasource.[keyPrefix]** prefix removed (i.e. `spark.datasource.keyPrefix.k1` becomes `k1`).

`extractSessionConfigs` is used when:

* `DataFrameReader` is requested to [load data](DataFrameReader.md#load)
* `DataFrameWriter` is requested to [save data](DataFrameWriter.md#save)
* (Spark Structured Streaming) `DataStreamReader` is requested to load data from a streaming data source
* (Spark Structured Streaming) `DataStreamWriter` is requested to start a streaming query

## <span id="getTableFromProvider"> getTableFromProvider

```scala
getTableFromProvider(
  provider: TableProvider,
  options: CaseInsensitiveStringMap,
  userSpecifiedSchema: Option[StructType]): Table
```

`getTableFromProvider` creates a [Table](connector/Table.md) for the given [TableProvider](connector/TableProvider.md), options and user-defined schema.

`getTableFromProvider` is used when:

* `DataFrameReader` is requested to [load data](DataFrameReader.md#load)
* `DataFrameWriter` is requested to [save data](DataFrameWriter.md#save)
* (Spark Structured Streaming) `DataStreamReader` is requested to load data from a streaming data source
* (Spark Structured Streaming) `DataStreamWriter` is requested to start a streaming query
