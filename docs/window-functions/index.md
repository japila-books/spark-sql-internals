# Window Functions

From the [official documentation of PostgreSQL](https://www.postgresql.org/docs/14/functions-window.html):

> **Window functions** provide the ability to perform calculations across sets of rows that are related to the current query row.

Window functions are a subset of [standard functions](../standard-functions/index.md) and hence generate a value for every group of rows that are associated with the current row by some _relation_.

Window functions require a **window specification** ([WindowSpec](WindowSpec.md)) that defines which rows are included in a **window** (_frame_, i.e. the set of rows that are associated with the current row by some _relation_).

[Window](Window.md) utility is used to create a `WindowSpec` to be refined further using [Window operators](Window.md#operators).

```scala
import org.apache.spark.sql.expressions.Window
val byHTokens = Window.partitionBy('token startsWith "h")
```

```scala
import org.apache.spark.sql.expressions.WindowSpec
assert(byHTokens.isInstanceOf[WindowSpec])
```

```scala
import org.apache.spark.sql.expressions.Window
val windowSpec = Window
  .partitionBy($"orderId")
  .orderBy($"time")
```

With a `WindowSpec` defined, [Column.over](../Column.md#over) operator is used to associate the `WindowSpec` with [aggregate](../standard-functions/index.md#aggregate-functions) or [window](../standard-functions/index.md#window-functions) functions.

```scala
import org.apache.spark.sql.functions.rank
rank.over(byHTokens)
```

```scala
import org.apache.spark.sql.functions.first
first.over(windowSpec)
```

## Execution

Window functions are executed by [WindowExec](../physical-operators/WindowExec.md) unary physical operator.

## Limitations

`WindowSpecDefinition` expression enforces the following [requirements on WindowFrames](../expressions/WindowSpecDefinition.md#checkInputDataTypes):

1. No `UnspecifiedFrame`s are allowed (and should be resolved during analysis)
1. A [range window frame](RangeFrame.md) cannot be used in an unordered window specification.
1. A [range window frame](RangeFrame.md) with value boundaries cannot be used in a window specification with multiple order by expressions
1. The data type in the order specification ought to match the data type of the [range frame](RangeFrame.md)
