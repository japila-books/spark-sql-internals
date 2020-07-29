title: UnixTimestamp

# UnixTimestamp TimeZoneAware Binary Expression

`UnixTimestamp` is a expressions/Expression.md#BinaryExpression[binary] expression with expressions/Expression.md#TimeZoneAwareExpression[timezone] support that represents spark-sql-functions-datetime.md#unix_timestamp[unix_timestamp] function (and indirectly spark-sql-functions-datetime.md#to_date[to_date] and spark-sql-functions-datetime.md##to_timestamp[to_timestamp]).

```
import org.apache.spark.sql.functions.unix_timestamp
val c1 = unix_timestamp()

scala> c1.explain(true)
unix_timestamp(current_timestamp(), yyyy-MM-dd HH:mm:ss, None)

scala> println(c1.expr.numberedTreeString)
00 unix_timestamp(current_timestamp(), yyyy-MM-dd HH:mm:ss, None)
01 :- current_timestamp()
02 +- yyyy-MM-dd HH:mm:ss

import org.apache.spark.sql.catalyst.expressions.UnixTimestamp
scala> c1.expr.isInstanceOf[UnixTimestamp]
res0: Boolean = true
```

NOTE: `UnixTimestamp` is `UnixTime` expression internally (as is `ToUnixTimestamp` expression).

[[inputTypes]][[dataType]]
`UnixTimestamp` supports `StringType`, spark-sql-DataType.md#DateType[DateType] and `TimestampType` as input types for a time expression and returns `LongType`.

```
scala> c1.expr.eval()
res1: Any = 1493354303
```

[[formatter]]
`UnixTimestamp` uses `DateTimeUtils.newDateFormat` for date/time format (as Java's https://docs.oracle.com/javase/8/docs/api/java/text/DateFormat.html[java.text.DateFormat]).
