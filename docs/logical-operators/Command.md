---
title: Command
---

# Command &mdash; Eagerly-Executed Logical Operators

`Command` is an extension of the [LogicalPlan](LogicalPlan.md) abstraction for [logical operators](#implementations) that are executed early in the [query plan lifecycle](../QueryExecution.md#query-plan-lifecycle) (unlike logical operators in general).

`Command` is a marker interface for logical operators that are executed when a `Dataset` is requested for the [logical plan](../dataset/index.md#logicalPlan) (which is after the query has been [analyzed](../QueryExecution.md#analyzed)).

## Implementations

* [AlterTable](AlterTable.md)
* [CommentOnTable](CommentOnTable.md)
* [DataWritingCommand](DataWritingCommand.md)
* [DeleteFromTable](DeleteFromTable.md)
* [DescribeRelation](DescribeRelation.md)
* [MergeIntoTable](MergeIntoTable.md)
* [RunnableCommand](RunnableCommand.md)
* [SetCatalogAndNamespace](SetCatalogAndNamespace.md)
* [ShowTableProperties](ShowTableProperties.md)
* [ShowTables](ShowTables.md)
* [UpdateTable](UpdateTable.md)
* [V2WriteCommand](V2WriteCommand.md)
* _others_

## Output Attributes { #output }

??? note "QueryPlan"

    ```scala
    output: Seq[Attribute]
    ```

    `output` is part of the [QueryPlan](../catalyst/QueryPlan.md#output) abstraction.

`Command` has no output [attributes](../expressions/Attribute.md) by default.

## Child Logical Operators { #children }

??? note "TreeNode"

    ```scala
    children: Seq[LogicalPlan]
    ```

    `children` is part of the [TreeNode](../catalyst/TreeNode.md#children) abstraction.

`Command` has no child [logical operators](LogicalPlan.md) by default.

## Statistics { #stats }

??? note "LogicalPlanStats"

    ```scala
    stats: Statistics
    ```

    `stats` is part of the [LogicalPlanStats](../cost-based-optimization/LogicalPlanStats.md#stats) abstraction.

`Command` has no [Statistics](../cost-based-optimization/Statistics.md) by default.
