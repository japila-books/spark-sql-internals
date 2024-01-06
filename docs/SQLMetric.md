# SQLMetric

`SQLMetric` is an `AccumulatorV2` ([Spark Core]({{ book.spark_core }}/accumulators/AccumulatorV2/)) for [performance metrics of physical operators](physical-operators/SparkPlan.md#metrics).

!!! note
    Use **Details for Query** page in [SQL tab](ui/SQLTab.md#ExecutionPage) in web UI to see the SQL execution metrics of a structured query.

## Creating Instance

`SQLMetric` takes the following to be created:

* [Metric Type](#metricType)
* <span id="initValue"> Initial Value

`SQLMetric` is created using the specialized utilities:

* [createMetric](#createMetric)
* [createSizeMetric](#createSizeMetric)
* [createTimingMetric](#createTimingMetric)
* [createNanoTimingMetric](#createNanoTimingMetric)
* [createAverageMetric](#createAverageMetric)

### <span id="createAverageMetric"> createAverageMetric

```scala
createAverageMetric(
  sc: SparkContext,
  name: String): SQLMetric
```

`createAverageMetric` creates a `SQLMetric` with [average](#AVERAGE_METRIC) type and registers it with the given `name`.

### <span id="createMetric"> createMetric

```scala
createMetric(
  sc: SparkContext,
  name: String): SQLMetric
```

`createMetric` creates a `SQLMetric` with [sum](#SUM_METRIC) type and registers it with the given `name`.

### <span id="createNanoTimingMetric"> createNanoTimingMetric

```scala
createNanoTimingMetric(
  sc: SparkContext,
  name: String): SQLMetric
```

`createNanoTimingMetric` creates a `SQLMetric` with [nsTiming](#NS_TIMING_METRIC) type and registers it with the given `name`.

### <span id="createSizeMetric"> createSizeMetric

```scala
createSizeMetric(
  sc: SparkContext,
  name: String): SQLMetric
```

`createSizeMetric` creates a `SQLMetric` with [size](#SIZE_METRIC) type and registers it with the given `name`.

### <span id="createTimingMetric"> createTimingMetric

```scala
createTimingMetric(
  sc: SparkContext,
  name: String): SQLMetric
```

`createTimingMetric` creates a `SQLMetric` with [timing](#TIMING_METRIC) type and registers it with the given `name`.

## <span id="metricType"> Metric Types

`SQLMetric` is given a metric type to be [created](#creating-instance):

* <span id="AVERAGE_METRIC"> `average`
* <span id="NS_TIMING_METRIC"> `nsTiming`
* <span id="SIZE_METRIC"> `size`
* <span id="SUM_METRIC"> `sum`
* <span id="TIMING_METRIC"> `timing`

## <span id="postDriverMetricUpdates"> Posting Driver-Side Metric Updates

```scala
postDriverMetricUpdates(
  sc: SparkContext,
  executionId: String,
  metrics: Seq[SQLMetric]): Unit
```

`postDriverMetricUpdates` posts a `SparkListenerDriverAccumUpdates` event to `LiveListenerBus` (only if `executionId` is specified).

---

`postDriverMetricUpdates` is used when:

* `BasicWriteJobStatsTracker` is requested for [processStats](files/BasicWriteJobStatsTracker.md#processStats)
* `BroadcastExchangeExec` is requested for [relationFuture](physical-operators/BroadcastExchangeExec.md#relationFuture)
* `FileSourceScanExec` physical operator is requested for [sendDriverMetrics](physical-operators/FileSourceScanExec.md#sendDriverMetrics)
* `SubqueryBroadcastExec` physical operator is requested for `relationFuture`
* `SubqueryExec` physical operator is requested for [relationFuture](physical-operators/SubqueryExec.md#relationFuture)
