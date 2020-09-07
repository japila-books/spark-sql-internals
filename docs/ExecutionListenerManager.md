title: ExecutionListenerManager

# ExecutionListenerManager -- Management Interface of QueryExecutionListeners

`ExecutionListenerManager` is the <<methods, management interface>> for `QueryExecutionListeners` that listen for execution metrics:

* Name of the action (that triggered a query execution)

* [QueryExecution](QueryExecution.md)

* Execution time of this query (in nanoseconds)

`ExecutionListenerManager` is available as SparkSession.md#listenerManager[listenerManager] property of `SparkSession` (and SessionState.md#listenerManager[listenerManager] property of `SessionState`).

[source, scala]
----
scala> :type spark.listenerManager
org.apache.spark.sql.util.ExecutionListenerManager

scala> :type spark.sessionState.listenerManager
org.apache.spark.sql.util.ExecutionListenerManager
----

[[conf]]
[[creating-instance]]
`ExecutionListenerManager` takes a single `SparkConf` when created

While <<creating-instance, created>>, `ExecutionListenerManager` reads StaticSQLConf.md#spark.sql.queryExecutionListeners[spark.sql.queryExecutionListeners] configuration property with `QueryExecutionListeners` and <<register, registers>> them.

[[spark.sql.queryExecutionListeners]]
`ExecutionListenerManager` uses StaticSQLConf.md#spark.sql.queryExecutionListeners[spark.sql.queryExecutionListeners] configuration property as the list of `QueryExecutionListeners` that should be automatically added to newly created sessions (and registers them while <<creating-instance, being created>>).

[[methods]]
.ExecutionListenerManager's Public Methods
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| <<register, register>>
a|

[source, scala]
----
register(listener: QueryExecutionListener): Unit
----

| <<unregister, unregister>>
a|

[source, scala]
----
unregister(listener: QueryExecutionListener): Unit
----

| <<clear, clear>>
a|

[source, scala]
----
clear(): Unit
----
|===

`ExecutionListenerManager` is <<creating-instance, created>> exclusively when `BaseSessionStateBuilder` is requested for BaseSessionStateBuilder.md#listenerManager[ExecutionListenerManager] (while `SessionState` is BaseSessionStateBuilder.md#build[built]).

[[listeners]]
`ExecutionListenerManager` uses `listeners` internal registry for registered <<spark-sql-QueryExecutionListener.md#, QueryExecutionListeners>>.

=== [[onSuccess]] `onSuccess` Internal Method

[source, scala]
----
onSuccess(funcName: String, qe: QueryExecution, duration: Long): Unit
----

`onSuccess`...FIXME

[NOTE]
====
`onSuccess` is used when:

* `DataFrameWriter` is requested to spark-sql-DataFrameWriter.md#runCommand[run a logical command] (after it has finished with no exceptions)

* `Dataset` is requested to spark-sql-Dataset.md#withAction[withAction]
====

=== [[onFailure]] `onFailure` Internal Method

[source, scala]
----
onFailure(funcName: String, qe: QueryExecution, exception: Exception): Unit
----

`onFailure`...FIXME

[NOTE]
====
`onFailure` is used when:

* `DataFrameWriter` is requested to spark-sql-DataFrameWriter.md#runCommand[run a logical command] (after it has reported an exception)

* `Dataset` is requested to spark-sql-Dataset.md#withAction[withAction]
====

=== [[withErrorHandling]] `withErrorHandling` Internal Method

[source, scala]
----
withErrorHandling(f: QueryExecutionListener => Unit): Unit
----

`withErrorHandling`...FIXME

NOTE: `withErrorHandling` is used when `ExecutionListenerManager` is requested to <<onSuccess, onSuccess>> and <<onFailure, onFailure>>.

=== [[register]] Registering QueryExecutionListener -- `register` Method

[source, scala]
----
register(listener: QueryExecutionListener): Unit
----

Internally, `register` simply registers (adds) the input <<spark-sql-QueryExecutionListener.md#, QueryExecutionListener>> to the <<listeners, listeners>> internal registry.
