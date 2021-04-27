# CostEvaluator

`CostEvaluator` is an [abstraction](#contract) of [cost evaluators](#implementations) in [Adaptive Query Execution](index.md).

## Contract

### <span id="evaluateCost"> Evaluating Cost

```scala
evaluateCost(
  plan: SparkPlan): Cost
```

Evaluates the cost of [SparkPlan](../physical-operators/SparkPlan.md)

Used when:

* FIXME

## Implementations

* [SimpleCostEvaluator](SimpleCostEvaluator.md)
