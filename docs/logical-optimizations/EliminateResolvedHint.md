# EliminateResolvedHint Logical Optimization

`EliminateResolvedHint` is a [default logical optimization](../catalyst/Optimizer.md#defaultBatches).

## <span id="nonExcludableRules"> Non-Excludable Rule

`EliminateResolvedHint` is a [non-excludable rule](../catalyst/Optimizer.md#nonExcludableRules).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` transforms [Join](../logical-operators/Join.md) logical operators with no hints defined in the given [LogicalPlan](../logical-operators/LogicalPlan.md):

1. [Extracts hints](#extractHintsFromPlan) from the [left](../logical-operators/Join.md#left) and [right](../logical-operators/Join.md#right) sides of the join (that gives new operators and [JoinHint](../JoinHint.md)s for either side)

1. Creates a new [JoinHint](../JoinHint.md) with the [hints merged](#mergeHints) for the left and right sides

1. Creates a new [Join](../logical-operators/Join.md) logical operator with the new left and right operators and the new `JoinHint`

In the end, `apply` finds [ResolvedHint](../logical-operators/ResolvedHint.md)s and, if found, requests the [HintErrorHandler](#hintErrorHandler) to [joinNotFoundForJoinHint](../HintErrorHandler.md#joinNotFoundForJoinHint) and ignores the hint (returns the child of the `ResolvedHint`).

## <span id="hintErrorHandler"> HintErrorHandler

```scala
hintErrorHandler: HintErrorHandler
```

`hintErrorHandler` is the default `HintErrorHandler`.

## <span id="extractHintsFromPlan"> Extracting Hints from Logical Plan

```scala
extractHintsFromPlan(
  plan: LogicalPlan): (LogicalPlan, Seq[HintInfo])
```

`extractHintsFromPlan` extracts all hints from the given [LogicalPlan](../logical-operators/LogicalPlan.md) and gives:

* [HintInfo](../HintInfo.md)s
* Transformed plan with [ResolvedHint](../logical-operators/ResolvedHint.md) nodes removed

`extractHintsFromPlan`...FIXME

`extractHintsFromPlan` is used when:

* `EliminateResolvedHint` is requested to [execute](#apply)
* `CacheManager` is requested to [useCachedData](../CacheManager.md#useCachedData)

## <span id="mergeHints"> Merging Hints

```scala
mergeHints(
  hints: Seq[HintInfo]): Option[HintInfo]
```

`mergeHints`...FIXME
