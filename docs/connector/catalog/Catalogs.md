# Catalogs

`Catalogs` is a utility to [load (and initialize)](#load) a [CatalogPlugin](CatalogPlugin.md) by a given name.

## <span id="load"> Loading Catalog by Name

```scala
load(
  name: String,
  conf: SQLConf): CatalogPlugin
```

`load` finds the class name of the [CatalogPlugin](CatalogPlugin.md) in the given [SQLConf](../../SQLConf.md) by `spark.sql.catalog.[name]` key (or throws an [CatalogNotFoundException](#load-CatalogNotFoundException)).

`load` loads the class and makes sure that it is a [CatalogPlugin](CatalogPlugin.md) (or throws an [SparkException](#load-SparkException)).

In the end, `load` creates a new instance (using a public no-arg constructor) and requests the `CatalogPlugin` to [initialize](CatalogPlugin.md#initialize) (with the given `name` and [all the catalog options](#catalogOptions) that use `spark.sql.catalog.[name]` prefix).

---

`load` is used when:

* `CatalogManager` is requested to [look up a catalog by name](CatalogManager.md#catalog) and [loadV2SessionCatalog](CatalogManager.md#loadV2SessionCatalog)

### <span id="load-CatalogNotFoundException"> CatalogNotFoundException

 `load` throws a `CatalogNotFoundException` when the `spark.sql.catalog.[name]` key could not be found:

```text
Catalog '[name]' plugin class not found: spark.sql.catalog.[name] is not defined
```

### <span id="load-SparkException"> SparkException

`load` throws a `SparkException` when the class name is not of the `CatalogPlugin` type:

```text
Plugin class for catalog '[name]' does not implement CatalogPlugin: [pluginClassName]
```

### <span id="catalogOptions"> Collecting Catalog Options

```scala
catalogOptions(
  name: String,
  conf: SQLConf): CaseInsensitiveStringMap
```

`catalogOptions` collects all options with `spark.sql.catalog.[name].` prefix (in the given [SQLConf](../../SQLConf.md)).
