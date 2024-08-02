# DelegatingCatalogExtension

`DelegatingCatalogExtension` is an [extension](#contract) of the [CatalogExtension](CatalogExtension.md) abstraction for catalogs that delegate unsupported catalog extensions to the [Delegate Catalog](#delegate).

`DelegatingCatalogExtension` is a convenience abstraction so that Spark extensions developers can focus on a subset of the [CatalogExtension](CatalogExtension.md) features.

## Delegate Catalog { #delegate }

`DelegatingCatalogExtension` can be given a [CatalogPlugin](CatalogPlugin.md) to handle the following (unless overriden):

* [name](CatalogPlugin.md#name)
* [defaultNamespace](CatalogPlugin.md#defaultNamespace)
* [asTableCatalog](#asTableCatalog)
* [asNamespaceCatalog](#asNamespaceCatalog)
* [asFunctionCatalog](#asFunctionCatalog)

The `CatalogPlugin` is assigned at [setDelegateCatalog](#setDelegateCatalog).

## setDelegateCatalog { #setDelegateCatalog }

??? note "CatalogExtension"

    ```java
    void setDelegateCatalog(
      CatalogPlugin delegate)
    ```

    `setDelegateCatalog` is part of the [CatalogExtension](CatalogExtension.md#setDelegateCatalog) abstraction.

`setDelegateCatalog` sets this [CatalogPlugin](#delegate).

??? note "Final Method"
    `setDelegateCatalog` is a Java **final method** to prevent [subclasses](#implementations) from overriding or hiding it.

    Learn more in the [Java Language Specification]({{ java.spec }}/jls-8.html#jls-8.4.3.3).
