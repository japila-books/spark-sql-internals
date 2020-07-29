title: DescribeColumnCommand

# DescribeColumnCommand Logical Command for DESCRIBE TABLE SQL Command with Column

`DescribeColumnCommand` is a spark-sql-LogicalPlan-RunnableCommand.md[logical command] for spark-sql-SparkSqlAstBuilder.md#DescribeColumnCommand[DESCRIBE TABLE] SQL command with a single column only (i.e. no `PARTITION` specification).

```
[DESC|DESCRIBE] TABLE? [EXTENDED|FORMATTED] table_name column_name
```

[source, scala]
----
// Make the example reproducible
val tableName = "t1"
import org.apache.spark.sql.catalyst.TableIdentifier
val tableId = TableIdentifier(tableName)

val sessionCatalog = spark.sessionState.catalog
sessionCatalog.dropTable(tableId, ignoreIfNotExists = true, purge = true)

val df = Seq((0, 0.0, "zero"), (1, 1.4, "one")).toDF("id", "p1", "p2")
df.write.saveAsTable("t1")

// DescribeColumnCommand represents DESC EXTENDED tableName colName SQL command
val descExtSQL = "DESC EXTENDED t1 p1"
val plan = spark.sql(descExtSQL).queryExecution.logical
import org.apache.spark.sql.execution.command.DescribeColumnCommand
val cmd = plan.asInstanceOf[DescribeColumnCommand]
scala> println(cmd)
DescribeColumnCommand `t1`, [p1], true

scala> spark.sql(descExtSQL).show
+--------------+----------+
|     info_name|info_value|
+--------------+----------+
|      col_name|        p1|
|     data_type|    double|
|       comment|      NULL|
|           min|      NULL|
|           max|      NULL|
|     num_nulls|      NULL|
|distinct_count|      NULL|
|   avg_col_len|      NULL|
|   max_col_len|      NULL|
|     histogram|      NULL|
+--------------+----------+

// Run ANALYZE TABLE...FOR COLUMNS SQL command to compute the column statistics
val allCols = df.columns.mkString(",")
val analyzeTableSQL = s"ANALYZE TABLE $tableName COMPUTE STATISTICS FOR COLUMNS $allCols"
spark.sql(analyzeTableSQL)

scala> spark.sql(descExtSQL).show
+--------------+----------+
|     info_name|info_value|
+--------------+----------+
|      col_name|        p1|
|     data_type|    double|
|       comment|      NULL|
|           min|       0.0|
|           max|       1.4|
|     num_nulls|         0|
|distinct_count|         2|
|   avg_col_len|         8|
|   max_col_len|         8|
|     histogram|      NULL|
+--------------+----------+
----

[[output]]
`DescribeColumnCommand` defines the spark-sql-LogicalPlan-Command.md#output[output schema] with the following columns:

* `info_name` with "name of the column info" comment
* `info_value` with "value of the column info" comment

## describeTable Labeled Alternative

`DescribeColumnCommand` is described by `describeTable` labeled alternative in `statement` expression in [SqlBase.g4](../sql/AstBuilder.md#grammar) and parsed using [SparkSqlParser](../sql/SparkSqlParser.md#visitDescribeTable).

=== [[run]] Executing Logical Command (Describing Column with Optional Statistics) -- `run` Method

[source, scala]
----
run(session: SparkSession): Seq[Row]
----

NOTE: `run` is part of <<spark-sql-LogicalPlan-RunnableCommand.md#run, RunnableCommand Contract>> to execute (run) a logical command.

`run` resolves the <<colNameParts, column name>> in <<table, table>> and makes sure that it is a "flat" field (i.e. not of a nested data type).

`run` requests the `SessionCatalog` for the spark-sql-SessionCatalog.md#getTempViewOrPermanentTableMetadata[table metadata].

NOTE: `run` uses the input `SparkSession` to access SparkSession.md#sessionState[SessionState] that in turn is used to access the SessionState.md#catalog[SessionCatalog].

`run` takes the spark-sql-CatalogStatistics.md#colStats[column statistics] from the  spark-sql-CatalogTable.md#stats[table statistics] if available.

NOTE: spark-sql-CatalogStatistics.md#colStats[Column statistics] are available (in the spark-sql-CatalogTable.md#stats[table statistics]) only after spark-sql-LogicalPlan-AnalyzeColumnCommand.md[ANALYZE TABLE FOR COLUMNS] SQL command was run.

`run` adds `comment` metadata if available for the <<colNameParts, column>>.

`run` gives the following rows (in that order):

. `col_name`
. `data_type`
. `comment`

If `DescribeColumnCommand` command was executed with <<isExtended, EXTENDED or FORMATTED option>>, `run` gives the following additional rows (in that order):

. `min`
. `max`
. `num_nulls`
. `distinct_count`
. `avg_col_len`
. `max_col_len`
. <<histogramDescription, histogram>>

`run` gives `NULL` for the value of the comment and statistics if not available.

=== [[histogramDescription]] `histogramDescription` Internal Method

[source, scala]
----
histogramDescription(histogram: Histogram): Seq[Row]
----

`histogramDescription`...FIXME

NOTE: `histogramDescription` is used exclusively when `DescribeColumnCommand` is <<run, executed>> with `EXTENDED` or `FORMATTED` option turned on.

=== [[creating-instance]] Creating DescribeColumnCommand Instance

`DescribeColumnCommand` takes the following when created:

* [[table]] `TableIdentifier`
* [[colNameParts]] Column name
* [[isExtended]] `isExtended` flag that indicates whether spark-sql-SparkSqlAstBuilder.md#DescribeColumnCommand[EXTENDED or FORMATTED option] was used or not
