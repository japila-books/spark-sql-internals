---
title: LeafRunnableCommand
---

# LeafRunnableCommand &mdash; Leaf Logical Runnable Commands

`LeafRunnableCommand` is an [extension](#contract) of the [RunnableCommand](RunnableCommand.md) abstraction for [leaf logical runnable commands](#implementations).

!!! important
    It looks like `LeafRunnableCommand` was introduced in [SPARK-34989]({{ spark.jira }}/SPARK-34989) to improve the performance of`mapChildren` and `withNewChildren` methods.
    
    I don't understand why such a simplistic trait definition could help as seems very Scala-specific. Help appreciated! 🙏

    ```scala
    trait LeafRunnableCommand extends RunnableCommand with LeafLike[LogicalPlan]
    ```

## Implementations

* [AlterTableAddColumnsCommand](AlterTableAddColumnsCommand.md)
* [AnalyzeColumnCommand](AnalyzeColumnCommand.md)
* [AnalyzePartitionCommand](AnalyzePartitionCommand.md)
* [AnalyzeTableCommand](AnalyzeTableCommand.md)
* [CacheTableCommand](CacheTableCommand.md)
* [ClearCacheCommand](ClearCacheCommand.md)
* [CreateDataSourceTableCommand](CreateDataSourceTableCommand.md)
* [CreateTempViewUsing](CreateTempViewUsing.md)
* [CreateViewCommand](CreateViewCommand.md)
* [DescribeColumnCommand](DescribeColumnCommand.md)
* [ExplainCommand](ExplainCommand.md)
* [InsertIntoDataSourceCommand](InsertIntoDataSourceCommand.md)
* [SaveIntoDataSourceCommand](SaveIntoDataSourceCommand.md)
* [SetCommand](SetCommand.md)
* [SetNamespaceCommand](SetNamespaceCommand.md)
* [ShowCreateTableCommand](ShowCreateTableCommand.md)
* [ShowTablePropertiesCommand](ShowTablePropertiesCommand.md)
* [TruncateTableCommand](TruncateTableCommand.md)
* _many others_
