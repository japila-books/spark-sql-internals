# UpdateCTERelationStats Logical Optimization

`UpdateCTERelationStats` is a [logical optimization](../catalyst/Optimizer.md#batches) that [updateCTEStats](#updateCTEStats) for `CTE` operators.

`UpdateCTERelationStats` is part of the [Update CTE Relation Stats](../catalyst/Optimizer.md#Update-CTE-Relation-Stats) once-executed batch in the standard batches of the [Logical Optimizer](../catalyst/Optimizer.md).

`UpdateCTERelationStats` is simply a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` does nothing and simply returns the given [LogicalPlan](../logical-operators/LogicalPlan.md) when applied to a [Subquery](../logical-operators/Subquery.md) or non-`CTE` query tree. Otherwise, `apply` [updateCTEStats](#updateCTEStats).

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

## <span id="updateCTEStats"> updateCTEStats

```scala
updateCTEStats(
  plan: LogicalPlan,
  statsMap: mutable.HashMap[Long, Statistics]): LogicalPlan
```

`updateCTEStats` branches off based on the type of the [logical operator](../logical-operators/LogicalPlan.md):

1. `WithCTE`
1. `CTERelationRef`
1. Others with `CTE` tree pattern

For all other types, `updateCTEStats` returns the given `LogicalPlan`.

`updateCTEStats` is a recursive function.
