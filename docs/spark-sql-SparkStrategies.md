title: SparkStrategies

# SparkStrategies -- Container of Execution Planning Strategies

`SparkStrategies` is an abstract Catalyst catalyst/QueryPlanner.md[query planner] that _merely_ serves as a "container" (or a namespace) of the concrete spark-sql-SparkStrategy.md[execution planning strategies] (for [SparkPlanner](SparkPlanner.md)):

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
`SparkStrategies` has a single lazily-instantiated `singleRowRdd` value that is an `RDD` of spark-sql-InternalRow.md[internal binary rows] that [BasicOperators](execution-planning-strategies/BasicOperators.md) execution planning strategy uses when resolving [OneRowRelation](execution-planning-strategies/BasicOperators.md#OneRowRelation) (to spark-sql-SparkPlan-RDDScanExec.md[RDDScanExec] leaf physical operator).

NOTE: `OneRowRelation` logical operator represents SQL's spark-sql-AstBuilder.md#visitQuerySpecification[SELECT clause without FROM clause] or spark-sql-AstBuilder.md#visitExplain[EXPLAIN DESCRIBE TABLE].
