# Catalogs Utility

## <span id="load"> Loading Catalog by Name

```scala
load(
  name: String,
  conf: SQLConf): CatalogPlugin
```

`load`...FIXME

`load` is used when `CatalogManager` is requested to [look up a catalog by name](CatalogManager.md#catalog) or [loadV2SessionCatalog](CatalogManager.md#loadV2SessionCatalog).
