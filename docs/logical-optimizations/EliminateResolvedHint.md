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

`extractHintsFromPlan` collects (_extracts_) [HintInfo](../logical-operators/ResolvedHint.md#hints)s from the [ResolvedHint](../logical-operators/ResolvedHint.md) unary logical operators in the given [LogicalPlan](../logical-operators/LogicalPlan.md) and gives:

* [HintInfo](../HintInfo.md)s
* Transformed plan with [ResolvedHint](../logical-operators/ResolvedHint.md) nodes removed

While collecting, `extractHintsFromPlan` removes the [ResolvedHint](../logical-operators/ResolvedHint.md) unary logical operators.

!!! note
    It is possible (yet still unclear) that some `ResolvedHint`s won't get extracted.

`extractHintsFromPlan` is used when:

* `EliminateResolvedHint` is requested to [execute](#apply)
* `CacheManager` is requested to [useCachedData](../CacheManager.md#useCachedData)

## <span id="mergeHints"> Merging Hints

```scala
mergeHints(
  hints: Seq[HintInfo]): Option[HintInfo]
```

`mergeHints`...FIXME

## Demo

Create a logical query plan using [Catalyst DSL](../catalyst-dsl/index.md).

!!! fixme
    Needs more work

```text
import org.apache.spark.sql.catalyst.dsl.plans._

val t1 = table("t1").hint(...)
val t2 = table("t2")

import org.apache.spark.sql.catalyst.plans.logical.{HintInfo, SHUFFLE_HASH}
val hintShuffleHash = Some(HintInfo(Some(SHUFFLE_HASH)))

import org.apache.spark.sql.catalyst.plans.logical.JoinHint
JoinHint(hintShuffleHash, hintShuffleHash)

val plan = t1.join(t2)
```

```text
import org.apache.spark.sql.catalyst.optimizer.EliminateResolvedHint

```
