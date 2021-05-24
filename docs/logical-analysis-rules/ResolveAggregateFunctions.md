# ResolveAggregateFunctions Logical Analysis Rule

`ResolveAggregateFunctions` is a [logical rule](../catalyst/Rule.md) (`Rule[LogicalPlan]`).

`ResolveAggregateFunctions` is part of [Resolution](../Analyzer.md#Resolution) batch of [Logical Analyzer](../Analyzer.md).

## Creating Instance

`ResolveAggregateFunctions` takes no arguments to be created.

`ResolveAggregateFunctions` is created when:

* `Analyzer` is requested for [batches](../Analyzer.md#batches)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` resolves the following operators in the input [LogicalPlan](../logical-operators/LogicalPlan.md):

* [UnresolvedHaving](../logical-operators/UnresolvedHaving.md) with [Aggregate](../logical-operators/Aggregate.md) resolved
* [Filter](../logical-operators/Filter.md) with [Aggregate](../logical-operators/Aggregate.md) resolved
* [Sort](../logical-operators/Sort.md) with [Aggregate](../logical-operators/Aggregate.md) resolved
