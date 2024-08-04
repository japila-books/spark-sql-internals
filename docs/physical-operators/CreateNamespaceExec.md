---
title: CreateNamespaceExec
---

# CreateNamespaceExec Physical Command Operator

`CreateNamespaceExec` is a leaf [V2CommandExec](V2CommandExec.md) that represents [CreateNamespace](../logical-operators/CreateNamespace.md) logical operator at execution (for non-[session catalogs](../connector/catalog/CatalogV2Util.md#isSessionCatalog)).

## Executing Command { #run }

??? note "V2CommandExec"

    ```scala
    run(): Seq[InternalRow]
    ```

    `run` is part of the [V2CommandExec](V2CommandExec.md#run) abstraction.

`run` requests the given [SupportsNamespaces](../connector/catalog/SupportsNamespaces.md) catalog to [check if the multi-part namespace exists](../connector/catalog/SupportsNamespaces.md#namespaceExists).

Unless the namespace exists, `run` requests the [SupportsNamespaces](../connector/catalog/SupportsNamespaces.md) catalog to [create it](../connector/catalog/SupportsNamespaces.md#createNamespace) (with the `owner` property being the current user).
