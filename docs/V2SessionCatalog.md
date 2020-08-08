# V2SessionCatalog &mdash; Default Session Catalog

`V2SessionCatalog` is the [default session catalog](connector/catalog/CatalogManager.md#defaultSessionCatalog) of [CatalogManager](connector/catalog/CatalogManager.md).

`V2SessionCatalog` is a [TableCatalog](connector/catalog/TableCatalog.md) and a [SupportsNamespaces](connector/catalog/SupportsNamespaces.md).

## Creating Instance

`V2SessionCatalog` takes the following to be created:

* <span id="catalog"> [SessionCatalog](SessionCatalog.md)
* <span id="conf"> [SQLConf](SQLConf.md)

`V2SessionCatalog` is created when `BaseSessionStateBuilder` is requested for [one](BaseSessionStateBuilder.md#v2SessionCatalog).

## <span id="defaultNamespace"> Default Namespace

```scala
defaultNamespace: Array[String]
```

The default namespace of `V2SessionCatalog` is **default**.

`defaultNamespace` is part of the [CatalogPlugin](connector/catalog/CatalogPlugin.md#defaultNamespace) abstraction.

## Name

```scala
name: String
```

The name of `V2SessionCatalog` is [spark_catalog](connector/catalog/CatalogManager.md#SESSION_CATALOG_NAME).

`name` is part of the [CatalogPlugin](connector/catalog/CatalogPlugin.md#name) abstraction.
