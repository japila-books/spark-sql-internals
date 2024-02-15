---
title: WithCTE
---

# WithCTE Logical Operator

`WithCTE` is a [logical operator](LogicalPlan.md) that represents [UnresolvedWith](../logical-operators/UnresolvedWith.md) unary logical operators after analysis.

## Creating Instance

`WithCTE` takes the following to be created:

* <span id="plan"> [Logical operator](LogicalPlan.md)
* <span id="cteDefs"> [CTERelationDef](CTERelationDef.md)s

`WithCTE` is created when:

* [CTESubstitution](../logical-analysis-rules/CTESubstitution.md) logical analysis rule is executed
* [InlineCTE](../logical-optimizations/InlineCTE.md) logical optimization is executed
* [UpdateCTERelationStats](../logical-optimizations/UpdateCTERelationStats.md) logical optimization is executed

## <span id="nodePatterns"> Node Patterns

```scala
nodePatterns: Seq[TreePattern]
```

`nodePatterns` is [CTE](../catalyst/TreePattern.md#CTE).

`nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

## Query Planning

`WithCTE` logical operators are planned by [WithCTEStrategy](../execution-planning-strategies/WithCTEStrategy.md) execution planning strategy.
