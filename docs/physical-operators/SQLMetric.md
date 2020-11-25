# SQLMetric &mdash; SQL Execution Metric of Physical Operator

`SQLMetric` is a SQL metric for monitoring execution of a SparkPlan.md[physical operator].

`SQLMetric` is an spark-accumulators.md[accumulator] (and that is the mechanism to propagate SQL metric updates on the executors to the driver, e.g. web UI).

NOTE: Use *Details for Query* page in spark-sql-webui.md#ExecutionPage[SQL tab] in web UI to see the SQL execution metrics of a structured query.

[NOTE]
====
SQL metrics are collected using `SparkListener`. If there are no tasks, Spark SQL cannot collect any metrics. Updates to metrics on the driver-side require explicit call of <<postDriverMetricUpdates, SQLMetrics.postDriverMetricUpdates>>.

This is why executing some physical operators (e.g. LocalTableScanExec) may not have SQL metrics in web UI's spark-sql-webui.md#ExecutionPage[Details for Query] in SQL tab.

Compare the following SQL queries and their execution pages.

[source, scala]
----
// The query does not have SQL metrics in web UI
Seq("Jacek").toDF("name").show

// The query gives numOutputRows metric in web UI's Details for Query (SQL tab)
Seq("Jacek").toDF("name").count
----
====

[[metricType]][[initValue]]
`SQLMetric` takes a metric type and an initial value when created.

[[metrics-types]]
.Metric Types and Corresponding Create Methods
[cols="1,1,1,2",options="header",width="100%"]
|===
| Metric Type
| Create Method
| Failed Values Counted?
| Description

| [[size]] `size`
| [[createSizeMetric]] `createSizeMetric`
| no
| Used when...

| [[sum]] `sum`
| [[createMetric]] `createMetric`
| no
| Used when...

| [[timing]] `timing`
| [[createTimingMetric]] `createTimingMetric`
| no
| Used when...
|===

=== [[reset]] `reset` Method

[source, scala]
----
reset(): Unit
----

`reset`...FIXME

NOTE: `reset` is used when...FIXME

=== [[postDriverMetricUpdates]] Posting Driver-Side Metric Updates -- `SQLMetrics.postDriverMetricUpdates` Method

[source, scala]
----
postDriverMetricUpdates(
  sc: SparkContext,
  executionId: String,
  metrics: Seq[SQLMetric]): Unit
----

`postDriverMetricUpdates` posts a [SparkListenerDriverAccumUpdates](../SQLListener.md#SparkListenerDriverAccumUpdates) event to `LiveListenerBus` when `executionId` is specified.

!!! note
    `postDriverMetricUpdates` method belongs to `SQLMetrics` object.

`postDriverMetricUpdates` is used when:

* `BroadcastExchangeExec` is requested to BroadcastExchangeExec.md#doPrepare[prepare for execution] (and initializes BroadcastExchangeExec.md#relationFuture[relationFuture] for the first time)

* `FileSourceScanExec` physical operator is requested for FileSourceScanExec.md#selectedPartitions[selectedPartitions] (and posts updates to `numFiles` and `metadataTime` metrics)

* `SubqueryExec` physical operator is requested to SubqueryExec.md#doPrepare[prepare for execution] (and initializes SubqueryExec.md#relationFuture[relationFuture] for the first time that in turn posts updates to `collectTime` and `dataSize` metrics)
