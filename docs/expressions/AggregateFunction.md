# AggregateFunction Expressions

`AggregateFunction` is an [extension](#contract) of the [Expression](Expression.md) abstraction for [aggregate functions](#implementations).

`AggregateFunction` can never be [foldable](#foldable).

## Contract

### <span id="aggBufferAttributes"> Aggregation Buffer Attributes

```scala
aggBufferAttributes: Seq[AttributeReference]
```

See [TypedImperativeAggregate](TypedImperativeAggregate.md#aggBufferAttributes)

### <span id="aggBufferSchema"> Aggregation Buffer Schema

```scala
aggBufferSchema: StructType
```

[Schema](../types/StructType.md) of an aggregation buffer with partial aggregate results

Used when:

* `AggregationIterator` is requested to [initializeAggregateFunctions](../aggregations/AggregationIterator.md#initializeAggregateFunctions)

### <span id="inputAggBufferAttributes"> inputAggBufferAttributes

```scala
inputAggBufferAttributes: Seq[AttributeReference]
```

## Implementations

* [DeclarativeAggregate](DeclarativeAggregate.md)
* [ImperativeAggregate](ImperativeAggregate.md)
* `TypedAggregateExpression`

## <span id="foldable"> foldable

```scala
foldable: Boolean
```

`foldable` is part of the [Expression](Expression.md#foldable) abstraction.

---

`foldable` is always `false`.

## <span id="toAggregateExpression"> Converting to AggregateExpression

```scala
toAggregateExpression(): AggregateExpression // (1)
toAggregateExpression(
  isDistinct: Boolean,
  filter: Option[Expression] = None): AggregateExpression
```

1. `isDistinct` flag is `false`

`toAggregateExpression` creates an [AggregateExpression](AggregateExpression.md) for this `AggregateFunction` and `Complete` mode.

```text
import org.apache.spark.sql.functions.collect_list
val fn = collect_list("gid")

import org.apache.spark.sql.catalyst.expressions.aggregate.AggregateExpression
val aggFn = fn.expr.asInstanceOf[AggregateExpression].aggregateFunction

scala> println(aggFn.numberedTreeString)
00 collect_list('gid, 0, 0)
01 +- 'gid
```

---

`toAggregateExpression` is used when:

* `AggregateFunction` is requested to [toAggregateExpression](#toAggregateExpression)
* `functions` utility is used to [withAggregateFunction](../standard-functions//index.md#withAggregateFunction)
* _others_
