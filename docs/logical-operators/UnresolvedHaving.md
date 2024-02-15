---
title: UnresolvedHaving
---

# UnresolvedHaving Unary Logical Operator

`UnresolvedHaving` is a [unary logical operator](LogicalPlan.md#UnaryNode).

## Creating Instance

`UnresolvedHaving` takes the following to be created:

* <span id="havingCondition"> Having [Expression](../expressions/Expression.md)
* <span id="child"> Child [LogicalPlan](LogicalPlan.md)

`UnresolvedHaving` is created when:

* `AstBuilder` is requested to [parse HAVING clause in a SQL query](../sql/AstBuilder.md#withHavingClause)

## <span id="resolved"> Never Resolved

```scala
resolved: Boolean
```

`resolved` is part of the [LogicalPlan](LogicalPlan.md#resolved) abstraction.

`resolved` is `false`.

## Logical Analysis

`UnresolvedHaving` [cannot be resolved](#resolved) and is supposed to be handled at [analysis](../QueryExecution.md#analyzed) using the following rules:

* [ExtractWindowExpressions](../logical-analysis-rules/ExtractWindowExpressions.md)
* [ResolveAggregateFunctions](../logical-analysis-rules/ResolveAggregateFunctions.md)
* [ResolveGroupingAnalytics](../logical-analysis-rules/ResolveGroupingAnalytics.md)

## Catalyst DSL

`UnresolvedHaving` can be created using the [having](../catalyst-dsl/DslLogicalPlan.md#having) operator in [Catalyst DSL](../catalyst-dsl/index.md).
