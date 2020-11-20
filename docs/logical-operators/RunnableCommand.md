# RunnableCommand Logical Operators

`RunnableCommand` is an [extension](#contract) of the [Command](Command.md) abstraction for [logical commands](#implementations) that can be [executed](#run) for side effects.

## Contract

### <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

Executes the command for side effects (possibly giving [Row](spark-sql-Row.md) back with the result)

Used when:

* [ExecutedCommandExec](../physical-operators/ExecutedCommandExec.md) leaf physical operator is executed (and [caches the result](../physical-operators/ExecutedCommandExec.md#sideEffectResult))
* [InsertIntoHadoopFsRelationCommand](InsertIntoHadoopFsRelationCommand.md) is executed

## Implementations

* [AddFileCommand](AddFileCommand.md)
* [AddJarCommand](AddJarCommand.md)
* [AlterDatabasePropertiesCommand](AlterDatabasePropertiesCommand.md)
* [AlterDatabaseSetLocationCommand](AlterDatabaseSetLocationCommand.md)
* [AlterTableAddColumnsCommand](AlterTableAddColumnsCommand.md)
* [AlterTableAddPartitionCommand](AlterTableAddPartitionCommand.md)
* [AlterTableChangeColumnCommand](AlterTableChangeColumnCommand.md)
* [AlterTableDropPartitionCommand](AlterTableDropPartitionCommand.md)
* [AlterTableRecoverPartitionsCommand](AlterTableRecoverPartitionsCommand.md)
* [AlterTableRenameCommand](AlterTableRenameCommand.md)
* [AlterTableRenamePartitionCommand](AlterTableRenamePartitionCommand.md)
* [AlterTableSerDePropertiesCommand](AlterTableSerDePropertiesCommand.md)
* [AlterTableSetLocationCommand](AlterTableSetLocationCommand.md)
* [AlterTableSetPropertiesCommand](AlterTableSetPropertiesCommand.md)
* [AlterTableUnsetPropertiesCommand](AlterTableUnsetPropertiesCommand.md)
* [AlterViewAsCommand](AlterViewAsCommand.md)
* [AnalyzeColumnCommand](AnalyzeColumnCommand.md)
* [AnalyzePartitionCommand](AnalyzePartitionCommand.md)
* [AnalyzeTableCommand](AnalyzeTableCommand.md)
* [CacheTableCommand](CacheTableCommand.md)
* [ClearCacheCommand](ClearCacheCommand.md)
* [CreateDatabaseCommand](CreateDatabaseCommand.md)
* [CreateDataSourceTableCommand](CreateDataSourceTableCommand.md)
* [CreateFunctionCommand](CreateFunctionCommand.md)
* [CreateTableCommand](CreateTableCommand.md)
* [CreateTableLikeCommand](CreateTableLikeCommand.md)
* [CreateTempViewUsing](CreateTempViewUsing.md)
* [CreateViewCommand](CreateViewCommand.md)
* [DescribeColumnCommand](DescribeColumnCommand.md)
* [DescribeCommandBase](DescribeCommandBase.md)
* [DescribeDatabaseCommand](DescribeDatabaseCommand.md)
* [DescribeFunctionCommand](DescribeFunctionCommand.md)
* [DropDatabaseCommand](DropDatabaseCommand.md)
* [DropFunctionCommand](DropFunctionCommand.md)
* [DropTableCommand](DropTableCommand.md)
* [ExplainCommand](ExplainCommand.md)
* [ExternalCommandExecutor](ExternalCommandExecutor.md)
* [InsertIntoDataSourceCommand](InsertIntoDataSourceCommand.md)
* [InsertIntoDataSourceDirCommand](InsertIntoDataSourceDirCommand.md)
* [ListFilesCommand](ListFilesCommand.md)
* [ListJarsCommand](ListJarsCommand.md)
* [LoadDataCommand](LoadDataCommand.md)
* [RefreshResource](RefreshResource.md)
* [RefreshTable](RefreshTable.md)
* [ResetCommand](ResetCommand.md)
* [SaveIntoDataSourceCommand](SaveIntoDataSourceCommand.md)
* [SetCommand](SetCommand.md)
* [ShowColumnsCommand](ShowColumnsCommand.md)
* [ShowCreateTableAsSerdeCommand](ShowCreateTableAsSerdeCommand.md)
* [ShowCreateTableCommand](ShowCreateTableCommand.md)
* [ShowFunctionsCommand](ShowFunctionsCommand.md)
* [ShowPartitionsCommand](ShowPartitionsCommand.md)
* [ShowTablePropertiesCommand](ShowTablePropertiesCommand.md)
* [ShowTablesCommand](ShowTablesCommand.md)
* [ShowViewsCommand](ShowViewsCommand.md)
* [StreamingExplainCommand](StreamingExplainCommand.md)
* [TruncateTableCommand](TruncateTableCommand.md)
* [UncacheTableCommand](UncacheTableCommand.md)

## Query Planning

`RunnableCommand` logical operators are resolved to [ExecutedCommandExec](../physical-operators/ExecutedCommandExec.md) physical operators in [BasicOperators](../execution-planning-strategies/BasicOperators.md#RunnableCommand) execution planning strategy.

## <span id="metrics"> Performance Metrics

```scala
metrics: Map[String, SQLMetric]
```

`RunnableCommand` can define optional [performance metrics](../SQLMetric.md).

`metrics` is empty by default.

??? note "Lazy Value"
    `metrics` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and cached afterwards.

`metrics` is used when [ExecutedCommandExec](../physical-operators/ExecutedCommandExec.md) leaf physical operator is executed (and requested for [performance metrics](../physical-operators/ExecutedCommandExec.md#metrics)).
