# ParseToTimestamp

`ParseToTimestamp` is a [RuntimeReplaceable](RuntimeReplaceable.md) expression to represent [to_timestamp](../functions/datetime.md#to_timestamp) standard function (in logical query plans).

As a `RuntimeReplaceable` expression, `ParseToTimestamp` is replaced by [Logical Optimizer](../catalyst/Optimizer.md#ReplaceExpressions) with the [child](#child) expression:

* `Cast(left, TimestampType)` for `to_timestamp(s: Column): Column` function

* `Cast(UnixTimestamp(left, format), TimestampType)` for `to_timestamp(s: Column, fmt: String): Column` function

## Demo

```text
// DEMO to_timestamp(s: Column): Column
import java.sql.Timestamp
import java.time.LocalDateTime
val times = Seq(Timestamp.valueOf(LocalDateTime.of(2018, 5, 30, 0, 0, 0)).toString).toDF("time")
scala> times.printSchema
root
 |-- time: string (nullable = true)

import org.apache.spark.sql.functions.to_timestamp
val q = times.select(to_timestamp($"time") as "ts")
scala> q.printSchema
root
 |-- ts: timestamp (nullable = true)

val plan = q.queryExecution.analyzed
scala> println(plan.numberedTreeString)
00 Project [to_timestamp('time, None) AS ts#29]
01 +- Project [value#16 AS time#18]
02    +- LocalRelation [value#16]

import org.apache.spark.sql.catalyst.expressions.ParseToTimestamp
val ptt = plan.expressions.head.children.head.asInstanceOf[ParseToTimestamp]
scala> println(ptt.numberedTreeString)
00 to_timestamp('time, None)
01 +- cast(time#18 as timestamp)
02    +- time#18: string
```
