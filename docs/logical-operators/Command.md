---
title: Command
---

# Command &mdash; Eagerly-Executed Logical Operators

`Command` is an extension of the [LogicalPlan](LogicalPlan.md) abstraction for [logical operators](#implementations) that are executed early in the [query plan lifecycle](../QueryExecution.md#query-plan-lifecycle) (unlike logical operators in general).

`Command` is a marker interface for logical operators that are executed when a `Dataset` is requested for the [logical plan](../Dataset.md#logicalPlan) (which is after the query has been [analyzed](../QueryExecution.md#analyzed)).

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

## <span id="output"> Output Attributes

```scala
output: Seq[Attribute]
```

`Command` has no output [attributes](../expressions/Attribute.md) by default.

`output` is part of the [QueryPlan](../catalyst/QueryPlan.md#output) abstraction.

## <span id="children"> Child Logical Operators

```scala
children: Seq[LogicalPlan]
```

`Command` has no child [logical operators](LogicalPlan.md) by default.

`children` is part of the [TreeNode](../catalyst/TreeNode.md#children) abstraction.

## <span id="stats"> Statistics

```scala
stats: Statistics
```

`stats` is part of the [LogicalPlanStats](../cost-based-optimization/LogicalPlanStats.md#stats) abstraction.

---

`Command` has no [Statistics](../cost-based-optimization/Statistics.md) by default.
