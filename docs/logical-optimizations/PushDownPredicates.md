# PushDownPredicates Logical Optimization

`PushDownPredicates` is a logical optimization (of the [Logical Optimizer](../catalyst/Optimizer.md#defaultBatches) and the [SparkOptimizer](../SparkOptimizer.md#defaultBatches)).

`PushDownPredicates` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

## Creating Instance

`PushDownPredicates` takes no arguments to be created (and is a Scala `object`).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` requests the given [LogicalPlan](../logical-operators/LogicalPlan.md) to [transformWithPruning](../catalyst/TreeNode.md#transformWithPruning) operators with [FILTER](../catalyst/TreePattern.md#FILTER) or [JOIN](../catalyst/TreePattern.md#JOIN) tree patterns.

`apply`...FIXME (migrate [PushDownPredicate](PushDownPredicate.md) logical optimization)

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
