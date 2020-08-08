# CatalogPlugin

`CatalogPlugin` is an [abstraction](#contract) of [catalogs](#implementations).

## Contract

### <span id="defaultNamespace"> Multi-Part Namespace

```java
String[] defaultNamespace()
```

A multi-part namespace

Default: (empty)

Used when `CatalogManager` is requested for the [current namespace](CatalogManager.md#currentNamespace)

### initialize

```java
void initialize(
  String name,
  CaseInsensitiveStringMap options)
```

Used when `Catalogs` utility is requested to [load a catalog by name](Catalogs.md#load)

### Name

```java
String name()
```

!!! note "SHOW CURRENT NAMESPACE"
    Use [ShowCurrentNamespaceExec](../../physical-operators/ShowCurrentNamespaceExec.md) physical command to display the name.

## Implementations

* [SupportsNamespaces](SupportsNamespaces.md)
* [TableCatalog](TableCatalog.md)
