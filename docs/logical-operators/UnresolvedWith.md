# UnresolvedWith Unary Logical Operator

`UnresolvedWith` is a [unary logical operator](LogicalPlan.md#UnaryNode) that represents a [WITH](../sql/AstBuilder.md#withCTE) clause in logical query plans.

## Creating Instance

`UnresolvedWith` takes the following to be created:

* <span id="child"> Child [logical operator](LogicalPlan.md)
* <span id="cteRelations"> Named CTE [SubqueryAlias](SubqueryAlias.md)es (_CTE Relations_)

`UnresolvedWith` is created when:

* `AstBuilder` is requested to [parse WITH clauses](../sql/AstBuilder.md#withCTE)

## <span id="simpleString"> Simple Node Description

```scala
simpleString(
  maxFields: Int): String
```

`simpleString` uses the names of the [CTE Relations](#cteRelations) for the description:

```text
CTE [cteAliases]
```

`simpleString` is part of the [TreeNode](../catalyst/TreeNode.md#simpleString) abstraction.

## Logical Analysis

`UnresolvedWith`s are resolved to [WithCTE](WithCTE.md) logical operators by [CTESubstitution](../logical-analysis-rules/CTESubstitution.md) logical analysis rule.
