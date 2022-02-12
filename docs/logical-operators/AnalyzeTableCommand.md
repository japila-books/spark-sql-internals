# AnalyzeTableCommand Logical Command

`AnalyzeTableCommand` is a [LeafRunnableCommand](LeafRunnableCommand.md) that [computes statistics](#run) (and stores them in a metastore).

## Creating Instance

`AnalyzeTableCommand` takes the following to be created:

* <span id="tableIdent"> Multi-part table identifier
* <span id="noScan"> `noScan` flag (default: `true` that indicates whether [NOSCAN](../cost-based-optimization.md#NOSCAN) option was used or not)

`AnalyzeTableCommand` is created when:

* [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule is executed (and resolves an [AnalyzeTable](AnalyzeTable.md) logical operator with no `PARTITION`s)

## <span id="run"> run

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` [analyzes](../CommandUtils.md#analyzeTable) the given [table](#tableIdent).

`run` returns an empty collection.

`run` is part of the [RunnableCommand](RunnableCommand.md#run) abstraction.

## Demo

### AnalyzeTableCommand

```text
// Seq((0, 0, "zero"), (1, 1, "one")).toDF("id", "p1", "p2").write.partitionBy("p1", "p2").saveAsTable("t1")
val sqlText = "ANALYZE TABLE t1 COMPUTE STATISTICS NOSCAN"
val plan = spark.sql(sqlText).queryExecution.logical
import org.apache.spark.sql.execution.command.AnalyzeTableCommand
val cmd = plan.asInstanceOf[AnalyzeTableCommand]
scala> println(cmd)
AnalyzeTableCommand `t1`, false
```

### CREATE TABLE

```scala
sql("CREATE TABLE demo_cbo VALUES (0, 'zero'), (1, 'one') AS t1(id, name)")
```

```text
scala> sql("desc extended demo_cbo").show(numRows = Integer.MAX_VALUE, truncate = false)
+----------------------------+----------------------------------------------------------+-------+
|col_name                    |data_type                                                 |comment|
+----------------------------+----------------------------------------------------------+-------+
|id                          |int                                                       |null   |
|name                        |string                                                    |null   |
|                            |                                                          |       |
|# Detailed Table Information|                                                          |       |
|Database                    |default                                                   |       |
|Table                       |demo_cbo                                                  |       |
|Owner                       |jacek                                                     |       |
|Created Time                |Sat Feb 12 19:51:15 CET 2022                              |       |
|Last Access                 |UNKNOWN                                                   |       |
|Created By                  |Spark 3.2.1                                               |       |
|Type                        |MANAGED                                                   |       |
|Provider                    |hive                                                      |       |
|Table Properties            |[transient_lastDdlTime=1644691875]                        |       |
|Statistics                  |13 bytes                                                  |       |
|Location                    |file:/Users/jacek/dev/oss/spark/spark-warehouse/demo_cbo  |       |
|Serde Library               |org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe        |       |
|InputFormat                 |org.apache.hadoop.mapred.TextInputFormat                  |       |
|OutputFormat                |org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat|       |
|Storage Properties          |[serialization.format=1]                                  |       |
|Partition Provider          |Catalog                                                   |       |
+----------------------------+----------------------------------------------------------+-------+
```

### ANALYZE TABLE COMPUTE STATISTICS

```scala
sql("ANALYZE TABLE demo_cbo COMPUTE STATISTICS")
```

Note the extra `Statistics` row.

```text
scala> sql("desc extended demo_cbo").show(numRows = Integer.MAX_VALUE, truncate = false)
+----------------------------+----------------------------------------------------------+-------+
|col_name                    |data_type                                                 |comment|
+----------------------------+----------------------------------------------------------+-------+
|id                          |int                                                       |null   |
|name                        |string                                                    |null   |
|                            |                                                          |       |
|# Detailed Table Information|                                                          |       |
|Database                    |default                                                   |       |
|Table                       |demo_cbo                                                  |       |
|Owner                       |jacek                                                     |       |
|Created Time                |Sat Feb 12 19:51:15 CET 2022                              |       |
|Last Access                 |UNKNOWN                                                   |       |
|Created By                  |Spark 3.2.1                                               |       |
|Type                        |MANAGED                                                   |       |
|Provider                    |hive                                                      |       |
|Table Properties            |[transient_lastDdlTime=1644691915]                        |       |
|Statistics                  |13 bytes, 2 rows                                          |       |
|Location                    |file:/Users/jacek/dev/oss/spark/spark-warehouse/demo_cbo  |       |
|Serde Library               |org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe        |       |
|InputFormat                 |org.apache.hadoop.mapred.TextInputFormat                  |       |
|OutputFormat                |org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat|       |
|Storage Properties          |[serialization.format=1]                                  |       |
|Partition Provider          |Catalog                                                   |       |
+----------------------------+----------------------------------------------------------+-------+
```

### FOR ALL COLUMNS

```scala
sql("ANALYZE TABLE demo_cbo COMPUTE STATISTICS FOR ALL COLUMNS")
```

```text
// Use describeColName
scala> sql("desc extended demo_cbo id").show(numRows = Integer.MAX_VALUE, truncate = false)
+--------------+----------+
|info_name     |info_value|
+--------------+----------+
|col_name      |id        |
|data_type     |int       |
|comment       |NULL      |
|min           |0         |
|max           |1         |
|num_nulls     |0         |
|distinct_count|2         |
|avg_col_len   |4         |
|max_col_len   |4         |
|histogram     |NULL      |
+--------------+----------+
```

```text
scala> sql("desc extended demo_cbo name").show(numRows = Integer.MAX_VALUE, truncate = false)
+--------------+----------+
|info_name     |info_value|
+--------------+----------+
|col_name      |name      |
|data_type     |string    |
|comment       |NULL      |
|min           |NULL      |
|max           |NULL      |
|num_nulls     |0         |
|distinct_count|2         |
|avg_col_len   |4         |
|max_col_len   |4         |
|histogram     |NULL      |
+--------------+----------+
```
