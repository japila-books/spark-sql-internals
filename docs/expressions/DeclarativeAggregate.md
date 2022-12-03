# DeclarativeAggregate Expression-Based Functions

`DeclarativeAggregate` is an [extension](#contract) of the [AggregateFunction](AggregateFunction.md) abstraction for [expression-based aggregate functions](#implementations) that are [unevaluable](Unevaluable.md) and use expressions for evaluation.

## Contract

### <span id="evaluateExpression"> evaluateExpression

```scala
evaluateExpression: Expression
```

[Expression](Expression.md) to calculate the final value of this aggregate function

Used when:

* `EliminateAggregateFilter` logical optimization is executed
* `AggregatingAccumulator` utility is used to create an `AggregatingAccumulator`
* `AggregationIterator` is requested for the [generateResultProjection](../physical-operators/AggregationIterator.md#generateResultProjection)
* `HashAggregateExec` physical operator is requested to [doProduceWithoutKeys](../physical-operators/HashAggregateExec.md#doProduceWithoutKeys) and [generateResultFunction](../physical-operators/HashAggregateExec.md#generateResultFunction)
* `AggregateProcessor` is [created](../window-functions/AggregateProcessor.md#apply)

### <span id="initialValues"> Initialize Aggregation Buffers Expressions

```scala
initialValues: Seq[Expression]
```

Catalyst [Expression](Expression.md) to initialize aggregation buffers (for the initial values of this aggregate function)

Used when:

* `EliminateAggregateFilter` logical optimization is executed
* `AggregatingAccumulator` utility is used to create an `AggregatingAccumulator`
* `AggregateCodegenSupport` is requested to [doProduceWithoutKeys](../physical-operators/AggregateCodegenSupport.md#doProduceWithoutKeys)
* `AggregationIterator` is [created](../physical-operators/AggregationIterator.md#expressionAggInitialProjection)
* `HashAggregateExec` physical operator is requested to [createHashMap](../physical-operators/HashAggregateExec.md#createHashMap), [getEmptyAggregationBuffer](../physical-operators/HashAggregateExec.md#getEmptyAggregationBuffer)
* `HashMapGenerator` is [created](../HashMapGenerator.md#buffVars)
* `AggregateProcessor` is [created](../window-functions/AggregateProcessor.md#apply)

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
* [First](First.md)
* `SimpleTypedAggregateExpression`
* _others_
