---
title: ParseToTimestamp
---

# ParseToTimestamp Expression

`ParseToTimestamp` is a [RuntimeReplaceable](RuntimeReplaceable.md) expression that represents the following standard functions in logical query plans:

* [to_timestamp](../standard-functions/datetime.md#to_timestamp)
* [to_timestamp_ltz](../standard-functions/datetime.md#to_timestamp_ltz)
* [to_timestamp_ntz](../standard-functions/datetime.md#to_timestamp_ntz)
* [try_to_timestamp](../standard-functions/datetime.md#try_to_timestamp)

## Creating Instance

`ParseToTimestamp` takes the following to be created:

* <span id="left"> Left [Expression](Expression.md)
* <span id="format"> Optional Format [Expression](Expression.md)
* <span id="dataType"> [DataType](../types/DataType.md)
* <span id="timeZoneId"> Optional TimeZone ID (default: unspecified)
* <span id="failOnError"> `failOnError` flag

`ParseToTimestamp` is created when:

* `ParseToTimestampLTZExpressionBuilder` is requested to `build` (for `to_timestamp_ltz` standard function)
* `ParseToTimestampNTZExpressionBuilder` is requested to `build` (for `to_timestamp_ntz` standard function)
* `TryToTimestampExpressionBuilder` is requested to `build` (for `try_to_timestamp` standard function)
* [to_timestamp](../standard-functions/datetime.md#to_timestamp) standard function is used

## nodeName { #nodeName }

??? note "TreeNode"

    ```scala
    nodeName: String
    ```

    `nodeName` is part of the [TreeNode](../catalyst/TreeNode.md#nodeName) abstraction.

`nodeName` is the following text:

```text
to_timestamp
```

## Replacement Expression { #replacement }

??? note "RuntimeReplaceable"

    ```scala
    replacement: Expression
    ```

    `replacement` is part of the [RuntimeReplaceable](RuntimeReplaceable.md#replacement) abstraction.

With the [format](#format) specified, `replacement` is a `GetTimestamp(left, f, dataType, timeZoneId)` expression.

Otherwise, `replacement` is a `Cast(left, dataType, timeZoneId)` expression.

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
