# SupportsNamespaces

`SupportsNamespaces` is an [extension](#contract) of the [CatalogPlugin](CatalogPlugin.md) abstraction for [catalogs with namespace support](#implementations).

## Contract (Subset)

### Create Namespace { #createNamespace }

```java
void createNamespace(
  String[] namespace,
  Map<String, String> metadata)
```

Creates a multi-part namespace in this catalog

Used when:

* `DelegatingCatalogExtension` is requested to [createNamespace](DelegatingCatalogExtension.md#createNamespace)
* `CREATE NAMESPACE` command is executed

### List Namespaces { #listNamespaces }

```java
String[][] listNamespaces()
```

Lists the top-level namespaces from this catalog

Used when:

* `DelegatingCatalogExtension` is requested to [listNamespaces](DelegatingCatalogExtension.md#listNamespaces)
* `SHOW NAMESPACES` command is executed

### Load Namespace Metadata { #loadNamespaceMetadata }

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

### Check If Namespace Exists { #namespaceExists }

```java
boolean namespaceExists(
  String[] namespace)
```

By default, `namespaceExists` tries to [load the namespace metadata](#loadNamespaceMetadata) in this catalog. For a successful load, `namespaceExists` is positive (`true`).

Used when:

* `CatalogManager` is requested to [setCurrentNamespace](CatalogManager.md#setCurrentNamespace)
* `CatalogImpl` is requested to [databaseExists](../../CatalogImpl.md#databaseExists)
* `DelegatingCatalogExtension` is requested to [namespaceExists](DelegatingCatalogExtension.md#namespaceExists)
* `CREATE NAMESPACE` command is executed
* `DROP NAMESPACE` command is executed

## Implementations

* [CatalogExtension](CatalogExtension.md)
* [JDBCTableCatalog](../../jdbc/JDBCTableCatalog.md)
* [V2SessionCatalog](../../V2SessionCatalog.md)
