---
title: RowLevelWrite
---

# RowLevelWrite Logical Operators

`RowLevelWrite` is an [extension](#contract) of the [V2WriteCommand](V2WriteCommand.md) abstraction for [write commands](#implementations) with [SupportsSubquery](SupportsSubquery.md).

## Contract (Subset)

### operation

```scala
operation: RowLevelOperation
```

See:

* [ReplaceData](ReplaceData.md#operation)
* [WriteDelta](WriteDelta.md#operation)

Used when:

* `GroupBasedRowLevelOperation` is requested to `unapply`
* `WriteDelta` is requested to [metadataAttrsResolved](WriteDelta.md#metadataAttrsResolved), [rowIdAttrsResolved](WriteDelta.md#rowIdAttrsResolved)
* `GroupBasedRowLevelOperationScanPlanning` is requested to [apply](../logical-optimizations/GroupBasedRowLevelOperationScanPlanning.md#apply)
* `RewrittenRowLevelCommand` is requested to `unapply`
* `RowLevelOperationRuntimeGroupFiltering` is requested to `apply`

## Implementations

* [ReplaceData](ReplaceData.md)
* [WriteDelta](WriteDelta.md)
