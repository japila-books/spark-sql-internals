# RangeFrame

`RangeFrame` is a `FrameType` of [WindowSpec](WindowSpec.md)s with the following:

1. [rangeBetween](WindowSpec.md#rangeBetween) operator or [RANGE BETWEEN](../sql/AstBuilder.md#visitWindowDef) SQL clause
1. [Unspecified frame with an order specification](#ResolveWindowFrame)

## <span id="CumeDist"> CumeDist Expression

[CumeDist](../expressions/CumeDist.md) window function expression requires a `RangeFrame` with [UnboundedPreceding](Window.md#frame-boundaries) and [CurrentRow](Window.md#frame-boundaries).

It is because `CUME_DIST` must return the same value for equal values in the partition.

## <span id="ResolveWindowFrame"> UnspecifiedFrame with Order Specification and ResolveWindowFrame

`RangeFrame` with [UnboundedPreceding](Window.md#frame-boundaries) and [CurrentRow](Window.md#frame-boundaries) is assumed (by [ResolveWindowFrame](../logical-analysis-rules/ResolveWindowFrame.md) logical resolution rule) for ordered window specifications ([WindowSpecDefinition](../expressions/WindowSpecDefinition.md)s with `UnspecifiedFrame` but a non-empty [order specification](../expressions/WindowSpecDefinition.md#orderSpec)).

## <span id="inputType"> inputType

```scala
inputType: AbstractDataType
```

`inputType` can be any of the following numeric and interval data types:

* `NumericType`
* `CalendarIntervalType`
* `DayTimeIntervalType`
* `YearMonthIntervalType`

`inputType` is part of the `FrameType` abstraction.

## <span id="sql"> sql

```scala
sql: String
```

`sql` is `RANGE`.

`sql` is part of the `FrameType` abstraction.
