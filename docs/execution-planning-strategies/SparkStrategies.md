---
title: SparkStrategies
---

# SparkStrategies &mdash; Container of Execution Planning Strategies

`SparkStrategies` is an abstract Catalyst [query planner](../catalyst/QueryPlanner.md) that _merely_ serves as a "container" (or a namespace) of the concrete [execution planning strategies](SparkStrategy.md) (for [SparkPlanner](../SparkPlanner.md)):

* [Aggregation](Aggregation.md)
* [BasicOperators](BasicOperators.md)
* `FlatMapGroupsWithStateStrategy`
* [InMemoryScans](InMemoryScans.md)
* [JoinSelection](JoinSelection.md)
* [SpecialLimits](SpecialLimits.md)
* `StatefulAggregationStrategy`
* `StreamingDeduplicationStrategy`
* `StreamingRelationStrategy`

[[singleRowRdd]]
`SparkStrategies` has a single lazily-instantiated `singleRowRdd` value that is an `RDD` of [InternalRow](../InternalRow.md)s that [BasicOperators](BasicOperators.md) execution planning strategy uses when resolving [OneRowRelation](BasicOperators.md#OneRowRelation) (to `RDDScanExec` leaf physical operator).

NOTE: `OneRowRelation` logical operator represents SQL's [SELECT clause without FROM clause](../sql/AstBuilder.md#visitQuerySpecification) or [EXPLAIN DESCRIBE TABLE](../sql/AstBuilder.md#visitExplain).
