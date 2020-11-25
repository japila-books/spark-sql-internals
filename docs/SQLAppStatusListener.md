# SQLAppStatusListener Spark Listener

`SQLAppStatusListener` is a `SparkListener` ([Spark Core]({{ book.spark }}/SparkListener/)).

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

`onJobStart` is part of the `SparkListener` abstraction.

`onJobStart`...FIXME

=== [[onStageSubmitted]] `onStageSubmitted` Callback

[source, scala]
----
onStageSubmitted(event: SparkListenerStageSubmitted): Unit
----

`onStageSubmitted` is part of the `SparkListener` abstraction.

`onStageSubmitted`...FIXME

=== [[onJobEnd]] `onJobEnd` Callback

[source, scala]
----
onJobEnd(event: SparkListenerJobEnd): Unit
----

`onJobEnd` is part of the `SparkListener` abstraction.

`onJobEnd`...FIXME

=== [[onExecutorMetricsUpdate]] `onExecutorMetricsUpdate` Callback

[source, scala]
----
onExecutorMetricsUpdate(event: SparkListenerExecutorMetricsUpdate): Unit
----

`onExecutorMetricsUpdate` is part of the `SparkListener` abstraction.

`onExecutorMetricsUpdate`...FIXME

=== [[onTaskEnd]] `onTaskEnd` Callback

[source, scala]
----
onTaskEnd(event: SparkListenerTaskEnd): Unit
----

`onTaskEnd` is part of the `SparkListener` abstraction.

`onTaskEnd`...FIXME

=== [[onOtherEvent]] Handling SparkListenerEvent -- `onOtherEvent` Callback

[source, scala]
----
onOtherEvent(event: SparkListenerEvent): Unit
----

`onOtherEvent` is part of the `SparkListener` abstraction.

`onOtherEvent`...FIXME
