title: AnalyzePartitionCommand

# AnalyzePartitionCommand Logical Command -- Computing Partition-Level Statistics

`AnalyzePartitionCommand` is a RunnableCommand.md[logical command] that <<run, computes statistics>> (i.e. <<total-size-stat, total size>> and <<row-count-stat, row count>>) for <<partitionSpec, table partitions>> and stores the stats in a metastore.

`AnalyzePartitionCommand` is <<creating-instance, created>> exclusively for spark-sql-SparkSqlAstBuilder.md#AnalyzePartitionCommand[ANALYZE TABLE] with `PARTITION` specification only (i.e. no `FOR COLUMNS` clause).

[source, scala]
----
// Seq((0, 0, "zero"), (1, 1, "one")).toDF("id", "p1", "p2").write.partitionBy("p1", "p2").saveAsTable("t1")
val analyzeTable = "ANALYZE TABLE t1 PARTITION (p1, p2) COMPUTE STATISTICS"
val plan = spark.sql(analyzeTable).queryExecution.logical
import org.apache.spark.sql.execution.command.AnalyzePartitionCommand
val cmd = plan.asInstanceOf[AnalyzePartitionCommand]
scala> println(cmd)
AnalyzePartitionCommand `t1`, Map(p1 -> None, p2 -> None), false
----

=== [[run]] Executing Logical Command (Computing Partition-Level Statistics and Altering Metastore) -- `run` Method

[source, scala]
----
run(sparkSession: SparkSession): Seq[Row]
----

NOTE: `run` is part of <<RunnableCommand.md#run, RunnableCommand Contract>> to execute (run) a logical command.

`run` requests the session-specific `SessionCatalog` for the [metadata](../SessionCatalog.md#getTableMetadata) of the <<tableIdent, table>> and makes sure that it is not a view.

NOTE: `run` uses the input `SparkSession` to access the session-specific SparkSession.md#sessionState[SessionState] that in turn is used to access the current SessionState.md#catalog[SessionCatalog].

`run` <<getPartitionSpec, getPartitionSpec>>.

`run` requests the session-specific `SessionCatalog` for the [partitions](../SessionCatalog.md#listPartitions) per the partition specification.

`run` finishes when the table has no partitions defined in a metastore.

[[row-count-stat]]
`run` <<calculateRowCountsPerPartition, computes row count statistics per partition>> unless <<noscan, noscan>> flag was enabled.

[[total-size-stat]]
`run` [calculates total size (in bytes)](../CommandUtils.md#calculateLocationSize) (aka _partition location size_) for every table partition and [creates a CatalogStatistics with the current statistics if different from the statistics recorded in the metastore](../CommandUtils.md#compareAndGetNewStats) (with a new row count statistic computed earlier).

In the end, `run` [alters table partition metadata](../SessionCatalog.md#alterPartitions) for partitions with the statistics changed.

`run` reports a `NoSuchPartitionException` when partitions do not match the metastore.

`run` reports an `AnalysisException` when executed on a view.

```text
ANALYZE TABLE is not supported on views.
```

=== [[calculateRowCountsPerPartition]] Computing Row Count Statistics Per Partition -- `calculateRowCountsPerPartition` Internal Method

[source, scala]
----
calculateRowCountsPerPartition(
  sparkSession: SparkSession,
  tableMeta: CatalogTable,
  partitionValueSpec: Option[TablePartitionSpec]): Map[TablePartitionSpec, BigInt]
----

`calculateRowCountsPerPartition`...FIXME

NOTE: `calculateRowCountsPerPartition` is used exclusively when `AnalyzePartitionCommand` is <<run, executed>>.

=== [[getPartitionSpec]] `getPartitionSpec` Internal Method

[source, scala]
----
getPartitionSpec(table: CatalogTable): Option[TablePartitionSpec]
----

`getPartitionSpec`...FIXME

NOTE: `getPartitionSpec` is used exclusively when `AnalyzePartitionCommand` is <<run, executed>>.

=== [[creating-instance]] Creating AnalyzePartitionCommand Instance

`AnalyzePartitionCommand` takes the following when created:

* [[tableIdent]] `TableIdentifier`
* [[partitionSpec]] Partition specification
* [[noscan]] `noscan` flag (enabled by default) that indicates whether spark-sql-cost-based-optimization.md#NOSCAN[NOSCAN] option was used or not
