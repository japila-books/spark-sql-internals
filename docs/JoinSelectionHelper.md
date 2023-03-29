# JoinSelectionHelper

## canBroadcastBySize { #canBroadcastBySize }

```scala
canBroadcastBySize(
  plan: LogicalPlan,
  conf: SQLConf): Boolean
```

`canBroadcastBySize`...FIXME

---

`canBroadcastBySize` is used when:

* [InjectRuntimeFilter](logical-optimizations/InjectRuntimeFilter.md) logical optimization is executed (and [injectInSubqueryFilter](logical-optimizations/InjectRuntimeFilter.md#injectInSubqueryFilter) and [isProbablyShuffleJoin](logical-optimizations/InjectRuntimeFilter.md#isProbablyShuffleJoin))
* `JoinSelectionHelper` is requested to [getBroadcastBuildSide](#getBroadcastBuildSide)
* [JoinSelection](execution-planning-strategies/JoinSelection.md) execution planning strategy is executed

## getBroadcastBuildSide { #getBroadcastBuildSide }

```scala
getBroadcastBuildSide(
  left: LogicalPlan,
  right: LogicalPlan,
  joinType: JoinType,
  hint: JoinHint,
  hintOnly: Boolean,
  conf: SQLConf): Option[BuildSide]
```

`getBroadcastBuildSide`...FIXME

---

`getBroadcastBuildSide` is used when:

* `JoinSelectionHelper` is requested to [canPlanAsBroadcastHashJoin](#canPlanAsBroadcastHashJoin)
* [JoinSelection](execution-planning-strategies/JoinSelection.md) execution planning strategy is executed

## canPlanAsBroadcastHashJoin { #canPlanAsBroadcastHashJoin }

```scala
canPlanAsBroadcastHashJoin(
  join: Join,
  conf: SQLConf): Boolean
```

`canPlanAsBroadcastHashJoin`...FIXME

---

`canPlanAsBroadcastHashJoin` is used when:

* [PushDownLeftSemiAntiJoin](logical-optimizations/PushDownLeftSemiAntiJoin.md) logical optimization is executed

## hintToSortMergeJoin { #hintToSortMergeJoin }

```scala
hintToSortMergeJoin(
  hint: JoinHint): Boolean
```

`hintToSortMergeJoin` is enabled (`true`) when either the [left](hints/JoinHint.md#leftHint) or the [right](hints/JoinHint.md#rightHint) side of the join contains [SHUFFLE_MERGE](hints/JoinStrategyHint.md#SHUFFLE_MERGE) hint.

---

`hintToSortMergeJoin` is used when:

* [PushDownLeftSemiAntiJoin](logical-optimizations/PushDownLeftSemiAntiJoin.md) logical optimization is executed
