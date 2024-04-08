---
title: RowNumberLike
---

# RowNumberLike Aggregate Window Function Expressions

`RowNumberLike` is an extension of the [AggregateWindowFunction](AggregateWindowFunction.md) abstraction for [aggregate window function leaf expressions](#implementations).

## Implementations

* `CumeDist`
* `NTile`
* [RowNumber](RowNumber.md)

## rowNumber Attribute Reference { #rowNumber }

```scala
rowNumber: AttributeReference
```

`rowNumber` is an `AttributeReference` with the following properties:

* `rowNumber` name
* `IntegerType` data type
* [nullable](Expression.md#nullable) disabled (`false`)

## Aggregation Buffer Attributes { #aggBufferAttributes }

??? note "AggregateFunction"

    ```scala
    aggBufferAttributes: Seq[AttributeReference]
    ```

    `aggBufferAttributes` is part of the [AggregateFunction](AggregateFunction.md#aggBufferAttributes) abstraction.

`aggBufferAttributes` is a collection with the [rowNumber](#rowNumber) attribute reference.

## Update Expressions { #updateExpressions }

??? note "DeclarativeAggregate"

    ```scala
    updateExpressions: Seq[Expression]
    ```

    `updateExpressions` is part of the [DeclarativeAggregate](DeclarativeAggregate.md#updateExpressions) abstraction.

`updateExpressions` is a collection with the [rowNumber](#rowNumber) attribute reference incremented (by 1).
