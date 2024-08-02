# CatalogExtension

`CatalogExtension` is an [extension](#contract) of the [TableCatalog](TableCatalog.md) and [SupportsNamespaces](SupportsNamespaces.md) abstractions for [session catalog extensions](#implementations) that [setDelegateCatalog](#setDelegateCatalog).

## Contract

### setDelegateCatalog { #setDelegateCatalog }

```java
void setDelegateCatalog(
  CatalogPlugin delegate)
```

Used when:

* `CatalogManager` is requested to [loadV2SessionCatalog](CatalogManager.md#loadV2SessionCatalog)

## Implementations

* [DelegatingCatalogExtension](DelegatingCatalogExtension.md)
