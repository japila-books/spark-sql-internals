# CatalogPlugin

`CatalogPlugin` is an [abstraction](#contract) of [table catalogs](#implementations).

!!! note "Demo: Developing CatalogPlugin"
    Learn more in [Demo: Developing CatalogPlugin](../../demo/developing-catalogplugin.md).

!!! note "CatalogHelper"
    [CatalogHelper](CatalogHelper.md) is a Scala implicit class of `CatalogPlugin` with extensions methods.

## Contract

### <span id="defaultNamespace"> Default Namespace

```java
String[] defaultNamespace()
```

Default namespace

Default: (empty)

Used when:

* `CatalogManager` is requested for the [current namespace](CatalogManager.md#currentNamespace)

### <span id="initialize"> Initializing CatalogPlugin

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

### <span id="name"> Name

```java
String name()
```

!!! note "SHOW CURRENT NAMESPACE"
    Use `SHOW CURRENT NAMESPACE` command to display the name.

## Implementations

* [FunctionCatalog](FunctionCatalog.md)
* [SupportsNamespaces](SupportsNamespaces.md)
* [TableCatalog](TableCatalog.md)
