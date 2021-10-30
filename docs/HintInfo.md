# HintInfo

## Creating Instance

`HintInfo` takes the following to be created:

* <span id="strategy"> Optional [JoinStrategyHint](JoinStrategyHint.md) (default: undefined)

`HintInfo` is created when:

* [ResolveJoinStrategyHints](logical-analysis-rules/ResolveJoinStrategyHints.md) logical resolution rule is [executed](logical-analysis-rules/ResolveJoinStrategyHints.md#createHintInfo)
* [ResolvedHint](logical-operators/ResolvedHint.md) logical operator is created
* `HintInfo` is requested to [merge with another HintInfo](#merge)
* [broadcast](spark-sql-functions.md#broadcast) standard function is used (on a `Dataset`)
* [DemoteBroadcastHashJoin](adaptive-query-execution/DemoteBroadcastHashJoin.md) logical optimization is executed

## <span id="toString"> Text Representation

```scala
toString: String
```

`toString` is part of the `Object` ([Java]({{ java.api }}/java/lang/Object.html#toString())) abstraction.

`toString` returns the following (with the [strategy](#strategy) if defined or `none`):

```text
(strategy=[strategy|none])
```

## <span id="merge"> Merging Hints

```scala
merge(
  other: HintInfo,
  hintErrorHandler: HintErrorHandler): HintInfo
```

`merge`...FIXME

`merge` is used when:

* [ResolveJoinStrategyHints](logical-analysis-rules/ResolveJoinStrategyHints.md) logical resolution rule is [executed](logical-analysis-rules/ResolveJoinStrategyHints.md#applyJoinStrategyHint)
* [EliminateResolvedHint](logical-optimizations/EliminateResolvedHint.md) logical optimization is [executed](logical-optimizations/EliminateResolvedHint.md#mergeHints)
