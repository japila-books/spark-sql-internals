# ResolvedHint Unary Logical Operator

`ResolvedHint` is a [unary logical operator](LogicalPlan.md#UnaryNode) to represent resolved hint nodes in a [logical query plan](#child).

## Creating Instance

`ResolvedHint` takes the following to be created:

* <span id="child"> Child [LogicalPlan](LogicalPlan.md)
* <span id="hints"> [HintInfo](../hints/HintInfo.md)

`ResolvedHint` is created when:

* [ResolveJoinStrategyHints](../logical-analysis-rules/ResolveJoinStrategyHints.md) logical resolution rule is [executed](../logical-analysis-rules/ResolveJoinStrategyHints.md#applyJoinStrategyHint)
* [broadcast](../functions/index.md#broadcast) standard function is used (on a `Dataset`)
* `CacheManager` is requested to [useCachedData](../CacheManager.md#useCachedData)

## Query Execution Planning

[BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy throws an `IllegalStateException` for `ResolvedHint`s when executed.
