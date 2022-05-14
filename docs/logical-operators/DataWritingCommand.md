# DataWritingCommand -- Logical Commands That Write Query Data

`DataWritingCommand` is an <<contract, extension>> of the <<Command.md#, Command contract>> for <<implementations, logical commands>> that write the result of executing <<query, query>> (_query data_) to a relation when <<run, executed>>.

`DataWritingCommand` is resolved to a <<DataWritingCommandExec.md#, DataWritingCommandExec>> physical operator when [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (i.e. plan a <<spark-sql-LogicalPlan.md#, logical plan>> to a <<SparkPlan.md#, physical plan>>).

[[contract]]
.DataWritingCommand Contract
[cols="1m,2",options="header",width="100%"]
|===
| Property
| Description

| outputColumnNames
a| [[outputColumnNames]]

[source, scala]
----
outputColumnNames: Seq[String]
----

The output column names of the <<query, analyzed input query plan>>

Used when `DataWritingCommand` is requested for the <<outputColumns, outputColumns>>

| query
a| [[query]]

[source, scala]
----
query: LogicalPlan
----

The analyzed <<spark-sql-LogicalPlan.md#, logical query plan>> representing the data to write (i.e. whose result will be inserted into a relation)

Used when `DataWritingCommand` is requested for the <<children, child nodes>> and <<outputColumns, outputColumns>>.

| run
a| [[run]]

[source, scala]
----
run(
  sparkSession: SparkSession,
  child: SparkPlan): Seq[Row]
----

Executes the command to write query data (the result of executing SparkPlan.md[structured query])

Used when:

* `DataWritingCommandExec` physical operator is requested for the [sideEffectResult](../physical-operators/DataWritingCommandExec.md#sideEffectResult)
* [CreateDataSourceTableAsSelectCommand](CreateDataSourceTableAsSelectCommand.md) logical command is executed
|===

[[children]]
When requested for the <<Command.md#children, child nodes>>, `DataWritingCommand` simply returns the <<query, logical query plan>>.

[[extensions]]
.DataWritingCommands (Direct Implementations and Extensions Only)
[cols="1,2",options="header",width="100%"]
|===
| DataWritingCommand
| Description

| CreateDataSourceTableAsSelectCommand.md[CreateDataSourceTableAsSelectCommand]
| [[CreateDataSourceTableAsSelectCommand]]

| hive/CreateHiveTableAsSelectCommand.md[CreateHiveTableAsSelectCommand]
| [[CreateHiveTableAsSelectCommand]]

| [InsertIntoHadoopFsRelationCommand](InsertIntoHadoopFsRelationCommand.md)
| [[InsertIntoHadoopFsRelationCommand]]

| hive/SaveAsHiveFile.md[SaveAsHiveFile]
| [[SaveAsHiveFile]] Commands that write query result as Hive files (i.e. hive/InsertIntoHiveDirCommand.md[InsertIntoHiveDirCommand] and hive/InsertIntoHiveTable.md[InsertIntoHiveTable])

|===

=== [[basicWriteJobStatsTracker]] `basicWriteJobStatsTracker` Method

[source, scala]
----
basicWriteJobStatsTracker(hadoopConf: Configuration): BasicWriteJobStatsTracker
----

`basicWriteJobStatsTracker` simply creates and returns a new [BasicWriteJobStatsTracker](../datasources/BasicWriteJobStatsTracker.md) (with the given Hadoop `Configuration` and the <<metrics, metrics>>).

[NOTE]
====
`basicWriteJobStatsTracker` is used when:

* `SaveAsHiveFile` is requested to <<hive/SaveAsHiveFile.md#saveAsHiveFile, saveAsHiveFile>> (when hive/InsertIntoHiveDirCommand.md[InsertIntoHiveDirCommand] and hive/InsertIntoHiveTable.md[InsertIntoHiveTable] logical commands are executed)

* [InsertIntoHadoopFsRelationCommand](InsertIntoHadoopFsRelationCommand.md) logical command is executed
====

=== [[outputColumns]] Output Columns -- `outputColumns` Method

[source, scala]
----
outputColumns: Seq[Attribute]
----

`outputColumns`...FIXME

[NOTE]
====
`outputColumns` is used when:

* hive/CreateHiveTableAsSelectCommand.md[CreateHiveTableAsSelectCommand], hive/InsertIntoHiveDirCommand.md[InsertIntoHiveDirCommand] and [InsertIntoHadoopFsRelationCommand](InsertIntoHadoopFsRelationCommand.md) logical commands are executed

* `SaveAsHiveFile` is requested to <<hive/SaveAsHiveFile.md#saveAsHiveFile, saveAsHiveFile>>
====

## <span id="metrics"> Performance Metrics

Key             | Name (in web UI)        | Description
----------------|-------------------------|---------
 numFiles   | number of written files   |
 numOutputBytes | bytes of written output |
 numOutputRows | number of output rows |
 numParts | number of dynamic part |
