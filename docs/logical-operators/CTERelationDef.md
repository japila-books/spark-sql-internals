# CTERelationDef Unary Logical Operator

`CTERelationDef` is a [unary logical operator](LogicalPlan.md#UnaryNode).

## Creating Instance

`CTERelationDef` takes the following to be created:

* <span id="child"> Child [LogicalPlan](LogicalPlan.md)
* <span id="id"> ID

`CTERelationDef` is created when:

* [CTESubstitution](../logical-analysis-rules/CTESubstitution.md) logical analysis rule is executed

## <span id="nodePatterns"> Node Patterns

```scala
nodePatterns: Seq[TreePattern]
```

`nodePatterns` is [CTE](../catalyst/TreePattern.md#CTE).

`nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.
