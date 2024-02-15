---
title: CTERelationRef
---

# CTERelationRef Leaf Logical Operator

`CTERelationRef` is a [leaf logical operator](LeafNode.md).

## Creating Instance

`CTERelationRef` takes the following to be created:

* <span id="cteId"> CTE Id
* <span id="_resolved"> `_resolved` flag
* <span id="output"> Output [Attribute](../expressions/Attribute.md)s
* <span id="statsOpt"> Optional [Statistics](../cost-based-optimization/Statistics.md) (default: `None`)

`CTERelationRef` is created when:

* [CTESubstitution](../logical-analysis-rules/CTESubstitution.md) logical resolution rule is executed
* [ResolveWithCTE](../logical-analysis-rules/ResolveWithCTE.md) logical resolution rule is executed

## MultiInstanceRelation { #MultiInstanceRelation }

`CTERelationRef` is a [MultiInstanceRelation](MultiInstanceRelation.md).

## Node Patterns { #nodePatterns }

??? note "TreeNode"

    ```scala
    nodePatterns: Seq[TreePattern]
    ```

    `nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

`nodePatterns` is [CTE](../catalyst/TreePattern.md#CTE).

## Query Planning

`CTERelationRef` logical operators are planned by [WithCTEStrategy](../execution-planning-strategies/WithCTEStrategy.md) execution planning strategy (to [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) physical operators).
