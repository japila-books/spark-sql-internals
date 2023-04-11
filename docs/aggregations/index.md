# Aggregation Queries

**Aggregation Queries** (_Aggregations_) are structured queries with [Aggregate](../logical-operators/Aggregate.md) logical operator.

`Aggregate` is used to [computeColumnStats](../CommandUtils.md#computeColumnStats) and [computePercentiles](../CommandUtils.md#computePercentiles).

## High-Level Operators

### SQL

`Aggregate` represents the following SQL clauses:

* [GROUP BY](../sql/AstBuilder.md#withAggregationClause) (incl. `GROUPING SETS`, `WITH CUBE`, `WITH ROLLUP`)
* [visitCommonSelectQueryClausePlan](../sql/AstBuilder.md#visitCommonSelectQueryClausePlan)

### KeyValueGroupedDataset

[KeyValueGroupedDataset.agg](../KeyValueGroupedDataset.md#agg) operator is used

### RelationalGroupedDataset

`RelationalGroupedDataset` is requested to [toDF](../RelationalGroupedDataset.md#toDF).

## Group Types

* `CUBE`
* `GROUPBY`
* `PIVOT`
* `ROLLUP`

## Logical Analysis

The following logical analysis rules handle `Aggregate` logical operator:

* [CleanupAliases](../logical-analysis-rules/CleanupAliases.md)
* `ExtractGenerator`
* `ExtractWindowExpressions`
* `GlobalAggregates`
* [ResolveAliases](../logical-analysis-rules/ResolveAliases.md)
* [ResolveGroupingAnalytics](../logical-analysis-rules/ResolveGroupingAnalytics.md)
* [ResolveOrdinalInOrderByAndGroupBy](../logical-analysis-rules/ResolveOrdinalInOrderByAndGroupBy.md)
* `ResolvePivot`

## UnsupportedOperationChecker

`UnsupportedOperationChecker` is responsible for asserting correctness of aggregation queries (among others).

??? note "FIXME List unsupported features"

## Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md) defines [groupBy](../catalyst-dsl/index.md#groupBy) operator to create aggregation queries.

## Logical Optimizations

The following logical optimizations handle `Aggregate` logical operator:

* `DecorrelateInnerQuery`
* `InjectRuntimeFilter`
* `MergeScalarSubqueries`
* [OptimizeMetadataOnlyQuery](../logical-optimizations/OptimizeMetadataOnlyQuery.md)
* `PullOutGroupingExpressions`
* [PullupCorrelatedPredicates](../logical-optimizations/PullupCorrelatedPredicates.md)
* `ReplaceDistinctWithAggregate`
* `ReplaceDeduplicateWithAggregate`
* `RewriteAsOfJoin`
* [RewriteCorrelatedScalarSubquery](../logical-optimizations/RewriteCorrelatedScalarSubquery.md)
* `RewriteDistinctAggregates`
* [RewriteExceptAll](../logical-optimizations/RewriteExceptAll.md)
* `RewriteIntersectAll`
* [V2ScanRelationPushDown](../logical-optimizations/V2ScanRelationPushDown.md)

### Cost-Based Optimization

`Aggregate` operators are handled by [BasicStatsPlanVisitor](../cost-based-optimization/BasicStatsPlanVisitor.md) for [visitDistinct](../cost-based-optimization/BasicStatsPlanVisitor.md#visitDistinct) and [visitAggregate](../cost-based-optimization/BasicStatsPlanVisitor.md#visitAggregate)

### PushDownPredicate { #PushDownPredicate }

[PushDownPredicate](../logical-optimizations/PushDownPredicate.md) logical plan optimization applies so-called **filter pushdown** to a [Pivot](../logical-operators/Pivot.md) operator when under `Filter` operator and with all expressions deterministic.

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

## Query Planning

`Aggregate` logical operator is planned to one of the physical operators in [Aggregation](../execution-planning-strategies/Aggregation.md) execution planning strategy (using [PhysicalAggregation](../PhysicalAggregation.md) utility):

* [HashAggregateExec](../physical-operators/HashAggregateExec.md)
* [ObjectHashAggregateExec](../physical-operators/ObjectHashAggregateExec.md)
* [SortAggregateExec](../physical-operators/SortAggregateExec.md)

## Physical Optimization

The following physical optimizations use `Aggregate` logical operator:

* [PlanAdaptiveDynamicPruningFilters](../physical-optimizations/PlanAdaptiveDynamicPruningFilters.md)
* [PlanDynamicPruningFilters](../physical-optimizations/PlanDynamicPruningFilters.md)
* `RowLevelOperationRuntimeGroupFiltering`
