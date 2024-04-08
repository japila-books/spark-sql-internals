# AggregateWindowFunction Expressions

`AggregateWindowFunction` is an extension of the [DeclarativeAggregate](DeclarativeAggregate.md) and [WindowFunction](WindowFunction.md) abstractions for [aggregate window function expressions](#implementations).

## Implementations

* `NthValue`
* `RankLike`
* [RowNumberLike](RowNumberLike.md)
* `SizeBasedWindowFunction`

## Frame { #frame }

??? note "WindowFunction"

    ```scala
    frame: WindowFrame
    ```

    `frame` is part of the [WindowFunction](WindowFunction.md#frame) abstraction.

`frame` is a `SpecifiedWindowFrame` with the following:

* `RowFrame` type
* `UnboundedPreceding` lower expression
* `CurrentRow` lower expression
