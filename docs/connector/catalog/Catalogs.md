# Catalogs Utility

## <span id="load"> Loading Catalog by Name

```scala
load(
  name: String,
  conf: SQLConf): CatalogPlugin
```

`load` finds the class name of the [CatalogPlugin](CatalogPlugin.md) in the given [SQLConf](../../SQLConf.md) using `spark.sql.catalog.[name]` key.

`load` loads the class and makes sure that it is a [CatalogPlugin](CatalogPlugin.md).

In the end, `load` creates a new instance (using a public no-arg constructor) and requests the `CatalogPlugin` to [initialize](CatalogPlugin.md#initialize) (with the given name and all options that use `spark.sql.catalog.[name]` prefix).

 `load` throws a `CatalogNotFoundException` when the `spark.sql.catalog.[name]` key could not be found:

```text
Catalog '[name]' plugin class not found: spark.sql.catalog.[name] is not defined
```

`load` throws a `SparkException` when the class name is not of the `CatalogPlugin` type:

```text
Plugin class for catalog '[name]' does not implement CatalogPlugin: [pluginClassName]
```

`load` is used when `CatalogManager` is requested to [look up a catalog by name](CatalogManager.md#catalog) or [loadV2SessionCatalog](CatalogManager.md#loadV2SessionCatalog).
