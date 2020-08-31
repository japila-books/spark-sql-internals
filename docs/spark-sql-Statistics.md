title: Statistics

# Statistics -- Estimates of Plan Statistics and Query Hints

[[creating-instance]]
`Statistics` holds the statistics estimates and query hints of a logical operator:

* [[sizeInBytes]] Total (output) size (in bytes)
* [[rowCount]] Estimated number of rows (aka _row count_)
* [[attributeStats]] Column attribute statistics (aka _column (equi-height) histograms_)
* [[hints]] spark-sql-HintInfo.md[Query hints]

NOTE: *Cost statistics*, *plan statistics* or *query statistics* are all synonyms and used interchangeably.

You can access statistics and query hints of a logical plan using spark-sql-LogicalPlanStats.md#stats[stats] property.

[source, scala]
----
val q = spark.range(5).hint("broadcast").join(spark.range(1), "id")
val plan = q.queryExecution.optimizedPlan
val stats = plan.stats

scala> :type stats
org.apache.spark.sql.catalyst.plans.logical.Statistics

scala> println(stats.simpleString)
sizeInBytes=213.0 B, hints=none
----

NOTE: Use spark-sql-cost-based-optimization.md#ANALYZE-TABLE[ANALYZE TABLE COMPUTE STATISTICS] SQL command to compute <<sizeInBytes, total size>> and <<rowCount, row count>> statistics of a table.

NOTE: Use spark-sql-cost-based-optimization.md#ANALYZE-TABLE[ANALYZE TABLE COMPUTE STATISTICS FOR COLUMNS] SQL Command to generate <<attributeStats, column (equi-height) histograms>> of a table.

!!! note
    Use `Dataset.hint` or `SELECT` SQL statement with hints for [query hints](new-and-noteworthy/hint-framework.md#specifying-query-hints).

`Statistics` is <<creating-instance, created>> when:

* spark-sql-LogicalPlan-LeafNode.md#computeStats[Leaf logical operators] (specifically) and spark-sql-LogicalPlanStats.md#stats[logical operators] (in general) are requested for statistics estimates

* hive/HiveTableRelation.md#computeStats[HiveTableRelation] and spark-sql-LogicalPlan-LogicalRelation.md#computeStats[LogicalRelation] are requested for statistics estimates (through spark-sql-CatalogStatistics.md#toPlanStats[CatalogStatistics])

NOTE: <<rowCount, row count>> estimate is used in spark-sql-Optimizer-CostBasedJoinReorder.md[CostBasedJoinReorder] logical optimization when spark-sql-cost-based-optimization.md#spark.sql.cbo.enabled[cost-based optimization is enabled].

[NOTE]
====
spark-sql-CatalogStatistics.md[CatalogStatistics] is a "subset" of all possible `Statistics` (as there are no concepts of <<attributeStats, attributes>> and <<hints, query hints>> in [metastore](ExternalCatalog.md)).

`CatalogStatistics` are statistics stored in an external catalog (usually a Hive metastore) and are often referred as *Hive statistics* while `Statistics` represents the *Spark statistics*.
====

[[simpleString]][[toString]]
`Statistics` comes with `simpleString` method that is used for the readable *text representation* (that is `toString` with *Statistics* prefix).

[source, scala]
----
import org.apache.spark.sql.catalyst.plans.logical.Statistics
import org.apache.spark.sql.catalyst.plans.logical.HintInfo
val stats = Statistics(sizeInBytes = 10, rowCount = Some(20), hints = HintInfo(broadcast = true))

scala> println(stats)
Statistics(sizeInBytes=10.0 B, rowCount=20, hints=(broadcast))

scala> println(stats.simpleString)
sizeInBytes=10.0 B, rowCount=20, hints=(broadcast)
----
