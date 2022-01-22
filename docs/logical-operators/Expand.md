# Expand Unary Logical Operator

`Expand` is a spark-sql-LogicalPlan.md#UnaryNode[unary logical operator] that represents `Cube`, `Rollup`, GroupingSets.md[GroupingSets] and expressions/TimeWindow.md[TimeWindow] logical operators after they have been resolved at <<analyzer, analysis phase>>.

```
FIXME Examples for
1. Cube
2. Rollup
3. GroupingSets
4. See TimeWindow

val q = ...

scala> println(q.queryExecution.logical.numberedTreeString)
...
```

!!! note
    `Expand` logical operator is resolved to `ExpandExec` physical operator in [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy.

[[properties]]
.Expand's Properties
[width="100%",cols="1,2",options="header"]
|===
| Name
| Description

| `references`
| `AttributeSet` from <<projections, projections>>

| `validConstraints`
| Empty set of expressions/Expression.md[expressions]
|===

## <span id="analyzer"> Analysis Phase

`Expand` logical operator is resolved to at [analysis phase](../Analyzer.md) in the following logical evaluation rules:

* [ResolveGroupingAnalytics](../Analyzer.md#ResolveGroupingAnalytics) (for `Cube`, `Rollup`, [GroupingSets](GroupingSets.md) logical operators)

* `TimeWindowing` (for [TimeWindow](../expressions/TimeWindow.md) logical operator)

NOTE: Aggregate -> (Cube|Rollup|GroupingSets) -> constructAggregate -> constructExpand

```text
val spark: SparkSession = ...
// using q from the example above
val plan = q.queryExecution.logical

scala> println(plan.numberedTreeString)
...FIXME
```

=== [[optimizer]] Rule-Based Logical Query Optimization Phase

* [ColumnPruning](../logical-optimizations/ColumnPruning.md)
* [FoldablePropagation](../catalyst/Optimizer.md#FoldablePropagation)
* [RewriteDistinctAggregates](../catalyst/Optimizer.md#RewriteDistinctAggregates)

=== [[creating-instance]] Creating Expand Instance

`Expand` takes the following when created:

* [[projections]] Projection [expressions](../expressions/Expression.md)
* [[output]] Output schema [attributes](../expressions/Attribute.md)
* [[child]] Child [logical plan](../logical-operators/LogicalPlan.md)
