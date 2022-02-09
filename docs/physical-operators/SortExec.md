# SortExec Unary Physical Operator

`SortExec` is a [unary physical operator](UnaryExecNode.md) (that, among other use cases, represents [Sort](../logical-operators/Sort.md) logical operators at execution).

## Creating Instance

`SortExec` takes the following to be created:

* <span id="sortOrder"> [SortOrder](../expressions/SortOrder.md) expressions
* <span id="global"> `global` flag
* <span id="child"> Child [physical operator](SparkPlan.md)
* <span id="testSpillFrequency"> `testSpillFrequency` (default: `0`)

`SortExec` is created when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md#Sort) execution planning strategy is executed (with a [Sort](../logical-operators/Sort.md) logical operator)
* `FileFormatWriter` utility is used to [write out a query result](../FileFormatWriter.md#write)
* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization is executed

## <span id="metrics"> Performance Metrics

Key             | Name (in web UI)        | Description
----------------|-------------------------|---------
 peakMemory     | peak memory             |
 sortTime       | sort time               |
 spillSize      | spill size              |

## <span id="enableRadixSort"><span id="spark.sql.sort.enableRadixSort"> Radix Sort

`SortExec` operator uses the [spark.sql.sort.enableRadixSort](../configuration-properties.md#spark.sql.sort.enableRadixSort) configuration property when [creating an UnsafeExternalRowSorter](#createSorter).

## <span id="BlockingOperatorWithCodegen"> BlockingOperatorWithCodegen

`SortExec` is a `BlockingOperatorWithCodegen`.

## <span id="CodegenSupport"> CodegenSupport

`SortExec` supports [Java code generation](CodegenSupport.md) (indirectly as a `BlockingOperatorWithCodegen`).

## <span id="outputOrdering"> Output Data Ordering Requirements

```scala
outputOrdering: Seq[SortOrder]
```

`outputOrdering` is the given [SortOrder](#sortOrder) expressions.

`outputOrdering` is part of the [SparkPlan](SparkPlan.md#outputOrdering) abstraction.

## <span id="requiredChildDistribution"> Required Child Output Distribution

```scala
requiredChildDistribution: Seq[Distribution]
```

`requiredChildDistribution` is a [OrderedDistribution](OrderedDistribution.md) (with the [SortOrder](#sortOrder) expressions) with the [global](#global) flag enabled or a [UnspecifiedDistribution](UnspecifiedDistribution.md).

`requiredChildDistribution` is part of the [SparkPlan](SparkPlan.md#requiredChildDistribution) abstraction.

## Physical Optimizations

### OptimizeSkewedJoin

[OptimizeSkewedJoin](../physical-optimizations/OptimizeSkewedJoin.md) physical optimization is used to optimize skewed [SortMergeJoinExec](SortMergeJoinExec.md)s (with `SortExec` operators) in [Adaptive Query Execution](../adaptive-query-execution/index.md).

### RemoveRedundantSorts

`SortExec` operators can be removed from a physical query plan by [RemoveRedundantSorts](../physical-optimizations/RemoveRedundantSorts.md) physical optimization (with [spark.sql.execution.removeRedundantSorts](../configuration-properties.md#spark.sql.execution.removeRedundantSorts) enabled).

## <span id="createSorter"> Creating UnsafeExternalRowSorter

```scala
createSorter(): UnsafeExternalRowSorter
```

`createSorter`...FIXME

`createSorter` is used when:

* `SortExec` is requested to [execute](#doExecute)
* `FileFormatWriter` utility is used to [write out a query result](../FileFormatWriter.md#write)

## Demo

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
