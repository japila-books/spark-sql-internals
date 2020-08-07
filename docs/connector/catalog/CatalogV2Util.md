# CatalogV2Util Utility

## <span id="getTableProviderCatalog"> getTableProviderCatalog

```scala
getTableProviderCatalog(
  provider: SupportsCatalogOptions,
  catalogManager: CatalogManager,
  options: CaseInsensitiveStringMap): TableCatalog
```

`getTableProviderCatalog`...FIXME

`getTableProviderCatalog` is used when:

* `DataFrameReader` is requested to [load](../../DataFrameReader.md#load) (for a data source that is a [SupportsCatalogOptions])

* `DataFrameWriter` is requested to [save](../../spark-sql-DataFrameWriter.md#save) (for a data source that is a [SupportsCatalogOptions])
