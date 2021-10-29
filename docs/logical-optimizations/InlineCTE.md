# InlineCTE Logical Optimization

`InlineCTE` is a [base logical optimization](../catalyst/Optimizer.md#batches) that...FIXME

`InlineCTE` is part of the [Finish Analysis](../catalyst/Optimizer.md#Finish-Analysis) once-executed batch in the standard batches of the [Logical Optimizer](../catalyst/Optimizer.md).

`InlineCTE` is a [Catalyst Rule](../catalyst/Rule.md) for transforming [LogicalPlan](../logical-operators/LogicalPlan.md)s (`Rule[LogicalPlan]`).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` does nothing and simply returns the given [LogicalPlan](../logical-operators/LogicalPlan.md) when applied to a `Subquery` or a non-[CTE](../catalyst/TreePattern.md#CTE) query plan. Otherwise, `apply` [buildCTEMap](#buildCTEMap) followed by [inlineCTE](#inlineCTE) (with `forceInline` off).

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

## <span id="buildCTEMap"> buildCTEMap

```scala
buildCTEMap(
  plan: LogicalPlan,
  cteMap: mutable.HashMap[Long, (CTERelationDef, Int)]): Unit
```

For a [WithCTE](../logical-operators/WithCTE.md) logical operator `buildCTEMap`...FIXME

For a [CTERelationRef](../logical-operators/CTERelationRef.md) logical operator `buildCTEMap`...FIXME

## <span id="inlineCTE"> inlineCTE

```scala
inlineCTE(
  plan: LogicalPlan,
  cteMap: mutable.HashMap[Long, (CTERelationDef, Int)],
  forceInline: Boolean): LogicalPlan
```

`inlineCTE`...FIXME
