---
title: ResolveGroupingAnalytics
---

# ResolveGroupingAnalytics Logical Resolution Rule

`ResolveGroupingAnalytics` is a [logical resolution rule](../catalyst/Rule.md) (`Rule[LogicalPlan]`).

`ResolveGroupingAnalytics` is part of [Resolution](../Analyzer.md#Resolution) batch of [Logical Analyzer](../Analyzer.md).

## Creating Instance

`ResolveGroupingAnalytics` takes no arguments to be created.

??? note "Singleton Object"
    `ResolveGroupingAnalytics` is a Scala **object** which is a class that has exactly one instance. It is created lazily when it is referenced, like a `lazy val`.

    Learn more in [Tour of Scala](https://docs.scala-lang.org/tour/singleton-objects.html).

`ResolveGroupingAnalytics` is created when:

* `Analyzer` is requested for [batches](../Analyzer.md#batches)

## Executing Rule { #apply }

??? note "Rule"

    ```scala
    apply(
      plan: LogicalPlan): LogicalPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` resolves the following operators in the input [LogicalPlan](../logical-operators/LogicalPlan.md):

* [UnresolvedHaving](../logical-operators/UnresolvedHaving.md) with [Aggregate](../logical-operators/Aggregate.md) with `Cube`
* [UnresolvedHaving](../logical-operators/UnresolvedHaving.md) with [Aggregate](../logical-operators/Aggregate.md) with `Rollup`
* [UnresolvedHaving](../logical-operators/UnresolvedHaving.md) with [GroupingSets](../logical-operators/GroupingSets.md)
* [Aggregate](../logical-operators/Aggregate.md) with `Cube`
* [Aggregate](../logical-operators/Aggregate.md) with `Rollup`
* [GroupingSets](../logical-operators/GroupingSets.md)
* `Filter` with `Grouping` or `GroupingID` expressions
* [Sort](../logical-operators/Sort.md) with `Grouping` or `GroupingID` expressions

### tryResolveHavingCondition { #tryResolveHavingCondition }

```scala
tryResolveHavingCondition(
  h: UnresolvedHaving): LogicalPlan
```

`tryResolveHavingCondition`...FIXME

### constructAggregate { #constructAggregate }

```scala
constructAggregate(
  selectedGroupByExprs: Seq[Seq[Expression]],
  groupByExprs: Seq[Expression],
  aggregationExprs: Seq[NamedExpression],
  child: LogicalPlan): LogicalPlan
```

`constructAggregate`...FIXME

#### constructExpand { #constructExpand }

```scala
constructExpand(
  selectedGroupByExprs: Seq[Seq[Expression]],
  child: LogicalPlan,
  groupByAliases: Seq[Alias],
  gid: Attribute): LogicalPlan
```

`constructExpand`...FIXME

### hasGroupingFunction { #hasGroupingFunction }

```scala
hasGroupingFunction(
  e: Expression): Boolean
```

`hasGroupingFunction` holds `true` when there is either `Grouping` or `GroupingID` expression in the given [Expression](../expressions/Expression.md) (tree).

In other words, the given `Expression` or its children are `Grouping` or `GroupingID` expressions.
