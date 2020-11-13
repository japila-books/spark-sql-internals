# CreateTempViewUsing Logical Command

`CreateTempViewUsing` is a <<RunnableCommand.md#, logical command>> for <<run, creating or replacing a temporary view>> (global or not) using a <<provider, data source>>.

`CreateTempViewUsing` is <<creating-instance, created>> to represent <<spark-sql-SparkSqlAstBuilder.md#visitCreateTempViewUsing, CREATE TEMPORARY VIEW &hellip; USING>> SQL statements.

[source, scala]
----
val sqlText = s"""
    |CREATE GLOBAL TEMPORARY VIEW myTempCsvView
    |(id LONG, name STRING)
    |USING csv
  """.stripMargin
// Logical commands are executed at analysis
scala> sql(sqlText)
res4: org.apache.spark.sql.DataFrame = []

scala> spark.catalog.listTables(spark.sharedState.globalTempViewManager.database).show
+-------------+-----------+-----------+---------+-----------+
|         name|   database|description|tableType|isTemporary|
+-------------+-----------+-----------+---------+-----------+
|mytempcsvview|global_temp|       null|TEMPORARY|       true|
+-------------+-----------+-----------+---------+-----------+
----

=== [[run]] Executing Logical Command -- `run` Method

[source, scala]
----
run(sparkSession: SparkSession): Seq[Row]
----

NOTE: `run` is part of <<RunnableCommand.md#run, RunnableCommand Contract>> to execute (run) a logical command.

`run` [creates a DataSource](../DataSource.md#apply) and requests it to [resolve itself](../DataSource.md#resolveRelation) (and create a [BaseRelation](../BaseRelation.md)).

`run` then requests the input `SparkSession` to <<SparkSession.md#baseRelationToDataFrame, create a DataFrame from the BaseRelation>> that is used to <<Dataset.md#logicalPlan, get the analyzed logical plan>> (that is the view definition of the temporary table).

Depending on the <<global, global>> flag, `run` requests the `SessionCatalog` to [createGlobalTempView](../SessionCatalog.md#createGlobalTempView) (`global` flag is on) or [createTempView](../SessionCatalog.md#createTempView) (`global` flag is off).

`run` throws an `AnalysisException` when executed with `hive` <<provider, provider>>.

```
Hive data source can only be used with tables, you can't use it with CREATE TEMP VIEW USING
```
=== [[creating-instance]] Creating CreateTempViewUsing Instance

`CreateTempViewUsing` takes the following when created:

* [[tableIdent]] `TableIdentifier`
* [[userSpecifiedSchema]] Optional user-defined schema ([StructType](../StructType.md))
* [[replace]] `replace` flag
* [[global]] `global` flag
* [[provider]] Name of the [data source provider](../DataSource.md)
* [[options]] Options (as `Map[String, String]`)

## <span id="argString"> argString

```scala
argString: String
```

`argString`...FIXME

`argString` is part of the [TreeNode](../catalyst/TreeNode.md#argString) abstraction.
