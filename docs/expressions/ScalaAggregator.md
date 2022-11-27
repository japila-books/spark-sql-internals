# ScalaAggregator

`ScalaAggregator[IN, BUF, OUT]` is a [TypedImperativeAggregate](TypedImperativeAggregate.md) (of `BUF` values).

`ScalaAggregator` is a [UserDefinedExpression](UserDefinedExpression.md).

## Creating Instance

`ScalaAggregator` takes the following to be created:

* <span id="children"> Children [Expression](Expression.md)s
* [Aggregator](#agg)
* <span id="inputEncoder"> Input [ExpressionEncoder](../ExpressionEncoder.md) (of `IN`s)
* <span id="bufferEncoder"> Buffer [ExpressionEncoder](../ExpressionEncoder.md) (of `BUF`s)
* <span id="nullable"> `nullable` flag (default: `false`)
* <span id="isDeterministic"> `isDeterministic` flag (default: `true`)
* <span id="mutableAggBufferOffset"> `mutableAggBufferOffset` (default: `0`)
* <span id="inputAggBufferOffset"> `inputAggBufferOffset` (default: `0`)
* <span id="aggregatorName"> Aggregator Name (default: undefined)

`ScalaAggregator` is created when:

* `UserDefinedAggregator` is requested to [scalaAggregator](UserDefinedAggregator.md#scalaAggregator)

### <span id="agg"> Aggregator

`ScalaAggregator` is given an [Aggregator](Aggregator.md) when [created](#creating-instance).

ScalaAggregator | Aggregator
----------------|-----------
 [outputEncoder](#outputEncoder) | [outputEncoder](Aggregator.md#outputEncoder)
 [createAggregationBuffer](#createAggregationBuffer) | [zero](Aggregator.md#zero)
 [update](#update) | [reduce](Aggregator.md#reduce)
 [merge](#merge) | [merge](Aggregator.md#merge)
 [Interpreted Execution](#eval) | [finish](Aggregator.md#finish)
 [name](#name) | Simple class name

## <span id="eval"> Interpreted Execution

```scala
eval(
  buffer: BUF): Any
```

`eval` is part of the [TypedImperativeAggregate](TypedImperativeAggregate.md#eval) abstraction.

---

`eval` requests the [agg](#agg) to [finish](Aggregator.md#finish) with the given (reduction) `buffer`.

`eval` requests the [outputSerializer](#outputSerializer) to convert the result (of type `OUT` to an [InternalRow](../InternalRow.md)).

In the end, `eval` returns the row if [isSerializedAsStruct](../ExpressionEncoder.md#isSerializedAsStruct) or the 0th element (that is expected to be of [dataType](#dataType)).

## Logical Analysis

The [input](#inputEncoder) and [buffer](#bufferEncoder) encoders are [resolved and bound](../ExpressionEncoder.md#resolveAndBind) using `ResolveEncodersInScalaAgg` logical resolution rule.
