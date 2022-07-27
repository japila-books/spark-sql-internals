# ResolveRelations Logical Resolution Rule

`ResolveRelations` is a logical resolution rule that the [logical query plan analyzer](../Analyzer.md#ResolveRelations) uses to [replace (_resolve_) UnresolvedRelations](#apply).

`ResolveRelations` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

`ResolveRelations` is part of [Resolution](../Analyzer.md#Resolution) fixed-point batch of rules.

## Creating Instance

`ResolveRelations` takes no arguments to be created.

`ResolveRelations` is created when:

* `Analyzer` is requested for the [batches](../Analyzer.md#batches)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

---

`apply` resolves the following operators in the given [LogicalPlan](../logical-operators/LogicalPlan.md) (from bottom to the top of the tree):

* [InsertIntoStatement](../logical-operators/InsertIntoStatement.md)s
* [V2WriteCommand](../logical-operators/V2WriteCommand.md)s
* `UnresolvedRelation`s
* `RelationTimeTravel`s
* [UnresolvedTable](../logical-operators/UnresolvedTable.md)s
* `UnresolvedView`s
* [UnresolvedTableOrView](../logical-operators/UnresolvedTableOrView.md)s

## Demo

```text
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
```

## <span id="lookupRelation"> lookupRelation

```scala
lookupRelation(
  u: UnresolvedRelation,
  timeTravelSpec: Option[TimeTravelSpec] = None): Option[LogicalPlan]
```

`lookupRelation`...FIXME

## <span id="lookupTableOrView"> lookupTableOrView

```scala
lookupTableOrView(
  identifier: Seq[String]): Option[LogicalPlan]
```

`lookupTableOrView`...FIXME

## <span id="resolveViews"> resolveViews

```scala
resolveViews(
  plan: LogicalPlan): LogicalPlan
```

`resolveViews` resolves the [unresolved](../logical-operators/LogicalPlan.md#resolved) child of the given [LogicalPlan](../logical-operators/LogicalPlan.md) if it is one of the following:

* [View](../logical-operators/View.md)
* [SubqueryAlias](../logical-operators/SubqueryAlias.md) over a [View](../logical-operators/View.md)

Otherwise, `resolveViews` returns the given `plan` unmodified.

`resolveViews` uses the [CatalogTable](../logical-operators/View.md#desc) (of the [View](../logical-operators/View.md)) to resolve the view (as the `CatalogTable` provides necessary information to resolve it).
