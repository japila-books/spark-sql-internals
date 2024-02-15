---
title: CreateDataSourceTableAsSelectCommand
---

# CreateDataSourceTableAsSelectCommand Logical Command

`CreateDataSourceTableAsSelectCommand` is a <<DataWritingCommand.md#, logical command>> that <<run, creates a DataSource table>> with the data from a <<query, structured query>> (_AS query_).

NOTE: A DataSource table is a Spark SQL native table that uses any data source but Hive (per `USING` clause).

`CreateDataSourceTableAsSelectCommand` is <<creating-instance, created>> when [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) post-hoc logical resolution rule is executed (and resolves a CreateTable.md[CreateTable] logical operator for a Spark table with a <<query, AS query>>).

NOTE: CreateDataSourceTableCommand.md[CreateDataSourceTableCommand] is used instead when a CreateTable.md[CreateTable] logical operator is used with no <<query, AS query>>.

[source,plaintext]
----
val ctas = """
  CREATE TABLE users
  USING csv
  COMMENT 'users table'
  LOCATION '/tmp/users'
  AS SELECT * FROM VALUES ((0, "jacek"))
"""
scala> sql(ctas)
... WARN HiveExternalCatalog: Couldn't find corresponding Hive SerDe for data source provider csv. Persisting data source table `default`.`users` into Hive metastore in Spark SQL specific format, which is NOT compatible with Hive.

val plan = sql(ctas).queryExecution.logical.numberedTreeString
org.apache.spark.sql.AnalysisException: Table default.users already exists. You need to drop it first.;
  at org.apache.spark.sql.execution.command.CreateDataSourceTableAsSelectCommand.run(createDataSourceTables.scala:159)
  at org.apache.spark.sql.execution.command.DataWritingCommandExec.sideEffectResult$lzycompute(commands.scala:104)
  at org.apache.spark.sql.execution.command.DataWritingCommandExec.sideEffectResult(commands.scala:102)
  at org.apache.spark.sql.execution.command.DataWritingCommandExec.executeCollect(commands.scala:115)
  at org.apache.spark.sql.Dataset.$anonfun$logicalPlan$1(Dataset.scala:194)
  at org.apache.spark.sql.Dataset.$anonfun$withAction$2(Dataset.scala:3370)
  at org.apache.spark.sql.execution.SQLExecution$.$anonfun$withNewExecutionId$1(SQLExecution.scala:78)
  at org.apache.spark.sql.execution.SQLExecution$.withSQLConfPropagated(SQLExecution.scala:125)
  at org.apache.spark.sql.execution.SQLExecution$.withNewExecutionId(SQLExecution.scala:73)
  at org.apache.spark.sql.Dataset.withAction(Dataset.scala:3370)
  at org.apache.spark.sql.Dataset.<init>(Dataset.scala:194)
  at org.apache.spark.sql.Dataset$.ofRows(Dataset.scala:79)
  at org.apache.spark.sql.SparkSession.sql(SparkSession.scala:642)
  ... 49 elided
----

## Creating Instance

`CreateDataSourceTableAsSelectCommand` takes the following to be created:

* [[table]] [CatalogTable](../CatalogTable.md)
* [[mode]] [SaveMode](../DataFrameWriter.md#SaveMode)
* [[query]] AS query ([LogicalPlan](../logical-operators/LogicalPlan.md))
* [[outputColumnNames]] Output column names (`Seq[String]`)

=== [[run]] Executing Data-Writing Logical Command -- `run` Method

[source, scala]
----
run(
  sparkSession: SparkSession,
  child: SparkPlan): Seq[Row]
----

NOTE: `run` is part of DataWritingCommand.md#run[DataWritingCommand] contract.

`run`...FIXME

`run` throws an `AssertionError` when the [tableType](../CatalogTable.md#tableType) of the [CatalogTable](#table) is `VIEW` or the [provider](../CatalogTable.md#provider) is undefined.

## <span id="saveDataIntoTable"> saveDataIntoTable

```scala
saveDataIntoTable(
  session: SparkSession,
  table: CatalogTable,
  tableLocation: Option[URI],
  physicalPlan: SparkPlan,
  mode: SaveMode,
  tableExists: Boolean): BaseRelation
```

`saveDataIntoTable` creates a [BaseRelation](../BaseRelation.md) for...FIXME

`saveDataIntoTable`...FIXME
