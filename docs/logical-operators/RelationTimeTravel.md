---
title: RelationTimeTravel
---

# RelationTimeTravel Logical Operator

`RelationTimeTravel` is an unresolved logical operator (`UnresolvedLeafNode`) to "mark a need" to [time travel](../time-travel/index.md) the [child relation](#relation) to the given [timestamp](#timestamp) or [version](#version).

`RelationTimeTravel` represents the following in table identifiers in a SQL query:

* `FOR? (SYSTEM_VERSION | VERSION) AS OF version`
* `FOR? (SYSTEM_TIME | TIMESTAMP) AS OF timestamp`

## Creating Instance

`RelationTimeTravel` takes the following to be created:

* <span id="relation"> Child relation ([LogicalPlan](LogicalPlan.md))
* <span id="timestamp"> Optional timestamp ([Expression](../expressions/Expression.md))
* <span id="version"> Optional version

`RelationTimeTravel` is created when:

* `AstBuilder` is requested to [withTimeTravel](../sql/AstBuilder.md#withTimeTravel)

## nodePatterns { #nodePatterns }

??? note "TreeNode"

    ```scala
    nodePatterns: Seq[TreePattern]
    ```

    `nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

`nodePatterns` is the following [TreePattern](../catalyst/TreePattern.md):

* [RELATION_TIME_TRAVEL](../catalyst/TreePattern.md#RELATION_TIME_TRAVEL)

## Logical Analysis

`RelationTimeTravel` is a target of the following logical rules:

* [CTESubstitution](../logical-analysis-rules/CTESubstitution.md) (only for [UnresolvedRelation](UnresolvedRelation.md)s with a single-part [table identifier](UnresolvedRelation.md#multipartIdentifier))
* `EvalSubqueriesForTimeTravel` (only for [timestamp](#timestamp) specified)
* [ResolveRelations](../logical-analysis-rules/ResolveRelations.md)
* [ResolveSQLOnFile](../logical-analysis-rules/ResolveSQLOnFile.md)
* [ResolveSubquery](../logical-analysis-rules/ResolveSubquery.md)
