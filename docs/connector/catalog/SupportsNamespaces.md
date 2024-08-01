# SupportsNamespaces

`SupportsNamespaces` is an [extension](#contract) of the [CatalogPlugin](CatalogPlugin.md) abstraction for [catalogs with namespace support](#implementations).

## Contract (Subset)

### listNamespaces { #listNamespaces }

```java
String[][] listNamespaces()
```

Lists the top-level namespaces from this catalog

Used when:

* `DelegatingCatalogExtension` is requested to [listNamespaces](DelegatingCatalogExtension.md#listNamespaces)
* `SHOW NAMESPACES` command is executed

### loadNamespaceMetadata { #loadNamespaceMetadata }

```java
Map<String, String> loadNamespaceMetadata(
  String[] namespace)
```

Loads metadata properties for the namespace

Used when:

* `DelegatingCatalogExtension` is requested to [loadNamespaceMetadata](DelegatingCatalogExtension.md#loadNamespaceMetadata)
* `SupportsNamespaces` is requested to [namespaceExists](#namespaceExists)
* `DESCRIBE NAMESPACE` command is executed
* `CatalogImpl` is requested to [getNamespace](../../CatalogImpl.md#getNamespace)

## Implementations

* [CatalogExtension](CatalogExtension.md)
* [JDBCTableCatalog](../../jdbc/JDBCTableCatalog.md)
* [V2SessionCatalog](../../V2SessionCatalog.md)
