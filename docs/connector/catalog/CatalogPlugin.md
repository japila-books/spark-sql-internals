# CatalogPlugin

`CatalogPlugin` is an [abstraction](#contract) of [table catalogs](#implementations).

!!! note "CatalogHelper"
    [CatalogHelper](CatalogHelper.md) is a Scala implicit class of `CatalogPlugin` with extensions methods.

## Contract

### Default Namespace { #defaultNamespace }

```java
String[] defaultNamespace()
```

Default namespace

Default: (empty)

Used when:

* `CatalogManager` is requested for the [current namespace](CatalogManager.md#currentNamespace)

### Initialize CatalogPlugin { #initialize }

```java
void initialize(
  String name,
  CaseInsensitiveStringMap options)
```

Initializes this `CatalogPlugin` with the following:

* Name that was used in `spark.sql.catalog.[name]` configuration property
* `spark.sql.catalog.[name].`-prefixed case-insensitive options

Used when:

* `Catalogs` utility is used to [load a catalog by name](Catalogs.md#load)

### Name

```java
String name()
```

!!! note "SHOW CURRENT NAMESPACE"
    Use `SHOW CURRENT NAMESPACE` command to display the name.

## Implementations

* [FunctionCatalog](FunctionCatalog.md)
* [SupportsNamespaces](SupportsNamespaces.md)
* [TableCatalog](TableCatalog.md)
* [ViewCatalog](ViewCatalog.md)

## Demo

Learn more in [Demo: Developing CatalogPlugin](../../demo/developing-catalogplugin.md).
