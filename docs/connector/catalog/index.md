# Catalog Plugin API

Main abstractions:

* [CatalogManager](CatalogManager.md)
* [CatalogPlugin](CatalogPlugin.md)
* [FunctionCatalog](FunctionCatalog.md)

## spark.sql.catalog { #spark.sql.catalog }

Custom [CatalogPlugin](CatalogPlugin.md)s are registered using `spark.sql.catalog` configuration property.

```text
spark.sql.catalog.catalog-name=com.example.YourCatalogClass
```

Whenever additional features are required (e.g., [FunctionCatalog](FunctionCatalog.md)), the implicit class [CatalogHelper](CatalogHelper.md) is used to make the conversion.
