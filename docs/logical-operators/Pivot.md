# Pivot Unary Logical Operator

`Pivot` is an [unary logical operator](LogicalPlan.md#UnaryNode) that represents [pivot](../RelationalGroupedDataset.md#pivot) operator.

```text
val visits = Seq(
  (0, "Warsaw", 2015),
  (1, "Warsaw", 2016),
  (2, "Boston", 2017)
).toDF("id", "city", "year")

val q = visits
  .groupBy("city")
  .pivot("year", Seq("2015", "2016", "2017"))
  .count()
scala> println(q.queryExecution.logical.numberedTreeString)
00 Pivot [city#8], year#9: int, [2015, 2016, 2017], [count(1) AS count#157L]
01 +- Project [_1#3 AS id#7, _2#4 AS city#8, _3#5 AS year#9]
02    +- LocalRelation [_1#3, _2#4, _3#5]
```

`Pivot` is <<creating-instance, created>> when `RelationalGroupedDataset` [creates a DataFrame for an aggregate operator](../RelationalGroupedDataset.md#toDF).

=== [[analyzer]] Analysis Phase

`Pivot` operator is resolved at [analysis phase](../Analyzer.md) in the following logical evaluation rules:

* [ResolveAliases](../logical-analysis-rules/ResolveAliases.md)
* [ResolvePivot](../Analyzer.md#ResolvePivot)

```text
val spark: SparkSession = ...

import spark.sessionState.analyzer.ResolveAliases
// see q in the example above
val plan = q.queryExecution.logical

scala> println(plan.numberedTreeString)
00 Pivot [city#8], year#9: int, [2015, 2016, 2017], [count(1) AS count#24L]
01 +- Project [_1#3 AS id#7, _2#4 AS city#8, _3#5 AS year#9]
02    +- LocalRelation [_1#3, _2#4, _3#5]

// FIXME Find a plan to show the effect of ResolveAliases
val planResolved = ResolveAliases(plan)
```

`Pivot` operator "disappears" behind (i.e. is converted to) a Aggregate.md[Aggregate] logical operator (possibly under `Project` operator).

[source, scala]
----
import spark.sessionState.analyzer.ResolvePivot
val planAfterResolvePivot = ResolvePivot(plan)
scala> println(planAfterResolvePivot.numberedTreeString)
00 Project [city#8, __pivot_count(1) AS `count` AS `count(1) AS ``count```#62[0] AS 2015#63L, __pivot_count(1) AS `count` AS `count(1) AS ``count```#62[1] AS 2016#64L, __pivot_count(1) AS `count` AS `count(1) AS ``count```#62[2] AS 2017#65L]
01 +- Aggregate [city#8], [city#8, pivotfirst(year#9, count(1) AS `count`#54L, 2015, 2016, 2017, 0, 0) AS __pivot_count(1) AS `count` AS `count(1) AS ``count```#62]
02    +- Aggregate [city#8, year#9], [city#8, year#9, count(1) AS count#24L AS count(1) AS `count`#54L]
03       +- Project [_1#3 AS id#7, _2#4 AS city#8, _3#5 AS year#9]
04          +- LocalRelation [_1#3, _2#4, _3#5]
----

## Creating Instance

`Pivot` takes the following to be created:

* [[groupByExprs]] Grouping expressions/NamedExpression.md[named expressions]
* [[pivotColumn]] Pivot column expressions/Expression.md[expression]
* [[pivotValues]] Pivot values spark-sql-Expression-Literal.md[literals]
* [[aggregates]] Aggregation expressions/Expression.md[expressions]
* [[child]] Child spark-sql-LogicalPlan.md[logical plan]
