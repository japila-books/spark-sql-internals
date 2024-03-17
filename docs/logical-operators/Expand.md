---
title: Expand
---

# Expand Unary Logical Operator

`Expand` is a [unary logical operator](LogicalPlan.md#UnaryNode) that represents `Cube`, `Rollup`, [GroupingSets](GroupingSets.md) and [TimeWindow](../expressions/TimeWindow.md) logical operators after they have been resolved at [analysis phase](#analyzer).

## Creating Instance

`Expand` takes the following to be created:

* <span id="projections"> Projections (`Seq[Seq[Expression]]`)
* <span id="output"> Output [Attribute](../expressions/Attribute.md)s
* <span id="child"> Child [LogicalPlan](LogicalPlan.md)

`Expand` is created when:

* `ResolveUnpivot` logical resolution rule is executed (to resolve `Unpivot` expression)
* `TimeWindowing` logical resolution rule is executed (to resolve [TimeWindow](../expressions/TimeWindow.md) expressions)
* `RewriteUpdateTable` logical resolution rule is executed (to `buildDeletesAndInserts`)
* `Expand` is requested to [apply](#apply)

## Creating Expand { #apply }

```scala
apply(
  groupingSetsAttrs: Seq[Seq[Attribute]],
  groupByAliases: Seq[Alias],
  groupByAttrs: Seq[Attribute],
  gid: Attribute,
  child: LogicalPlan): Expand
```

`apply`...FIXME

---

`apply` is used when:

* [ResolveGroupingAnalytics](../logical-analysis-rules/ResolveGroupingAnalytics.md) logical analysis rule is [executed](../logical-analysis-rules/ResolveGroupingAnalytics.md#constructExpand)

## Analysis Phase { #analyzer }

`Expand` logical operator is resolved at [analysis phase](../Analyzer.md) in the following logical evaluation rules:

* [ResolveGroupingAnalytics](../Analyzer.md#ResolveGroupingAnalytics) (for `Cube`, `Rollup`, [GroupingSets](GroupingSets.md) logical operators)
* `ResolveUnpivot`
* `RewriteUpdateTable`
* `TimeWindowing` (for [TimeWindow](../expressions/TimeWindow.md) logical operator)

## Physical Planning

`Expand` logical operator is resolved to [ExpandExec](../physical-operators/ExpandExec.md) physical operator in [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy.
