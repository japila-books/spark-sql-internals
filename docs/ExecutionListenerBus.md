# ExecutionListenerBus

`ExecutionListenerBus` is a `ListenerBus` ([Spark Core]({{ book.spark_core }}/ListenerBus)) that notifies registered [QueryExecutionListener](QueryExecutionListener.md)s about[SparkListenerSQLExecutionEnd](ui/SparkListenerSQLExecutionEnd.md) events.

`ExecutionListenerBus` is a `SparkListener` ([Spark Core]({{ book.spark_core }}/SparkListener)).

## Creating Instance

`ExecutionListenerBus` takes the following to be created:

* <span id="manager"> [ExecutionListenerManager](ExecutionListenerManager.md)
* <span id="session"><span id="sessionUUID"> [SparkSession](SparkSession.md) or Session ID

`ExecutionListenerBus` is created when:

* `ExecutionListenerManager` is [created](ExecutionListenerManager.md#listenerBus)

## <span id="onOtherEvent"> Intercepting Other Events

```scala
onOtherEvent(
  event: SparkListenerEvent): Unit
```

`onOtherEvent` is part of the `SparkListenerInterface` ([Spark Core]({{ book.spark_core }}/SparkListenerInterface#onOtherEvent)) abstraction.

---

`onOtherEvent` [post](#doPostEvent) the given [SparkListenerSQLExecutionEnd](ui/SparkListenerSQLExecutionEnd.md) to all registered [QueryExecutionListener](QueryExecutionListener.md)s.

## <span id="doPostEvent"> Notifying QueryExecutionListener about SparkListenerSQLExecutionEnd

```scala
doPostEvent(
  listener: QueryExecutionListener,
  event: SparkListenerSQLExecutionEnd): Unit
```

`doPostEvent` is part of the `ListenerBus` ([Spark Core]({{ book.spark_core }}/ListenerBus#doPostEvent)) abstraction.

---

`doPostEvent`...FIXME
