# CalendarInterval

`CalendarInterval` represents a calendar interval.

## Creating Instance

`CalendarInterval` takes the following to be created:

* <span id="months"> Months
* <span id="days"> Days
* <span id="microseconds"> Microseconds

`CalendarInterval` is created when:

* `CALENDAR_INTERVAL` utility is used to `extract` a `CalendarInterval` from a `ByteBuffer`
* `ColumnVector` is requested to [getInterval](../ColumnVector.md#getInterval)
* `IntervalUtils` utilities are used
* `DateTimeUtils` utility is used to `subtractDates`
* `UnsafeRow` is requested to [getInterval](../UnsafeRow.md#getInterval)
* `UnsafeArrayData` is requested to `getInterval`
* `Literal` utility is used to [create the default value for CalendarIntervalType](../expressions/Literal.md#default)
* `TemporalSequenceImpl` is requested for the `defaultStep`

## Examples

```text
0 seconds
5 years
2 months
10 days
2 hours
1 minute
```
