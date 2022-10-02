# Pivot Unary Logical Operator

`Pivot` is an [unary logical operator](LogicalPlan.md#UnaryNode) that represents [pivot](../basic-aggregation/RelationalGroupedDataset.md#pivot) operator.

## Creating Instance

`Pivot` takes the following to be created:

* <span id="groupByExprsOpt"> Grouping [NamedExpression](../expressions/NamedExpression.md)s
* <span id="pivotColumn"> Pivot Column [Expression](../expressions/Expression.md)
* <span id="pivotValues"> Pivot Value [Expression](../expressions/Expression.md)s
* <span id="aggregates"> Aggregate [Expression](../expressions/Expression.md)s
* <span id="child"> Child [LogicalPlan](LogicalPlan.md)

`Pivot` is created when:

* `AstBuilder` is requested to [parse PIVOT clause](../sql/AstBuilder.md#withPivot)
* `RelationalGroupedDataset` is requested to [toDF](../basic-aggregation/RelationalGroupedDataset.md#toDF) (with `PivotType`)

## <span id="analyzer"> Analysis Phase

`Pivot` is resolved to a [Aggregate](Aggregate.md) logical operator by [ResolvePivot](../Analyzer.md#ResolvePivot) logical evaluation rule.

```text
scala> :type spark
org.apache.spark.sql.SparkSession

import spark.sessionState.analyzer.ResolveAliases

// see q in the demo on this page
val plan = q.queryExecution.logical

scala> println(plan.numberedTreeString)
00 Pivot [city#8], year#9: int, [2015, 2016, 2017], [count(1) AS count#24L]
01 +- Project [_1#3 AS id#7, _2#4 AS city#8, _3#5 AS year#9]
02    +- LocalRelation [_1#3, _2#4, _3#5]

// FIXME Find a plan to show the effect of ResolveAliases
val planResolved = ResolveAliases(plan)
```

`Pivot` operator "disappears" behind (i.e. is converted to) an [Aggregate](Aggregate.md) logical operator.

```text
import spark.sessionState.analyzer.ResolvePivot
val planAfterResolvePivot = ResolvePivot(plan)
scala> println(planAfterResolvePivot.numberedTreeString)
00 Project [city#8, __pivot_count(1) AS `count` AS `count(1) AS ``count```#62[0] AS 2015#63L, __pivot_count(1) AS `count` AS `count(1) AS ``count```#62[1] AS 2016#64L, __pivot_count(1) AS `count` AS `count(1) AS ``count```#62[2] AS 2017#65L]
01 +- Aggregate [city#8], [city#8, pivotfirst(year#9, count(1) AS `count`#54L, 2015, 2016, 2017, 0, 0) AS __pivot_count(1) AS `count` AS `count(1) AS ``count```#62]
02    +- Aggregate [city#8, year#9], [city#8, year#9, count(1) AS count#24L AS count(1) AS `count`#54L]
03       +- Project [_1#3 AS id#7, _2#4 AS city#8, _3#5 AS year#9]
04          +- LocalRelation [_1#3, _2#4, _3#5]
```

## Demo

```scala
val visits = Seq(
  (0, "Warsaw", 2015),
  (1, "Warsaw", 2016),
  (2, "Boston", 2017)
).toDF("id", "city", "year")
```

```scala
val q = visits
  .groupBy("city")
  .pivot("year", Seq("2015", "2016", "2017"))
  .count()
```

```text
scala> println(q.queryExecution.logical.numberedTreeString)
00 Pivot [city#8], year#9: int, [2015, 2016, 2017], [count(1) AS count#157L]
01 +- Project [_1#3 AS id#7, _2#4 AS city#8, _3#5 AS year#9]
02    +- LocalRelation [_1#3, _2#4, _3#5]
```
