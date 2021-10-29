# LocalTableScanExec Leaf Physical Operator

`LocalTableScanExec` is a [leaf physical operator](SparkPlan.md#LeafExecNode) and `producedAttributes` being `outputSet`.

`LocalTableScanExec` is <<creating-instance, created>> when [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy resolves LocalRelation.md[LocalRelation] and Spark Structured Streaming's `MemoryPlan` logical operators.

TIP: Read on `MemoryPlan` logical operator in the https://jaceklaskowski.gitbooks.io/spark-structured-streaming/spark-sql-streaming-MemoryPlan.html[Spark Structured Streaming] gitbook.

[source, scala]
----
val names = Seq("Jacek", "Agata").toDF("name")
val optimizedPlan = names.queryExecution.optimizedPlan

scala> println(optimizedPlan.numberedTreeString)
00 LocalRelation [name#9]

// Physical plan with LocalTableScanExec operator (shown as LocalTableScan)
scala> names.explain
== Physical Plan ==
LocalTableScan [name#9]

// Going fairly low-level...you've been warned

val plan = names.queryExecution.executedPlan
import org.apache.spark.sql.execution.LocalTableScanExec
val ltse = plan.asInstanceOf[LocalTableScanExec]

val ltseRDD = ltse.execute()
scala> :type ltseRDD
org.apache.spark.rdd.RDD[org.apache.spark.sql.catalyst.InternalRow]

scala> println(ltseRDD.toDebugString)
(2) MapPartitionsRDD[1] at execute at <console>:30 []
 |  ParallelCollectionRDD[0] at execute at <console>:30 []

// no computation on the source dataset has really occurred yet
// Let's trigger a RDD action
scala> ltseRDD.first
res6: org.apache.spark.sql.catalyst.InternalRow = [0,1000000005,6b6563614a]

// Low-level "show"
scala> ltseRDD.foreach(println)
[0,1000000005,6b6563614a]
[0,1000000005,6174616741]

// High-level show
scala> names.show
+-----+
| name|
+-----+
|Jacek|
|Agata|
+-----+
----

[[internal-registries]]
.LocalTableScanExec's Internal Properties
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| [[unsafeRows]] `unsafeRows`
| [InternalRow](../InternalRow.md)s

| [[numParallelism]] `numParallelism`
|

| [[rdd]] `rdd`
|
|===

## Creating Instance

`LocalTableScanExec` takes the following when created:

* [[output]] Output schema [attributes](../expressions/Attribute.md)
* [[rows]] [InternalRow](../InternalRow.md)s

## <span id="metrics"> Performance Metrics

Key             | Name (in web UI)        | Description
----------------|-------------------------|---------
numOutputRows   | number of output rows   | Number of output rows

!!! note
    It _appears_ that when no Spark job is used to execute a `LocalTableScanExec` the <<numOutputRows, numOutputRows>> metric is not displayed in the web UI.

    ```text
    val names = Seq("Jacek", "Agata").toDF("name")

    // The following query gives no numOutputRows metric in web UI's Details for Query (SQL tab)
    scala> names.show
    +-----+
    | name|
    +-----+
    |Jacek|
    |Agata|
    +-----+

    // The query gives numOutputRows metric in web UI's Details for Query (SQL tab)
    scala> names.groupBy(length($"name")).count.show
    +------------+-----+
    |length(name)|count|
    +------------+-----+
    |           5|    2|
    +------------+-----+

    // The (type-preserving) query does also give numOutputRows metric in web UI's Details for Query (SQL tab)
    scala> names.as[String].map(_.toUpperCase).show
    +-----+
    |value|
    +-----+
    |JACEK|
    |AGATA|
    +-----+
    ```

![LocalTableScanExec in web UI (Details for Query)](../images/spark-sql-LocalTableScanExec-webui-query-details.png)
