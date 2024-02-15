---
title: CTERelationDef
---

# CTERelationDef Unary Logical Operator

`CTERelationDef` is a [unary logical operator](LogicalPlan.md#UnaryNode).

## Creating Instance

`CTERelationDef` takes the following to be created:

* <span id="child"> Child [logical operator](LogicalPlan.md)
* <span id="id"> ID (default: a new unique ID)

`CTERelationDef` is created when:

* [CTESubstitution](../logical-analysis-rules/CTESubstitution.md) logical analysis rule is executed

## Node Patterns { #nodePatterns }

??? note "TreeNode"

    ```scala
    nodePatterns: Seq[TreePattern]
    ```

    `nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

`nodePatterns` is [CTE](../catalyst/TreePattern.md#CTE).
