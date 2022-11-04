# SparkListenerSQLExecutionEnd

`SparkListenerSQLExecutionEnd` is a `SparkListenerEvent` ([Spark Core]({{ book.spark_core }}/SparkListenerEvent)).

`SparkListenerSQLExecutionEnd` is posted (to an event bus) to announce that `SQLExecution` has completed [executing a structured query](../SQLExecution.md#withNewExecutionId).

## Creating Instance

`SparkListenerSQLExecutionEnd` takes the following to be created:

* [Execution ID](#executionId)
* [Timestamp](#time)

`SparkListenerSQLExecutionEnd` is created when:

* `SQLExecution` is requested to [withNewExecutionId](../SQLExecution.md#withNewExecutionId)

### <span id="executionId"> Execution ID

`SparkListenerSQLExecutionEnd` is given `executionId` when [created](#creating-instance).

The execution ID is the [next available execution ID](../SQLExecution.md#nextExecutionId) when `SQLExecution` is requested to [withNewExecutionId](../SQLExecution.md#withNewExecutionId).

### <span id="time"> Timestamp

`SparkListenerSQLExecutionEnd` is given a timestamp when [created](#creating-instance).

The timestamp is the time when `SQLExecution` has finished [withNewExecutionId](../SQLExecution.md#withNewExecutionId).

## SparkListener.onOtherEvent

`SparkListenerSQLExecutionEnd` can be intercepted using `SparkListener.onOtherEvent` ([Spark Core]({{ book.spark_core }}/SparkListenerInterface#onOtherEvent)).

## SparkListeners

The following `SparkListener`s intercepts `SparkListenerSQLExecutionEnd`s:

* `SQLEventFilterBuilder`
* [SQLAppStatusListener](SQLAppStatusListener.md)

## QueryExecutionListeners

`SparkListenerSQLExecutionEnd` is posted to [QueryExecutionListener](../QueryExecutionListener.md)s using `ExecutionListenerBus`.
