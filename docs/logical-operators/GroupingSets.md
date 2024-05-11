---
title: GroupingSets
---

# GroupingSets Unary Logical Operator

`GroupingSets` is a `BaseGroupingSets` that represents the following high-level SQL-only operators (in a logical query plan):

* [GROUPING SETS](../sql/AstBuilder.md#visitGroupingAnalytics) SQL statement
* [GROUP BY ... GROUPING SETS](../sql/AstBuilder.md#withAggregationClause) SQL statement

!!! note
    `grouping` and `grouping_id` standard functions can only be used with grouping analytics clauses (incl. `GroupingSets`).

??? note "Spark Structured Streaming Not Supported"
    Grouping Sets is not supported on streaming DataFrames (that is enforced by `UnsupportedOperationChecker`).

## Creating Instance

`GroupingSets` takes the following to be created:

* <span id="groupingSetIndexes"> GroupingSets Indicies
* <span id="flatGroupingSets"> Flat GroupingSets [Expression](../expressions/Expression.md)s
* <span id="userGivenGroupByExprs"> User-Specified GroupBy [Expression](../expressions/Expression.md)s

`GroupingSets` is created using [apply](#apply) utility only.

## Creating GroupingSets { #apply }

```scala
apply(
  groupingSets: Seq[Seq[Expression]]): GroupingSets // (1)!
apply(
  groupingSets: Seq[Seq[Expression]],
  userGivenGroupByExprs: Seq[Expression]): GroupingSets
```

1. `userGivenGroupByExprs` is an empty collection (`Nil`)

`apply` computes the [GroupingSet indicies](#groupingSetIndexes) and creates a [GroupingSets](#creating-instance).

---

`apply` is used when:

* `AstBuilder` is requested to parse [GROUPING SETS](../sql/AstBuilder.md#visitGroupingAnalytics) or [GROUP BY ... GROUPING SETS](../sql/AstBuilder.md#withAggregationClause) SQL statements

<!---
## Review Me

`GroupingSets` is a spark-sql-LogicalPlan.md#UnaryNode[unary logical operator] that represents SQL's sql/AstBuilder.md#withAggregation[GROUPING SETS] variant of `GROUP BY` clause.

```text
val q = sql("""
  SELECT customer, year, SUM(sales)
  FROM VALUES ("abc", 2017, 30) AS t1 (customer, year, sales)
  GROUP BY customer, year
  GROUPING SETS ((customer), (year))
  """)
scala> println(q.queryExecution.logical.numberedTreeString)
00 'GroupingSets [ArrayBuffer('customer), ArrayBuffer('year)], ['customer, 'year], ['customer, 'year, unresolvedalias('SUM('sales), None)]
01 +- 'SubqueryAlias t1
02    +- 'UnresolvedInlineTable [customer, year, sales], [List(abc, 2017, 30)]
```

`GroupingSets` operator is resolved to an `Aggregate` logical operator at <<analyzer, analysis phase>>.

```
scala> println(q.queryExecution.analyzed.numberedTreeString)
00 Aggregate [customer#8, year#9, spark_grouping_id#5], [customer#8, year#9, sum(cast(sales#2 as bigint)) AS sum(sales)#4L]
01 +- Expand [List(customer#0, year#1, sales#2, customer#6, null, 1), List(customer#0, year#1, sales#2, null, year#7, 2)], [customer#0, year#1, sales#2, customer#8, year#9, spark_grouping_id#5]
02    +- Project [customer#0, year#1, sales#2, customer#0 AS customer#6, year#1 AS year#7]
03       +- SubqueryAlias t1
04          +- LocalRelation [customer#0, year#1, sales#2]
```

NOTE: `GroupingSets` can only be created using SQL.

NOTE: `GroupingSets` is not supported on Structured Streaming's spark-sql-LogicalPlan.md#isStreaming[streaming Datasets].

[[resolved]]
`GroupingSets` is never resolved (as it can only be converted to an `Aggregate` logical operator).

[[output]]
The catalyst/QueryPlan.md#output[output schema] of a `GroupingSets` are exactly the attributes of <<aggregations, aggregate named expressions>>.

=== [[analyzer]] Analysis Phase

`GroupingSets` operator is resolved at [analysis phase](../Analyzer.md) in the following logical evaluation rules:

* [ResolveAliases](../logical-analysis-rules/ResolveAliases.md) for unresolved aliases in <<aggregations, aggregate named expressions>>

* [ResolveGroupingAnalytics](../Analyzer.md#ResolveGroupingAnalytics)

`GroupingSets` operator is resolved to an Aggregate.md[Aggregate] with Expand.md[Expand] logical operators.

[source, scala]
----
val spark: SparkSession = ...
// using q from the example above
val plan = q.queryExecution.logical

scala> println(plan.numberedTreeString)
00 'GroupingSets [ArrayBuffer('customer), ArrayBuffer('year)], ['customer, 'year], ['customer, 'year, unresolvedalias('SUM('sales), None)]
01 +- 'SubqueryAlias t1
02    +- 'UnresolvedInlineTable [customer, year, sales], [List(abc, 2017, 30)]

// Note unresolvedalias for SUM expression
// Note UnresolvedInlineTable and SubqueryAlias

// FIXME Show the evaluation rules to get rid of the unresolvable parts
----
-->
