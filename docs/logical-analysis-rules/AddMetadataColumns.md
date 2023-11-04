---
title: AddMetadataColumns
---

# AddMetadataColumns Logical Resolution Rule

`AddMetadataColumns` [adds metadata columns to logical operators with metadata columns defined](#apply)

`AddMetadataColumns` is a [Rule](../catalyst/Rule.md) to transform a [LogicalPlan](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

`AddMetadataColumns` is part of the [Resolution](../Analyzer.md#Resolution) batch of the [Analyzer](../Analyzer.md).

## Executing Rule { #apply }

??? note "Signature"

    ```scala
    apply(
      plan: LogicalPlan): LogicalPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` [adds metadata columns](#addMetadataCol) to [logical operators](../logical-operators/LogicalPlan.md) (with [metadata columns defined](#hasMetadataCol)).

### addMetadataCol { #addMetadataCol }

```scala
addMetadataCol(
  plan: LogicalPlan,
  requiredAttrIds: Set[ExprId]): LogicalPlan
```

`addMetadataCol`...FIXME

### hasMetadataCol { #hasMetadataCol }

```scala
hasMetadataCol(
  plan: LogicalPlan): Boolean
```

`hasMetadataCol` is positive (`true`) when there is at least one [Attribute](../expressions/Attribute.md) expression (among the [Expressions](../catalyst/QueryPlan.md#expressions) of the given [LogicalPlan](../logical-operators/LogicalPlan.md)) for which either holds true:

* It is a [metadata column](../metadata-columns/MetadataColumnHelper.md#isMetadataCol)
* [ExprId](../expressions/NamedExpression.md#exprId) of this `Attribute` is among the [metadata output attributes](../logical-operators/LogicalPlan.md#metadataOutput) of any of the [children](../catalyst/TreeNode.md#children) of the given [LogicalPlan](../logical-operators/LogicalPlan.md)
