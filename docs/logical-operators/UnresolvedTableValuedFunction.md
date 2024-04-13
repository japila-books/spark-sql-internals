---
title: UnresolvedTableValuedFunction
---

# UnresolvedTableValuedFunction Logical Operator

`UnresolvedTableValuedFunction` is a [unresolved leaf logical operator](LeafNode.md) that represents a [table-valued function](../table-valued-functions/index.md).

`UnresolvedTableValuedFunction` is resolved into a concrete [LogicalPlan](LogicalPlan.md) by [ResolveFunctions](../logical-analysis-rules/ResolveFunctions.md) logical analysis rule.

## Creating Instance

`UnresolvedTableValuedFunction` takes the following to be created:

* <span id="name"> Name
* <span id="functionArgs"> Function Arguments ([Expression](../expressions/Expression.md)s)

`UnresolvedTableValuedFunction` is created when:

* `UnresolvedTableValuedFunction` is requested to [apply](#apply)
* `AstBuilder` is requested to [parse a table-valued function](../sql/AstBuilder.md#visitTableValuedFunction) in a SQL statement

## Creating UnresolvedTableValuedFunction { #apply }

```scala
apply(
  name: FunctionIdentifier,
  functionArgs: Seq[Expression]): UnresolvedTableValuedFunction
apply(
  name: String,
  functionArgs: Seq[Expression]): UnresolvedTableValuedFunction
```

`apply` creates a [UnresolvedTableValuedFunction](#creating-instance).

??? note "Unused"
    `apply` does not seem to be used beside the tests.

## Node Patterns { #nodePatterns }

??? note "TreeNode"

    ```scala
    nodePatterns: Seq[TreePattern]
    ```

    `nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

`nodePatterns` is the following:

* [UNRESOLVED_TABLE_VALUED_FUNCTION](../catalyst/TreePattern.md#UNRESOLVED_TABLE_VALUED_FUNCTION)
