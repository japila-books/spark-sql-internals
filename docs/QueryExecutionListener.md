# QueryExecutionListener

`QueryExecutionListener` is an [abstraction](#contract) of [query execution listeners](#implementations) that can intercept [onFailure](#onFailure) and [onSuccess](#onSuccess) events.

## Contract

### <span id="onFailure"> onFailure

```scala
onFailure(
  funcName: String,
  qe: QueryExecution,
  exception: Exception): Unit
```

Used when:

* `ExecutionListenerBus` is requested to [doPostEvent](ExecutionListenerBus.md#doPostEvent)

### <span id="onSuccess"> onSuccess

```scala
onSuccess(
  funcName: String,
  qe: QueryExecution,
  durationNs: Long): Unit
```

Used when:

* `ExecutionListenerBus` is requested to [doPostEvent](ExecutionListenerBus.md#doPostEvent)

## Implementations

* `ObservationListener`
