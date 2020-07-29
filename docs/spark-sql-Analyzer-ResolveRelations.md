# ResolveRelations Logical Resolution Rule -- Resolving UnresolvedRelations With Tables in Catalog

`ResolveRelations` is a logical resolution rule that the spark-sql-Analyzer.md#ResolveRelations[logical query plan analyzer] uses to <<apply, resolve UnresolvedRelations>> (in a logical query plan), i.e.

* Resolves spark-sql-LogicalPlan-UnresolvedRelation.md[UnresolvedRelation] logical operators (in InsertIntoTable.md[InsertIntoTable] operators)

* Other uses of `UnresolvedRelation`

Technically, `ResolveRelations` is just a catalyst/Rule.md[Catalyst rule] for transforming spark-sql-LogicalPlan.md[logical plans], i.e. `Rule[LogicalPlan]`.

`ResolveRelations` is part of spark-sql-Analyzer.md#Resolution[Resolution] fixed-point batch of rules.

[[example]]
[source, scala]
----
// Example: InsertIntoTable with UnresolvedRelation
import org.apache.spark.sql.catalyst.dsl.plans._
val plan = table("t1").insertInto(tableName = "t2", overwrite = true)
scala> println(plan.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `t2`, true, false
01 +- 'UnresolvedRelation `t1`

// Register the tables so the following resolution works
sql("CREATE TABLE IF NOT EXISTS t1(id long)")
sql("CREATE TABLE IF NOT EXISTS t2(id long)")

// ResolveRelations is a Scala object of the Analyzer class
// We need an instance of the Analyzer class to access it
import spark.sessionState.analyzer.ResolveRelations
val resolvedPlan = ResolveRelations(plan)
scala> println(resolvedPlan.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `t2`, true, false
01 +- 'SubqueryAlias t1
02    +- 'UnresolvedCatalogRelation `default`.`t1`, org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe

// Example: Other uses of UnresolvedRelation
// Use a temporary view
val v1 = spark.range(1).createOrReplaceTempView("v1")
scala> spark.catalog.listTables.filter($"name" === "v1").show
+----+--------+-----------+---------+-----------+
|name|database|description|tableType|isTemporary|
+----+--------+-----------+---------+-----------+
|  v1|    null|       null|TEMPORARY|       true|
+----+--------+-----------+---------+-----------+

import org.apache.spark.sql.catalyst.dsl.expressions._
val plan = table("v1").select(star())
scala> println(plan.numberedTreeString)
00 'Project [*]
01 +- 'UnresolvedRelation `v1`

val resolvedPlan = ResolveRelations(plan)
scala> println(resolvedPlan.numberedTreeString)
00 'Project [*]
01 +- SubqueryAlias v1
02    +- Range (0, 1, step=1, splits=Some(8))

// Example
import org.apache.spark.sql.catalyst.dsl.plans._
val plan = table(db = "db1", ref = "t1")
scala> println(plan.numberedTreeString)
00 'UnresolvedRelation `db1`.`t1`

// Register the database so the following resolution works
sql("CREATE DATABASE IF NOT EXISTS db1")

val resolvedPlan = ResolveRelations(plan)
scala> println(resolvedPlan.numberedTreeString)
00 'SubqueryAlias t1
01 +- 'UnresolvedCatalogRelation `db1`.`t1`, org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe
----

=== [[apply]] Applying ResolveRelations to Logical Plan -- `apply` Method

[source, scala]
----
apply(
  plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of catalyst/Rule.md#apply[Rule Contract] to execute a rule on a spark-sql-LogicalPlan.md[logical plan].

For a InsertIntoTable.md[InsertIntoTable] logical operator with a spark-sql-LogicalPlan-UnresolvedRelation.md[UnresolvedRelation] child operator, `apply` <<lookupTableFromCatalog, lookupTableFromCatalog>> and executes the spark-sql-Optimizer-EliminateSubqueryAliases.md[EliminateSubqueryAliases] optimization rule.

For a spark-sql-LogicalPlan-View.md[View] operator, `apply` substitutes the resolved table for the InsertIntoTable.md[InsertIntoTable] operator (that will be no longer a `UnresolvedRelation` next time the rule is executed). For spark-sql-LogicalPlan-View.md[View] operator, `apply` fail analysis with the exception:

```
Inserting into a view is not allowed. View: [identifier].
```

For spark-sql-LogicalPlan-UnresolvedRelation.md[UnresolvedRelation] logical operators, `apply` simply <<resolveRelation, resolveRelation>>.

=== [[resolveRelation]] Resolving Relation -- `resolveRelation` Method

[source, scala]
----
resolveRelation(
  plan: LogicalPlan): LogicalPlan
----

`resolveRelation`...FIXME

NOTE: `resolveRelation` is used when `ResolveRelations` rule is <<apply, executed>> (for a spark-sql-LogicalPlan-UnresolvedRelation.md[UnresolvedRelation] logical operator).

=== [[isRunningDirectlyOnFiles]] `isRunningDirectlyOnFiles` Internal Method

[source, scala]
----
isRunningDirectlyOnFiles(table: TableIdentifier): Boolean
----

`isRunningDirectlyOnFiles` is enabled (i.e. `true`) when all of the following conditions hold:

* The database of the input `table` is defined

* spark-sql-properties.md#spark.sql.runSQLOnFiles[spark.sql.runSQLOnFiles] internal configuration property is enabled

* The `table` is not a spark-sql-SessionCatalog.md#isTemporaryTable[temporary table]

* The spark-sql-SessionCatalog.md#databaseExists[database] or the spark-sql-SessionCatalog.md#tableExists[table] do not exist (in the spark-sql-Analyzer.md#catalog[SessionCatalog])

NOTE: `isRunningDirectlyOnFiles` is used exclusively when `ResolveRelations` <<resolveRelation, resolves a relation>> (as a spark-sql-LogicalPlan-UnresolvedRelation.md[UnresolvedRelation] leaf logical operator for a table reference).

=== [[lookupTableFromCatalog]] Finding Table in Session-Scoped Catalog of Relational Entities -- `lookupTableFromCatalog` Internal Method

[source, scala]
----
lookupTableFromCatalog(
  u: UnresolvedRelation,
  defaultDatabase: Option[String] = None): LogicalPlan
----

`lookupTableFromCatalog` simply requests `SessionCatalog` to spark-sql-SessionCatalog.md#lookupRelation[find the table in relational catalogs].

NOTE: `lookupTableFromCatalog` requests `Analyzer` for the current spark-sql-Analyzer.md#catalog[SessionCatalog].

NOTE: The table is described using spark-sql-LogicalPlan-UnresolvedRelation.md#tableIdentifier[TableIdentifier] of the input `UnresolvedRelation`.

`lookupTableFromCatalog` fails the analysis phase (by reporting a `AnalysisException`) when the table or the table's database cannot be found.

NOTE: `lookupTableFromCatalog` is used when `ResolveRelations` is <<apply, executed>> (for InsertIntoTable.md[InsertIntoTable] with `UnresolvedRelation` operators) or <<resolveRelation, resolves a relation>> (for "standalone" spark-sql-LogicalPlan-UnresolvedRelation.md[UnresolvedRelations]).
