# ResolveJoinStrategyHints Logical Resolution Rule

`ResolveJoinStrategyHints` is a logical resolution rule to [resolve UnresolvedHints logical operators](#apply) with [JoinStrategyHint](../JoinStrategyHint.md)s.

`ResolveJoinStrategyHints` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

`ResolveJoinStrategyHints` is part of [Hints](../Analyzer.md#Hints) batch of rules of [Logical Analyzer](../Analyzer.md).

## Creating Instance

`ResolveJoinStrategyHints` takes the following to be created:

* <span id="conf"> [SQLConf](../SQLConf.md)

`ResolveJoinStrategyHints` is created when [Logical Analyzer](../Analyzer.md) is requested for the [batches of rules](../Analyzer.md#batches).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` traverses the given [logical query plan](../logical-operators/LogicalPlan.md) to find [UnresolvedHint](../logical-operators/UnresolvedHint.md) operators with names that are the [hintAliases](../JoinStrategyHint.md#hintAliases) of the supported [JoinStrategyHint](../JoinStrategyHint.md)s.

For `UnresolvedHint`s with no parameters, `apply` creates a [ResolvedHint](../logical-operators/ResolvedHint.md) (with [HintInfo](../logical-operators/HintInfo.md) with just the name).

For `UnresolvedHint`s with parameters, `apply` accepts two types of parameters:

* Table Name (as a `String`)
* Table Identifier (as a [UnresolvedAttribute](../expressions/UnresolvedAttribute.md))

`apply` [applyJoinStrategyHint](#applyJoinStrategyHint) to create a [ResolvedHint](../logical-operators/ResolvedHint.md).

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

## <span id="applyJoinStrategyHint"> applyJoinStrategyHint Internal Method

```scala
applyJoinStrategyHint(
  plan: LogicalPlan,
  relationsInHint: Set[Seq[String]],
  relationsInHintWithMatch: mutable.HashSet[Seq[String]],
  hintName: String): LogicalPlan
```

`applyJoinStrategyHint`...FIXME

`applyJoinStrategyHint` is used when `ResolveJoinStrategyHints` logical rule is [executed](#apply).

## Example

```text
// FIXME Review the example to use ResolveJoinStrategyHints and other hints

// Use Catalyst DSL to create a logical plan
import org.apache.spark.sql.catalyst.dsl.plans._
val plan = table("t1").join(table("t2")).hint(name = "broadcast", "t1", "table2")
scala> println(plan.numberedTreeString)
00 'UnresolvedHint broadcast, [t1, table2]
01 +- 'Join Inner
02    :- 'UnresolvedRelation `t1`
03    +- 'UnresolvedRelation `t2`

import org.apache.spark.sql.catalyst.analysis.ResolveHints.ResolveJoinStrategyHints
val resolver = new ResolveJoinStrategyHints(spark.sessionState.conf)
val analyzedPlan = resolver(plan)
scala> println(analyzedPlan.numberedTreeString)
00 'Join Inner
01 :- 'ResolvedHint (broadcast)
02 :  +- 'UnresolvedRelation `t1`
03 +- 'UnresolvedRelation `t2`
```
