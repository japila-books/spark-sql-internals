# WindowSpec

`WindowSpec` defines a **window specification** for [Window Functions](index.md).

A window (specification) describes a group of records that are in *some* relation to the current record.

## Creating Instance

`WindowSpec` takes the following to be created:

* [Partition Specification](#partitionSpec)
* [Order Specification](#orderSpec)
* [Frame Specification](#frame)

`WindowSpec` is created when:

* `Window` utility is used to [create a default WindowSpec](Window.md#spec)
* `WindowSpec` is requested to [partitionBy](WindowSpec.md#partitionBy), [orderBy](WindowSpec.md#orderBy), [rowsBetween](WindowSpec.md#rowsBetween), [rangeBetween](WindowSpec.md#rangeBetween)

### Partition Specification { #partitionSpec }

Partition specification are [Expression](../expressions/Expression.md)s that define which rows are in the same partition. With no partition defined, all rows belong to a single partition.

### Order Specification { #orderSpec }

Order specification are [SortOrder](../expressions/SortOrder.md)s that define how rows are ordered in a partition that in turn defines the position of a row in a partition.

The ordering could be ascending (`ASC` in SQL or `asc` in Scala) or descending (`DESC` or `desc`).

### Frame Specification { #frame }

Frame specification is a `WindowFrame` that defines the rows to include in the frame for the current row, based on their relative position to the current row.

Frame specification is defined using [rowsBetween](#rowsBetween) and [rangeBetween](#rangeBetween) operators.

For example, _"the three rows preceding the current row to the current row"_ describes a frame including the current input row and three rows appearing before the current row.

`Window` utility defines special [Frame Boundaries](Window.md#frame-boundaries).

## rowsBetween { #rowsBetween }

```scala
rowsBetween(
  start: Long,
  end: Long): WindowSpec
```

`rowsBetween` creates a [WindowSpec](#creating-instance) with a `SpecifiedWindowFrame` boundary [frame](#frame) (of `RowFrame` type) from the given`start` and `end` (both inclusive).

## rangeBetween { #rangeBetween }

```scala
rangeBetween(
  start: Long,
  end: Long): WindowSpec
```

`rangeBetween` creates a [WindowSpec](#creating-instance) with a `SpecifiedWindowFrame` boundary [frame](#frame) (of [RangeFrame](RangeFrame.md) type) from the given`start` and `end` (both inclusive).

## withAggregate { #withAggregate }

```scala
withAggregate(
  aggregate: Column): Column
```

`withAggregate` creates a [WindowSpecDefinition](../expressions/WindowSpecDefinition.md) expression for the [partitionSpec](#partitionSpec), [orderSpec](#orderSpec) and the [WindowFrame](#frame) (of this `WindowSpec`).

In the end, `withAggregate` creates a [WindowExpression](../expressions/WindowExpression.md) expression for the [aggregate expression](../Column.md#expr) (of the given [Column](../Column.md)) and the [WindowSpecDefinition](../expressions/WindowSpecDefinition.md).

---

`withAggregate` is used when:

* [Column.over](../Column.md#over) operator is used
