# ExecutionListenerManager

`ExecutionListenerManager` is the [management interface](#management-interface) for Spark developers to manage session-bound [QueryExecutionListener](QueryExecutionListener.md)s.

## Management Interface

### <span id="clear"> Removing All QueryExecutionListeners

```scala
clear(): Unit
```

### <span id="register"> Registering QueryExecutionListener

```scala
register(
  listener: QueryExecutionListener): Unit
```

### <span id="unregister"> De-registering QueryExecutionListener

```scala
unregister(
  listener: QueryExecutionListener): Unit
```

## <span id="listenerManager"> SparkSession

`ExecutionListenerManager` is available as [SparkSession.listenerManager](SparkSession.md#listenerManager) (and [SessionState.listenerManager](SessionState.md#listenerManager)).

```text
scala> :type spark.listenerManager
org.apache.spark.sql.util.ExecutionListenerManager
```

```text
scala> :type spark.sessionState.listenerManager
org.apache.spark.sql.util.ExecutionListenerManager
```

## <span id="loadExtensions"><span id="spark.sql.queryExecutionListeners"> loadExtensions Flag and spark.sql.queryExecutionListeners

`ExecutionListenerManager` is given `loadExtensions` flag when [created](#creating-instance).

When enabled, `ExecutionListenerManager` [registers](#register) the [QueryExecutionListener](QueryExecutionListener.md)s that are configured using the [spark.sql.queryExecutionListeners](StaticSQLConf.md#spark.sql.queryExecutionListeners) configuration property.

## Creating Instance

`ExecutionListenerManager` takes the following to be created:

* <span id="session"> [SparkSession](SparkSession.md)
* [loadExtensions](#loadExtensions) flag

`ExecutionListenerManager` is created when:

* `BaseSessionStateBuilder` is requested for the session-bound [ExecutionListenerManager](BaseSessionStateBuilder.md#listenerManager) (while `SessionState` is [built](BaseSessionStateBuilder.md#build))

## <span id="onSuccess"> onSuccess

```scala
onSuccess(
  funcName: String,
  qe: QueryExecution,
  duration: Long): Unit
```

`onSuccess`...FIXME

`onSuccess` is used when:

* `DataFrameWriter` is requested to [run a logical command](DataFrameWriter.md#runCommand) (after it has finished with no exceptions)
* `Dataset` is requested to [withAction](Dataset.md#withAction)

## <span id="onFailure"> onFailure

```scala
onFailure(
  funcName: String,
  qe: QueryExecution,
  exception: Exception): Unit
```

`onFailure`...FIXME

`onFailure` is used when:

* `DataFrameWriter` is requested to [run a logical command](DataFrameWriter.md#runCommand) (after it has reported an exception)
* `Dataset` is requested to [withAction](Dataset.md#withAction)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.util.ExecutionListenerManager` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.util.ExecutionListenerManager=ALL
```

Refer to [Logging](spark-logging.md).
