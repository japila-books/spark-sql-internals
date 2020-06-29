== [[CreateHiveTableAsSelectCommand]] CreateHiveTableAsSelectCommand Logical Command

`CreateHiveTableAsSelectCommand` is a link:../spark-sql-LogicalPlan-DataWritingCommand.adoc[logical command] that writes the result of executing a <<query, structured query>> to a <<tableDesc, Hive table>> (per <<mode, save mode>>).

`CreateHiveTableAsSelectCommand` uses the given <<tableDesc, CatalogTable>> for the link:../spark-sql-CatalogTable.adoc#identifier[table name].

`CreateHiveTableAsSelectCommand` is <<creating-instance, created>> when link:HiveAnalysis.adoc[HiveAnalysis] logical resolution rule is executed and resolves a link:../spark-sql-LogicalPlan-CreateTable.adoc[CreateTable] logical operator with a child structured query and a link:../spark-sql-DDLUtils.adoc#isHiveTable[Hive table].

When <<run, executed>>, `CreateHiveTableAsSelectCommand` runs (_morphs itself into_) a link:InsertIntoHiveTable.adoc[InsertIntoHiveTable] logical command.

[source, scala]
----
assert(spark.version == "2.4.5")

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
----

=== [[creating-instance]] Creating CreateHiveTableAsSelectCommand Instance

`CreateHiveTableAsSelectCommand` takes the following to be created:

* [[tableDesc]] link:../spark-sql-CatalogTable.adoc[CatalogTable]
* [[query]] Structured query (as a link:../spark-sql-LogicalPlan.adoc[LogicalPlan])
* [[outputColumnNames]] Names of the output columns
* [[mode]] link:../spark-sql-DataFrameWriter.adoc[SaveMode]

=== [[run]] Executing Data-Writing Logical Command -- `run` Method

[source, scala]
----
run(
  sparkSession: SparkSession,
  child: SparkPlan): Seq[Row]
----

NOTE: `run` is part of link:../spark-sql-LogicalPlan-DataWritingCommand.adoc#run[DataWritingCommand] contract.

In summary, `run` runs a link:InsertIntoHiveTable.adoc[InsertIntoHiveTable] logical command.

`run` requests the input link:../spark-sql-SparkSession.adoc[SparkSession] for link:../spark-sql-SparkSession.adoc#sessionState[SessionState] that is then requested for the link:../spark-sql-SessionState.adoc#catalog[SessionCatalog].

`run` requests the `SessionCatalog` to link:../spark-sql-SessionCatalog.adoc#tableExists[check out whether the table exists or not].

With the Hive table available, `run` validates the <<mode, save mode>> and runs a link:InsertIntoHiveTable.adoc[InsertIntoHiveTable] logical command (with `overwrite` and `ifPartitionNotExists` flags disabled).

When the Hive table is not available, `run` asserts that the link:../spark-sql-CatalogTable.adoc#schema[schema] (of the <<tableDesc, CatalogTable>>) is not defined and requests the `SessionCatalog` to link:../spark-sql-SessionCatalog.adoc#createTable[create the table] (with the `ignoreIfExists` flag disabled). In the end, `run` runs a link:InsertIntoHiveTable.adoc[InsertIntoHiveTable] logical command (with `overwrite` flag enabled and `ifPartitionNotExists` flag disabled).
