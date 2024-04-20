---
title: RuntimeReplaceable
---

# RuntimeReplaceable Expressions

`RuntimeReplaceable` is an [extension](#contract) of the [Expression](Expression.md) abstraction for [expressions](#implementations) that are replaced by [Logical Optimizer](../catalyst/Optimizer.md#ReplaceExpressions) with [replacement](#replacement) expression (that can then be evaluated).

!!! note
    Catalyst Optimizer uses [ReplaceExpressions](../logical-optimizations/ReplaceExpressions.md) logical optimization to replace `RuntimeReplaceable` expressions.

`RuntimeReplaceable` contract allows for **expression aliases**, i.e. expressions that are fairly complex in the inside than on the outside, and is used to provide compatibility with other SQL databases by supporting SQL functions with their more complex Catalyst expressions (that are already supported by Spark SQL).

!!! note
    `RuntimeReplaceables` are tied up to their SQL functions in [FunctionRegistry](../FunctionRegistry.md#expressions).

!!! note
    To make sure the `explain` plan and expression SQL works correctly, a `RuntimeReplaceable` implementation should override [flatArguments](Expression.md#flatArguments) and [sql](Expression.md#sql) methods.

## Contract

### Replacement Expression { #replacement }

```scala
replacement: Expression
```

See:

* [ParseToTimestamp](ParseToTimestamp.md#replacement)

Used (mainly) when:

* [ReplaceExpressions](../logical-optimizations/ReplaceExpressions.md) logical optimization is executed 

## Implementations

* [ParseToTimestamp](ParseToTimestamp.md)
* _many others_
