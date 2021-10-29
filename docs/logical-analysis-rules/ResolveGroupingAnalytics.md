# ResolveGroupingAnalytics Logical Resolution Rule

`ResolveGroupingAnalytics` is a [logical rule](../catalyst/Rule.md) (`Rule[LogicalPlan]`).

`ResolveGroupingAnalytics` is part of [Resolution](../Analyzer.md#Resolution) batch of [Logical Analyzer](../Analyzer.md).

## Creating Instance

`ResolveGroupingAnalytics` takes no arguments to be created.

`ResolveGroupingAnalytics` is created when:

* `Analyzer` is requested for [batches](../Analyzer.md#batches)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` resolves the following operators in the input [LogicalPlan](../logical-operators/LogicalPlan.md):

* [UnresolvedHaving](../logical-operators/UnresolvedHaving.md) with [Aggregate](../logical-operators/Aggregate.md) with `Cube`
* [UnresolvedHaving](../logical-operators/UnresolvedHaving.md) with [Aggregate](../logical-operators/Aggregate.md) with `Rollup`
* [UnresolvedHaving](../logical-operators/UnresolvedHaving.md) with [GroupingSets](../logical-operators/GroupingSets.md)
* [Aggregate](../logical-operators/Aggregate.md) with `Cube`
* [Aggregate](../logical-operators/Aggregate.md) with `Rollup`
* [GroupingSets](../logical-operators/GroupingSets.md)
* `Filter` with `Grouping` or `GroupingID` expressions
* [Sort](../logical-operators/Sort.md) with `Grouping` or `GroupingID` expressions

## <span id="tryResolveHavingCondition"> tryResolveHavingCondition

```scala
tryResolveHavingCondition(
  h: UnresolvedHaving): LogicalPlan
```

`tryResolveHavingCondition`...FIXME
