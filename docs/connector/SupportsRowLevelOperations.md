---
title: SupportsRowLevelOperations
---

# SupportsRowLevelOperations Tables

`SupportsRowLevelOperations` is an [extension](#contract) of the [Table](Table.md) abstraction for [tables](#implementations) that [newRowLevelOperationBuilder](#newRowLevelOperationBuilder).

## Contract

### <span id="newRowLevelOperationBuilder"> newRowLevelOperationBuilder

```java
RowLevelOperationBuilder newRowLevelOperationBuilder(
  RowLevelOperationInfo info)
```

Used when:

* `RewriteRowLevelCommand` analysis rule is requested to [buildOperationTable](../logical-analysis-rules/RewriteRowLevelCommand.md#buildOperationTable)

## Implementations

!!! note
    No built-in implementations available.
