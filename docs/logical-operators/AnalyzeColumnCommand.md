# AnalyzeColumnCommand Logical Command

`AnalyzeColumnCommand` is a [logical command](RunnableCommand.md) to represent [AnalyzeColumn](AnalyzeColumn.md) logical operator.

`AnalyzeColumnCommand` is not supported on views (unless they are [cached](#analyzeColumnInCachedData)).

## Creating Instance

`AnalyzeColumnCommand` takes the following to be created:

* <span id="tableIdent"> Table
* <span id="columnNames"> Column Names
* <span id="allColumns"> `allColumns` Flag

`AnalyzeColumnCommand` is created when:

* [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule is executed (to resolve an [AnalyzeColumn](AnalyzeColumn.md))

## <span id="run"> Executing Logical Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` is part of [RunnableCommand](RunnableCommand.md#run) abstraction.

`run` calculates the following statistics:

* sizeInBytes
* stats for each column

### <span id="computeColumnStats"> Computing Statistics for Specified Columns

```scala
computeColumnStats(
  sparkSession: SparkSession,
  tableIdent: TableIdentifier,
  columnNames: Seq[String]): (Long, Map[String, ColumnStat])
```

`computeColumnStats`...FIXME

### <span id="computePercentiles"> Computing Percentiles

```scala
computePercentiles(
  attributesToAnalyze: Seq[Attribute],
  sparkSession: SparkSession,
  relation: LogicalPlan): AttributeMap[ArrayData]
```

`computePercentiles`...FIXME

### <span id="analyzeColumnInCatalog"> analyzeColumnInCatalog

```scala
analyzeColumnInCatalog(
  sparkSession: SparkSession): Unit
```

`analyzeColumnInCatalog` requests the [SessionCatalog](../SessionState.md#catalog) for [getTableMetadata](../SessionCatalog.md#getTableMetadata) of the [table](#tableIdent).

For `VIEW` catalog tables, `analyzeColumnInCatalog` analyzes the [columnNames](#columnNames) if it's [a cached view](#analyzeColumnInCachedData) (or [throws an AnalysisException](#analyzeColumnInCatalog-AnalysisException)).

For `EXTERNAL` and `MANAGED` catalog tables, `analyzeColumnInCatalog` [getColumnsToAnalyze](#getColumnsToAnalyze) for the [columnNames](#columnNames).

`analyzeColumnInCatalog` [computeColumnStats](../CommandUtils.md#computeColumnStats) for the [columnNames](#columnNames).

`analyzeColumnInCatalog` [converts the column stats to CatalogColumnStat](../cost-based-optimization/ColumnStat.md#toCatalogColumnStat).

`analyzeColumnInCatalog` creates a [CatalogStatistics](../CatalogStatistics.md) with the following:

Property | Value
---------|-------
 `sizeInBytes` | [calculateTotalSize](../CommandUtils.md#calculateTotalSize)
 `rowCount` | [computeColumnStats](../CommandUtils.md#computeColumnStats)
 `colStats` | [CatalogStatistics](../CatalogTable.md#stats) with the new [CatalogColumnStat](../cost-based-optimization/CatalogColumnStat.md)s applied

In the end, `analyzeColumnInCatalog` requests the [SessionCatalog](../SessionState.md#catalog) to [alter](../SessionCatalog.md#alterTableStats) the [table](#tableIdent) with the new [CatalogStatistics](../CatalogStatistics.md).

#### <span id="analyzeColumnInCatalog-AnalysisException"> AnalysisException

`analyzeColumnInCatalog` throws the following `AnalysisException` unless the catalog view is cached:

```text
ANALYZE TABLE is not supported on views.
```

## Demo

`AnalyzeColumnCommand` can [generate column histograms](#computeColumnStats) when [spark.sql.statistics.histogram.enabled](../configuration-properties.md#spark.sql.statistics.histogram.enabled) configuration property is enabled. `AnalyzeColumnCommand` supports column histograms for the following [data types](../types/DataType.md):

* `IntegralType`
* `DecimalType`
* `DoubleType`
* `FloatType`
* `DateType`
* `TimestampType`

```text
// ./bin/spark-shell --conf spark.sql.statistics.histogram.enabled=true
// Use the above example to set up the environment
// Make sure that ANALYZE TABLE COMPUTE STATISTICS FOR COLUMNS was run with histogram enabled

// There are 254 bins by default
// Use spark.sql.statistics.histogram.numBins to control the bins
val descExtSQL = s"DESC EXTENDED $tableName p1"
scala> spark.sql(descExtSQL).show(truncate = false)
+--------------+-----------------------------------------------------+
|info_name     |info_value                                           |
+--------------+-----------------------------------------------------+
|col_name      |p1                                                   |
|data_type     |double                                               |
|comment       |NULL                                                 |
|min           |0.0                                                  |
|max           |1.4                                                  |
|num_nulls     |0                                                    |
|distinct_count|2                                                    |
|avg_col_len   |8                                                    |
|max_col_len   |8                                                    |
|histogram     |height: 0.007874015748031496, num_of_bins: 254       |
|bin_0         |lower_bound: 0.0, upper_bound: 0.0, distinct_count: 1|
|bin_1         |lower_bound: 0.0, upper_bound: 0.0, distinct_count: 1|
|bin_2         |lower_bound: 0.0, upper_bound: 0.0, distinct_count: 1|
|bin_3         |lower_bound: 0.0, upper_bound: 0.0, distinct_count: 1|
|bin_4         |lower_bound: 0.0, upper_bound: 0.0, distinct_count: 1|
|bin_5         |lower_bound: 0.0, upper_bound: 0.0, distinct_count: 1|
|bin_6         |lower_bound: 0.0, upper_bound: 0.0, distinct_count: 1|
|bin_7         |lower_bound: 0.0, upper_bound: 0.0, distinct_count: 1|
|bin_8         |lower_bound: 0.0, upper_bound: 0.0, distinct_count: 1|
|bin_9         |lower_bound: 0.0, upper_bound: 0.0, distinct_count: 1|
+--------------+-----------------------------------------------------+
only showing top 20 rows
```

## Demo

```text
// Make the example reproducible
val tableName = "t1"
import org.apache.spark.sql.catalyst.TableIdentifier
val tableId = TableIdentifier(tableName)

val sessionCatalog = spark.sessionState.catalog
sessionCatalog.dropTable(tableId, ignoreIfNotExists = true, purge = true)

val df = Seq((0, 0.0, "zero"), (1, 1.4, "one")).toDF("id", "p1", "p2")
df.write.saveAsTable("t1")

// AnalyzeColumnCommand represents ANALYZE TABLE...FOR COLUMNS SQL command
val allCols = df.columns.mkString(",")
val analyzeTableSQL = s"ANALYZE TABLE $tableName COMPUTE STATISTICS FOR COLUMNS $allCols"
val plan = spark.sql(analyzeTableSQL).queryExecution.logical
import org.apache.spark.sql.execution.command.AnalyzeColumnCommand
val cmd = plan.asInstanceOf[AnalyzeColumnCommand]
scala> println(cmd)
AnalyzeColumnCommand `t1`, [id, p1, p2]

spark.sql(analyzeTableSQL)
val stats = sessionCatalog.getTableMetadata(tableId).stats.get
scala> println(stats.simpleString)
1421 bytes, 2 rows

scala> stats.colStats.map { case (c, ss) => s"$c: $ss" }.foreach(println)
id: ColumnStat(2,Some(0),Some(1),0,4,4,None)
p1: ColumnStat(2,Some(0.0),Some(1.4),0,8,8,None)
p2: ColumnStat(2,None,None,0,4,4,None)

// Use DESC EXTENDED for friendlier output
scala> sql(s"DESC EXTENDED $tableName id").show
+--------------+----------+
|     info_name|info_value|
+--------------+----------+
|      col_name|        id|
|     data_type|       int|
|       comment|      NULL|
|           min|         0|
|           max|         1|
|     num_nulls|         0|
|distinct_count|         2|
|   avg_col_len|         4|
|   max_col_len|         4|
|     histogram|      NULL|
+--------------+----------+
```
