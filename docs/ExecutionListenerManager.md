# ExecutionListenerManager

`ExecutionListenerManager` is a frontend (_facade_) of [ExecutionListenerBus](#listenerBus) to manage [QueryExecutionListener](QueryExecutionListener.md)s (in a [SparkSession](#session)).

## Creating Instance

`ExecutionListenerManager` takes the following to be created:

* <span id="session"> [SparkSession](SparkSession.md)
* <span id="sqlConf"> [SQLConf](SQLConf.md)
* [loadExtensions](#loadExtensions) flag

`ExecutionListenerManager` is created when:

* `BaseSessionStateBuilder` is requested for the session [ExecutionListenerManager](BaseSessionStateBuilder.md#listenerManager) (while `SessionState` is [built](BaseSessionStateBuilder.md#build))
* `ExecutionListenerManager` is requested to [clone](#clone)

## <span id="listenerBus"> ExecutionListenerBus

`ExecutionListenerManager` creates an [ExecutionListenerBus](ExecutionListenerBus.md) when [created](#creating-instance) with the following:

* This `ExecutionListenerManager`
* [SparkSession](#session)

The `ExecutionListenerBus` is used for the following:

* [Register a QueryExecutionListener](#register)
* [Unregister a QueryExecutionListener](#unregister)
* [Unregister all QueryExecutionListeners](#clear)
* [clone](#clone)

## <span id="listenerManager"> Accessing ExecutionListenerManager

`ExecutionListenerManager` is available as [SparkSession.listenerManager](SparkSession.md#listenerManager) (and [SessionState.listenerManager](SessionState.md#listenerManager)).

```text
scala> :type spark.listenerManager
org.apache.spark.sql.util.ExecutionListenerManager
```

```text
scala> :type spark.sessionState.listenerManager
org.apache.spark.sql.util.ExecutionListenerManager
```

## <span id="loadExtensions"><span id="spark.sql.queryExecutionListeners"> spark.sql.queryExecutionListeners

`ExecutionListenerManager` is given `loadExtensions` flag when [created](#creating-instance).

When enabled, `ExecutionListenerManager` [registers](#register) the [QueryExecutionListener](QueryExecutionListener.md)s that are configured using the [spark.sql.queryExecutionListeners](StaticSQLConf.md#spark.sql.queryExecutionListeners) configuration property.

## <span id="clear"> Removing All QueryExecutionListeners

```scala
clear(): Unit
```

## <span id="register"> Registering QueryExecutionListener

```scala
register(
  listener: QueryExecutionListener): Unit
```

`register` requests the [ExecutionListenerBus](#listenerBus) to register the given [QueryExecutionListener](QueryExecutionListener.md).

---

`register` is used when:

* `Observation` is requested to [register](Observation.md#register)
* `ExecutionListenerManager` is [created](#creating-instance) and [cloned](#clone)

## <span id="unregister"> De-registering QueryExecutionListener

```scala
unregister(
  listener: QueryExecutionListener): Unit
```

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.util.ExecutionListenerManager` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
log4j.logger.org.apache.spark.sql.util.ExecutionListenerManager=ALL
```

Refer to [Logging](spark-logging.md).
