title: SortExec

# SortExec Unary Physical Operator

`SortExec` is a [unary physical operator](UnaryExecNode.md) that is <<creating-instance, created>> when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md#Sort) execution planning strategy is executed

* <<spark-sql-FileFormatWriter.md#, FileFormatWriter>> helper object is requested to <<spark-sql-FileFormatWriter.md#write, write the result of a structured query>>

* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization is executed

`SortExec` supports [Java code generation](CodegenSupport.md) (aka _codegen_).

```text
val q = Seq((0, "zero"), (1, "one")).toDF("id", "name").sort('id)
val qe = q.queryExecution

val logicalPlan = qe.analyzed
scala> println(logicalPlan.numberedTreeString)
00 Sort [id#72 ASC NULLS FIRST], true
01 +- Project [_1#69 AS id#72, _2#70 AS name#73]
02    +- LocalRelation [_1#69, _2#70]

// BasicOperators does the conversion of Sort logical operator to SortExec
val sparkPlan = qe.sparkPlan
scala> println(sparkPlan.numberedTreeString)
00 Sort [id#72 ASC NULLS FIRST], true, 0
01 +- LocalTableScan [id#72, name#73]

// SortExec supports Whole-Stage Code Generation
val executedPlan = qe.executedPlan
scala> println(executedPlan.numberedTreeString)
00 *(1) Sort [id#72 ASC NULLS FIRST], true, 0
01 +- Exchange rangepartitioning(id#72 ASC NULLS FIRST, 200)
02    +- LocalTableScan [id#72, name#73]

import org.apache.spark.sql.execution.SortExec
val sortExec = executedPlan.collect { case se: SortExec => se }.head
assert(sortExec.isInstanceOf[SortExec])
```

[[output]]
When requested for the <<catalyst/QueryPlan.md#output, output attributes>>, `SortExec` simply gives whatever the <<child, child operator>> uses.

[[outputOrdering]]
`SortExec` uses the <<sortOrder, sorting order expressions>> for the <<SparkPlan.md#outputOrdering, output data ordering requirements>>.

[[outputPartitioning]]
When requested for the <<SparkPlan.md#outputPartitioning, output data partitioning requirements>>, `SortExec` simply gives whatever the <<child, child operator>> uses.

[[requiredChildDistribution]]
When requested for the <<SparkPlan.md#requiredChildDistribution, required partition requirements>>, `SortExec` gives the [OrderedDistribution](OrderedDistribution.md) (with the <<sortOrder, sorting order expressions>> for the [ordering](OrderedDistribution.md#ordering)) when the <<global, global>> flag is enabled (`true`) or the [UnspecifiedDistribution](UnspecifiedDistribution.md).

`SortExec` operator uses the [spark.sql.sort.enableRadixSort](../SQLConf.md#spark.sql.sort.enableRadixSort) internal configuration property (enabled by default) to control...FIXME

[[metrics]]
.SortExec's Performance Metrics
[cols="1,2,2",options="header",width="100%"]
|===
| Key
| Name (in web UI)
| Description

| `peakMemory`
| peak memory
| [[peakMemory]]

| `sortTime`
| sort time
| [[sortTime]]

| `spillSize`
| spill size
| [[spillSize]]
|===

=== [[creating-instance]] Creating SortExec Instance

`SortExec` takes the following when created:

* [[sortOrder]] <<spark-sql-Expression-SortOrder.md#, Sorting order expressions>> (`Seq[SortOrder]`)
* [[global]] `global` flag
* [[child]] Child <<SparkPlan.md#, physical plan>>
* [[testSpillFrequency]] `testSpillFrequency` (default: `0`)
