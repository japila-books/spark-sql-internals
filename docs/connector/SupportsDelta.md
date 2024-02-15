---
title: SupportsDelta
---

# SupportsDelta Row-Level Operations

`SupportsDelta` is an [extension](#contract) of the [RowLevelOperation](RowLevelOperation.md) abstraction for [row-level operations](#implementations) with [rowId](#rowId).

## Contract (Subset)

### rowId { #rowId }

```java
NamedReference[] rowId()
```

row ID column references for row equality

Used when:

* [RewriteRowLevelCommand](../logical-analysis-rules/RewriteRowLevelCommand.md) logical analysis rule is executed (and [resolveRowIdAttrs](../logical-analysis-rules/RewriteRowLevelCommand.md#resolveRowIdAttrs))
* [WriteDelta](../logical-operators/WriteDelta.md) logical operator is executed (and [rowIdAttrsResolved](../logical-operators/WriteDelta.md#rowIdAttrsResolved))

## Implementations

!!! note
    No built-in implementations available.
