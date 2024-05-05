---
title: BroadcastExchangeExec
---

# BroadcastExchangeExec Unary Physical Operator for Broadcast Joins

`BroadcastExchangeExec` is an [BroadcastExchangeLike](BroadcastExchangeLike.md) unary physical operator to collect and broadcast rows of a child relation (to worker nodes).

`BroadcastExchangeExec` is <<creating-instance, created>> when [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization is executed (that can really be either BroadcastHashJoinExec.md[BroadcastHashJoinExec] or BroadcastNestedLoopJoinExec.md[BroadcastNestedLoopJoinExec] operators).

```text
val t1 = spark.range(5)
val t2 = spark.range(5)
val q = t1.join(t2).where(t1("id") === t2("id"))

scala> q.explain
== Physical Plan ==
*BroadcastHashJoin [id#19L], [id#22L], Inner, BuildRight
:- *Range (0, 5, step=1, splits=Some(8))
+- BroadcastExchange HashedRelationBroadcastMode(List(input[0, bigint, false]))
   +- *Range (0, 5, step=1, splits=Some(8))
```

[[outputPartitioning]]
`BroadcastExchangeExec` uses [BroadcastPartitioning](Partitioning.md#BroadcastPartitioning) partitioning scheme (with the input <<mode, BroadcastMode>>).

=== [[doExecuteBroadcast]] Waiting Until Relation Has Been Broadcast -- `doExecuteBroadcast` Method

[source, scala]
----
def doExecuteBroadcast[T](): broadcast.Broadcast[T]
----

`doExecuteBroadcast` waits until the <<relationFuture, rows are broadcast>>.

NOTE: `doExecuteBroadcast` waits [spark.sql.broadcastTimeout](../SQLConf.md#broadcastTimeout) (defaults to 5 minutes).

NOTE: `doExecuteBroadcast` is part of SparkPlan.md#doExecuteBroadcast[SparkPlan Contract] to return the result of a structured query as a broadcast variable.

=== [[relationFuture]] Lazily-Once-Initialized Asynchronously-Broadcast `relationFuture` Internal Attribute

[source, scala]
----
relationFuture: Future[broadcast.Broadcast[Any]]
----

When "materialized" (aka _executed_), `relationFuture` finds the current [execution id](../SQLExecution.md#spark.sql.execution.id) and sets it to the `Future` thread.

`relationFuture` requests <<child, child physical operator>> to SparkPlan.md#executeCollectIterator[executeCollectIterator].

`relationFuture` records the time for `executeCollectIterator` in <<collectTime, collectTime>> metrics.

NOTE: `relationFuture` accepts a relation with up to 512 millions rows and 8GB in size, and reports a `SparkException` if the conditions are violated.

`relationFuture` requests the input <<mode, BroadcastMode>> to `transform` the internal rows to create a relation, e.g. [HashedRelation](HashedRelation.md) or a `Array[InternalRow]`.

`relationFuture` calculates the data size:

* For a `HashedRelation`, `relationFuture` requests it to [estimatedSize](../KnownSizeEstimation.md#estimatedSize)

* For a `Array[InternalRow]`, `relationFuture` transforms the `InternalRows` to UnsafeRow.md[UnsafeRows] and requests each to UnsafeRow.md#getSizeInBytes[getSizeInBytes] that it sums all up.

`relationFuture` records the data size as the <<dataSize, dataSize>> metric.

`relationFuture` records the <<buildTime, buildTime>> metric.

`relationFuture` requests the SparkPlan.md#sparkContext[SparkContext] to `broadcast` the relation and records the time in <<broadcastTime, broadcastTime>> metrics.

In the end, `relationFuture` requests `SQLMetrics` to [post a SparkListenerDriverAccumUpdates](../SQLMetric.md#postDriverMetricUpdates) (with the execution id and the SQL metrics) and returns the broadcast internal rows.

NOTE: Since initialization of `relationFuture` happens on the driver, [posting a SparkListenerDriverAccumUpdates](../SQLMetric.md#postDriverMetricUpdates) is the only way how all the SQL metrics could be accessible to other subsystems using `SparkListener` listeners (incl. web UI).

In case of `OutOfMemoryError`, `relationFuture` reports another `OutOfMemoryError` with the following message:

[options="wrap"]
----
Not enough memory to build and broadcast the table to all worker nodes. As a workaround, you can either disable broadcast by setting spark.sql.autoBroadcastJoinThreshold to -1 or increase the spark driver memory by setting spark.driver.memory to a higher value
----

[[executionContext]]
NOTE: `relationFuture` is executed on a separate thread from a custom https://www.scala-lang.org/api/2.11.8/index.html#scala.concurrent.ExecutionContext[scala.concurrent.ExecutionContext] (built from a cached https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ThreadPoolExecutor.html[java.util.concurrent.ThreadPoolExecutor] with the prefix *broadcast-exchange* and up to 128 threads).

NOTE: `relationFuture` is used when `BroadcastExchangeExec` is requested to <<doPrepare, prepare for execution>> (that triggers asynchronous execution of the child operator and broadcasting the result) and <<doExecuteBroadcast, execute broadcast>> (that waits until the broadcasting has finished).

=== [[doPrepare]] Broadcasting Relation (Rows) Asynchronously -- `doPrepare` Method

[source, scala]
----
doPrepare(): Unit
----

NOTE: `doPrepare` is part of SparkPlan.md#doPrepare[SparkPlan Contract] to prepare a physical operator for execution.

`doPrepare` simply "materializes" the internal lazily-once-initialized <<relationFuture, asynchronous broadcast>>.

=== [[creating-instance]] Creating BroadcastExchangeExec Instance

`BroadcastExchangeExec` takes the following when created:

* [[mode]] [BroadcastMode](BroadcastMode.md)
* [[child]] Child [logical plan](../logical-operators/LogicalPlan.md)

## <span id="metrics"> Performance Metrics

Key             | Name (in web UI)        | Description
----------------|-------------------------|---------
 broadcastTime  | time to broadcast (ms)  |
 buildTime      | time to build (ms)      |
 collectTime    | time to collect (ms)    |
 dataSize       | data size (bytes)       |

![BroadcastExchangeExec in web UI (Details for Query)](../images/spark-sql-BroadcastExchangeExec-webui-details-for-query.png)
