---
title: UnresolvedHint
---

# UnresolvedHint Unary Logical Operator

`UnresolvedHint` is an [unary logical operator](LogicalPlan.md#UnaryNode) that represents a hint (by [name](#name)) for the [child](#child) logical plan.

## Creating Instance

`UnresolvedHint` takes the following to be created:

* <span id="name"> Hint Name
* <span id="parameters"> Hint Parameters (if any)
* <span id="child"> Child [LogicalPlan](LogicalPlan.md)

`UnresolvedHint` is created when:

* [Dataset.hint](../dataset-operators.md#hint) operator is used
* `AstBuilder` is requested to [parse hints in a SQL query](../sql/AstBuilder.md#withHints)

## <span id="resolved"> Never Resolved

```scala
resolved: Boolean
```

`resolved` is part of the [LogicalPlan](LogicalPlan.md#resolved) abstraction.

`resolved` is `false`.

## Logical Analysis

`UnresolvedHint`s [cannot be resolved](#resolved) and are supposed to be converted to [ResolvedHint](ResolvedHint.md) unary logical operators at [analysis](../Analyzer.md#Hints) or removed from a logical plan.

The following logical rules are used to act on `UnresolvedHint` logical operators (the order of executing the rules matters):

* [ResolveJoinStrategyHints](../logical-analysis-rules/ResolveJoinStrategyHints.md)
* [ResolveCoalesceHints](../logical-analysis-rules/ResolveCoalesceHints.md)
* `RemoveAllHints`

[Analyzer](../CheckAnalysis.md#checkAnalysis) throws an `IllegalStateException` for any `UnresolvedHint`s left (_unresolved_):

```text
Internal error: logical hint operator should have been removed during analysis
```

## Catalyst DSL

`UnresolvedHint` can be created using the [hint](../catalyst-dsl/DslLogicalPlan.md#hint) operator in [Catalyst DSL](../catalyst-dsl/index.md).

```scala
import org.apache.spark.sql.catalyst.plans.logical.LocalRelation
val r1 = LocalRelation('a.int, 'b.timestamp, 'c.boolean)
```

```text
scala> println(r1.numberedTreeString)
00 LocalRelation <empty>, [a#0, b#1, c#2]
```

```scala
import org.apache.spark.sql.catalyst.dsl.plans._
val plan = r1.hint(name = "myHint", 100, true)
```

```text
scala> println(plan.numberedTreeString)
00 'UnresolvedHint myHint, [100, true]
01 +- LocalRelation <empty>, [a#0, b#1, c#2]
```

## Demo

```text
// Dataset API
val q = spark.range(1).hint("myHint", 100, true)
val plan = q.queryExecution.logical
scala> println(plan.numberedTreeString)
00 'UnresolvedHint myHint, [100, true]
01 +- Range (0, 1, step=1, splits=Some(8))

// SQL
val q = sql("SELECT /*+ myHint (100, true) */ 1")
val plan = q.queryExecution.logical
scala> println(plan.numberedTreeString)
00 'UnresolvedHint myHint, [100, true]
01 +- 'Project [unresolvedalias(1, None)]
02    +- OneRowRelation
```

```text
// Let's hint the query twice
// The order of hints matters as every hint operator executes Spark analyzer
// That will resolve all but the last hint
val q = spark.range(100).
  hint("broadcast").
  hint("myHint", 100, true)
val plan = q.queryExecution.logical
scala> println(plan.numberedTreeString)
00 'UnresolvedHint myHint, [100, true]
01 +- ResolvedHint (broadcast)
02    +- Range (0, 100, step=1, splits=Some(8))

// Let's resolve unresolved hints
import org.apache.spark.sql.catalyst.rules.RuleExecutor
import org.apache.spark.sql.catalyst.plans.logical.LogicalPlan
import org.apache.spark.sql.catalyst.analysis.ResolveHints
import org.apache.spark.sql.internal.SQLConf
object HintResolver extends RuleExecutor[LogicalPlan] {
  lazy val batches =
    Batch("Hints", FixedPoint(maxIterations = 100),
      new ResolveHints.ResolveJoinStrategyHints(SQLConf.get),
      ResolveHints.RemoveAllHints) :: Nil
}
val resolvedPlan = HintResolver.execute(plan)
scala> println(resolvedPlan.numberedTreeString)
00 ResolvedHint (broadcast)
01 +- Range (0, 100, step=1, splits=Some(8))
```
