# LocalTableScanExec Leaf Physical Operator

`LocalTableScanExec` is a [leaf physical operator](SparkPlan.md#LeafExecNode) that represents the following at execution:

* [LocalRelation](../logical-operators/LocalRelation.md) logical operator
* `LocalScan` (under [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md))
* `MemoryPlan` ([Spark Structured Streaming]({{ book.structured_streaming }}/connectors/memory/MemoryPlan))
* `NoopCommand`

![LocalTableScanExec in web UI (Details for Query)](../images/spark-sql-LocalTableScanExec-webui-query-details.png)

## Creating Instance

`LocalTableScanExec` takes the following to be created:

* <span id="output"> Output [Attribute](../expressions/Attribute.md)s
* <span id="rows"> Rows ([InternalRow](../InternalRow.md)s)

`LocalTableScanExec` is created when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (to plan a `MemoryPlan`, a [LocalRelation](../logical-operators/LocalRelation.md), [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) and `NoopCommand` logical operators)

## Performance Metrics

### <span id="numOutputRows"> number of output rows

## <span id="InputRDDCodegen"> InputRDDCodegen

`LocalTableScanExec` is a `InputRDDCodegen`.

## <span id="CollapseCodegenStages"> CollapseCodegenStages

[CollapseCodegenStages](../physical-optimizations/CollapseCodegenStages.md) physical optimization considers `LocalTableScanExec` special when [insertWholeStageCodegen](../physical-optimizations/CollapseCodegenStages.md#insertWholeStageCodegen) (so it won't be the root of [WholeStageCodegen](../whole-stage-code-generation/index.md) to support the fast driver-local collect/take paths).

## Demo

```text
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
```
