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

* `DataFrameWriter` is requested to [save](../../DataFrameWriter.md#save) (for a data source that is a [SupportsCatalogOptions])

## <span id="loadTable"> Loading Table

```scala
loadTable(
  catalog: CatalogPlugin,
  ident: Identifier): Option[Table]
```

`loadTable` requests the given [CatalogPlugin](CatalogPlugin.md) (as a [TableCatalog](TableCatalog.md)) to [load the table](TableCatalog.md#loadTable) by the `Identifier`.

`loadTable` returns the [Table](../Table.md) if available or `None`.

`loadTable` is used when...FIXME
