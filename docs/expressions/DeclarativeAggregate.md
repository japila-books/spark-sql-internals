# DeclarativeAggregate &mdash; Unevaluable Aggregate Function Expressions

`DeclarativeAggregate` is an [extension](#contract) of the [AggregateFunction](AggregateFunction.md) abstraction for [aggregate function expressions](#implementations) that are [unevaluable](Unevaluable.md) and use expressions for evaluation.

## Contract

### <span id="evaluateExpression"> evaluateExpression

```scala
evaluateExpression: Expression
```

[Expression](Expression.md) to calculate the final value of this aggregate function

Used when:

* `EliminateAggregateFilter` logical optimization is executed
* `AggregatingAccumulator` utility is used to create an `AggregatingAccumulator`
* `AggregationIterator` is requested for the [generateResultProjection](../AggregationIterator.md#generateResultProjection)
* `HashAggregateExec` physical operator is requested to [doProduceWithoutKeys](../physical-operators/HashAggregateExec.md#doProduceWithoutKeys) and [generateResultFunction](../physical-operators/HashAggregateExec.md#generateResultFunction)
* `AggregateProcessor` is [created](../physical-operators/AggregateProcessor.md#apply)

### <span id="initialValues"> initialValues

```scala
initialValues: Seq[Expression]
```

[Expression](Expression.md) for initial values of this aggregate function

Used when:

* `EliminateAggregateFilter` logical optimization is executed
* `AggregatingAccumulator` utility is used to create an `AggregatingAccumulator`
* `AggregationIterator` is [created](../AggregationIterator.md#expressionAggInitialProjection)
* `HashAggregateExec` physical operator is requested to [doProduceWithoutKeys](../physical-operators/HashAggregateExec.md#doProduceWithoutKeys), [createHashMap](../physical-operators/HashAggregateExec.md#createHashMap) and [getEmptyAggregationBuffer](../physical-operators/HashAggregateExec.md#getEmptyAggregationBuffer)
* `HashMapGenerator` is created
* `AggregateProcessor` is [created](../physical-operators/AggregateProcessor.md#apply)

### <span id="mergeExpressions"> mergeExpressions

```scala
mergeExpressions: Seq[Expression]
```

### <span id="updateExpressions"> updateExpressions

```scala
updateExpressions: Seq[Expression]
```

## Implementations

* [AggregateWindowFunction](AggregateWindowFunction.md)
* `Average`
* `BitAggregate`
* `CentralMomentAgg`
* `Count`
* `Covariance`
* [First](First.md)
* `Last`
* `Max`
* `MaxMinBy`
* `Min`
* `PearsonCorrelation`
* `Product`
* `SimpleTypedAggregateExpression`
* `Sum`
* `UnevaluableAggregate`
