# WindowSpec

`WindowSpec` defines a **window specification** for [Window Functions](index.md).

## Creating Instance

`WindowSpec` takes the following to be created:

* [Partition Specification](#partitionSpec)
* [Order Specification](#orderSpec)
* [Frame Specification](#frame)

`WindowSpec` is created when:

* `Window` utility is used to [create a default WindowSpec](Window.md#spec)
* `WindowSpec` is requested to [partitionBy](WindowSpec.md#partitionBy), [orderBy](WindowSpec.md#orderBy), [rowsBetween](WindowSpec.md#rowsBetween), [rangeBetween](WindowSpec.md#rangeBetween)

### <span id="partitionSpec"> Partition Specification

Partition specification are [Expression](../expressions/Expression.md)s that define which rows are in the same partition. With no partition defined, all rows belong to a single partition.

### <span id="orderSpec"> Order Specification

Order specification are [SortOrder](../expressions/SortOrder.md)s that define how rows are ordered in a partition that in turn defines the position of a row in a partition.

The ordering could be ascending (`ASC` in SQL or `asc` in Scala) or descending (`DESC` or `desc`).

### <span id="frame"> Frame Specification

Frame specification is a `WindowFrame` that defines the rows to include in the frame for the current row, based on their relative position to the current row.

Frame specification is defined using [rowsBetween](#rowsBetween) and [rangeBetween](#rangeBetween) operators.

For example, _"the three rows preceding the current row to the current row"_ describes a frame including the current input row and three rows appearing before the current row.

`Window` utility defines special [Frame Boundaries](Window.md#frame-boundaries).

## <span id="rowsBetween"> rowsBetween

```scala
rowsBetween(
  start: Long,
  end: Long): WindowSpec
```

`rowsBetween` creates a [WindowSpec](#creating-instance) with a `SpecifiedWindowFrame` boundary [frame](#frame) (of `RowFrame` type) from the given`start` and `end` (both inclusive).

## <span id="rangeBetween"> rangeBetween

```scala
rangeBetween(
  start: Long,
  end: Long): WindowSpec
```

`rangeBetween` creates a [WindowSpec](#creating-instance) with a `SpecifiedWindowFrame` boundary [frame](#frame) (of [RangeFrame](RangeFrame.md) type) from the given`start` and `end` (both inclusive).
