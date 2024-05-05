---
title: Sort
---

# Sort Unary Logical Operator

`Sort` is a [unary logical operator](LogicalPlan.md#UnaryNode) that represents the following operators in a logical plan:

* `ORDER BY`, `SORT BY`, `SORT BY ... DISTRIBUTE BY` and `CLUSTER BY` clauses (when `AstBuilder` is requested to [parse a query](../sql/AstBuilder.md#withQueryResultClauses))

* [Dataset.sortWithinPartitions](../dataset/index.md#sortWithinPartitions), [Dataset.sort](../dataset/index.md#sort) and [Dataset.randomSplit](../dataset/index.md#randomSplit) operators

## Creating Instance

`Sort` takes the following to be created:

* <span id="order"> [SortOrder](../expressions/SortOrder.md) expressions
* <span id="global"> `global` flag (for global (`true`) or partition-only (`false`) sorting)
* <span id="child"> Child [logical operator](LogicalPlan.md)

## Execution Planning

`Sort` logical operator is resolved to [SortExec](../physical-operators/SortExec.md) unary physical operator by [BasicOperators](../execution-planning-strategies/BasicOperators.md#Sort) execution planning strategy.

## Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md) defines [orderBy](../catalyst-dsl/DslLogicalPlan.md#orderBy) and [sortBy](../catalyst-dsl/DslLogicalPlan.md#sortBy) operators to create `Sort` operators (with the [global](#global) flag enabled or not, respectively).

```scala
import org.apache.spark.sql.catalyst.dsl.expressions._
import org.apache.spark.sql.catalyst.dsl.plans._
val t1 = table("t1")
```

```scala
val globalSortById = t1.orderBy('id.asc_nullsLast)
```

```text
// Note true for the global flag
scala> println(globalSortById.numberedTreeString)
00 'Sort ['id ASC NULLS LAST], true
01 +- 'UnresolvedRelation `t1`
```

```scala
val partitionOnlySortById = t1.sortBy('id.asc_nullsLast)
```

```text
// Note false for the global flag
scala> println(partitionOnlySortById.numberedTreeString)
00 'Sort ['id ASC NULLS LAST], false
01 +- 'UnresolvedRelation `t1`
```

## Demo

```text
// Using the feature of ordinal literal
val ids = Seq(1,3,2).toDF("id").sort(lit(1))
val logicalPlan = ids.queryExecution.logical
scala> println(logicalPlan.numberedTreeString)
00 Sort [1 ASC NULLS FIRST], true
01 +- AnalysisBarrier
02       +- Project [value#22 AS id#24]
03          +- LocalRelation [value#22]

import org.apache.spark.sql.catalyst.plans.logical.Sort
val sortOp = logicalPlan.collect { case s: Sort => s }.head
scala> println(sortOp.numberedTreeString)
00 Sort [1 ASC NULLS FIRST], true
01 +- AnalysisBarrier
02       +- Project [value#22 AS id#24]
03          +- LocalRelation [value#22]
```

```text
val nums = Seq((0, "zero"), (1, "one")).toDF("id", "name")
// Creates a Sort logical operator:
// - descending sort direction for id column (specified explicitly)
// - name column is wrapped with ascending sort direction
val numsOrdered = nums.sort('id.desc, 'name)
val logicalPlan = numsOrdered.queryExecution.logical
scala> println(logicalPlan.numberedTreeString)
00 'Sort ['id DESC NULLS LAST, 'name ASC NULLS FIRST], true
01 +- Project [_1#11 AS id#14, _2#12 AS name#15]
02    +- LocalRelation [_1#11, _2#12]
```
