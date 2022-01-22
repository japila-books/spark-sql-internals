# FindDataSourceTable Logical Evaluation Rule

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

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` resolves `UnresolvedCatalogRelation`s for Spark (Data Source) and Hive tables:

* `apply` [creates HiveTableRelation logical operators](#readDataSourceTable) for `UnresolvedCatalogRelation`s of Spark tables (incl. `InsertIntoTable`s)

* `apply` [creates LogicalRelation logical operators](#readHiveTable) for `InsertIntoTable`s with `UnresolvedCatalogRelation` of a Hive table or `UnresolvedCatalogRelation`s of a Hive table

`apply` is part of [Rule](../catalyst/Rule.md#apply) contract.

=== [[readHiveTable]] Creating HiveTableRelation Logical Operator -- `readHiveTable` Internal Method

[source, scala]
----
readHiveTable(
  table: CatalogTable): LogicalPlan
----

`readHiveTable` creates a hive/HiveTableRelation.md[HiveTableRelation] for the input [CatalogTable](../CatalogTable.md).

NOTE: `readHiveTable` is used when `FindDataSourceTable` is requested to <<apply, resolve an UnresolvedCatalogRelation in a logical plan>> (for hive tables).

=== [[readDataSourceTable]] Creating LogicalRelation Logical Operator for CatalogTable -- `readDataSourceTable` Internal Method

[source, scala]
----
readDataSourceTable(
  table: CatalogTable): LogicalPlan
----

`readDataSourceTable` requests the <<sparkSession, SparkSession>> for SessionState.md#catalog[SessionCatalog].

`readDataSourceTable` requests the `SessionCatalog` for the [cached logical plan](../SessionCatalog.md#getCachedPlan) for the input [CatalogTable](../CatalogTable.md).

If not available, `readDataSourceTable` [creates a new DataSource](../DataSource.md) for the [provider](../CatalogTable.md#provider) (of the input `CatalogTable`) with the extra `path` option (based on the `locationUri` of the [storage](../CatalogTable.md#storage) of the input `CatalogTable`). `readDataSourceTable` requests the `DataSource` to [resolve the relation and create a corresponding BaseRelation](../DataSource.md#resolveRelation) that is then used to create a [LogicalRelation](../logical-operators/LogicalRelation.md) with the input [CatalogTable](../CatalogTable.md).

NOTE: `readDataSourceTable` is used when `FindDataSourceTable` is requested to <<apply, resolve an UnresolvedCatalogRelation in a logical plan>> (for data source tables).
