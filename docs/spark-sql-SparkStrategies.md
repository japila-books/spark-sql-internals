title: SparkStrategies

# SparkStrategies -- Container of Execution Planning Strategies

`SparkStrategies` is an abstract Catalyst link:catalyst/QueryPlanner.md[query planner] that _merely_ serves as a "container" (or a namespace) of the concrete link:spark-sql-SparkStrategy.adoc[execution planning strategies] (for link:spark-sql-SparkPlanner.adoc[SparkPlanner]):

* [Aggregation](execution-planning-strategies/Aggregation.md)
* [BasicOperators](execution-planning-strategies/BasicOperators.md)
* `FlatMapGroupsWithStateStrategy`
* [InMemoryScans](execution-planning-strategies/InMemoryScans.md)
* [JoinSelection](execution-planning-strategies/JoinSelection.md)
* `SpecialLimits`
* `StatefulAggregationStrategy`
* `StreamingDeduplicationStrategy`
* `StreamingRelationStrategy`

[[singleRowRdd]]
`SparkStrategies` has a single lazily-instantiated `singleRowRdd` value that is an `RDD` of link:spark-sql-InternalRow.adoc[internal binary rows] that [BasicOperators](execution-planning-strategies/BasicOperators.md) execution planning strategy uses when resolving [OneRowRelation](execution-planning-strategies/BasicOperators.md#OneRowRelation) (to link:spark-sql-SparkPlan-RDDScanExec.adoc[RDDScanExec] leaf physical operator).

NOTE: `OneRowRelation` logical operator represents SQL's link:spark-sql-AstBuilder.adoc#visitQuerySpecification[SELECT clause without FROM clause] or link:spark-sql-AstBuilder.adoc#visitExplain[EXPLAIN DESCRIBE TABLE].
