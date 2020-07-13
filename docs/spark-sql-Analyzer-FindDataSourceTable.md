# FindDataSourceTable Logical Evaluation Rule -- Resolving UnresolvedCatalogRelations

`FindDataSourceTable` is a link:spark-sql-catalyst-Rule.adoc[Catalyst rule] for <<apply, resolving UnresolvedCatalogRelations>> (of Spark and Hive tables) in a logical query plan.

`FindDataSourceTable` is part of link:spark-sql-Analyzer.adoc#extendedResolutionRules[additional rules] in `Resolution` fixed-point batch of rules.

[[sparkSession]][[creating-instance]]
`FindDataSourceTable` takes a single link:SparkSession.md[SparkSession] to be created.

[source, scala]
----
scala> :type spark
org.apache.spark.sql.SparkSession

// Example: InsertIntoTable with UnresolvedCatalogRelation
// Drop tables to make the example reproducible
val db = spark.catalog.currentDatabase
Seq("t1", "t2").foreach { t =>
  spark.sharedState.externalCatalog.dropTable(db, t, ignoreIfNotExists = true, purge = true)
}

// Create tables
sql("CREATE TABLE t1 (id LONG) USING parquet")
sql("CREATE TABLE t2 (id LONG) USING orc")

import org.apache.spark.sql.catalyst.dsl.plans._
val plan = table("t1").insertInto(tableName = "t2", overwrite = true)
scala> println(plan.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `t2`, true, false
01 +- 'UnresolvedRelation `t1`

// Transform the logical plan with ResolveRelations logical rule first
// so UnresolvedRelations become UnresolvedCatalogRelations
import spark.sessionState.analyzer.ResolveRelations
val planWithUnresolvedCatalogRelations = ResolveRelations(plan)
scala> println(planWithUnresolvedCatalogRelations.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `t2`, true, false
01 +- 'SubqueryAlias t1
02    +- 'UnresolvedCatalogRelation `default`.`t1`, org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe

// Let's resolve UnresolvedCatalogRelations then
import org.apache.spark.sql.execution.datasources.FindDataSourceTable
val r = new FindDataSourceTable(spark)
val tablesResolvedPlan = r(planWithUnresolvedCatalogRelations)
// FIXME Why is t2 not resolved?!
scala> println(tablesResolvedPlan.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `t2`, true, false
01 +- SubqueryAlias t1
02    +- Relation[id#10L] parquet
----

=== [[apply]] Applying Rule to Logical Plan (Resolving UnresolvedCatalogRelations) -- `apply` Method

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of link:spark-sql-catalyst-Rule.adoc#apply[Rule] contract.

`apply` resolves link:spark-sql-LogicalPlan-UnresolvedCatalogRelation.adoc[UnresolvedCatalogRelations] for Spark (Data Source) and Hive tables:

* `apply` <<readDataSourceTable, creates HiveTableRelation logical operators>> for link:spark-sql-LogicalPlan-UnresolvedCatalogRelation.adoc[UnresolvedCatalogRelations] of link:spark-sql-DDLUtils.adoc#isDatasourceTable[Spark tables] (incl. link:InsertIntoTable.adoc[InsertIntoTable] operators)

* `apply` <<readHiveTable, creates LogicalRelation logical operators>> for link:InsertIntoTable.adoc[InsertIntoTable] operators with link:spark-sql-LogicalPlan-UnresolvedCatalogRelation.adoc[UnresolvedCatalogRelation] of a Hive table or link:spark-sql-LogicalPlan-UnresolvedCatalogRelation.adoc[UnresolvedCatalogRelations] of a Hive table

=== [[readHiveTable]] Creating HiveTableRelation Logical Operator -- `readHiveTable` Internal Method

[source, scala]
----
readHiveTable(
  table: CatalogTable): LogicalPlan
----

`readHiveTable` creates a link:hive/HiveTableRelation.adoc[HiveTableRelation] for the input link:spark-sql-CatalogTable.adoc[CatalogTable].

NOTE: `readHiveTable` is used when `FindDataSourceTable` is requested to <<apply, resolve an UnresolvedCatalogRelation in a logical plan>> (for hive tables).

=== [[readDataSourceTable]] Creating LogicalRelation Logical Operator for CatalogTable -- `readDataSourceTable` Internal Method

[source, scala]
----
readDataSourceTable(
  table: CatalogTable): LogicalPlan
----

`readDataSourceTable` requests the <<sparkSession, SparkSession>> for link:SessionState.md#catalog[SessionCatalog].

`readDataSourceTable` requests the `SessionCatalog` for the link:spark-sql-SessionCatalog.adoc#getCachedPlan[cached logical plan] for the input link:spark-sql-CatalogTable.adoc[CatalogTable].

If not available, `readDataSourceTable` creates a new link:spark-sql-DataSource.adoc[DataSource] for the link:spark-sql-CatalogTable.adoc#provider[provider] (of the input `CatalogTable`) with the extra `path` option (based on the `locationUri` of the link:spark-sql-CatalogTable.adoc#storage[storage] of the input `CatalogTable`). `readDataSourceTable` requests the `DataSource` to link:spark-sql-DataSource.adoc#resolveRelation[resolve the relation and create a corresponding BaseRelation] that is then used to create a link:spark-sql-LogicalPlan-LogicalRelation.adoc#apply[LogicalRelation] with the input link:spark-sql-CatalogTable.adoc[CatalogTable].

NOTE: `readDataSourceTable` is used when `FindDataSourceTable` is requested to <<apply, resolve an UnresolvedCatalogRelation in a logical plan>> (for data source tables).
