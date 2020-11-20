# Command &mdash; Eagerly-Executed Logical Operators

`Command` is an extension of the [LogicalPlan](LogicalPlan.md) abstraction for [logical operators](#implementations) that are executed early in the [query plan lifecycle](../QueryExecution.md#query-plan-lifecycle) (unlike logical operators in general).

`Command` is a marker interface for logical operators that are executed when a `Dataset` is requested for the [logical plan](../Dataset.md#logicalPlan) (which is after the query has been [analyzed](../QueryExecution.md#analyzed)).

## Implementations

* AlterNamespaceSetLocation
* AlterNamespaceSetProperties
* AlterTable
* CommentOnNamespace
* CommentOnTable
* CreateNamespace
* CreateTableAsSelect
* [CreateV2Table](CreateV2Table.md)
* [DataWritingCommand](DataWritingCommand.md)
* [DeleteFromTable](DeleteFromTable.md)
* DescribeNamespace
* [DescribeRelation](DescribeRelation.md)
* DropNamespace
* DropTable
* [MergeIntoTable](MergeIntoTable.md)
* RefreshTable
* RenameTable
* ReplaceTable
* ReplaceTableAsSelect
* [RunnableCommand](RunnableCommand.md)
* [SetCatalogAndNamespace](SetCatalogAndNamespace.md)
* [ShowCurrentNamespace](ShowCurrentNamespace.md)
* ShowNamespaces
* ShowTableProperties
* [ShowTables](ShowTables.md)
* ShowViews
* UpdateTable
* [V2WriteCommand](V2WriteCommand.md)

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

`Command` has no [Statistics](Statistics.md) by default.

`stats` is part of the [LogicalPlanStats](LogicalPlanStats.md#stats) abstraction.
