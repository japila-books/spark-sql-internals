# ScalaAggregator

`ScalaAggregator[IN, BUF, OUT]` is a [TypedImperativeAggregate](TypedImperativeAggregate.md) (of `BUF` values).

## Creating Instance

`ScalaAggregator` takes the following to be created:

* <span id="children"> Children [Expression](Expression.md)s
* <span id="agg"> [Aggregator](Aggregator.md)
* <span id="inputEncoder"> Input [ExpressionEncoder](../ExpressionEncoder.md) (of `IN`s)
* <span id="bufferEncoder"> Buffer [ExpressionEncoder](../ExpressionEncoder.md) (of `BUF`s)
* <span id="nullable"> `nullable` flag (default: `false`)
* <span id="isDeterministic"> `isDeterministic` flag (default: `true`)
* <span id="mutableAggBufferOffset"> `mutableAggBufferOffset` (default: `0`)
* <span id="inputAggBufferOffset"> `inputAggBufferOffset` (default: `0`)
* <span id="aggregatorName"> Aggregator Name (default: undefined)

`ScalaAggregator` is created when:

* `UserDefinedAggregator` is requested to [scalaAggregator](UserDefinedAggregator.md#scalaAggregator)

## UserDefinedExpression

`ScalaAggregator` is a [UserDefinedExpression](UserDefinedExpression.md).

## Logical Analysis

The [input](#inputEncoder) and [buffer](#bufferEncoder) encoders are [resolved and bound](../ExpressionEncoder.md#resolveAndBind) using `ResolveEncodersInScalaAgg` logical resolution rule.
