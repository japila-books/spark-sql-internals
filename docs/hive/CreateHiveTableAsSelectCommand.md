# CreateHiveTableAsSelectCommand Logical Command

`CreateHiveTableAsSelectCommand` is a [logical command](../logical-operators/DataWritingCommand.md) that writes the result of executing a <<query, structured query>> to a <<tableDesc, Hive table>> (per <<mode, save mode>>).

`CreateHiveTableAsSelectCommand` uses the given <<tableDesc, CatalogTable>> for the [table name](../CatalogTable.md#identifier).

`CreateHiveTableAsSelectCommand` is <<creating-instance, created>> when HiveAnalysis.md[HiveAnalysis] logical resolution rule is executed and resolves a ../CreateTable.md[CreateTable] logical operator with a child structured query and a Hive table.

When <<run, executed>>, `CreateHiveTableAsSelectCommand` runs (_morphs itself into_) a InsertIntoHiveTable.md[InsertIntoHiveTable] logical command.

```text
val tableName = "create_hive_table_as_select_demo"
val q = sql(s"""CREATE TABLE IF NOT EXISTS $tableName USING hive SELECT 1L AS id""")
scala> q.explain(extended = true)
== Parsed Logical Plan ==
'CreateTable `create_hive_table_as_select_demo`, Ignore
+- Project [1 AS id#74L]
   +- OneRowRelation

== Analyzed Logical Plan ==
CreateHiveTableAsSelectCommand [Database:default, TableName: create_hive_table_as_select_demo, InsertIntoHiveTable]
+- Project [1 AS id#74L]
   +- OneRowRelation

== Optimized Logical Plan ==
CreateHiveTableAsSelectCommand [Database:default, TableName: create_hive_table_as_select_demo, InsertIntoHiveTable]
+- Project [1 AS id#74L]
   +- OneRowRelation

== Physical Plan ==
Execute CreateHiveTableAsSelectCommand CreateHiveTableAsSelectCommand [Database:default, TableName: create_hive_table_as_select_demo, InsertIntoHiveTable]
+- *(1) Project [1 AS id#74L]
   +- Scan OneRowRelation[]

scala> spark.table(tableName).show
+---+
| id|
+---+
|  1|
+---+
```

## Creating Instance

`CreateHiveTableAsSelectCommand` takes the following to be created:

* [[tableDesc]] [CatalogTable](../CatalogTable.md)
* [[query]] Structured query (as a [LogicalPlan](../logical-operators/LogicalPlan.md))
* [[outputColumnNames]] Names of the output columns
* [[mode]] [SaveMode](../DataFrameWriter.md#SaveMode)

=== [[run]] Executing Data-Writing Logical Command -- `run` Method

[source, scala]
----
run(
  sparkSession: SparkSession,
  child: SparkPlan): Seq[Row]
----

NOTE: `run` is part of ../DataWritingCommand.md#run[DataWritingCommand] contract.

In summary, `run` runs a InsertIntoHiveTable.md[InsertIntoHiveTable] logical command.

`run` requests the input ../SparkSession.md[SparkSession] for ../SparkSession.md#sessionState[SessionState] that is then requested for the ../SessionState.md#catalog[SessionCatalog].

`run` requests the `SessionCatalog` to ../SessionCatalog.md#tableExists[check out whether the table exists or not].

With the Hive table available, `run` validates the <<mode, save mode>> and runs a InsertIntoHiveTable.md[InsertIntoHiveTable] logical command (with `overwrite` and `ifPartitionNotExists` flags disabled).

When the Hive table is not available, `run` asserts that the [schema](../CatalogTable.md#schema) (of the <<tableDesc, CatalogTable>>) is not defined and requests the `SessionCatalog` to ../SessionCatalog.md#createTable[create the table] (with the `ignoreIfExists` flag disabled). In the end, `run` runs a InsertIntoHiveTable.md[InsertIntoHiveTable] logical command (with `overwrite` flag enabled and `ifPartitionNotExists` flag disabled).
