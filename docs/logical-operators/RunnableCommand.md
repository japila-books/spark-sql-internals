# RunnableCommand -- Generic Logical Command with Side Effects

`RunnableCommand` is the generic spark-sql-LogicalPlan-Command.md[logical command] that is <<run, executed>> eagerly for its side effects.

[[contract]]
[[run]]
`RunnableCommand` defines one abstract method `run` that computes a collection of spark-sql-Row.md[Row] records with the side effect, i.e. the result of executing a command.

[source, scala]
----
run(sparkSession: SparkSession): Seq[Row]
----

!!! note
    `RunnableCommand` logical operator is resolved to spark-sql-SparkPlan-ExecutedCommandExec.md[ExecutedCommandExec] physical operator in [BasicOperators](../execution-planning-strategies/BasicOperators.md#RunnableCommand) execution planning strategy.

[NOTE]
====
`run` is executed when:

* `ExecutedCommandExec` spark-sql-SparkPlan-ExecutedCommandExec.md#sideEffectResult[executes logical RunnableCommand and caches the result as InternalRows]

* `InsertIntoHadoopFsRelationCommand` is spark-sql-LogicalPlan-InsertIntoHadoopFsRelationCommand.md#run[executed]

* `QueryExecution` is requested to spark-sql-QueryExecution.md#hiveResultString[transform the result of executing DescribeTableCommand to a Hive-compatible output format]
====

[[available-commands]]
.Available RunnableCommands
[width="100%",cols="1,2",options="header"]
|===
| RunnableCommand
| Description

| AddFileCommand
|

| AddJarCommand
|

| AlterDatabasePropertiesCommand
|

| AlterTableAddPartitionCommand
| [[AlterTableAddPartitionCommand]]

| AlterTableChangeColumnCommand
|

| AlterTableDropPartitionCommand
|

| [AlterTableRecoverPartitionsCommand](AlterTableRecoverPartitionsCommand.md)
|

| AlterTableRenameCommand
|

| AlterTableRenamePartitionCommand
|

| AlterTableSerDePropertiesCommand
|

| AlterTableSetLocationCommand
|

| AlterTableSetPropertiesCommand
|

| AlterTableUnsetPropertiesCommand
|

| AlterViewAsCommand
|

| spark-sql-LogicalPlan-AnalyzeColumnCommand.md[AnalyzeColumnCommand]
| [[AnalyzeColumnCommand]]

| spark-sql-LogicalPlan-AnalyzePartitionCommand.md[AnalyzePartitionCommand]
| [[AnalyzePartitionCommand]]

| spark-sql-LogicalPlan-AnalyzeTableCommand.md[AnalyzeTableCommand]
| [[AnalyzeTableCommand]]

| CacheTableCommand
a| [[CacheTableCommand]] When <<run, executed>>, `CacheTableCommand` spark-sql-Dataset.md#ofRows[creates a DataFrame] followed by spark-sql-dataset-operators.md#createTempView[registering a temporary view] for the optional `query`.

[source, scala]
----
CACHE LAZY? TABLE [table] (AS? [query])?
----

`CacheTableCommand` requests the session-specific `Catalog` to spark-sql-Catalog.md#cacheTable[cache the table].

NOTE: `CacheTableCommand` uses `SparkSession` SparkSession.md#catalog[to access the `Catalog`].

If the caching is not `LAZY` (which is not by default), `CacheTableCommand` SparkSession.md#table[creates a DataFrame for the table] and spark-sql-dataset-operators.md#count[counts the rows] (that will trigger the caching).

NOTE: `CacheTableCommand` uses a Spark SQL pattern to trigger DataFrame caching by executing `count` operation.

[source, scala]
----
val q = "CACHE TABLE ids AS SELECT * from range(5)"
scala> println(sql(q).queryExecution.logical.numberedTreeString)
00 CacheTableCommand `ids`, false
01    +- 'Project [*]
02       +- 'UnresolvedTableValuedFunction range, [5]

// ids table is already cached but let's use it anyway (and see what happens)
val q2 = "CACHE LAZY TABLE ids"
scala> println(sql(q2).queryExecution.logical.numberedTreeString)
17/05/17 06:16:39 WARN CacheManager: Asked to cache already cached data.
00 CacheTableCommand `ids`, true
----

| ClearCacheCommand
|

| CreateDatabaseCommand
|

| spark-sql-LogicalPlan-CreateDataSourceTableAsSelectCommand.md[CreateDataSourceTableAsSelectCommand]
| [[CreateDataSourceTableAsSelectCommand]] When <<run, executed>>, ...FIXME

Used exclusively when [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) posthoc logical resolution rule resolves a spark-sql-LogicalPlan-CreateTable.md[CreateTable] logical operator with queries using non-Hive table providers (which is when `DataFrameWriter` spark-sql-DataFrameWriter.md#saveAsTable[saves a DataFrame to a non-Hive table] or for spark-sql-SparkSqlAstBuilder.md#visitCreateTable[Create Table As Select] SQL statements)

| spark-sql-LogicalPlan-CreateDataSourceTableCommand.md[CreateDataSourceTableCommand]
| [[CreateDataSourceTableCommand]]

| CreateFunctionCommand
|

| <<spark-sql-LogicalPlan-CreateTableCommand.md#, CreateTableCommand>>
| [[CreateTableCommand]]

| CreateTableLikeCommand
|

| <<spark-sql-LogicalPlan-CreateTempViewUsing.md#, CreateTempViewUsing>>
| [[CreateTempViewUsing]]

| <<spark-sql-LogicalPlan-CreateViewCommand.md#, CreateViewCommand>>
| [[CreateViewCommand]]

| spark-sql-LogicalPlan-DescribeColumnCommand.md[DescribeColumnCommand]
| [[DescribeColumnCommand]]

| DescribeDatabaseCommand
|

| DescribeFunctionCommand
|

| spark-sql-LogicalPlan-DescribeTableCommand.md[DescribeTableCommand]
| [[DescribeTableCommand]]

| DropDatabaseCommand
|

| DropFunctionCommand
|

| DropTableCommand
|

| ExplainCommand
|

| <<spark-sql-LogicalPlan-InsertIntoDataSourceCommand.md#, InsertIntoDataSourceCommand>>
| [[InsertIntoDataSourceCommand]]

| spark-sql-LogicalPlan-InsertIntoHadoopFsRelationCommand.md[InsertIntoHadoopFsRelationCommand]
| [[InsertIntoHadoopFsRelationCommand]]

| hive/InsertIntoHiveTable.md[InsertIntoHiveTable]
| [[InsertIntoHiveTable]]

| ListFilesCommand
|

| ListJarsCommand
|

| LoadDataCommand
|

| RefreshResource
|

| RefreshTable
|

| ResetCommand
|

| SaveIntoDataSourceCommand
| [[SaveIntoDataSourceCommand]] When <<run, executed>>, requests `DataSource` to spark-sql-DataSource.md#write[write a DataFrame to a data source per save mode].

Used exclusively when `DataFrameWriter` is requested to spark-sql-DataFrameWriter.md#save[save a DataFrame to a data source].

| SetCommand
| [[SetCommand]]

| SetDatabaseCommand
|

| ShowColumnsCommand
|

| <<spark-sql-LogicalPlan-ShowCreateTableCommand.md#, ShowCreateTableCommand>>
| [[ShowCreateTableCommand]]

| ShowDatabasesCommand
|

| ShowFunctionsCommand
|

| ShowPartitionsCommand
|

| ShowTablePropertiesCommand
|

| <<spark-sql-LogicalPlan-ShowTablesCommand.md#, ShowTablesCommand>>
| [[ShowTablesCommand]]

| StreamingExplainCommand
|

| xref:spark-sql-LogicalPlan-TruncateTableCommand.md[TruncateTableCommand]
| [[TruncateTableCommand]]

| UncacheTableCommand
|
|===
