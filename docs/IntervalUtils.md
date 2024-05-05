# IntervalUtils

## <span id="fromIntervalString"> Parsing CalendarInterval

```scala
fromIntervalString(
  input: String): CalendarInterval
```

`fromIntervalString`...FIXME

`fromIntervalString` is used when:

* `TimeWindow` utility is used to [getIntervalInMicroSeconds](expressions/TimeWindow.md#getIntervalInMicroSeconds)
* `Dataset` is requested to [withWatermark](dataset/index.md#withWatermark)
