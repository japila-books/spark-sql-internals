---
title: AggregateFunction
---

# AggregateFunction Expressions

`AggregateFunction` is an [extension](#contract) of the [Expression](Expression.md) abstraction for [aggregate functions](#implementations).

`AggregateFunction` can never be [foldable](#foldable).

## Contract

### Aggregation Buffer Attributes { #aggBufferAttributes }

```scala
aggBufferAttributes: Seq[AttributeReference]
```

See [TypedImperativeAggregate](TypedImperativeAggregate.md#aggBufferAttributes)

### Aggregation Buffer Schema { #aggBufferSchema }

```scala
aggBufferSchema: StructType
```

[Schema](../types/StructType.md) of an aggregation buffer with partial aggregate results

Used when:

* `AggregationIterator` is requested to [initializeAggregateFunctions](../aggregations/AggregationIterator.md#initializeAggregateFunctions)

### inputAggBufferAttributes { #inputAggBufferAttributes }

```scala
inputAggBufferAttributes: Seq[AttributeReference]
```

## Implementations

* [DeclarativeAggregate](DeclarativeAggregate.md)
* [ImperativeAggregate](ImperativeAggregate.md)
* `TypedAggregateExpression`

## foldable { #foldable }

??? note "Expression"

    ```scala
    foldable: Boolean
    ```

    `foldable` is part of the [Expression](Expression.md#foldable) abstraction.

`foldable` is always disabled (`false`).

## Converting into AggregateExpression { #toAggregateExpression }

```scala
toAggregateExpression(): AggregateExpression // (1)
toAggregateExpression(
  isDistinct: Boolean,
  filter: Option[Expression] = None): AggregateExpression
```

1. `isDistinct` flag is `false`

`toAggregateExpression` creates an [AggregateExpression](AggregateExpression.md) for this `AggregateFunction` (with `Complete` mode).

```scala
import org.apache.spark.sql.functions.collect_list
val fn = collect_list("gid")
```

```scala
import org.apache.spark.sql.catalyst.expressions.aggregate.AggregateExpression
val aggFn = fn.expr.asInstanceOf[AggregateExpression].aggregateFunction
```

```text
scala> println(aggFn.numberedTreeString)
00 collect_list('gid, 0, 0)
01 +- 'gid
```

---

`toAggregateExpression` is used when:

* `AggregateFunction` is requested to [toAggregateExpression](#toAggregateExpression)
* `functions` utility is used to [withAggregateFunction](../standard-functions//index.md#withAggregateFunction)
* _others_
