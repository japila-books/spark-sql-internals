---
title: UnresolvedTable
---

# UnresolvedTable Leaf Logical Operator

`UnresolvedTable` is an unresolved [leaf logical operator](LeafNode.md) (`UnresolvedLeafNode`) that represents a table that has yet to be looked up in a catalog.

## Creating Instance

`UnresolvedTable` takes the following to be created:

* <span id="multipartIdentifier"> Multi-Part Identifier
* <span id="commandName"> Command Name
* <span id="relationTypeMismatchHint"> Optional `relationTypeMismatchHint`

`UnresolvedTable` is created when:

* `AstBuilder` is requested to [create an UnresolvedTable](../sql/AstBuilder.md#createUnresolvedTable)
* `CatalogImpl` is requested to [recover partitions](../CatalogImpl.md#recoverPartitions)

## Logical Analysis

`UnresolvedTable` is resolved by [ResolveRelations](../logical-analysis-rules/ResolveRelations.md) logical resolution rule.

??? note "CheckAnalysis and AnalysisException"
    [CheckAnalysis](../CheckAnalysis.md#checkAnalysis0) reports an `AnalysisException` (`TABLE_OR_VIEW_NOT_FOUND`) when there are any `UnresolvedTable`s left in a logical query plan after logical analysis.
