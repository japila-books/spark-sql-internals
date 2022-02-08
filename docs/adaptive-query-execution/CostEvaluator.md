# CostEvaluator

`CostEvaluator` is an [abstraction](#contract) of [cost evaluators](#implementations) in [Adaptive Query Execution](index.md).

## Contract

### <span id="evaluateCost"> Evaluating Cost

```scala
evaluateCost(
  plan: SparkPlan): Cost
```

Evaluates the cost of the given [SparkPlan](../physical-operators/SparkPlan.md)

Used when:

* `AdaptiveSparkPlanExec` physical operator is requested for the [final physical query plan](../physical-operators/AdaptiveSparkPlanExec.md#getFinalPhysicalPlan)

## Implementations

* [SimpleCostEvaluator](SimpleCostEvaluator.md)
