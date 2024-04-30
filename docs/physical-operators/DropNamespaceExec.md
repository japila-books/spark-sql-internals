---
title: DropNamespaceExec
---

# DropNamespaceExec Physical Command

`DropNamespaceExec` is a leaf [V2CommandExec](V2CommandExec.md) that represents a [DropNamespace](../logical-operators/DropNamespace.md) logical operator at execution.

## Creating Instance

`DropNamespaceExec` takes the following to be created:

* <span id="catalog"> [CatalogPlugin](../connector/catalog/CatalogPlugin.md)
* <span id="namespace"> Namespace (`Seq[String]`)
* <span id="ifExists"> `ifExists` flag
* <span id="cascade"> `cascade` flag

`DropNamespaceExec` is created when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (to plan [DropNamespace](../logical-operators/DropNamespace.md) logical operator)

## Executing Command { #run }

??? note "V2CommandExec"

    ```scala
    run(): Seq[InternalRow]
    ```

    `run` is part of the [V2CommandExec](V2CommandExec.md#run) abstraction.

`run` requests the [CatalogPlugin](#catalog) for [SupportsNamespaces](../connector/catalog/CatalogHelper.md#asNamespaceCatalog) representation.

`run` asks the `CatalogPlugin` (as a `SupportsNamespaces`) if the [namespace exists](../connector/catalog/SupportsNamespaces.md#namespaceExists) and, if so, [drops it](../connector/catalog/SupportsNamespaces.md#dropNamespace).

!!! note "Empty collection returned"
    `run` returns an empty collection (_no value_).
