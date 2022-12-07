# SortExec Physical Operator

`SortExec` is a [unary physical operator](UnaryExecNode.md) that (most importantly) represents [Sort](../logical-operators/Sort.md) logical operator at execution.

## Creating Instance

`SortExec` takes the following to be created:

* <span id="sortOrder"> [SortOrder](../expressions/SortOrder.md) expressions
* <span id="global"> `global` flag
* <span id="child"> Child [physical operator](SparkPlan.md)
* <span id="testSpillFrequency"> `testSpillFrequency`

`SortExec` is created when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md#Sort) execution planning strategy is executed (with a [Sort](../logical-operators/Sort.md) logical operator)
* `FileFormatWriter` utility is used to [write out a query result](../datasources/FileFormatWriter.md#write)
* [EnsureRequirements](../physical-optimizations/EnsureRequirements.md) physical optimization is executed

## <span id="metrics"> Performance Metrics

### <span id="peakMemory"> peak memory

### <span id="sortTime"> sort time

### <span id="spillSize"> spill size

Number of in-memory bytes spilled by this operator at [execution](#doExecute) (while an [UnsafeExternalRowSorter](#createSorter) was [sorting](../UnsafeExternalRowSorter.md#sort) the rows in a partition)

The `spill size` metric is computed using `TaskMetrics` ([Spark Core]({{ book.spark_core }}/executor/TaskMetrics#memoryBytesSpilled)) and is a difference of the metric before and after [sorting](../UnsafeExternalRowSorter.md#sort).

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

`createSorter` [creates a BaseOrdering](../expressions/RowOrdering.md#create) for the [sortOrders](#sortOrder) and the [output schema](#output).

`createSorter` uses [spark.sql.sort.enableRadixSort](../configuration-properties.md#spark.sql.sort.enableRadixSort) configuration property to enable radix sort when possible.

??? note "Radix Sort, Sort Order and Supported Data Types"
    Radix sort can be used when there is exactly one [sortOrder](#sortOrder) that can be satisfied (based on the data type) with a radix sort on the prefix.

    The following data types are supported:

    * `AnsiIntervalType`
    * `BooleanType`
    * `ByteType`
    * `DateType`
    * `DecimalType` (up to `18` precision digits)
    * `DoubleType`
    * `FloatType`
    * `IntegerType`
    * `LongType`
    * `ShortType`
    * `TimestampNTZType`
    * `TimestampType`

`createSorter` [creates an UnsafeExternalRowSorter](../UnsafeExternalRowSorter.md#create) with the following:

* `spark.buffer.pageSize` (default: `64MB`) for a page size
* Whether radix sort can be used
* _others_

---

`createSorter` is used when:

* `SortExec` is [executed](#doExecute) (one per partition)
* `FileFormatWriter` utility is used to [write out a query result](../datasources/FileFormatWriter.md#write)

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
