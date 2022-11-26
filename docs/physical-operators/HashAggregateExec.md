# HashAggregateExec Aggregate Physical Operator

`HashAggregateExec` is a [unary physical operator](BaseAggregateExec.md) for **hash-based aggregation**.

![HashAggregateExec in web UI (Details for Query)](../images/HashAggregateExec-webui-details-for-query.png)

`HashAggregateExec` is a `BlockingOperatorWithCodegen`.

`HashAggregateExec` is an [AliasAwareOutputPartitioning](AliasAwareOutputPartitioning.md).

!!! note
    `HashAggregateExec` is the [preferred aggregate physical operator](../execution-planning-strategies/Aggregation.md#aggregate-physical-operator-preference) for [Aggregation](../execution-planning-strategies/Aggregation.md) execution planning strategy (over [ObjectHashAggregateExec](ObjectHashAggregateExec.md) and [SortAggregateExec](SortAggregateExec.md)).

`HashAggregateExec` supports [Java code generation](CodegenSupport.md) (aka _codegen_).

`HashAggregateExec` uses [TungstenAggregationIterator](TungstenAggregationIterator.md) (to iterate over `UnsafeRows` in partitions) when [executed](#doExecute).

!!! note
    `HashAggregateExec` uses `TungstenAggregationIterator` that can (theoretically) [switch to a sort-based aggregation when the hash-based approach is unable to acquire enough memory](TungstenAggregationIterator.md#switchToSortBasedAggregation).

    See [testFallbackStartsAt](#testFallbackStartsAt) internal property and [spark.sql.TungstenAggregate.testFallbackStartsAt](../configuration-properties.md#spark.sql.TungstenAggregate.testFallbackStartsAt) configuration property.

    Search logs for the following INFO message to know whether the switch has happened.

    ```text
    falling back to sort based aggregation.
    ```

## Creating Instance

`HashAggregateExec` takes the following to be created:

* <span id="requiredChildDistributionExpressions"> Required child distribution [expressions](../expressions/Expression.md)
* <span id="groupingExpressions"> [Named expressions](../expressions/NamedExpression.md) for grouping keys
* <span id="aggregateExpressions"> [AggregateExpression](../expressions/AggregateExpression.md)s
* <span id="aggregateAttributes"> Aggregate [attribute](../expressions/Attribute.md)s
* <span id="initialInputBufferOffset"> Initial input buffer offset
* <span id="resultExpressions"> Output [named expressions](../expressions/NamedExpression.md)
* <span id="child"> Child [physical operator](SparkPlan.md)

`HashAggregateExec` is created when (indirectly through [AggUtils.createAggregate](../AggUtils.md#createAggregate)) when:

* [Aggregation](../execution-planning-strategies/Aggregation.md) execution planning strategy is executed (to select the aggregate physical operator for an [Aggregate](../logical-operators/Aggregate.md) logical operator

* `StatefulAggregationStrategy` (Structured Streaming) execution planning strategy creates plan for streaming `EventTimeWatermark` or [Aggregate](../logical-operators/Aggregate.md) logical operators

## Demo

```text
val q = spark.range(10).
  groupBy('id % 2 as "group").
  agg(sum("id") as "sum")

// HashAggregateExec selected due to:
// 1. sum uses mutable types for aggregate expression
// 2. just a single id column reference of LongType data type
scala> q.explain
== Physical Plan ==
*HashAggregate(keys=[(id#0L % 2)#12L], functions=[sum(id#0L)])
+- Exchange hashpartitioning((id#0L % 2)#12L, 200)
   +- *HashAggregate(keys=[(id#0L % 2) AS (id#0L % 2)#12L], functions=[partial_sum(id#0L)])
      +- *Range (0, 10, step=1, splits=8)

val execPlan = q.queryExecution.sparkPlan
scala> println(execPlan.numberedTreeString)
00 HashAggregate(keys=[(id#0L % 2)#15L], functions=[sum(id#0L)], output=[group#3L, sum#7L])
01 +- HashAggregate(keys=[(id#0L % 2) AS (id#0L % 2)#15L], functions=[partial_sum(id#0L)], output=[(id#0L % 2)#15L, sum#17L])
02    +- Range (0, 10, step=1, splits=8)
```

Going low level...watch your steps :)

```scala
import q.queryExecution.optimizedPlan
import org.apache.spark.sql.catalyst.plans.logical.Aggregate
val aggLog = optimizedPlan.asInstanceOf[Aggregate]
import org.apache.spark.sql.catalyst.planning.PhysicalAggregation
import org.apache.spark.sql.catalyst.expressions.aggregate.AggregateExpression
val (_, aggregateExpressions: Seq[AggregateExpression], _, _) = PhysicalAggregation.unapply(aggLog).get
val aggregateBufferAttributes =
  aggregateExpressions.flatMap(_.aggregateFunction.aggBufferAttributes)
```

```text
import org.apache.spark.sql.execution.aggregate.HashAggregateExec
// that's the exact reason why HashAggregateExec was selected
// Aggregation execution planning strategy prefers HashAggregateExec
scala> val useHash = HashAggregateExec.supportsAggregate(aggregateBufferAttributes)
useHash: Boolean = true

val hashAggExec = execPlan.asInstanceOf[HashAggregateExec]
scala> println(execPlan.numberedTreeString)
00 HashAggregate(keys=[(id#0L % 2)#15L], functions=[sum(id#0L)], output=[group#3L, sum#7L])
01 +- HashAggregate(keys=[(id#0L % 2) AS (id#0L % 2)#15L], functions=[partial_sum(id#0L)], output=[(id#0L % 2)#15L, sum#17L])
02    +- Range (0, 10, step=1, splits=8)

val hashAggExecRDD = hashAggExec.execute // <-- calls doExecute
scala> println(hashAggExecRDD.toDebugString)
(8) MapPartitionsRDD[3] at execute at <console>:30 []
 |  MapPartitionsRDD[2] at execute at <console>:30 []
 |  MapPartitionsRDD[1] at execute at <console>:30 []
 |  ParallelCollectionRDD[0] at execute at <console>:30 []
```

## <span id="metrics"> Performance Metrics

### <span id="aggTime"> aggTime

Name (in web UI): time in aggregation build

### <span id="avgHashProbe"> avgHashProbe

Average hash map probe per lookup (i.e. `numProbes` / `numKeyLookups`)

Name (in web UI): avg hash probe bucket list iters

`numProbes` and `numKeyLookups` are used in [BytesToBytesMap](../spark-sql-BytesToBytesMap.md) append-only hash map for the number of iteration to look up a single key and the number of all the lookups in total, respectively.

### <span id="numOutputRows"> numOutputRows

Average hash map probe per lookup (i.e. `numProbes` / `numKeyLookups`)

Name (in web UI): number of output rows

Number of groups (per partition) that (depending on the number of partitions and the side of ShuffleExchangeExec.md[ShuffleExchangeExec] operator) is the number of groups

* `0` for no input with a grouping expression, e.g. `spark.range(0).groupBy($"id").count.show`

* `1` for no grouping expression and no input, e.g. `spark.range(0).groupBy().count.show`

!!! tip
    Use different number of elements and partitions in `range` operator to observe the difference in `numOutputRows` metric, e.g.

```text
spark.
  range(0, 10, 1, numPartitions = 1).
  groupBy($"id" % 5 as "gid").
  count.
  show

spark.
  range(0, 10, 1, numPartitions = 5).
  groupBy($"id" % 5 as "gid").
  count.
  show
```

### <span id="peakMemory"> peakMemory

Name (in web UI): peak memory

### <span id="spillSize"> spillSize

Name (in web UI): spill size

## <span id="requiredChildDistribution"> Required Child Distribution

```scala
requiredChildDistribution: List[Distribution]
```

`requiredChildDistribution` is part of the [SparkPlan](SparkPlan.md#requiredChildDistribution) abstraction.

`requiredChildDistribution` varies per the input [required child distribution expressions](#requiredChildDistributionExpressions):

* [AllTuples](AllTuples.md) when defined, but empty
* [ClusteredDistribution](ClusteredDistribution.md) for non-empty expressions
* [UnspecifiedDistribution](UnspecifiedDistribution.md) when undefined

!!! note
    `requiredChildDistributionExpressions` is exactly `requiredChildDistributionExpressions` from [AggUtils.createAggregate](../AggUtils.md#createAggregate) and is undefined by default.

    ---

    (No distinct in aggregation) `requiredChildDistributionExpressions` is undefined when `HashAggregateExec` is created for partial aggregations (i.e. `mode` is `Partial` for aggregate expressions).

    `requiredChildDistributionExpressions` is defined, but could possibly be empty, when `HashAggregateExec` is created for final aggregations (i.e. `mode` is `Final` for aggregate expressions).

    ---

    (one distinct in aggregation) `requiredChildDistributionExpressions` is undefined when `HashAggregateExec` is created for partial aggregations (i.e. `mode` is `Partial` for aggregate expressions) with one distinct in aggregation.

    `requiredChildDistributionExpressions` is defined, but could possibly be empty, when `HashAggregateExec` is created for partial merge aggregations (i.e. `mode` is `PartialMerge` for aggregate expressions).

    *FIXME* for the following two cases in aggregation with one distinct.

NOTE: The prefix for variable names for `HashAggregateExec` operators in [CodegenSupport](CodegenSupport.md)-generated code is **agg**.

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute` requests the <<child, child>> physical operator to <<SparkPlan.md#execute, execute>> (that triggers physical query planning and generates an `RDD[InternalRow]`) and transforms it by executing the following function on internal rows per partition with index (using `RDD.mapPartitionsWithIndex` that creates another RDD):

1. Records the start execution time (`beforeAgg`)

1. Requests the `Iterator[InternalRow]` (from executing the <<child, child>> physical operator) for the next element

    * If there is no input (an empty partition), but there are <<groupingExpressions, grouping keys>> used, `doExecute` simply returns an empty iterator

    * Otherwise, `doExecute` creates a <<TungstenAggregationIterator.md#creating-instance, TungstenAggregationIterator>> and branches off per whether there are rows to process and the <<groupingExpressions, grouping keys>>.

For empty partitions and no <<groupingExpressions, grouping keys>>, `doExecute` increments the <<numOutputRows, numOutputRows>> metric and requests the `TungstenAggregationIterator` to <<TungstenAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput, create a single UnsafeRow>> as the only element of the result iterator.

For non-empty partitions or there are <<groupingExpressions, grouping keys>> used, `doExecute` returns the `TungstenAggregationIterator`.

In the end, `doExecute` calculates the <<aggTime, aggTime>> metric and returns an `Iterator[UnsafeRow]` that can be as follows:

* Empty

* A single-element `Iterator[UnsafeRow]` with the <<TungstenAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput, single UnsafeRow>>

* The [TungstenAggregationIterator](TungstenAggregationIterator.md)

!!! note
    The [numOutputRows](#numOutputRows), [peakMemory](#peakMemory), [spillSize](#spillSize) and [avgHashProbe](#avgHashProbe) metrics are used exclusively to create the [TungstenAggregationIterator](TungstenAggregationIterator.md).

!!! note
    `doExecute` (by `RDD.mapPartitionsWithIndex` transformation) adds a new `MapPartitionsRDD` to the RDD lineage. Use `RDD.toDebugString` to see the additional `MapPartitionsRDD`.

    ```text
    val ids = spark.range(1)
    scala> println(ids.queryExecution.toRdd.toDebugString)
    (8) MapPartitionsRDD[12] at toRdd at <console>:29 []
    |  MapPartitionsRDD[11] at toRdd at <console>:29 []
    |  ParallelCollectionRDD[10] at toRdd at <console>:29 []

    // Use groupBy that gives HashAggregateExec operator
    val q = ids.groupBy('id).count
    scala> q.explain
    == Physical Plan ==
    *(2) HashAggregate(keys=[id#30L], functions=[count(1)])
    +- Exchange hashpartitioning(id#30L, 200)
      +- *(1) HashAggregate(keys=[id#30L], functions=[partial_count(1)])
          +- *(1) Range (0, 1, step=1, splits=8)

    val rdd = q.queryExecution.toRdd
    scala> println(rdd.toDebugString)
    (200) MapPartitionsRDD[18] at toRdd at <console>:28 []
      |   ShuffledRowRDD[17] at toRdd at <console>:28 []
      +-(8) MapPartitionsRDD[16] at toRdd at <console>:28 []
        |  MapPartitionsRDD[15] at toRdd at <console>:28 []
        |  MapPartitionsRDD[14] at toRdd at <console>:28 []
        |  ParallelCollectionRDD[13] at toRdd at <console>:28 []
    ```

## <span id="doConsume"> Generating Java Code for Consume Path

```scala
doConsume(
  ctx: CodegenContext,
  input: Seq[ExprCode],
  row: ExprCode): String
```

`doConsume` is part of the [CodegenSupport](CodegenSupport.md#doConsume) abstraction.

`doConsume` [doConsumeWithoutKeys](#doConsumeWithoutKeys) when no [named expressions for the grouping keys](#groupingExpressions) were specified for the `HashAggregateExec` or [doConsumeWithKeys](#doConsumeWithKeys) otherwise.

### <span id="doConsumeWithKeys"> doConsumeWithKeys

```scala
doConsumeWithKeys(
  ctx: CodegenContext,
  input: Seq[ExprCode]): String
```

`doConsumeWithKeys`...FIXME

### <span id="doConsumeWithoutKeys"> doConsumeWithoutKeys

```scala
doConsumeWithoutKeys(
  ctx: CodegenContext,
  input: Seq[ExprCode]): String
```

`doConsumeWithoutKeys`...FIXME

## <span id="doProduce"> Generating Java Code for Produce Path

```scala
doProduce(
  ctx: CodegenContext): String
```

`doProduce` is part of the [CodegenSupport](CodegenSupport.md#doProduce) abstraction.

`doProduce` executes [doProduceWithoutKeys](#doProduceWithoutKeys) when no [named expressions for the grouping keys](#groupingExpressions) were specified for the `HashAggregateExec` or [doProduceWithKeys](#doProduceWithKeys) otherwise.

### <span id="doProduceWithKeys"> doProduceWithKeys

```scala
doProduceWithKeys(
  ctx: CodegenContext): String
```

`doProduceWithKeys`...FIXME

### <span id="doProduceWithoutKeys"> doProduceWithoutKeys

```scala
doProduceWithoutKeys(
  ctx: CodegenContext): String
```

`doProduceWithoutKeys`...FIXME

### <span id="generateResultFunction"> generateResultFunction

```scala
generateResultFunction(
  ctx: CodegenContext): String
```

`generateResultFunction`...FIXME

### <span id="finishAggregate"> finishAggregate

```scala
finishAggregate(
  hashMap: UnsafeFixedWidthAggregationMap,
  sorter: UnsafeKVExternalSorter,
  peakMemory: SQLMetric,
  spillSize: SQLMetric,
  avgHashProbe: SQLMetric): KVIterator[UnsafeRow, UnsafeRow]
```

`finishAggregate`...FIXME

### <span id="createHashMap"> createHashMap

```scala
createHashMap(): UnsafeFixedWidthAggregationMap
```

`createHashMap` creates a [UnsafeFixedWidthAggregationMap](UnsafeFixedWidthAggregationMap.md) (with the <<getEmptyAggregationBuffer, empty aggregation buffer>>, the <<bufferSchema, bufferSchema>>, the <<groupingKeySchema, groupingKeySchema>>, the current `TaskMemoryManager`, `1024 * 16` initial capacity and the page size of the `TaskMemoryManager`)

## Internal Properties

| aggregateBufferAttributes
| [[aggregateBufferAttributes]] All the <<spark-sql-Expression-AggregateFunction.md#aggBufferAttributes, AttributeReferences>> of the [AggregateFunctions](../expressions/AggregateExpression.md#aggregateFunction) of the <<aggregateExpressions, AggregateExpressions>>

| testFallbackStartsAt
| [[testFallbackStartsAt]] Optional pair of numbers for controlled fall-back to a sort-based aggregation when the hash-based approach is unable to acquire enough memory.

| declFunctions
| [[declFunctions]] <<spark-sql-Expression-DeclarativeAggregate.md#, DeclarativeAggregate>> expressions (from the [AggregateFunctions](../expressions/AggregateExpression.md#aggregateFunction) of the <<aggregateExpressions, AggregateExpressions>>)

| bufferSchema
| [[bufferSchema]] [StructType](../types/StructType.md#fromAttributes) built from the <<aggregateBufferAttributes, aggregateBufferAttributes>>

| groupingKeySchema
| [[groupingKeySchema]] [StructType](../types/StructType.md#fromAttributes) built from the <<groupingAttributes, groupingAttributes>>

| groupingAttributes
| [[groupingAttributes]] <<expressions/NamedExpression.md#toAttribute, Attributes>> of the <<groupingExpressions, groupingExpressions>>
