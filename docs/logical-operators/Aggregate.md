title: Aggregate

# Aggregate Unary Logical Operator

`Aggregate` is a spark-sql-LogicalPlan.md#UnaryNode[unary logical operator] that holds the following:

* [[groupingExpressions]] Grouping expressions/Expression.md[expressions]
* [[aggregateExpressions]] Aggregate spark-sql-Expression-NamedExpression.md[named expressions]
* [[child]] Child spark-sql-LogicalPlan.md[logical plan]

`Aggregate` is created to represent the following (after a logical plan is spark-sql-LogicalPlan.md#analyzed[analyzed]):

* SQL's spark-sql-AstBuilder.md#withAggregation[GROUP BY] clause (possibly with `WITH CUBE` or `WITH ROLLUP`)

* spark-sql-RelationalGroupedDataset.md[RelationalGroupedDataset] aggregations (e.g. spark-sql-RelationalGroupedDataset.md#pivot[pivot])

* spark-sql-KeyValueGroupedDataset.md[KeyValueGroupedDataset] aggregations

* spark-sql-LogicalPlan-AnalyzeColumnCommand.md[AnalyzeColumnCommand] logical command

NOTE: `Aggregate` logical operator is translated to one of spark-sql-SparkPlan-HashAggregateExec.md[HashAggregateExec], spark-sql-SparkPlan-ObjectHashAggregateExec.md[ObjectHashAggregateExec] or spark-sql-SparkPlan-SortAggregateExec.md[SortAggregateExec] physical operators in [Aggregation](../execution-planning-strategies/Aggregation.md) execution planning strategy.

[[properties]]
.Aggregate's Properties
[width="100%",cols="1,2",options="header"]
|===
| Name
| Description

| `maxRows`
a| <<child, Child logical plan>>'s `maxRows`

NOTE: Part of spark-sql-LogicalPlan.md#maxRows[LogicalPlan contract].

| `output`
a| Attributes of <<aggregateExpressions, aggregate named expressions>>

NOTE: Part of catalyst/QueryPlan.md#output[QueryPlan contract].

| `resolved`
a| Enabled when:

* <<expressions, expressions>> and <<child, child logical plan>> are resolved
* No spark-sql-Expression-WindowExpression.md[WindowExpressions] exist in <<aggregateExpressions, aggregate named expressions>>

NOTE: Part of spark-sql-LogicalPlan.md#resolved[LogicalPlan contract].

| `validConstraints`
a| The (expression) constraints of <<child, child logical plan>> and non-aggregate <<aggregateExpressions, aggregate named expressions>>.

NOTE: Part of catalyst/QueryPlan.md#validConstraints[QueryPlan contract].
|===

=== [[optimizer]] Rule-Based Logical Query Optimization Phase

spark-sql-Optimizer-PushDownPredicate.md[PushDownPredicate] logical plan optimization applies so-called *filter pushdown* to a spark-sql-LogicalPlan-Pivot.md[Pivot] operator when under `Filter` operator and with all expressions deterministic.

[source, scala]
----
import org.apache.spark.sql.catalyst.optimizer.PushDownPredicate

val q = visits
  .groupBy("city")
  .pivot("year")
  .count()
  .where($"city" === "Boston")

val pivotPlanAnalyzed = q.queryExecution.analyzed
scala> println(pivotPlanAnalyzed.numberedTreeString)
00 Filter (city#8 = Boston)
01 +- Project [city#8, __pivot_count(1) AS `count` AS `count(1) AS ``count```#142[0] AS 2015#143L, __pivot_count(1) AS `count` AS `count(1) AS ``count```#142[1] AS 2016#144L, __pivot_count(1) AS `count` AS `count(1) AS ``count```#142[2] AS 2017#145L]
02    +- Aggregate [city#8], [city#8, pivotfirst(year#9, count(1) AS `count`#134L, 2015, 2016, 2017, 0, 0) AS __pivot_count(1) AS `count` AS `count(1) AS ``count```#142]
03       +- Aggregate [city#8, year#9], [city#8, year#9, count(1) AS count(1) AS `count`#134L]
04          +- Project [_1#3 AS id#7, _2#4 AS city#8, _3#5 AS year#9]
05             +- LocalRelation [_1#3, _2#4, _3#5]

val afterPushDown = PushDownPredicate(pivotPlanAnalyzed)
scala> println(afterPushDown.numberedTreeString)
00 Project [city#8, __pivot_count(1) AS `count` AS `count(1) AS ``count```#142[0] AS 2015#143L, __pivot_count(1) AS `count` AS `count(1) AS ``count```#142[1] AS 2016#144L, __pivot_count(1) AS `count` AS `count(1) AS ``count```#142[2] AS 2017#145L]
01 +- Aggregate [city#8], [city#8, pivotfirst(year#9, count(1) AS `count`#134L, 2015, 2016, 2017, 0, 0) AS __pivot_count(1) AS `count` AS `count(1) AS ``count```#142]
02    +- Aggregate [city#8, year#9], [city#8, year#9, count(1) AS count(1) AS `count`#134L]
03       +- Project [_1#3 AS id#7, _2#4 AS city#8, _3#5 AS year#9]
04          +- Filter (_2#4 = Boston)
05             +- LocalRelation [_1#3, _2#4, _3#5]
----
