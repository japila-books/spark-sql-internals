# RunnableCommand Logical Operators

`RunnableCommand` is an [extension](#contract) of the [Command](Command.md) abstraction for [logical commands](#implementations) that can be [executed](#run) for side effects.

## Contract

### <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

Executes the command for side effects (possibly giving [Row](../Row.md) back with the result)

Used when:

* [ExecutedCommandExec](../physical-operators/ExecutedCommandExec.md) leaf physical operator is executed (and [caches the result](../physical-operators/ExecutedCommandExec.md#sideEffectResult))
* [InsertIntoHadoopFsRelationCommand](InsertIntoHadoopFsRelationCommand.md) is executed

## Implementations

* AddFileCommand
* AddJarCommand
* AlterDatabasePropertiesCommand
* AlterDatabaseSetLocationCommand
* AlterTableAddColumnsCommand
* AlterTableAddPartitionCommand
* AlterTableChangeColumnCommand
* AlterTableDropPartitionCommand
* AlterTableRecoverPartitionsCommand
* AlterTableRenameCommand
* AlterTableRenamePartitionCommand
* AlterTableSerDePropertiesCommand
* AlterTableSetLocationCommand
* AlterTableSetPropertiesCommand
* AlterTableUnsetPropertiesCommand
* AlterViewAsCommand
* [AnalyzeColumnCommand](AnalyzeColumnCommand.md)
* [AnalyzePartitionCommand](AnalyzePartitionCommand.md)
* [AnalyzeTableCommand](AnalyzeTableCommand.md)
* [CacheTableCommand](CacheTableCommand.md)
* [ClearCacheCommand](ClearCacheCommand.md)
* CreateDatabaseCommand
* [CreateDataSourceTableCommand](CreateDataSourceTableCommand.md)
* CreateFunctionCommand
* [CreateTableCommand](CreateTableCommand.md)
* CreateTableLikeCommand
* [CreateTempViewUsing](CreateTempViewUsing.md)
* [CreateViewCommand](CreateViewCommand.md)
* [DescribeColumnCommand](DescribeColumnCommand.md)
* DescribeCommandBase
* DescribeDatabaseCommand
* DescribeFunctionCommand
* DropDatabaseCommand
* DropFunctionCommand
* [DropTableCommand](DropTableCommand.md)
* [ExplainCommand](ExplainCommand.md)
* ExternalCommandExecutor
* [InsertIntoDataSourceCommand](InsertIntoDataSourceCommand.md)
* [InsertIntoDataSourceDirCommand](InsertIntoDataSourceDirCommand.md)
* ListFilesCommand
* ListJarsCommand
* LoadDataCommand
* RefreshResource
* RefreshTable
* ResetCommand
* [SaveIntoDataSourceCommand](SaveIntoDataSourceCommand.md)
* SetCommand
* ShowColumnsCommand
* ShowCreateTableAsSerdeCommand
* [ShowCreateTableCommand](ShowCreateTableCommand.md)
* ShowFunctionsCommand
* ShowPartitionsCommand
* ShowTablePropertiesCommand
* [ShowTablesCommand](ShowTablesCommand.md)
* ShowViewsCommand
* StreamingExplainCommand
* [TruncateTableCommand](TruncateTableCommand.md)
* UncacheTableCommand

## Query Planning

`RunnableCommand` logical operators are resolved to [ExecutedCommandExec](../physical-operators/ExecutedCommandExec.md) physical operators in [BasicOperators](../execution-planning-strategies/BasicOperators.md#RunnableCommand) execution planning strategy.

## <span id="metrics"> Performance Metrics

```scala
metrics: Map[String, SQLMetric]
```

`RunnableCommand` can define optional [performance metrics](../physical-operators/SQLMetric.md).

`metrics` is empty by default.

??? note "Lazy Value"
    `metrics` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and cached afterwards.

`metrics` is used when [ExecutedCommandExec](../physical-operators/ExecutedCommandExec.md) leaf physical operator is executed (and requested for [performance metrics](../physical-operators/ExecutedCommandExec.md#metrics)).
