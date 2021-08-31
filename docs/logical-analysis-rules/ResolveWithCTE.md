# ResolveWithCTE Logical Resolution Rule

`ResolveWithCTE` is a logical resolution rule that the [Logical Analyzer](../Analyzer.md) uses to [resolveWithCTE](#resolveWithCTE) for [CTE](../catalyst/TreePattern.md#CTE) query plans.

`ResolveWithCTE` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

`ResolveWithCTE` is part of [Resolution](../Analyzer.md#Resolution) fixed-point batch of rules.

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` does nothing and simply returns the given [LogicalPlan](../logical-operators/LogicalPlan.md) when applied to a non-[CTE](../catalyst/TreePattern.md#CTE) query plan. Otherwise, `apply` [resolveWithCTE](#resolveWithCTE).

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

## <span id="resolveWithCTE"> resolveWithCTE

```scala
resolveWithCTE(
  plan: LogicalPlan,
  cteDefMap: mutable.HashMap[Long, CTERelationDef]): LogicalPlan
```

`resolveWithCTE` requests the given [logical operator](../logical-operators/LogicalPlan.md) to `resolveOperatorsDownWithPruning` for [CTE](../catalyst/TreePattern.md#CTE) logical operators:

1. [WithCTE](../logical-operators/WithCTE.md)
1. [CTERelationRef](../logical-operators/CTERelationRef.md)
1. Others with `CTE` and [PLAN_EXPRESSION](../catalyst/TreePattern.md#PLAN_EXPRESSION) tree patterns

`resolveWithCTE` is a recursive function.
