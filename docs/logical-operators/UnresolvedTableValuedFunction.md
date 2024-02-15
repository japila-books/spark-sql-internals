---
title: UnresolvedTableValuedFunction
---

# UnresolvedTableValuedFunction Logical Operator

`UnresolvedTableValuedFunction` is a [LeafNode](LeafNode.md) that represents a table-valued function (e.g. `range`, `explode`).

## Creating Instance

`UnresolvedTableValuedFunction` takes the following to be created:

* <span id="name"> Name
* <span id="functionArgs"> Function Arguments ([Expression](../expressions/Expression.md)s)

`UnresolvedTableValuedFunction` is created when:

* `UnresolvedTableValuedFunction` is requested to [apply](#apply)
* `AstBuilder` is requested to [visitTableValuedFunction](../sql/AstBuilder.md#visitTableValuedFunction)

## <span id="apply"> Creating UnresolvedTableValuedFunction

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

## Logical Analysis

`UnresolvedTableValuedFunction` is resolved in [ResolveFunctions](../logical-analysis-rules/ResolveFunctions.md) logical analysis rule.
