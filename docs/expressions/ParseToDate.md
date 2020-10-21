title: ParseToDate

# ParseToDate Expression

`ParseToDate` is a spark-sql-Expression-RuntimeReplaceable.md[RuntimeReplaceable] expression that <<creating-instance, represents>> the spark-sql-functions-datetime.md#to_date[to_date] function (in logical query plans).

```scala
// DEMO to_date(e: Column): Column
// DEMO to_date(e: Column, fmt: String): Column
```

As a `RuntimeReplaceable` expression, `ParseToDate` is replaced by [Logical Query Optimizer](../catalyst/Optimizer.md#ReplaceExpressions) with the <<child, child>> expression:

* `Cast(left, DateType)` for `to_date(e: Column): Column` function

* `Cast(Cast(UnixTimestamp(left, format), TimestampType), DateType)` for `to_date(e: Column, fmt: String): Column` function

```scala
// FIXME DEMO Conversion to `Cast(left, DateType)`
// FIXME DEMO Conversion to `Cast(Cast(UnixTimestamp(left, format), TimestampType), DateType)`
```

=== [[creating-instance]] Creating ParseToDate Instance

`ParseToDate` takes the following when created:

* [[left]] Left Expression.md[expression]
* [[format]] `format` Expression.md[expression]
* [[child]] Child Expression.md[expression]
