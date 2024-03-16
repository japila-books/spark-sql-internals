---
title: ParameterizedQuery
---

# ParameterizedQuery Unary Logical Operators

`ParameterizedQuery` is a marker extension of the `UnresolvedUnaryNode` abstraction for [unary logical operators](#implementations) with the [PARAMETERIZED_QUERY](#nodePatterns) tree node pattern.

## Implementations

* [NameParameterizedQuery](NameParameterizedQuery.md)
* `PosParameterizedQuery`

## Creating Instance

`ParameterizedQuery` takes the following to be created:

* <span id="child"> Child [LogicalPlan](LogicalPlan.md) (_unused_)

!!! note "Abstract Class"
    `ParameterizedQuery` is an abstract class and cannot be created directly. It is created indirectly for the [concrete ParameterizedQueries](#implementations).

## Node Patterns { #nodePatterns }

??? note "TreeNode"

    ```scala
    nodePatterns: Seq[TreePattern]
    ```

    `nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

`nodePatterns` is just a single [PARAMETERIZED_QUERY](../catalyst/TreePattern.md#PARAMETERIZED_QUERY).
