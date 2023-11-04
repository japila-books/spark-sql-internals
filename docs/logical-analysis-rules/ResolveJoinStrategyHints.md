---
title: ResolveJoinStrategyHints
---

# ResolveJoinStrategyHints Logical Resolution Rule

`ResolveJoinStrategyHints` is a logical resolution rule to [resolve UnresolvedHint logical operators](#apply) with [JoinStrategyHint](../hints/JoinStrategyHint.md)s.

`ResolveJoinStrategyHints` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

`ResolveJoinStrategyHints` is part of [Hints](../Analyzer.md#Hints) batch of rules of [Logical Analyzer](../Analyzer.md).

## Creating Instance

`ResolveJoinStrategyHints` takes the following to be created:

* <span id="conf"> [SQLConf](../SQLConf.md)

`ResolveJoinStrategyHints` is created when:

* [Logical Analyzer](../Analyzer.md) is requested for the [batches of rules](../Analyzer.md#batches)

## <span id="STRATEGY_HINT_NAMES"> Hint Names

`ResolveJoinStrategyHints` takes the [hintAliases](../hints/JoinStrategyHint.md#hintAliases) of the [strategies](../hints/JoinStrategyHint.md#strategies) when [created](#creating-instance).

The hint aliases are the only hints (of [UnresolvedHint](../logical-operators/UnresolvedHint.md)s) that are going to be resolved when `ResolveJoinStrategyHints` is [executed](#apply).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` works with [LogicalPlan](../logical-operators/LogicalPlan.md)s that [contain](#containsPattern) the [UNRESOLVED_HINT](../catalyst/TreePattern.md#UNRESOLVED_HINT) tree pattern (that happens to be [UnresolvedHint](../logical-operators/UnresolvedHint.md)s only).

---

`apply` traverses the given [logical query plan](../logical-operators/LogicalPlan.md) to find [UnresolvedHint](../logical-operators/UnresolvedHint.md)s with names that are among the supported [hint names](#STRATEGY_HINT_NAMES).

For `UnresolvedHint`s with no parameters, `apply` creates a [ResolvedHint](../logical-operators/ResolvedHint.md) (with a [HintInfo](../hints/HintInfo.md) with the corresponding [JoinStrategyHint](../hints/JoinStrategyHint.md)).

For `UnresolvedHint`s with parameters, `apply` accepts two types of parameters:

* Table Name (as a `String`)
* Table Identifier (as a [UnresolvedAttribute](../expressions/UnresolvedAttribute.md))

`apply` [applyJoinStrategyHint](#applyJoinStrategyHint) to create a [ResolvedHint](../logical-operators/ResolvedHint.md).

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

## <span id="applyJoinStrategyHint"> applyJoinStrategyHint

```scala
applyJoinStrategyHint(
  plan: LogicalPlan,
  relationsInHint: Set[Seq[String]],
  relationsInHintWithMatch: mutable.HashSet[Seq[String]],
  hintName: String): LogicalPlan
```

`applyJoinStrategyHint`...FIXME

## Demo

!!! FIXME
    Review the example to use `ResolveJoinStrategyHints` and other hints

```scala
// Use Catalyst DSL to create a logical plan
import org.apache.spark.sql.catalyst.dsl.plans._
val plan = table("t1").join(table("t2")).hint(name = "broadcast", "t1", "table2")
```

```text
scala> println(plan.numberedTreeString)
00 'UnresolvedHint broadcast, [t1, table2]
01 +- 'Join Inner
02    :- 'UnresolvedRelation [t1], [], false
03    +- 'UnresolvedRelation [t2], [], false
```

```scala
import org.apache.spark.sql.catalyst.analysis.ResolveHints.ResolveJoinStrategyHints
val analyzedPlan = ResolveJoinStrategyHints(plan)
```

```text
scala> println(analyzedPlan.numberedTreeString)
00 'Join Inner
01 :- 'ResolvedHint (strategy=broadcast)
02 :  +- 'UnresolvedRelation [t1], [], false
03 +- 'UnresolvedRelation [t2], [], false
```
