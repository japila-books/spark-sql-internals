# CumeDist

`CumeDist` is a `SizeBasedWindowFunction` and a `RowNumberLike` expression that is used for the following:

* [cume_dist](../spark-sql-functions.md#cume_dist) standard function

* [cume_dist](../FunctionRegistry.md#expressions) SQL function

## Demo

```scala
import org.apache.spark.sql.catalyst.expressions.CumeDist
val cume_dist = CumeDist()
```

```scala
import org.apache.spark.sql.catalyst.expressions.CumeDist
val cume_dist = CumeDist()
scala> println(cume_dist)
cume_dist()
```

```text
scala> println(cume_dist.evaluateExpression.numberedTreeString)
00 (cast(rowNumber#0 as double) / cast(window__partition__size#1 as double))
01 :- cast(rowNumber#0 as double)
02 :  +- rowNumber#0: int
03 +- cast(window__partition__size#1 as double)
04    +- window__partition__size#1: int
```

## <span id="prettyName"> prettyName

```scala
prettyName: String
```

`prettyName` is **cume_dist** as the user-facing name.

`prettyName` is part of the [Expression](Expression.md#prettyName) abstraction.

## <span id="frame"> frame

```scala
frame: WindowFrame
```

`frame` is a `SpecifiedWindowFrame` with the following:

* `RangeFrame` frame type
* `UnboundedPreceding` lower frame boundary
* `CurrentRow` upper frame boundary

!!! note
    The [frame](#frame) of a `CumeDist` expression is range-based instead of row-based, because it has to return the same value for tie values in a window (equal values per `ORDER BY` specification).

`frame` is part of the `WindowFunction` abstraction.

## <span id="evaluateExpression"> evaluateExpression

```scala
evaluateExpression: Expression
```

`evaluateExpression` uses the formula `rowNumber / n` where `rowNumber` is the row number in a window frame (the number of values before and including the current row) divided by the number of rows in the window frame.

`evaluateExpression` is part of the [DeclarativeAggregate](DeclarativeAggregate.md#evaluateExpression) abstraction.
