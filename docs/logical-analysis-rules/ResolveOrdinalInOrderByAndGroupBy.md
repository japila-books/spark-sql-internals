# ResolveOrdinalInOrderByAndGroupBy Logical Resolution Rule

`ResolveOrdinalInOrderByAndGroupBy` is a [logical resolution rule](../Analyzer.md#batches) that <<apply, converts ordinal positions in Sort and Aggregate logical operators with corresponding expressions>>  in a logical query plan.

`ResolveOrdinalInOrderByAndGroupBy` is part of the [Resolution](../Analyzer.md#Resolution) fixed-point batch in the standard batches of the [Analyzer](../Analyzer.md).

`ResolveOrdinalInOrderByAndGroupBy` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md), i.e. `Rule[LogicalPlan]`.

[[creating-instance]]
`ResolveOrdinalInOrderByAndGroupBy` takes no arguments when created.

[source, scala]
----
// FIXME: DEMO
val rule = spark.sessionState.analyzer.ResolveOrdinalInOrderByAndGroupBy

val plan = ???
val planResolved = rule(plan)
scala> println(planResolved.numberedTreeString)
00 'UnresolvedRelation `t1`
----

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply` [walks the logical plan from children up the tree](../catalyst/TreeNode.md#transformUp) and looks for <<spark-sql-LogicalPlan-Sort.md#, Sort>> and <<spark-sql-LogicalPlan-Aggregate.md#, Aggregate>> logical operators with <<spark-sql-Expression-UnresolvedOrdinal.md#, UnresolvedOrdinal>> leaf expressions (in <<spark-sql-LogicalPlan-Sort.md#order, ordering>> and <<spark-sql-LogicalPlan-Aggregate.md#groupingExpressions, grouping>> expressions, respectively).

For a <<spark-sql-LogicalPlan-Sort.md#, Sort>> logical operator with <<spark-sql-Expression-UnresolvedOrdinal.md#, UnresolvedOrdinal>> expressions, `apply` replaces all the <<spark-sql-Expression-SortOrder.md#, SortOrder>> expressions (with <<spark-sql-Expression-UnresolvedOrdinal.md#, UnresolvedOrdinal>> child expressions) with `SortOrder` expressions and the expression at the `index - 1` position in the [output schema](../catalyst/QueryPlan.md#output) of the <<spark-sql-LogicalPlan-Sort.md#child, child>> logical operator.

For a <<spark-sql-LogicalPlan-Aggregate.md#, Aggregate>> logical operator with <<spark-sql-Expression-UnresolvedOrdinal.md#, UnresolvedOrdinal>> expressions, `apply` replaces all the expressions (with <<spark-sql-Expression-UnresolvedOrdinal.md#, UnresolvedOrdinal>> child expressions) with the expression at the `index - 1` position in the <<spark-sql-LogicalPlan-Aggregate.md#aggregateExpressions, aggregate named expressions>> of the current `Aggregate` logical operator.

`apply` throws a `AnalysisException` (and hence fails an analysis) if the ordinal is outside the range:

```
ORDER BY position [index] is not in select list (valid range is [1, [output.size]])
GROUP BY position [index] is not in select list (valid range is [1, [aggs.size]])
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
