# WindowFunctionFrame

`WindowFunctionFrame` is an [abstraction](#contract) of [window frames](#implementations).

## Contract

### <span id="currentLowerBound"> currentLowerBound

```scala
currentLowerBound(): Int
```

Used when:

* `WindowInPandasExec` ([PySpark]({{ book.pyspark }}/sql/WindowInPandasExec)) physical operator is requested to `doExecute`

### <span id="currentUpperBound"> currentUpperBound

```scala
currentUpperBound(): Int
```

Used when:

* `WindowInPandasExec` ([PySpark]({{ book.pyspark }}/sql/WindowInPandasExec)) physical operator is requested to `doExecute`

### <span id="prepare"> prepare

```scala
prepare(
  rows: ExternalAppendOnlyUnsafeRowArray): Unit
```

Prepares the frame (with the given [ExternalAppendOnlyUnsafeRowArray](../ExternalAppendOnlyUnsafeRowArray.md))

Used when:

* `WindowExec` physical operator is requested to [doExecute](../physical-operators/WindowExec.md#doExecute)
* `WindowInPandasExec` ([PySpark]({{ book.pyspark }}/sql/WindowInPandasExec)) physical operator is requested to `doExecute`

### <span id="write"> write

```scala
write(
  index: Int,
  current: InternalRow): Unit
```

Used when:

* `WindowExec` physical operator is requested to [doExecute](../physical-operators/WindowExec.md#doExecute)
* `WindowInPandasExec` ([PySpark]({{ book.pyspark }}/sql/WindowInPandasExec)) physical operator is requested to `doExecute`

## Implementations

* `OffsetWindowFunctionFrameBase`
* `SlidingWindowFunctionFrame`
* `UnboundedFollowingWindowFunctionFrame`
* `UnboundedPrecedingWindowFunctionFrame`

### <span id="UnboundedWindowFunctionFrame"> UnboundedWindowFunctionFrame

`UnboundedWindowFunctionFrame` is a [WindowFunctionFrame](#WindowFunctionFrame) that gives the same value for every row in a partition.

`UnboundedWindowFunctionFrame` is [created](#UnboundedWindowFunctionFrame-creating-instance) for [AggregateFunction](../expressions/AggregateFunction.md)s (in [AggregateExpression](../expressions/AggregateExpression.md)s) or [AggregateWindowFunction](../expressions/AggregateWindowFunction.md)s with no frame defined (i.e. no `rowsBetween` or `rangeBetween`) that boils down to using the WindowExec.md#entire-partition-frame[entire partition frame].
