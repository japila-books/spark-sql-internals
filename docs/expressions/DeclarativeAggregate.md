# DeclarativeAggregate Expression-Based Functions

`DeclarativeAggregate` is an [extension](#contract) of the [AggregateFunction](AggregateFunction.md) abstraction for [Catalyst Expression-based aggregate functions](#implementations) that use [Catalyst Expression](Expression.md) for evaluation.

`DeclarativeAggregate` is an [Unevaluable](Unevaluable.md).

## Contract

### <span id="evaluateExpression"> evaluateExpression

```scala
evaluateExpression: Expression
```

Catalyst [Expression](Expression.md) to calculate the final value of this aggregate function

Used when:

* `EliminateAggregateFilter` logical optimization is executed
* `AggregatingAccumulator` is [created](../AggregatingAccumulator.md#apply)
* `AggregationIterator` is requested for the [generateResultProjection](../aggregations/AggregationIterator.md#generateResultProjection)
* `HashAggregateExec` physical operator is requested to [doProduceWithoutKeys](../physical-operators/HashAggregateExec.md#doProduceWithoutKeys) and [generateResultFunction](../physical-operators/HashAggregateExec.md#generateResultFunction)
* `AggregateProcessor` is [created](../window-functions/AggregateProcessor.md#apply)

### <span id="initialValues"> Expressions to Initialize Empty Aggregation Buffers

```scala
initialValues: Seq[Expression]
```

Catalyst [Expression](Expression.md)s to initialize empty aggregation buffers (for the initial values of this aggregate function)

Used when:

* `EliminateAggregateFilter` logical optimization is executed
* `AggregatingAccumulator` is [created](../AggregatingAccumulator.md#apply)
* `AggregateCodegenSupport` is requested to [doProduceWithoutKeys](../physical-operators/AggregateCodegenSupport.md#doProduceWithoutKeys)
* `AggregationIterator` is [created](../aggregations/AggregationIterator.md#expressionAggInitialProjection)
* `HashAggregateExec` physical operator is requested to [createHashMap](../physical-operators/HashAggregateExec.md#createHashMap), [getEmptyAggregationBuffer](../physical-operators/HashAggregateExec.md#getEmptyAggregationBuffer)
* `HashMapGenerator` is [created](../HashMapGenerator.md#buffVars)
* `AggregateProcessor` is [created](../window-functions/AggregateProcessor.md#apply)

### <span id="mergeExpressions"> mergeExpressions

```scala
mergeExpressions: Seq[Expression]
```

Catalyst [Expression](Expression.md)s to...FIXME

### <span id="updateExpressions"> updateExpressions

```scala
updateExpressions: Seq[Expression]
```

Catalyst [Expression](Expression.md)s to update the mutable aggregation buffer based on an input row

Used when:

* `AggregateProcessor` is [created](../window-functions/AggregateProcessor.md#apply)
* `AggregateCodegenSupport` is requested to [doConsumeWithoutKeys](../physical-operators/AggregateCodegenSupport.md#doConsumeWithoutKeys)
* `AggregationIterator` is requested to [generateProcessRow](../aggregations/AggregationIterator.md#generateProcessRow)
* `AggregatingAccumulator` is [created](../AggregatingAccumulator.md#apply)
* `HashAggregateExec` is requested to [doConsumeWithKeys](../physical-operators/HashAggregateExec.md#doConsumeWithKeys)

## Implementations

* [AggregateWindowFunction](AggregateWindowFunction.md)
* [First](First.md)
* _others_
