# Aggregate Logical Operator

`Aggregate` is an [unary logical operator](LogicalPlan.md#UnaryNode) that represents the following high-level operators in a [logical query plan](LogicalPlan.md):

* `AstBuilder` is requested to [visitCommonSelectQueryClausePlan](../sql/AstBuilder.md#visitCommonSelectQueryClausePlan) (`HAVING` clause without `GROUP BY`) and [parse GROUP BY clause](../sql/AstBuilder.md#withAggregationClause)
* `KeyValueGroupedDataset` is requested to [agg](../basic-aggregation/KeyValueGroupedDataset.md#agg) (and [aggUntyped](../basic-aggregation/KeyValueGroupedDataset.md#aggUntyped))
* `RelationalGroupedDataset` is requested to [toDF](../basic-aggregation/RelationalGroupedDataset.md#toDF)

## Creating Instance

`Aggregate` takes the following to be created:

* <span id="groupingExpressions"> Grouping [Expression](../expressions/Expression.md)s
* <span id="aggregateExpressions"> Aggregate [NamedExpression](../expressions/NamedExpression.md)s
* <span id="child"> Child [LogicalPlan](LogicalPlan.md)

`Aggregate` is created when:

* `AstBuilder` is requested to [withSelectQuerySpecification](../sql/AstBuilder.md#withSelectQuerySpecification) and [withAggregationClause](../sql/AstBuilder.md#withAggregationClause)
* `DslLogicalPlan` is used to [groupBy](../catalyst-dsl/DslLogicalPlan.md#groupBy)
* `KeyValueGroupedDataset` is requested to [aggUntyped](../basic-aggregation/KeyValueGroupedDataset.md#aggUntyped)
* `RelationalGroupedDataset` is requested to [toDF](../basic-aggregation/RelationalGroupedDataset.md#toDF)
* [AnalyzeColumnCommand](AnalyzeColumnCommand.md) logical command (when `CommandUtils` is used to [computeColumnStats](../CommandUtils.md#computeColumnStats) and [computePercentiles](../CommandUtils.md#computePercentiles))

## <span id="supportsHashAggregate"> Checking Requirements for HashAggregateExec

```scala
supportsHashAggregate(
  aggregateBufferAttributes: Seq[Attribute]): Boolean
```

`supportsHashAggregate` [builds a StructType](../types/StructType.md#fromAttributes) for the given `aggregateBufferAttributes`.

In the end, `supportsHashAggregate` [isAggregateBufferMutable](#isAggregateBufferMutable).

---

`supportsHashAggregate` is used when:

* `MergeScalarSubqueries` is requested to `supportedAggregateMerge`
* `AggUtils` is requested to [create a physical operator for aggregation](../AggUtils.md#createAggregate)
* `HashAggregateExec` physical operator is created (to assert that the [aggregateBufferAttributes](../physical-operators/HashAggregateExec.md#aggregateBufferAttributes) are supported)

## <span id="isAggregateBufferMutable"> isAggregateBufferMutable

```scala
isAggregateBufferMutable(
  schema: StructType): Boolean
```

`isAggregateBufferMutable` is enabled (`true`) when the [type](../types/StructField.md#dataType) of all the [fields](../types/StructField.md) (in the given `schema`) are [mutable](../UnsafeRow.md#isMutable).

---

`isAggregateBufferMutable` is used when:

* `Aggregate` is requested to [check the requirements for HashAggregateExec](#supportsHashAggregate)
* `UnsafeFixedWidthAggregationMap` is requested to [supportsAggregationBufferSchema](../UnsafeFixedWidthAggregationMap.md#supportsAggregationBufferSchema)

## Query Planning

`Aggregate` logical operator is planned to one of the physical operators in [Aggregation](../execution-planning-strategies/Aggregation.md) execution planning strategy (using [PhysicalAggregation](../PhysicalAggregation.md) utility):

* [HashAggregateExec](../physical-operators/HashAggregateExec.md)
* [ObjectHashAggregateExec](../physical-operators/ObjectHashAggregateExec.md)
* [SortAggregateExec](../physical-operators/SortAggregateExec.md)

## Logical Optimization

[PushDownPredicate](../logical-optimizations/PushDownPredicate.md) logical plan optimization applies so-called **filter pushdown** to a [Pivot](Pivot.md) operator when under `Filter` operator and with all expressions deterministic.

```text
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
```
