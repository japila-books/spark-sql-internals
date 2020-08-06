title: CatalogStatistics

# CatalogStatistics -- Table Statistics From External Catalog (Metastore)

[[creating-instance]][[table-statistics]]
`CatalogStatistics` are *table statistics* that are stored in an [external catalog](ExternalCatalog.md):

* [[sizeInBytes]] Physical *total size* (in bytes)
* [[rowCount]] Estimated *number of rows* (aka _row count_)
* [[colStats]] *Column statistics* (i.e. column names and their spark-sql-ColumnStat.md[statistics])

[NOTE]
====
`CatalogStatistics` is a "subset" of the statistics in spark-sql-Statistics.md[Statistics] (as there are no concepts of spark-sql-Statistics.md#attributeStats[attributes] and spark-sql-Statistics.md#hints[broadcast hint] in metastore).

`CatalogStatistics` are often stored in a Hive metastore and are referred as *Hive statistics* while `Statistics` are the *Spark statistics*.
====

`CatalogStatistics` can be converted to spark-sql-Statistics.md[Spark statistics] using <<toPlanStats, toPlanStats>> method.

`CatalogStatistics` is <<creating-instance, created>> when:

* spark-sql-LogicalPlan-AnalyzeColumnCommand.md#run[AnalyzeColumnCommand], `AlterTableAddPartitionCommand` and `TruncateTableCommand` commands are executed (and store statistics in [ExternalCatalog](ExternalCatalog.md))

* `CommandUtils` is requested for spark-sql-CommandUtils.md#updateTableStats[updating existing table statistics], the spark-sql-CommandUtils.md#compareAndGetNewStats[current statistics (if changed)]

* `HiveExternalCatalog` is requested for [restoring Spark statistics from properties](hive/HiveExternalCatalog.md#statsFromProperties) (from a Hive Metastore)

* hive/DetermineTableStats.md#apply[DetermineTableStats] and spark-sql-SparkOptimizer-PruneFileSourcePartitions.md[PruneFileSourcePartitions] logical optimizations are executed (i.e. applied to a logical plan)

* `HiveClientImpl` is requested for a table or partition hive/HiveClientImpl.md#readHiveStats[statistics from Hive's parameters]

[source, scala]
----
scala> :type spark.sessionState.catalog
org.apache.spark.sql.catalyst.catalog.SessionCatalog

// Using higher-level interface to access CatalogStatistics
// Make sure that you ran ANALYZE TABLE (as described above)
val db = spark.catalog.currentDatabase
val tableName = "t1"
val metadata = spark.sharedState.externalCatalog.getTable(db, tableName)
val stats = metadata.stats

scala> :type stats
Option[org.apache.spark.sql.catalyst.catalog.CatalogStatistics]

// Using low-level internal SessionCatalog interface to access CatalogTables
val tid = spark.sessionState.sqlParser.parseTableIdentifier(tableName)
val metadata = spark.sessionState.catalog.getTempViewOrPermanentTableMetadata(tid)
val stats = metadata.stats

scala> :type stats
Option[org.apache.spark.sql.catalyst.catalog.CatalogStatistics]
----

[[simpleString]]
`CatalogStatistics` has a text representation.

[source, scala]
----
scala> :type stats
Option[org.apache.spark.sql.catalyst.catalog.CatalogStatistics]

scala> stats.map(_.simpleString).foreach(println)
714 bytes, 2 rows
----

=== [[toPlanStats]] Converting Metastore Statistics to Spark Statistics -- `toPlanStats` Method

[source, scala]
----
toPlanStats(planOutput: Seq[Attribute], cboEnabled: Boolean): Statistics
----

`toPlanStats` converts the table statistics (from an external metastore) to spark-sql-Statistics.md[Spark statistics].

With spark-sql-cost-based-optimization.md[cost-based optimization] enabled and <<rowCount, row count>> statistics available, `toPlanStats` creates a spark-sql-Statistics.md[Statistics] with the spark-sql-EstimationUtils.md#getOutputSize[estimated total (output) size], <<rowCount, row count>> and column statistics.

NOTE: Cost-based optimization is enabled when spark-sql-properties.md#spark.sql.cbo.enabled[spark.sql.cbo.enabled] configuration property is turned on, i.e. `true`, and is disabled by default.

Otherwise, when spark-sql-cost-based-optimization.md[cost-based optimization] is disabled, `toPlanStats` creates a spark-sql-Statistics.md[Statistics] with just the mandatory <<sizeInBytes, sizeInBytes>>.

CAUTION: FIXME Why does `toPlanStats` compute `sizeInBytes` differently per CBO?

[NOTE]
====
`toPlanStats` does the reverse of [HiveExternalCatalog.statsToProperties](hive/HiveExternalCatalog.md#statsToProperties).
====

NOTE: `toPlanStats` is used when [HiveTableRelation](hive/HiveTableRelation.md#computeStats) and [LogicalRelation](logical-operators/LogicalRelation.md#computeStats) are requested for statistics.
