# SQLAppStatusListener Spark Listener

`SQLAppStatusListener` is a spark-SparkListener.md[SparkListener] that...FIXME

[[internal-registries]]
.SQLAppStatusListener's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| [[liveUpdatePeriodNs]] `liveUpdatePeriodNs`
|

| [[liveExecutions]] `liveExecutions`
|

| [[stageMetrics]] `stageMetrics`
|

| [[uiInitialized]] `uiInitialized`
|
|===

=== [[onExecutionStart]] `onExecutionStart` Internal Method

[source, scala]
----
onExecutionStart(event: SparkListenerSQLExecutionStart): Unit
----

`onExecutionStart`...FIXME

NOTE: `onExecutionStart` is used exclusively when `SQLAppStatusListener` <<onOtherEvent, handles a SparkListenerSQLExecutionStart event>>.

=== [[onJobStart]] `onJobStart` Callback

[source, scala]
----
onJobStart(event: SparkListenerJobStart): Unit
----

NOTE: `onJobStart` is part of spark-SparkListener.md#onJobStart[SparkListener Contract] to...FIXME

`onJobStart`...FIXME

=== [[onStageSubmitted]] `onStageSubmitted` Callback

[source, scala]
----
onStageSubmitted(event: SparkListenerStageSubmitted): Unit
----

NOTE: `onStageSubmitted` is part of spark-SparkListener.md#onStageSubmitted[SparkListener Contract] to...FIXME

`onStageSubmitted`...FIXME

=== [[onJobEnd]] `onJobEnd` Callback

[source, scala]
----
onJobEnd(event: SparkListenerJobEnd): Unit
----

NOTE: `onJobEnd` is part of spark-SparkListener.md#onJobEnd[SparkListener Contract] to...FIXME

`onJobEnd`...FIXME

=== [[onExecutorMetricsUpdate]] `onExecutorMetricsUpdate` Callback

[source, scala]
----
onExecutorMetricsUpdate(event: SparkListenerExecutorMetricsUpdate): Unit
----

NOTE: `onExecutorMetricsUpdate` is part of spark-SparkListener.md#onExecutorMetricsUpdate[SparkListener Contract] to...FIXME

`onExecutorMetricsUpdate`...FIXME

=== [[onTaskEnd]] `onTaskEnd` Callback

[source, scala]
----
onTaskEnd(event: SparkListenerTaskEnd): Unit
----

NOTE: `onTaskEnd` is part of spark-SparkListener.md#onTaskEnd[SparkListener Contract] to...FIXME

`onTaskEnd`...FIXME

=== [[onOtherEvent]] Handling SparkListenerEvent -- `onOtherEvent` Callback

[source, scala]
----
onOtherEvent(event: SparkListenerEvent): Unit
----

NOTE: `onOtherEvent` is part of spark-SparkListener.md#onOtherEvent[SparkListener Contract] to...FIXME

`onOtherEvent`...FIXME
