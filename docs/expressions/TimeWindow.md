# TimeWindow

`TimeWindow` is an [unevaluable](Unevaluable.md) and non-SQL unary expression that represents [window](../spark-sql-functions.md#window) function.

## <span id="apply"> Creating TimeWindow

```scala
apply(
  timeColumn: Expression,
  windowDuration: String,
  slideDuration: String,
  startTime: String): TimeWindow
```

`apply` creates a [TimeWindow](#creating-instance) (for the given `timeColumn` expression and the durations and start time [converted to seconds](#getIntervalInMicroSeconds)).

`apply` is used when:

* [window](../spark-sql-functions.md#window) standard function is used

## <span id="getIntervalInMicroSeconds"> Parsing Time Interval to Microseconds

```scala
getIntervalInMicroSeconds(
  interval: String): Long
```

`getIntervalInMicroSeconds`...FIXME

`getIntervalInMicroSeconds` is used when:

* `TimeWindow` utility is used to [parseExpression](#parseExpression) and [apply](#apply)

## Analysis Phase

`TimeWindow` is resolved to [Expand](../logical-operators/Expand.md) unary logical operator (when `TimeWindowing` logical evaluation rule is executed).

```text
import java.time.LocalDateTime
import java.sql.Timestamp

val levels = Seq(
  // (year, month, dayOfMonth, hour, minute, second)
  ((2012, 12, 12, 12, 12, 12), 5),
  ((2012, 12, 12, 12, 12, 14), 9),
  ((2012, 12, 12, 13, 13, 14), 4),
  ((2016, 8,  13, 0, 0, 0), 10),
  ((2017, 5,  27, 0, 0, 0), 15)).
  map { case ((yy, mm, dd, h, m, s), a) => (LocalDateTime.of(yy, mm, dd, h, m, s), a) }.
  map { case (ts, a) => (Timestamp.valueOf(ts), a) }.
  toDF("time", "level")
scala> levels.show
+-------------------+-----+
|               time|level|
+-------------------+-----+
|2012-12-12 12:12:12|    5|
|2012-12-12 12:12:14|    9|
|2012-12-12 13:13:14|    4|
|2016-08-13 00:00:00|   10|
|2017-05-27 00:00:00|   15|
+-------------------+-----+

val q = levels.select(window($"time", "5 seconds"))

// Before Analyzer
scala> println(q.queryExecution.logical.numberedTreeString)
00 'Project [timewindow('time, 5000000, 5000000, 0) AS window#18]
01 +- Project [_1#6 AS time#9, _2#7 AS level#10]
02    +- LocalRelation [_1#6, _2#7]

// After Analyzer
scala> println(q.queryExecution.analyzed.numberedTreeString)
00 Project [window#19 AS window#18]
01 +- Filter ((time#9 >= window#19.start) && (time#9 < window#19.end))
02    +- Expand [List(named_struct(start, ((((CEIL((cast((precisetimestamp(time#9) - 0) as double) / cast(5000000 as double))) + cast(0 as bigint)) - cast(1 as bigint)) * 5000000) + 0), end, (((((CEIL((cast((precisetimestamp(time#9) - 0) as double) / cast(5000000 as double))) + cast(0 as bigint)) - cast(1 as bigint)) * 5000000) + 0) + 5000000)), time#9, level#10), List(named_struct(start, ((((CEIL((cast((precisetimestamp(time#9) - 0) as double) / cast(5000000 as double))) + cast(1 as bigint)) - cast(1 as bigint)) * 5000000) + 0), end, (((((CEIL((cast((precisetimestamp(time#9) - 0) as double) / cast(5000000 as double))) + cast(1 as bigint)) - cast(1 as bigint)) * 5000000) + 0) + 5000000)), time#9, level#10)], [window#19, time#9, level#10]
03       +- Project [_1#6 AS time#9, _2#7 AS level#10]
04          +- LocalRelation [_1#6, _2#7]
```

## Demo

```scala
import org.apache.spark.sql.functions.window
val timeColumn = window('time, "5 seconds")
```

```scala
val timeWindowExpr = timeColumn.expr
println(timeWindowExpr.numberedTreeString)
```

```text
00 timewindow('time, 5000000, 5000000, 0) AS window#3
01 +- timewindow('time, 5000000, 5000000, 0)
02    +- 'time
```

```scala
import org.apache.spark.sql.catalyst.expressions.TimeWindow
val timeWindow = timeColumn.expr.children.head.asInstanceOf[TimeWindow]
```
