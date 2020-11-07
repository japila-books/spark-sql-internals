# FileSourceStrategy Execution Planning Strategy for LogicalRelations with HadoopFsRelation

`FileSourceStrategy` is an [execution planning strategy](SparkStrategy.md) that <<apply, plans scans over collections of files>> (possibly partitioned or bucketed).

`FileSourceStrategy` is part of [predefined strategies](../SparkPlanner.md#strategies) of the [Spark Planner](../SparkPlanner.md).

```text
import org.apache.spark.sql.execution.datasources.FileSourceStrategy

// Enable INFO logging level to see the details of the strategy
val logger = FileSourceStrategy.getClass.getName.replace("$", "")
import org.apache.log4j.{Level, Logger}
Logger.getLogger(logger).setLevel(Level.INFO)

// Create a bucketed data source table
val tableName = "bucketed_4_id"
spark
  .range(100)
  .write
  .bucketBy(4, "id")
  .sortBy("id")
  .mode("overwrite")
  .saveAsTable(tableName)
val q = spark.table(tableName)
val plan = q.queryExecution.optimizedPlan

val executionPlan = FileSourceStrategy(plan).head

scala> println(executionPlan.numberedTreeString)
00 FileScan parquet default.bucketed_4_id[id#140L] Batched: true, Format: Parquet, Location: InMemoryFileIndex[file:/Users/jacek/dev/apps/spark-2.3.0-bin-hadoop2.7/spark-warehouse/bucketed_4..., PartitionFilters: [], PushedFilters: [], ReadSchema: struct<id:bigint>

import org.apache.spark.sql.execution.FileSourceScanExec
val scan = executionPlan.collectFirst { case fsse: FileSourceScanExec => fsse }.get

scala> :type scan
org.apache.spark.sql.execution.FileSourceScanExec
```

[[shouldPruneBuckets]]
`FileSourceScanExec` supports [Bucket Pruning](../spark-sql-bucketing.md#bucket-pruning) for [LogicalRelation](../logical-operators/LogicalRelation.md)s over [HadoopFsRelation](../HadoopFsRelation.md) with the [bucketing specification](../HadoopFsRelation.md#bucketSpec) with the following:

1. There is exactly one bucketing column
1. The number of buckets is greater than 1

```text
// Using the table created above
// There is exactly one bucketing column, i.e. id
// The number of buckets is greater than 1, i.e. 4
val tableName = "bucketed_4_id"
val q = spark.table(tableName).where($"id" isin (50, 90))
val qe = q.queryExecution
val plan = qe.optimizedPlan
scala> println(optimizedPlan.numberedTreeString)
00 Filter id#7L IN (50,90)
01 +- Relation[id#7L] parquet

import org.apache.spark.sql.execution.datasources.FileSourceStrategy

// Enable INFO logging level to see the details of the strategy
val logger = FileSourceStrategy.getClass.getName.replace("$", "")
import org.apache.log4j.{Level, Logger}
Logger.getLogger(logger).setLevel(Level.INFO)

scala> val executionPlan = FileSourceStrategy(plan).head
18/11/18 17:56:53 INFO FileSourceStrategy: Pruning directories with:
18/11/18 17:56:53 INFO FileSourceStrategy: Pruned 2 out of 4 buckets.
18/11/18 17:56:53 INFO FileSourceStrategy: Post-Scan Filters: id#7L IN (50,90)
18/11/18 17:56:53 INFO FileSourceStrategy: Output Data Schema: struct<id: bigint>
18/11/18 17:56:53 INFO FileSourceScanExec: Pushed Filters: In(id, [50,90])
executionPlan: org.apache.spark.sql.execution.SparkPlan = ...

scala> println(executionPlan.numberedTreeString)
00 Filter id#7L IN (50,90)
01 +- FileScan parquet default.bucketed_4_id[id#7L] Batched: true, Format: Parquet, Location: InMemoryFileIndex[file:/Users/jacek/dev/oss/spark/spark-warehouse/bucketed_4_id], PartitionFilters: [], PushedFilters: [In(id, [50,90])], ReadSchema: struct<id:bigint>, SelectedBucketsCount: 2 out of 4
```

[TIP]
====
Enable `INFO` logging level for `org.apache.spark.sql.execution.datasources.FileSourceStrategy` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.execution.datasources.FileSourceStrategy=INFO
```

Refer to spark-logging.md[Logging].
====

=== [[collectProjectsAndFilters]] `collectProjectsAndFilters` Method

[source, scala]
----
collectProjectsAndFilters(plan: LogicalPlan):
  (Option[Seq[NamedExpression]], Seq[Expression], LogicalPlan, Map[Attribute, Expression])
----

`collectProjectsAndFilters` is a pattern used to destructure a spark-sql-LogicalPlan.md[LogicalPlan] that can be `Project` or `Filter`. Any other `LogicalPlan` give an _all-empty_ response.

=== [[apply]] Applying FileSourceStrategy Strategy to Logical Plan (Executing FileSourceStrategy) -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): Seq[SparkPlan]
----

`apply` spark-sql-PhysicalOperation.md#unapply[destructures the input logical plan] into a tuple of projection and filter expressions together with a leaf logical operator.

`apply` only works with spark-sql-LogicalPlan.md[logical plans] that are actually a LogicalRelation.md[LogicalRelation] with a [HadoopFsRelation](../HadoopFsRelation.md) (possibly as a child of [Project](../logical-operators/Project.md) and [Filter](../logical-operators/Filter.md) logical operators).

`apply` computes `partitionKeyFilters` expression set with the filter expressions that are a subset of the [partitionSchema](../HadoopFsRelation.md#partitionSchema) of the `HadoopFsRelation`.

`apply` prints out the following INFO message to the logs:

```text
Pruning directories with: [partitionKeyFilters]
```

`apply` computes `afterScanFilters` predicate expressions/Expression.md[expressions] that should be evaluated after the scan.

`apply` prints out the following INFO message to the logs:

```
Post-Scan Filters: [afterScanFilters]
```

`apply` computes `readDataColumns` spark-sql-Expression-Attribute.md[attributes] that are the required attributes except the partition columns.

`apply` prints out the following INFO message to the logs:

```
Output Data Schema: [outputSchema]
```

`apply` creates a FileSourceScanExec.md#creating-instance[FileSourceScanExec] physical operator.

If there are any `afterScanFilter` predicate expressions, `apply` creates a <<FilterExec.md#creating-instance, FilterExec>> physical operator with them and the `FileSourceScanExec` operator.

If the <<FilterExec.md#output, output>> of the `FilterExec` physical operator is different from the `projects` expressions, `apply` creates a ProjectExec.md#creating-instance[ProjectExec] physical operator with them and the `FilterExec` or the `FileSourceScanExec` operators.

`apply` is part of [GenericStrategy](../catalyst/GenericStrategy.md#apply) abstraction.
