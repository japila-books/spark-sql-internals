# WindowExecBase Unary Physical Operators

`WindowExecBase` is an [extension](#contract) of the [UnaryExecNode](UnaryExecNode.md) abstraction for [window unary physical operators](#implementations).

## Contract

### <span id="orderSpec"> orderSpec

```scala
orderSpec: Seq[SortOrder]
```

Order Specification ([SortOrder](../expressions/SortOrder.md) expressions)

Used when:

* `WindowExecBase` is requested to [createBoundOrdering](#createBoundOrdering)

### <span id="partitionSpec"> partitionSpec

```scala
partitionSpec: Seq[Expression]
```

Partition Specification ([Expression](../expressions/Expression.md)s)

### <span id="windowExpression"> windowExpression

```scala
windowExpression: Seq[NamedExpression]
```

Window [Expression](../expressions/Expression.md)s (that are supposed to be [WindowExpression](../expressions/WindowExpression.md)s to build [windowFrameExpressionFactoryPairs](#windowFrameExpressionFactoryPairs))

Used when:

* `WindowExecBase` is requested to [createResultProjection](#createResultProjection) and [windowFrameExpressionFactoryPairs](#windowFrameExpressionFactoryPairs)

## Implementations

* [WindowExec](WindowExec.md)
* `WindowInPandasExec` ([PySpark]({{ book.pyspark }}/sql/WindowInPandasExec))

## <span id="windowFrameExpressionFactoryPairs"> windowFrameExpressionFactoryPairs

```scala
windowFrameExpressionFactoryPairs: Seq[(ExpressionBuffer, InternalRow => WindowFunctionFrame)]
```

`windowFrameExpressionFactoryPairs` finds [WindowExpression](../expressions/WindowExpression.md)s in the given [windowExpression](#windowExpression)s.

`windowFrameExpressionFactoryPairs` assumes that the [WindowFrame](#frameSpecification) (of the [WindowSpecDefinition](../expressions/WindowExpression.md#windowSpec) of the [WindowExpression](../expressions/WindowExpression.md)) is a `SpecifiedWindowFrame`.

`windowFrameExpressionFactoryPairs` branches off based on the [window function](../expressions/WindowExpression.md#windowFunction) (of the [WindowExpression](../expressions/WindowExpression.md)):

1. [AggregateExpression](../expressions/AggregateExpression.md)
1. `FrameLessOffsetWindowFunction`
1. [OffsetWindowFunction](../expressions/OffsetWindowFunction.md)
1. [AggregateWindowFunction](../expressions/AggregateWindowFunction.md)
1. [PythonUDF](../expressions/PythonUDF.md)

??? note "Lazy Value"
    `windowFrameExpressionFactoryPairs` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

## <span id="createBoundOrdering"> createBoundOrdering

```scala
createBoundOrdering(
  frame: FrameType,
  bound: Expression,
  timeZone: String): BoundOrdering
```

`createBoundOrdering`...FIXME
