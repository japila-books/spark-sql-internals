# FindDataSourceTable Logical Evaluation Rule -- Resolving UnresolvedCatalogRelations

`FindDataSourceTable` is a catalyst/Rule.md[Catalyst rule] for <<apply, resolving UnresolvedCatalogRelations>> (of Spark and Hive tables) in a logical query plan.

`FindDataSourceTable` is part of [additional rules](../Analyzer.md#extendedResolutionRules) in `Resolution` fixed-point batch of rules.

[[sparkSession]][[creating-instance]]
`FindDataSourceTable` takes a single [SparkSession](../SparkSession.md) to be created.

```text
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
```

=== [[apply]] Applying Rule to Logical Plan (Resolving UnresolvedCatalogRelations) -- `apply` Method

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of catalyst/Rule.md#apply[Rule] contract.

`apply` resolves spark-sql-LogicalPlan-UnresolvedCatalogRelation.md[UnresolvedCatalogRelations] for Spark (Data Source) and Hive tables:

* `apply` <<readDataSourceTable, creates HiveTableRelation logical operators>> for spark-sql-LogicalPlan-UnresolvedCatalogRelation.md[UnresolvedCatalogRelations] of spark-sql-DDLUtils.md#isDatasourceTable[Spark tables] (incl. InsertIntoTable.md[InsertIntoTable] operators)

* `apply` <<readHiveTable, creates LogicalRelation logical operators>> for InsertIntoTable.md[InsertIntoTable] operators with spark-sql-LogicalPlan-UnresolvedCatalogRelation.md[UnresolvedCatalogRelation] of a Hive table or spark-sql-LogicalPlan-UnresolvedCatalogRelation.md[UnresolvedCatalogRelations] of a Hive table

=== [[readHiveTable]] Creating HiveTableRelation Logical Operator -- `readHiveTable` Internal Method

[source, scala]
----
readHiveTable(
  table: CatalogTable): LogicalPlan
----

`readHiveTable` creates a hive/HiveTableRelation.md[HiveTableRelation] for the input spark-sql-CatalogTable.md[CatalogTable].

NOTE: `readHiveTable` is used when `FindDataSourceTable` is requested to <<apply, resolve an UnresolvedCatalogRelation in a logical plan>> (for hive tables).

=== [[readDataSourceTable]] Creating LogicalRelation Logical Operator for CatalogTable -- `readDataSourceTable` Internal Method

[source, scala]
----
readDataSourceTable(
  table: CatalogTable): LogicalPlan
----

`readDataSourceTable` requests the <<sparkSession, SparkSession>> for SessionState.md#catalog[SessionCatalog].

`readDataSourceTable` requests the `SessionCatalog` for the spark-sql-SessionCatalog.md#getCachedPlan[cached logical plan] for the input spark-sql-CatalogTable.md[CatalogTable].

If not available, `readDataSourceTable` creates a new spark-sql-DataSource.md[DataSource] for the spark-sql-CatalogTable.md#provider[provider] (of the input `CatalogTable`) with the extra `path` option (based on the `locationUri` of the spark-sql-CatalogTable.md#storage[storage] of the input `CatalogTable`). `readDataSourceTable` requests the `DataSource` to spark-sql-DataSource.md#resolveRelation[resolve the relation and create a corresponding BaseRelation] that is then used to create a spark-sql-LogicalPlan-LogicalRelation.md#apply[LogicalRelation] with the input spark-sql-CatalogTable.md[CatalogTable].

NOTE: `readDataSourceTable` is used when `FindDataSourceTable` is requested to <<apply, resolve an UnresolvedCatalogRelation in a logical plan>> (for data source tables).
