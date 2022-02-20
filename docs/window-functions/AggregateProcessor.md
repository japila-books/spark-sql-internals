# AggregateProcessor

`AggregateProcessor` is used by [WindowExecBase](../physical-operators/WindowExecBase.md) unary physical operators when requested for [windowFrameExpressionFactoryPairs](../physical-operators/WindowExecBase.md#windowFrameExpressionFactoryPairs) to create the following [WindowFunctionFrame](WindowFunctionFrame.md)s (for [supported AGGREGATE functions](#supported-aggregate-functions)):

* `SlidingWindowFunctionFrame`
* `UnboundedFollowingWindowFunctionFrame`
* `UnboundedPrecedingWindowFunctionFrame`
* `UnboundedWindowFunctionFrame`

## Supported AGGREGATE Functions

`AggregateProcessor` is used for the following `AGGREGATE` functions:

* [AggregateExpression](../expressions/AggregateExpression.md)
* [AggregateWindowFunction](../expressions/AggregateWindowFunction.md)
* [OffsetWindowFunction](../expressions/OffsetWindowFunction.md) with `RowFrame` with (`UnboundedPreceding`, non-`CurrentRow`) frame

## Creating Instance

`AggregateProcessor` takes the following to be created:

* <span id="bufferSchema"> Buffer Schema (`Array[AttributeReference]`)
* <span id="initialProjection"> Initial `MutableProjection`
* <span id="updateProjection"> Update `MutableProjection`
* <span id="evaluateProjection"> Evaluate `MutableProjection`
* <span id="imperatives"> [ImperativeAggregate](../expressions/ImperativeAggregate.md)
* <span id="trackPartitionSize"> `trackPartitionSize` flag

`AggregateProcessor` is created using [apply](#apply) factory.

## <span id="apply"> Creating AggregateProcessor Instance

```scala
apply(
  functions: Array[Expression],
  ordinal: Int,
  inputAttributes: Seq[Attribute],
  newMutableProjection: (Seq[Expression], Seq[Attribute]) => MutableProjection
): AggregateProcessor
```

`apply` creates an [AggregateProcessor](#creating-instance).

`apply` is used when:

* `WindowExecBase` unary physical operator is requested for [windowFrameExpressionFactoryPairs](../physical-operators/WindowExecBase.md#windowFrameExpressionFactoryPairs)

## <span id="evaluate"> evaluate

```scala
evaluate(
  target: InternalRow): Unit
```

`evaluate`...FIXME

`evaluate` is used when:

* `SlidingWindowFunctionFrame` is requested to `write`
* `UnboundedFollowingWindowFunctionFrame` is requested to `write`
* `UnboundedPrecedingWindowFunctionFrame` is requested to `write`
* `UnboundedWindowFunctionFrame` is requested to `prepare`

## <span id="initialize"> initialize

```scala
initialize(
  size: Int): Unit
```

`initialize`...FIXME

`initialize` is used when:

* `SlidingWindowFunctionFrame` is requested to `write`
* `UnboundedFollowingWindowFunctionFrame` is requested to `write`
* `UnboundedPrecedingWindowFunctionFrame` is requested to `prepare`
* `UnboundedWindowFunctionFrame` is requested to `prepare`

## <span id="update"> update

```scala
update(
  input: InternalRow): Unit
```

`update`...FIXME

`update` is used when:

* `SlidingWindowFunctionFrame` is requested to `write`
* `UnboundedFollowingWindowFunctionFrame` is requested to `write`
* `UnboundedPrecedingWindowFunctionFrame` is requested to `write`
* `UnboundedWindowFunctionFrame` is requested to `prepare`
