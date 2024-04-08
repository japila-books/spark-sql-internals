# ParseToDate

`ParseToDate` is a [RuntimeReplaceable](RuntimeReplaceable.md) expression to represent [to_date](../standard-functions//datetime.md#to_date) function (in logical query plans).

As a `RuntimeReplaceable` expression, `ParseToDate` is replaced by [Logical Query Optimizer](../catalyst/Optimizer.md#ReplaceExpressions) with the [child](#child) expression:

* `Cast(left, DateType)` for `to_date(e: Column): Column` function

* `Cast(Cast(UnixTimestamp(left, format), TimestampType), DateType)` for `to_date(e: Column, fmt: String): Column` function
