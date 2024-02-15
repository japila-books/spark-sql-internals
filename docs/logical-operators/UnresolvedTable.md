---
title: UnresolvedTable
---

# UnresolvedTable Leaf Logical Operator

`UnresolvedTable` is a [leaf logical operator](LeafNode.md).

## Creating Instance

`UnresolvedTable` takes the following to be created:

* <span id="multipartIdentifier"> Multi-Part Identifier
* <span id="commandName"> Command Name

`UnresolvedTable` is created when:

* `AstBuilder` is requested to [visitLoadData](../sql/AstBuilder.md#visitLoadData), [visitTruncateTable](../sql/AstBuilder.md#visitTruncateTable), [visitShowPartitions](../sql/AstBuilder.md#visitShowPartitions), [visitAddTablePartition](../sql/AstBuilder.md#visitAddTablePartition), [visitDropTablePartitions](../sql/AstBuilder.md#visitDropTablePartitions), [visitCommentTable](../sql/AstBuilder.md#visitCommentTable)

## <span id="resolved"> resolved

```scala
resolved: Boolean
```

`resolved` is part of the [LogicalPlan](LogicalPlan.md#resolved) abstraction.

`resolved` is `false`.

## Logical Analysis

`UnresolvedTable` is resolved to a [ResolvedTable](ResolvedTable.md) by `ResolveTables` logical resolution rule.
