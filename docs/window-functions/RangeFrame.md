# RangeFrame

`RangeFrame` is a `FrameType` of a [WindowSpec](WindowSpec.md) with [rangeBetween](WindowSpec.md#rangeBetween) applied.

## <span id="ResolveWindowFrame"> ResolveWindowFrame

[ResolveWindowFrame](../logical-analysis-rules/ResolveWindowFrame.md) logical resolution rule resolves [WindowExpression](../expressions/WindowExpression.md)s with [WindowSpecDefinition](../expressions/WindowSpecDefinition.md)s with `UnspecifiedFrame` to be a `RangeFrame` with `UnboundedPreceding` and `CurrentRow` for a non-empty [order specification](../expressions/WindowSpecDefinition.md#orderSpec).

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
