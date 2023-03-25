# ANSI Intervals

Spark SQL supports interval type defined by the ANSI SQL standard using `AnsiIntervalType`:

* `DayTimeIntervalType` for day-time intervals
* `YearMonthIntervalType` for year-month intervals

Intervals can be positive and negative.

## Parquet

ANSI intervals are supported by [parquet data source](../parquet/ParquetFileFormat.md) as follows:

* `DayTimeIntervalType` is the same as `LongType` (`INT64`)
* `YearMonthIntervalType` is the same as `IntegerType` (`INT32`)

## Demo

```text
select date'today' - date'2021-01-01' as diff
```
