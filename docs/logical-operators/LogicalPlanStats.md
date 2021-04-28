# LogicalPlanStats &mdash; Statistics Estimates and Query Hints of Logical Operators

`LogicalPlanStats` is an extension of the [LogicalPlan](LogicalPlan.md) abstraction to add [Statistics](#stats) for [query planning](../SparkPlanner.md) (with or without [cost-based optimization](../spark-sql-cost-based-optimization.md), e.g. [CostBasedJoinReorder](../logical-optimizations/CostBasedJoinReorder.md) or [JoinSelection](../execution-planning-strategies/JoinSelection.md), respectively).

## Scala Definition

```scala
trait LogicalPlanStats { self: LogicalPlan =>
  // body omitted
}
```

`LogicalPlanStats` is a Scala trait with `self: LogicalPlan` as part of its definition. It is a very useful feature of Scala that restricts the set of classes that the trait could be used with (as well as makes the target subtype known at compile time).

!!! tip
    Read up on `self-type` in Scala in the [Tour of Scala](https://docs.scala-lang.org/tour/self-types.html).

## <span id="stats"> Computing (and Caching) Statistics and Query Hints

```scala
stats: Statistics
```

`stats` gets the [statistics](Statistics.md) from [cache](#statsCache) if computed already. If not, `stats` branches off per whether [cost-based optimization](../spark-sql-cost-based-optimization.md) is enabled or not and requests [BasicStatsPlanVisitor](BasicStatsPlanVisitor.md) or [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md) for the statistics, respectively.

`statsCache` caches the statistics for later use.

`stats` is used when:

* `JoinSelection` execution planning strategy matches a logical plan:
   * [that is small enough for broadcast join](../execution-planning-strategies/JoinSelection.md#canBroadcast) (using `BroadcastHashJoinExec` or `BroadcastNestedLoopJoinExec` physical operators)
   * [whose a single partition should be small enough to build a hash table](../execution-planning-strategies/JoinSelection.md#canBuildLocalHashMap) (using `ShuffledHashJoinExec` physical operator)
   * [that is much smaller (3X) than the other plan](../execution-planning-strategies/JoinSelection.md#muchSmaller) (for `ShuffledHashJoinExec` physical operator)
   * ...
* `QueryExecution` is requested for [stringWithStats](../QueryExecution.md#stringWithStats) for `EXPLAIN COST` SQL command
* `CacheManager` is requested to [cache a Dataset](../CacheManager.md#cacheQuery) or [recacheByCondition](../CacheManager.md#recacheByCondition)
* `HiveMetastoreCatalog` is requested for `convertToLogicalRelation`
* `StarSchemaDetection`
* [CostBasedJoinReorder](../logical-optimizations/CostBasedJoinReorder.md) logical optimization is executed

## <span id="invalidateStatsCache"> Invalidating Statistics Cache

```scala
invalidateStatsCache(): Unit
```

`invalidateStatsCache` clears the [cache](#statsCache) of the current logical operator and all of the [children](../catalyst/TreeNode.md#children).

`invalidateStatsCache` is used when [AdaptiveSparkPlanExec](../adaptive-query-execution/AdaptiveSparkPlanExec.md) physical operator is requested to [reOptimize](../adaptive-query-execution/AdaptiveSparkPlanExec.md#reOptimize).

## <span id="statsCache"> Statistics Cache

```scala
statsCache: Option[Statistics]
```

`statsCache` holds the [Statistics](#stats) once computed (until [invalidated](#invalidateStatsCache)).

## Demo: Accessing Statistics

Use `EXPLAIN COST` SQL command to explain a query with the <<stats, statistics>>.

```text
scala> sql("EXPLAIN COST SHOW TABLES").as[String].collect.foreach(println)
== Optimized Logical Plan ==
ShowTablesCommand false, Statistics(sizeInBytes=1.0 B, hints=none)

== Physical Plan ==
Execute ShowTablesCommand
   +- ShowTablesCommand false
```

The statistics of a logical plan directly using [stats](#stats) method or indirectly requesting `QueryExecution` for [text representation with statistics](../QueryExecution.md#stringWithStats).

```text
val q = sql("SHOW TABLES")
scala> println(q.queryExecution.analyzed.stats)
Statistics(sizeInBytes=1.0 B, hints=none)

scala> println(q.queryExecution.stringWithStats)
== Optimized Logical Plan ==
ShowTablesCommand false, Statistics(sizeInBytes=1.0 B, hints=none)

== Physical Plan ==
Execute ShowTablesCommand
   +- ShowTablesCommand false
```

```text
val names = Seq((1, "one"), (2, "two")).toDF("id", "name")

assert(spark.sessionState.conf.cboEnabled == false, "CBO should be turned off")

// CBO is disabled and so only sizeInBytes stat is available
// FIXME Why is analyzed required (not just logical)?
val namesStatsCboOff = names.queryExecution.analyzed.stats
scala> println(namesStatsCboOff)
Statistics(sizeInBytes=48.0 B, hints=none)

// Turn CBO on
import org.apache.spark.sql.internal.SQLConf
spark.sessionState.conf.setConf(SQLConf.CBO_ENABLED, true)

// Make sure that CBO is really enabled
scala> println(spark.sessionState.conf.cboEnabled)
true

// Invalidate the stats cache
names.queryExecution.analyzed.invalidateStatsCache

// Check out the statistics
val namesStatsCboOn = names.queryExecution.analyzed.stats
scala> println(namesStatsCboOn)
Statistics(sizeInBytes=48.0 B, hints=none)

// Despite CBO enabled, we can only get sizeInBytes stat
// That's because names is a LocalRelation under the covers
scala> println(names.queryExecution.optimizedPlan.numberedTreeString)
00 LocalRelation [id#5, name#6]

// LocalRelation triggers BasicStatsPlanVisitor to execute default case
// which is exactly as if we had CBO turned off

// Let's register names as a managed table
// That will change the rules of how stats are computed
import org.apache.spark.sql.SaveMode
names.write.mode(SaveMode.Overwrite).saveAsTable("names")

scala> spark.catalog.tableExists("names")
res5: Boolean = true

scala> spark.catalog.listTables.filter($"name" === "names").show
+-----+--------+-----------+---------+-----------+
| name|database|description|tableType|isTemporary|
+-----+--------+-----------+---------+-----------+
|names| default|       null|  MANAGED|      false|
+-----+--------+-----------+---------+-----------+

val namesTable = spark.table("names")

// names is a managed table now
// And Relation (not LocalRelation)
scala> println(namesTable.queryExecution.optimizedPlan.numberedTreeString)
00 Relation[id#32,name#33] parquet

// Check out the statistics
val namesStatsCboOn = namesTable.queryExecution.analyzed.stats
scala> println(namesStatsCboOn)
Statistics(sizeInBytes=1064.0 B, hints=none)

// Nothing has really changed, hasn't it?
// Well, sizeInBytes is bigger, but that's the only stat available
// row count stat requires ANALYZE TABLE with no NOSCAN option
sql("ANALYZE TABLE names COMPUTE STATISTICS")

// Invalidate the stats cache
namesTable.queryExecution.analyzed.invalidateStatsCache

// No change?! How so?
val namesStatsCboOn = namesTable.queryExecution.analyzed.stats
scala> println(namesStatsCboOn)
Statistics(sizeInBytes=1064.0 B, hints=none)

// Use optimized logical plan instead
val namesTableStats = spark.table("names").queryExecution.optimizedPlan.stats
scala> println(namesTableStats)
Statistics(sizeInBytes=64.0 B, rowCount=2, hints=none)
```
