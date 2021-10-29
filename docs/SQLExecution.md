# SQLExecution

## <span id="EXECUTION_ID_KEY"><span id=spark.sql.execution.id"> spark.sql.execution.id

`SQLExecution` defines `spark.sql.execution.id` Spark property that is used to track multiple Spark jobs that should all together constitute a single execution of a structured query (and could be reported as a single execution unit).

```scala
import org.apache.spark.sql.execution.SQLExecution
scala> println(SQLExecution.EXECUTION_ID_KEY)
spark.sql.execution.id
```

Actions of a structured query are executed using <<withNewExecutionId, SQLExecution.withNewExecutionId>> static method that sets <<spark.sql.execution.id, spark.sql.execution.id>> as Spark Core's spark-sparkcontext-local-properties.md#setLocalProperty[local property] and "stitches" different Spark jobs as parts of one structured query action (that you can then see in web UI's [SQL tab](SQLTab.md)).

[TIP]
====
Use `SparkListener` (Spark Core) to listen to [SparkListenerSQLExecutionStart](SQLListener.md#SparkListenerSQLExecutionStart) events and know the execution ids of structured queries that have been executed in a Spark SQL application.

[source, scala]
----
// "SQLAppStatusListener" idea is borrowed from
// Spark SQL's org.apache.spark.sql.execution.ui.SQLAppStatusListener
import org.apache.spark.scheduler.{SparkListener, SparkListenerEvent}
import org.apache.spark.sql.execution.ui.{SparkListenerDriverAccumUpdates, SparkListenerSQLExecutionEnd, SparkListenerSQLExecutionStart}
public class SQLAppStatusListener extends SparkListener {
  override def onOtherEvent(event: SparkListenerEvent): Unit = event match {
    case e: SparkListenerSQLExecutionStart => onExecutionStart(e)
    case e: SparkListenerSQLExecutionEnd => onExecutionEnd(e)
    case e: SparkListenerDriverAccumUpdates => onDriverAccumUpdates(e)
    case _ => // Ignore
  }
  def onExecutionStart(event: SparkListenerSQLExecutionStart): Unit = {
    // Find the QueryExecution for the Dataset action that triggered the event
    // This is the SQL-specific way
    import org.apache.spark.sql.execution.SQLExecution
    queryExecution = SQLExecution.getQueryExecution(event.executionId)
  }
  def onJobStart(jobStart: SparkListenerJobStart): Unit = {
    // Find the QueryExecution for the Dataset action that triggered the event
    // This is a general Spark Core way using local properties
    import org.apache.spark.sql.execution.SQLExecution
    val executionIdStr = jobStart.properties.getProperty(SQLExecution.EXECUTION_ID_KEY)
    // Note that the Spark job may or may not be a part of a structured query
    if (executionIdStr != null) {
      queryExecution = SQLExecution.getQueryExecution(executionIdStr.toLong)
    }
  }
  def onExecutionEnd(event: SparkListenerSQLExecutionEnd): Unit = {}
  def onDriverAccumUpdates(event: SparkListenerDriverAccumUpdates): Unit = {}
}

val sqlListener = new SQLAppStatusListener()
spark.sparkContext.addSparkListener(sqlListener)
----
====

NOTE: Jobs without <<spark.sql.execution.id, spark.sql.execution.id>> key are not considered to belong to SQL query executions.

[[executionIdToQueryExecution]]
`SQLExecution` keeps track of all execution ids and their [QueryExecutions](QueryExecution.md) in `executionIdToQueryExecution` internal registry.

TIP: Use <<getQueryExecution, SQLExecution.getQueryExecution>> to find the [QueryExecution](QueryExecution.md) for an execution id.

=== [[withNewExecutionId]] Executing Dataset Action (with Zero or More Spark Jobs) Under New Execution Id -- `withNewExecutionId` Method

[source, scala]
----
withNewExecutionId[T](
  sparkSession: SparkSession,
  queryExecution: QueryExecution)(body: => T): T
----

`withNewExecutionId` executes `body` query action with a new <<spark.sql.execution.id, execution id>> (given as the input `executionId` or auto-generated) so that all Spark jobs that have been scheduled by the query action could be marked as parts of the same `Dataset` action execution.

`withNewExecutionId` allows for collecting all the Spark jobs (even executed on separate threads) together under a single SQL query execution for reporting purposes, e.g. to [reporting them as one single structured query in web UI](SQLTab.md).

NOTE: If there is another execution id already set, it is replaced for the course of the current action.

In addition, the `QueryExecution` variant posts [SparkListenerSQLExecutionStart](SQLListener.md#SparkListenerSQLExecutionStart) and [SparkListenerSQLExecutionEnd](SQLListener.md#SparkListenerSQLExecutionEnd) events (to spark-LiveListenerBus.md[LiveListenerBus] event bus) before and after executing the `body` action, respectively. It is used to inform [`SQLListener` when a SQL query execution starts and ends](SQLListener.md#onOtherEvent).

NOTE: Nested execution ids are not supported in the `QueryExecution` variant.

`withNewExecutionId` is used when:

* `Dataset` is requested to [Dataset.withNewExecutionId](Dataset.md#withNewExecutionId) and [Dataset.withAction](Dataset.md#withAction)

* `DataFrameWriter` is requested to [run a command](DataFrameWriter.md#runCommand)

* (Spark Structured Streaming) `StreamExecution` commits a batch to a streaming sink

* (Spark Thrift Server) `SparkSQLDriver` runs a command

=== [[getQueryExecution]] Finding QueryExecution for Execution ID -- `getQueryExecution` Method

[source, scala]
----
getQueryExecution(executionId: Long): QueryExecution
----

`getQueryExecution` simply gives the [QueryExecution](QueryExecution.md) for the `executionId` or `null` if not found.

=== [[withExecutionId]] Executing Action (with Zero or More Spark Jobs) Tracked Under Given Execution Id -- `withExecutionId` Method

[source, scala]
----
withExecutionId[T](
  sc: SparkContext,
  executionId: String)(body: => T): T
----

`withExecutionId` executes the `body` action as part of executing multiple Spark jobs under `executionId` <<EXECUTION_ID_KEY, execution identifier>>.

[source, scala]
----
def body = println("Hello World")
scala> SQLExecution.withExecutionId(sc = spark.sparkContext, executionId = "Custom Name")(body)
Hello World
----

[NOTE]
====
`withExecutionId` is used when:

* `BroadcastExchangeExec` is requested to BroadcastExchangeExec.md#doPrepare[prepare for execution] (and initializes BroadcastExchangeExec.md#relationFuture[relationFuture] for the first time)

* `SubqueryExec` is requested to SubqueryExec.md#doPrepare[prepare for execution] (and initializes SubqueryExec.md#relationFuture[relationFuture] for the first time)
====

=== [[checkSQLExecutionId]] `checkSQLExecutionId` Method

[source, scala]
----
checkSQLExecutionId(sparkSession: SparkSession): Unit
----

`checkSQLExecutionId`...FIXME

`checkSQLExecutionId` is used when `FileFormatWriter` is used to [write out a query result](FileFormatWriter.md#write).

=== [[withSQLConfPropagated]] `withSQLConfPropagated` Method

[source, scala]
----
withSQLConfPropagated[T](sparkSession: SparkSession)(body: => T): T
----

`withSQLConfPropagated`...FIXME

[NOTE]
====
`withSQLConfPropagated` is used when:

* `SQLExecution` is requested to <<withNewExecutionId, withNewExecutionId>> and <<withExecutionId, withExecutionId>>

* `TextInputJsonDataSource` is requested to `inferFromDataset`

* `MultiLineJsonDataSource` is requested to `infer`
====
