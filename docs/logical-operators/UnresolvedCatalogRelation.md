---
title: UnresolvedCatalogRelation
---

# UnresolvedCatalogRelation Leaf Logical Operator

`UnresolvedCatalogRelation` is an unresolved [leaf logical operator](LeafNode.md) (`UnresolvedLeafNode`) that represents a table relation.

??? note "UnresolvedTable"
    [UnresolvedTable](UnresolvedTable.md) leaf logical operator looks very similar.

## Creating Instance

`UnresolvedCatalogRelation` takes the following to be created:

* <span id="tableMeta"> [CatalogTable](../CatalogTable.md)
* <span id="options"> Case-insensitive Options
* <span id="isStreaming"> `isStreaming` flag (default: `false`)

!!! note
    `UnresolvedCatalogRelation` asserts that the `database` is defined in the given [CatalogTable](#tableMeta) (in the `TableIdentifier`).

`UnresolvedCatalogRelation` is created when:

* [ResolveRelations](../logical-analysis-rules/ResolveRelations.md) logical analysis rule is executed
* `SessionCatalog` is requested to [getRelation](../SessionCatalog.md#getRelation)
* [FindDataSourceTable](../logical-analysis-rules/FindDataSourceTable.md) logical analysis rule is executed (to analyse an [AppendData](AppendData.md))
