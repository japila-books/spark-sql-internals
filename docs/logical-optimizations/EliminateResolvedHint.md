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

1. [Extracts hints](#extractHintsFromPlan) from the [left](../logical-operators/Join.md#left) and [right](../logical-operators/Join.md#right) sides of the join (that gives new operators and [JoinHint](../hints/JoinHint.md)s for either side)

1. Creates a new [JoinHint](../hints/JoinHint.md) with the [hints merged](#mergeHints) for the left and right sides

1. Creates a new [Join](../logical-operators/Join.md) logical operator with the new left and right operators and the new `JoinHint`

In the end, `apply` finds [ResolvedHint](../logical-operators/ResolvedHint.md)s and, if found, requests the [HintErrorHandler](#hintErrorHandler) to [joinNotFoundForJoinHint](../hints/HintErrorHandler.md#joinNotFoundForJoinHint) and ignores the hint (returns the child of the `ResolvedHint`).

## <span id="hintErrorHandler"> HintErrorHandler

```scala
hintErrorHandler: HintErrorHandler
```

`hintErrorHandler` is the default [HintErrorHandler](../hints/HintErrorHandler.md).

## <span id="extractHintsFromPlan"> Extracting Hints from Logical Plan

```scala
extractHintsFromPlan(
  plan: LogicalPlan): (LogicalPlan, Seq[HintInfo])
```

`extractHintsFromPlan` collects (_extracts_) [HintInfo](../logical-operators/ResolvedHint.md#hints)s from the [ResolvedHint](../logical-operators/ResolvedHint.md) unary logical operators in the given [LogicalPlan](../logical-operators/LogicalPlan.md) and gives:

* [HintInfo](../hints/HintInfo.md)s
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

### Logical Query Plan

Create a logical plan using [Catalyst DSL](../catalyst-dsl/index.md).

```scala
import org.apache.spark.sql.catalyst.dsl.plans._
import org.apache.spark.sql.catalyst.plans.logical.{SHUFFLE_HASH, SHUFFLE_MERGE}
import org.apache.spark.sql.catalyst.plans.logical.LocalRelation
```

```scala
val t1 = LocalRelation('id.long, 'name.string).hint(SHUFFLE_HASH.displayName)
val t2 = LocalRelation('id.long, 'age.int).hint(SHUFFLE_MERGE.displayName)
val logical = t1.join(t2)
```

```text
scala> println(logical.numberedTreeString)
00 'Join Inner
01 :- 'UnresolvedHint shuffle_hash
02 :  +- LocalRelation <empty>, [id#0L, name#1]
03 +- 'UnresolvedHint merge
04    +- LocalRelation <empty>, [id#2L, age#3]
```

### Analyze Plan

```scala
val analyzed = logical.analyze
```

```text
scala> println(analyzed.numberedTreeString)
00 Join Inner
01 :- ResolvedHint (strategy=shuffle_hash)
02 :  +- LocalRelation <empty>, [id#0L, name#1]
03 +- ResolvedHint (strategy=merge)
04    +- LocalRelation <empty>, [id#2L, age#3]
```

### Optimize Plan

Optimize the plan (using `EliminateResolvedHint` only).

```text
import org.apache.spark.sql.catalyst.optimizer.EliminateResolvedHint
val optimizedPlan = EliminateResolvedHint(analyzed)
```

```text
scala> println(optimizedPlan.numberedTreeString)
00 Join Inner, leftHint=(strategy=shuffle_hash), rightHint=(strategy=merge)
01 :- LocalRelation <empty>, [id#0L, name#1]
02 +- LocalRelation <empty>, [id#2L, age#3]
```
