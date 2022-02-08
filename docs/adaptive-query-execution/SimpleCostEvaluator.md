# SimpleCostEvaluator

`SimpleCostEvaluator` is a [CostEvaluator](CostEvaluator.md) in [Adaptive Query Execution](index.md).

## <span id="evaluateCost"> Evaluating Cost

```scala
evaluateCost(
  plan: SparkPlan): Cost
```

`evaluateCost` counts the [shuffle exchanges](../physical-operators/ShuffleExchangeLike.md) unary physical operators in the given [SparkPlan](../physical-operators/SparkPlan.md).

`evaluateCost` is part of the [CostEvaluator](CostEvaluator.md#evaluateCost) abstraction.
