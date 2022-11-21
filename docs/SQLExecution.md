# SQLExecution

## <span id="EXECUTION_ID_KEY"><span id=spark.sql.execution.id"> spark.sql.execution.id

`SQLExecution` defines `spark.sql.execution.id` that is used as the key of the Spark local property in the following:

* [withNewExecutionId](#withNewExecutionId)
* [withExecutionId](#withExecutionId)

`spark.sql.execution.id` is used to track multiple Spark jobs that should all together be considered part of a single execution of a structured query.

```scala
import org.apache.spark.sql.execution.SQLExecution
scala> println(SQLExecution.EXECUTION_ID_KEY)
spark.sql.execution.id
```

`spark.sql.execution.id` allows "stitching" different Spark jobs (esp. executed on separate threads) as part of one structured query (that you can then see in web UI's [SQL tab](ui/SQLTab.md)).

!!! tip
    Use `SparkListener` ([Spark Core]({{ book.spark_core }}/SparkListener)) to listen to `SparkListenerSQLExecutionStart` events and know the execution IDs of structured queries that have been executed in a Spark SQL application.

    ```scala
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
    ```

Spark jobs without `spark.sql.execution.id` local property can then be considered to belong to a SQL query execution.

## <span id="withNewExecutionId"> withNewExecutionId

```scala
withNewExecutionId[T](
  queryExecution: QueryExecution,
  name: Option[String] = None)(
  body: => T): T
```

`withNewExecutionId` executes `body` query action with a next available [execution ID](#spark.sql.execution.id).

`withNewExecutionId` replaces an existing execution ID, if defined, until the entire `body` finishes.

`withNewExecutionId` posts `SparkListenerSQLExecutionStart` and [SparkListenerSQLExecutionEnd](ui/SparkListenerSQLExecutionEnd.md) events right before and right after executing the `body` action, respectively.

---

`withNewExecutionId` is used when:

* `Dataset` is requested to [withNewExecutionId](Dataset.md#withNewExecutionId), [withNewRDDExecutionId](Dataset.md#withNewRDDExecutionId), [Dataset.withAction](Dataset.md#withAction)
* `QueryExecution` is requested to [eagerlyExecuteCommands](QueryExecution.md#eagerlyExecuteCommands)
* _others_ (in Spark Thrift Server and [Spark Structured Streaming]({{ book.structured_streaming }}))

## <span id="withExecutionId"> withExecutionId

```scala
withExecutionId[T](
  sparkSession: SparkSession,
  executionId: String)(
  body: => T): T
```

`withExecutionId` executes the `body` under the given `executionId` [execution identifier](#EXECUTION_ID_KEY).

```text
val rdd = sc.parallelize(0 to 5, numSlices = 2)

import org.apache.spark.TaskContext
def func(ctx: TaskContext, ns: Iterator[Int]): Int = {
  ctx.partitionId
}

def runSparkJobs = {
  sc.runJob(rdd, func _)
}

import org.apache.spark.sql.execution.SQLExecution
SQLExecution.withExecutionId(spark, executionId = "100")(body = runSparkJobs)
```

---

`withExecutionId` is used when:

* `BroadcastExchangeExec` physical operator is requested to [prepare for execution](physical-operators/BroadcastExchangeExec.md#doPrepare) (and initializes [relationFuture](physical-operators/BroadcastExchangeExec.md#relationFuture))
* `SubqueryExec` physical operator is requested to [prepare for execution](physical-operators/SubqueryExec.md#doPrepare) (and initializes [relationFuture](physical-operators/SubqueryExec.md#relationFuture))
