# AQEPropagateEmptyRelation Adaptive Logical Optimization

`AQEPropagateEmptyRelation` is a logical optimization in [Adaptive Query Execution](../adaptive-query-execution/index.md).

`AQEPropagateEmptyRelation` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

## Creating Instance

`AQEPropagateEmptyRelation` takes no arguments to be created.

`AQEPropagateEmptyRelation` is created when:

* `AQEOptimizer` is requested for the [default batches](../adaptive-query-execution/AQEOptimizer.md#defaultBatches) (of adaptive optimizations)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
