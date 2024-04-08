# WindowFunction Expressions

`WindowFunction` is an extension of the [Expression](Expression.md) abstraction for [window functions](#implementations).

`WindowFunction` (along with [AggregateFunction](AggregateFunction.md)) is of `SQL` window function type.

## OVER Clause

`WindowFunction` can only be evaluated in the context of `OVER` window operator.

[CheckAnalysis](../CheckAnalysis.md) enforces that `WindowFunction`s can only be children of [WindowExpression](WindowExpression.md).

## Implementations

* [AggregateWindowFunction](AggregateWindowFunction.md)
* [OffsetWindowFunction](OffsetWindowFunction.md)

## Logical Resolution Rules

[Analyzer](../Analyzer.md) uses the following rules to work with `WindowFunction`s:

1. [ResolveWindowFrame](../logical-analysis-rules/ResolveWindowFrame.md)
1. `ResolveWindowOrder`
1. [ExtractWindowExpressions](../logical-analysis-rules/ExtractWindowExpressions.md)

## WindowFrame { #frame }

```scala
frame: WindowFrame
```

`frame` is an `UnspecifiedFrame` by default.

See:

* [AggregateWindowFunction](AggregateWindowFunction.md#frame)

---

`frame` is used when:

* [ResolveWindowFrame](../logical-analysis-rules/ResolveWindowFrame.md) logical resolution rule is executed
