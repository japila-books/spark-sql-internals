---
title: ShowCreateTableCommand
---

# ShowCreateTableCommand Logical Command

`ShowCreateTableCommand` is a [logical command](RunnableCommand.md) that <<run, executes>> a `SHOW CREATE TABLE` SQL statement (with a data source / non-Hive or a Hive table).

`ShowCreateTableCommand` is <<creating-instance, created>> when `SparkSqlAstBuilder` is requested to parse <<spark-sql-SparkSqlAstBuilder.md#visitShowCreateTable, SHOW CREATE TABLE>> SQL statement.

[[output]]
`ShowCreateTableCommand` uses a single `createtab_stmt` column (of type [StringType](../types/DataType.md#StringType)) for the [output schema](Command.md#output).

```text
import org.apache.spark.sql.SaveMode
spark.range(10e4.toLong)
  .write
  .bucketBy(4, "id")
  .sortBy("id")
  .mode(SaveMode.Overwrite)
  .saveAsTable("bucketed_4_10e4")
scala> sql("SHOW CREATE TABLE bucketed_4_10e4").show(truncate = false)
+----------------------------------------------------------------------------------------------------------------------------------------------------+
|createtab_stmt                                                                                                                                      |
+----------------------------------------------------------------------------------------------------------------------------------------------------+
|CREATE TABLE `bucketed_4_10e4` (`id` BIGINT)
USING parquet
OPTIONS (
  `serialization.format` '1'
)
CLUSTERED BY (id)
SORTED BY (id)
INTO 4 BUCKETS
|
+----------------------------------------------------------------------------------------------------------------------------------------------------+

scala> sql("SHOW CREATE TABLE bucketed_4_10e4").as[String].collect.foreach(println)
CREATE TABLE `bucketed_4_10e4` (`id` BIGINT)
USING parquet
OPTIONS (
  `serialization.format` '1'
)
CLUSTERED BY (id)
SORTED BY (id)
INTO 4 BUCKETS

```

[[table]]
[[creating-instance]]
`ShowCreateTableCommand` takes a single `TableIdentifier` when created.

=== [[run]] Executing Logical Command -- `run` Method

[source, scala]
----
run(sparkSession: SparkSession): Seq[Row]
----

NOTE: `run` is part of <<RunnableCommand.md#run, RunnableCommand Contract>> to execute (run) a logical command.

`run` requests the `SparkSession` for the <<SparkSession.md#sessionState, SessionState>> that is used to access the <<SessionState.md#catalog, SessionCatalog>>.

`run` then requests the `SessionCatalog` to [retrieve the table metadata from the external catalog (metastore)](../SessionCatalog.md#getTableMetadata).

`run` then <<showCreateDataSourceTable, showCreateDataSourceTable>> for a data source / non-Hive table or <<showCreateHiveTable, showCreateHiveTable>> for a Hive table (per the [table metadata](../CatalogTable.md)).

In the end, `run` returns the `CREATE TABLE` statement in a single `Row`.

=== [[showHiveTableNonDataColumns]] `showHiveTableNonDataColumns` Internal Method

[source, scala]
----
showHiveTableNonDataColumns(metadata: CatalogTable, builder: StringBuilder): Unit
----

`showHiveTableNonDataColumns`...FIXME

NOTE: `showHiveTableNonDataColumns` is used exclusively when `ShowCreateTableCommand` logical command is requested to <<showCreateHiveTable, showCreateHiveTable>>.

=== [[showCreateHiveTable]] `showCreateHiveTable` Internal Method

[source, scala]
----
showCreateHiveTable(metadata: CatalogTable): String
----

`showCreateHiveTable`...FIXME

NOTE: `showCreateHiveTable` is used exclusively when `ShowCreateTableCommand` logical command is executed (with a Hive <<table, table>>).

=== [[showHiveTableHeader]] `showHiveTableHeader` Internal Method

[source, scala]
----
showHiveTableHeader(metadata: CatalogTable, builder: StringBuilder): Unit
----

`showHiveTableHeader`...FIXME

NOTE: `showHiveTableHeader` is used exclusively when `ShowCreateTableCommand` logical command is requested to <<showCreateHiveTable, showCreateHiveTable>>.
