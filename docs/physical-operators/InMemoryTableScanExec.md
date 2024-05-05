---
title: InMemoryTableScanExec
---

# InMemoryTableScanExec Leaf Physical Operator

`InMemoryTableScanExec` is a [leaf physical operator](SparkPlan.md#LeafExecNode) that represents an [InMemoryRelation](#relation) logical operator at execution time.

## <span id="metrics"> Performance Metrics

Key             | Name (in web UI)        | Description
----------------|-------------------------|---------
numOutputRows   | number of output rows   | Number of output rows

![InMemoryTableScanExec in web UI (Details for Query)](../images/spark-sql-InMemoryTableScanExec-webui-query-details.png)

## Demo

!!! note "FIXME Do the below code blocks work still?"

```text
// Example to show produceBatches to generate a Java source code

// Create a DataFrame
val ids = spark.range(10)
// Cache it (and trigger the caching since it is lazy)
ids.cache.foreach(_ => ())

import org.apache.spark.sql.execution.columnar.InMemoryTableScanExec
// we need executedPlan with WholeStageCodegenExec physical operator
// this will make sure the code generation starts at the right place
val plan = ids.queryExecution.executedPlan
val scan = plan.collectFirst { case e: InMemoryTableScanExec => e }.get

assert(scan.supportsBatch, "supportsBatch flag should be on to trigger produceBatches")

import org.apache.spark.sql.catalyst.expressions.codegen.CodegenContext
val ctx = new CodegenContext

// produceBatches is private so we have to trigger it from "outside"
// It could be doProduce with supportsBatch flag on but it is protected
// (doProduce will also take care of the extra input `input` parameter)
// let's do this the only one right way
import org.apache.spark.sql.execution.CodegenSupport
val parent = plan.p(0).asInstanceOf[CodegenSupport]
val produceCode = scan.produce(ctx, parent)

scala> println(produceCode)



if (inmemorytablescan_mutableStateArray1[1] == null) {
  inmemorytablescan_nextBatch1();
}
while (inmemorytablescan_mutableStateArray1[1] != null) {
  int inmemorytablescan_numRows1 = inmemorytablescan_mutableStateArray1[1].numRows();
  int inmemorytablescan_localEnd1 = inmemorytablescan_numRows1 - inmemorytablescan_batchIdx1;
  for (int inmemorytablescan_localIdx1 = 0; inmemorytablescan_localIdx1 < inmemorytablescan_localEnd1; inmemorytablescan_localIdx1++) {
    int inmemorytablescan_rowIdx1 = inmemorytablescan_batchIdx1 + inmemorytablescan_localIdx1;
    long inmemorytablescan_value2 = inmemorytablescan_mutableStateArray2[1].getLong(inmemorytablescan_rowIdx1);
inmemorytablescan_mutableStateArray5[1].write(0, inmemorytablescan_value2);
append(inmemorytablescan_mutableStateArray3[1]);
    if (shouldStop()) { inmemorytablescan_batchIdx1 = inmemorytablescan_rowIdx1 + 1; return; }
  }
  inmemorytablescan_batchIdx1 = inmemorytablescan_numRows1;
  inmemorytablescan_mutableStateArray1[1] = null;
  inmemorytablescan_nextBatch1();
}
((org.apache.spark.sql.execution.metric.SQLMetric) references[3] /* scanTime */).add(inmemorytablescan_scanTime1 / (1000 * 1000));
inmemorytablescan_scanTime1 = 0;

// the code does not look good and begs for some polishing
// (You can only imagine how the Polish me looks when I say "polishing" :))

import org.apache.spark.sql.execution.WholeStageCodegenExec
val wsce = plan.asInstanceOf[WholeStageCodegenExec]

// Trigger code generation of the entire query plan tree
val (ctx, code) = wsce.doCodeGen

// CodeFormatter can pretty-print the code
import org.apache.spark.sql.catalyst.expressions.codegen.CodeFormatter
println(CodeFormatter.format(code))
```

```text
// Let's create a query with a InMemoryTableScanExec physical operator that supports batch decoding
val q = spark.range(4).cache
val plan = q.queryExecution.executedPlan

import org.apache.spark.sql.execution.columnar.InMemoryTableScanExec
val inmemoryScan = plan.collectFirst { case exec: InMemoryTableScanExec => exec }.get

assert(inmemoryScan.supportsBatch)

import org.apache.spark.sql.catalyst.expressions.codegen.CodegenContext
val ctx = new CodegenContext
import org.apache.spark.sql.execution.CodegenSupport
val parent = plan.asInstanceOf[CodegenSupport]
val code = inmemoryScan.produce(ctx, parent)
scala> println(code)



if (inmemorytablescan_mutableStateArray1[1] == null) {
  inmemorytablescan_nextBatch1();
}
while (inmemorytablescan_mutableStateArray1[1] != null) {
  int inmemorytablescan_numRows1 = inmemorytablescan_mutableStateArray1[1].numRows();
  int inmemorytablescan_localEnd1 = inmemorytablescan_numRows1 - inmemorytablescan_batchIdx1;
  for (int inmemorytablescan_localIdx1 = 0; inmemorytablescan_localIdx1 < inmemorytablescan_localEnd1; inmemorytablescan_localIdx1++) {
    int inmemorytablescan_rowIdx1 = inmemorytablescan_batchIdx1 + inmemorytablescan_localIdx1;
    long inmemorytablescan_value2 = inmemorytablescan_mutableStateArray2[1].getLong(inmemorytablescan_rowIdx1);
inmemorytablescan_mutableStateArray5[1].write(0, inmemorytablescan_value2);
append(inmemorytablescan_mutableStateArray3[1]);
    if (shouldStop()) { inmemorytablescan_batchIdx1 = inmemorytablescan_rowIdx1 + 1; return; }
  }
  inmemorytablescan_batchIdx1 = inmemorytablescan_numRows1;
  inmemorytablescan_mutableStateArray1[1] = null;
  inmemorytablescan_nextBatch1();
}
((org.apache.spark.sql.execution.metric.SQLMetric) references[3] /* scanTime */).add(inmemorytablescan_scanTime1 / (1000 * 1000));
inmemorytablescan_scanTime1 = 0;
```

```text
val q = Seq(Seq(1,2,3)).toDF("ids").cache
val plan = q.queryExecution.executedPlan

import org.apache.spark.sql.execution.columnar.InMemoryTableScanExec
val inmemoryScan = plan.collectFirst { case exec: InMemoryTableScanExec => exec }.get

assert(inmemoryScan.supportsBatch == false)

// NOTE: The following codegen won't work since supportsBatch is off and so is codegen
import org.apache.spark.sql.catalyst.expressions.codegen.CodegenContext
val ctx = new CodegenContext
import org.apache.spark.sql.execution.CodegenSupport
val parent = plan.asInstanceOf[CodegenSupport]
scala> val code = inmemoryScan.produce(ctx, parent)
java.lang.UnsupportedOperationException
  at org.apache.spark.sql.execution.CodegenSupport$class.doConsume(WholeStageCodegenExec.scala:315)
  at org.apache.spark.sql.execution.columnar.InMemoryTableScanExec.doConsume(InMemoryTableScanExec.scala:33)
  at org.apache.spark.sql.execution.CodegenSupport$class.constructDoConsumeFunction(WholeStageCodegenExec.scala:208)
  at org.apache.spark.sql.execution.CodegenSupport$class.consume(WholeStageCodegenExec.scala:179)
  at org.apache.spark.sql.execution.columnar.InMemoryTableScanExec.consume(InMemoryTableScanExec.scala:33)
  at org.apache.spark.sql.execution.ColumnarBatchScan$class.produceRows(ColumnarBatchScan.scala:166)
  at org.apache.spark.sql.execution.ColumnarBatchScan$class.doProduce(ColumnarBatchScan.scala:80)
  at org.apache.spark.sql.execution.columnar.InMemoryTableScanExec.doProduce(InMemoryTableScanExec.scala:33)
  at org.apache.spark.sql.execution.CodegenSupport$$anonfun$produce$1.apply(WholeStageCodegenExec.scala:88)
  at org.apache.spark.sql.execution.CodegenSupport$$anonfun$produce$1.apply(WholeStageCodegenExec.scala:83)
  at org.apache.spark.sql.execution.SparkPlan$$anonfun$executeQuery$1.apply(SparkPlan.scala:155)
  at org.apache.spark.rdd.RDDOperationScope$.withScope(RDDOperationScope.scala:151)
  at org.apache.spark.sql.execution.SparkPlan.executeQuery(SparkPlan.scala:152)
  at org.apache.spark.sql.execution.CodegenSupport$class.produce(WholeStageCodegenExec.scala:83)
  at org.apache.spark.sql.execution.columnar.InMemoryTableScanExec.produce(InMemoryTableScanExec.scala:33)
  ... 49 elided
```

```text
val q = spark.read.text("README.md")

val plan = q.queryExecution.executedPlan
import org.apache.spark.sql.execution.FileSourceScanExec
val scan = plan.collectFirst { case exec: FileSourceScanExec => exec }.get

// 2. supportsBatch is off
assert(scan.supportsBatch == false)

// 3. InMemoryTableScanExec.produce
import org.apache.spark.sql.catalyst.expressions.codegen.CodegenContext
val ctx = new CodegenContext
import org.apache.spark.sql.execution.CodegenSupport

import org.apache.spark.sql.execution.WholeStageCodegenExec
val wsce = plan.collectFirst { case exec: WholeStageCodegenExec => exec }.get

val code = scan.produce(ctx, parent = wsce)
scala> println(code)
// blank lines removed
while (scan_mutableStateArray[2].hasNext()) {
  InternalRow scan_row2 = (InternalRow) scan_mutableStateArray[2].next();
  ((org.apache.spark.sql.execution.metric.SQLMetric) references[2] /* numOutputRows */).add(1);
  append(scan_row2);
  if (shouldStop()) return;
}
```

<!---
## Review Me

`InMemoryTableScanExec` is <<creating-instance, created>> exclusively when [InMemoryScans](../execution-planning-strategies/InMemoryScans.md) execution planning strategy is executed and finds an InMemoryRelation.md[InMemoryRelation] logical operator in a logical query plan.

[[creating-instance]]
`InMemoryTableScanExec` takes the following to be created:

* [[attributes]] [Attribute](../expressions/Attribute.md) expressions
* [[predicates]] Predicate [expressions](../expressions/Expression.md)
* [[relation]] [InMemoryRelation](../logical-operators/InMemoryRelation.md) logical operator

`InMemoryTableScanExec` supports <<filteredCachedBatches, partition batch pruning>> (only when [spark.sql.inMemoryColumnarStorage.partitionPruning](../configuration-properties.md#spark.sql.inMemoryColumnarStorage.partitionPruning) internal configuration property is enabled).

```text
// Sample DataFrames
val tokens = Seq(
  (0, "playing"),
  (1, "with"),
  (2, "InMemoryTableScanExec")
).toDF("id", "token")
val ids = spark.range(10)

// Cache DataFrames
tokens.cache
ids.cache

val q = tokens.join(ids, Seq("id"), "outer")
scala> q.explain
== Physical Plan ==
*Project [coalesce(cast(id#5 as bigint), id#10L) AS id#33L, token#6]
+- SortMergeJoin [cast(id#5 as bigint)], [id#10L], FullOuter
   :- *Sort [cast(id#5 as bigint) ASC NULLS FIRST], false, 0
   :  +- Exchange hashpartitioning(cast(id#5 as bigint), 200)
   :     +- InMemoryTableScan [id#5, token#6]
   :           +- InMemoryRelation [id#5, token#6], true, 10000, StorageLevel(disk, memory, deserialized, 1 replicas)
   :                 +- LocalTableScan [id#5, token#6]
   +- *Sort [id#10L ASC NULLS FIRST], false, 0
      +- Exchange hashpartitioning(id#10L, 200)
         +- InMemoryTableScan [id#10L]
               +- InMemoryRelation [id#10L], true, 10000, StorageLevel(disk, memory, deserialized, 1 replicas)
                     +- *Range (0, 10, step=1, splits=8)
```

```scala
val q = spark.range(4).cache
val plan = q.queryExecution.executedPlan
import org.apache.spark.sql.execution.columnar.InMemoryTableScanExec
val inmemoryScan = plan.collectFirst { case exec: InMemoryTableScanExec => exec }.get
assert(inmemoryScan.supportCodegen == inmemoryScan.supportsBatch)
```

[[supportCodegen]]
`InMemoryTableScanExec` [supports Java code generation](CodegenSupport.md#supportCodegen) only if <<supportsBatch, batch decoding>> is enabled.

[[inputRDDs]]
`InMemoryTableScanExec` gives the single <<inputRDD, inputRDD>> as the [only RDD of internal rows](CodegenSupport.md#inputRDDs) (when `WholeStageCodegenExec` physical operator is WholeStageCodegenExec.md#doExecute[executed]).

[[enableAccumulatorsForTest]]
[[spark.sql.inMemoryTableScanStatistics.enable]]
`InMemoryTableScanExec` uses `spark.sql.inMemoryTableScanStatistics.enable` flag (default: `false`) to enable accumulators (that seems to be exclusively for testing purposes).

[[internal-registries]]
.InMemoryTableScanExec's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| [[columnarBatchSchema]] `columnarBatchSchema`
| [Schema](../types/StructType.md) of a columnar batch

Used exclusively when `InMemoryTableScanExec` is requested to <<createAndDecompressColumn, createAndDecompressColumn>>.

| [[stats]] `stats`
| [PartitionStatistics](../logical-operators/InMemoryRelation.md#partitionStatistics) of the <<relation, InMemoryRelation>>

Used when `InMemoryTableScanExec` is requested for <<partitionFilters, partitionFilters>>, <<filteredCachedBatches, partition batch pruning>> and <<statsFor, statsFor>>.
|===

=== [[vectorTypes]] `vectorTypes` Method

[source, scala]
----
vectorTypes: Option[Seq[String]]
----

`vectorTypes` uses [spark.sql.columnVector.offheap.enabled](../configuration-properties.md#spark.sql.columnVector.offheap.enabled) internal configuration property to select the name of the concrete column vector ([OnHeapColumnVector](../OnHeapColumnVector.md) or [OffHeapColumnVector](../OffHeapColumnVector.md)).

`vectorTypes` gives as many column vectors as the [attribute expressions](#attributes).

## <span id="supportsBatch"> supportsBatch Flag

```scala
supportsBatch: Boolean
```

`supportsBatch` is enabled when all of the following holds:

1. [spark.sql.inMemoryColumnarStorage.enableVectorizedReader](../configuration-properties.md#spark.sql.inMemoryColumnarStorage.enableVectorizedReader) configuration property is enabled

1. The [output schema](../catalyst/QueryPlan.md#schema) of the [InMemoryRelation](#relation) uses primitive data types only [BooleanType](../types/DataType.md#BooleanType), [ByteType](../types/DataType.md#ByteType), [ShortType](../types/DataType.md#ShortType), [IntegerType](../types/DataType.md#IntegerType), [LongType](../types/DataType.md#LongType), [FloatType](../types/DataType.md#FloatType), [DoubleType](../types/DataType.md#DoubleType)

1. The number of nested fields in the output schema of the [InMemoryRelation](#relation) is at most [spark.sql.codegen.maxFields](../configuration-properties.md#spark.sql.codegen.maxFields) internal configuration property

=== [[partitionFilters]] `partitionFilters` Property

[source, scala]
----
partitionFilters: Seq[Expression]
----

NOTE: `partitionFilters` is a Scala lazy value which is computed once when accessed and cached afterwards.

`partitionFilters`...FIXME

NOTE: `partitionFilters` is used when...FIXME

=== [[filteredCachedBatches]] Applying Partition Batch Pruning to Cached Column Buffers (Creating MapPartitionsRDD of Filtered CachedBatches) -- `filteredCachedBatches` Internal Method

[source, scala]
----
filteredCachedBatches(): RDD[CachedBatch]
----

`filteredCachedBatches` requests <<stats, PartitionStatistics>> for the output schema and <<relation, InMemoryRelation>> for [cached column buffers](../logical-operators/InMemoryRelation.md#cachedColumnBuffers) (as a `RDD[CachedBatch]`).

`filteredCachedBatches` takes the cached column buffers (as a `RDD[CachedBatch]`) and transforms the RDD per partition with index (i.e. `RDD.mapPartitionsWithIndexInternal`) as follows:

1. Creates a partition filter as a new [GenPredicate](SparkPlan.md#newPredicate) for the <<partitionFilters, partitionFilters>> expressions (concatenated together using `And` binary operator and the schema)

1. Requests the generated partition filter `Predicate` to `initialize`

1. Uses [spark.sql.inMemoryColumnarStorage.partitionPruning](../configuration-properties.md#spark.sql.inMemoryColumnarStorage.partitionPruning) internal configuration property to enable **partition batch pruning** and filtering out (skipping) `CachedBatches` in a partition based on column stats and the generated partition filter `Predicate`

!!! note
    When [spark.sql.inMemoryColumnarStorage.partitionPruning](../configuration-properties.md#spark.sql.inMemoryColumnarStorage.partitionPruning) internal configuration property is disabled, `filteredCachedBatches` does nothing and simply passes all `CachedBatch` elements along.

`filteredCachedBatches` is used when `InMemoryTableScanExec` is requested for the [inputRDD](#inputRDD) internal property.

=== [[createAndDecompressColumn]] `createAndDecompressColumn` Internal Method

```scala
createAndDecompressColumn(
   cachedColumnarBatch: CachedBatch): ColumnarBatch
```

`createAndDecompressColumn` takes the number of rows in the input `CachedBatch`.

`createAndDecompressColumn` requests [OffHeapColumnVector](../OffHeapColumnVector.md#allocateColumns) or [OnHeapColumnVector](../OnHeapColumnVector.md#allocateColumns) to allocate column vectors (with the number of rows and [columnarBatchSchema](#columnarBatchSchema)) per the [spark.sql.columnVector.offheap.enabled](../configuration-properties.md#spark.sql.columnVector.offheap.enabled) internal configuration flag.

`createAndDecompressColumn` creates a [ColumnarBatch](../vectorized-query-execution/ColumnarBatch.md) for the allocated column vectors (as an array of `ColumnVector`).

`createAndDecompressColumn` [sets the number of rows in the columnar batch](../vectorized-query-execution/ColumnarBatch.md#numRows).

For every <<attributes, Attribute>> `createAndDecompressColumn` requests `ColumnAccessor` to `decompress` the column.

`createAndDecompressColumn` registers a callback to be executed on a task completion that will close the `ColumnarBatch`.

In the end, `createAndDecompressColumn` returns the `ColumnarBatch`.

NOTE: `createAndDecompressColumn` is used exclusively when `InMemoryTableScanExec` is requested for the <<inputRDD, input RDD of internal rows>>.

=== [[inputRDD]] Creating Input RDD of Internal Rows -- `inputRDD` Internal Property

[source, scala]
----
inputRDD: RDD[InternalRow]
----

NOTE: `inputRDD` is a Scala lazy value which is computed once when accessed and cached afterwards.

`inputRDD` firstly <<filteredCachedBatches, applies partition batch pruning to cached column buffers>> (and creates a filtered cached batches as a `RDD[CachedBatch]`).

With <<supportsBatch, supportsBatch>> flag on, `inputRDD` finishes with a new `MapPartitionsRDD` (using `RDD.map`) by <<createAndDecompressColumn, createAndDecompressColumn>> on all cached columnar batches.

CAUTION: Show examples of <<supportsBatch, supportsBatch>> enabled and disabled

[source, scala]
----
// Demo: A MapPartitionsRDD in the RDD lineage
val q = spark.range(4).cache
val plan = q.queryExecution.executedPlan
import org.apache.spark.sql.execution.columnar.InMemoryTableScanExec
val inmemoryScan = plan.collectFirst { case exec: InMemoryTableScanExec => exec }.get

// supportsBatch flag is on since the schema is a single column of longs
assert(inmemoryScan.supportsBatch)

val rdd = inmemoryScan.inputRDDs.head
scala> rdd.toDebugString
res2: String =
(8) MapPartitionsRDD[5] at inputRDDs at <console>:27 []
 |  MapPartitionsRDD[4] at inputRDDs at <console>:27 []
 |  *(1) Range (0, 4, step=1, splits=8)
 MapPartitionsRDD[3] at cache at <console>:23 []
 |  MapPartitionsRDD[2] at cache at <console>:23 []
 |  MapPartitionsRDD[1] at cache at <console>:23 []
 |  ParallelCollectionRDD[0] at cache at <console>:23 []
----

With <<supportsBatch, supportsBatch>> flag off, `inputRDD` firstly <<filteredCachedBatches, applies partition batch pruning to cached column buffers>> (and creates a filtered cached batches as a `RDD[CachedBatch]`).

NOTE: Indeed. `inputRDD` <<filteredCachedBatches, applies partition batch pruning to cached column buffers>> (and creates a filtered cached batches as a `RDD[CachedBatch]`) twice which seems unnecessary.

In the end, `inputRDD` creates a new `MapPartitionsRDD` (using `RDD.map`) with a `ColumnarIterator` applied to all cached columnar batches that is created as follows:

. For every `CachedBatch` in the partition iterator adds the total number of rows in the batch to <<numOutputRows, numOutputRows>> SQL metric

. Requests `GenerateColumnAccessor` to [generate](../whole-stage-code-generation/CodeGenerator.md#generate) the Java code for a `ColumnarIterator` to perform expression evaluation for the given <<attributes, column types>>.

. Requests `ColumnarIterator` to initialize

[source, scala]
----
// Demo: A MapPartitionsRDD in the RDD lineage (supportsBatch flag off)
import java.sql.Date
import java.time.LocalDate
val q = Seq(Date.valueOf(LocalDate.now)).toDF("date").cache
val plan = q.queryExecution.executedPlan

import org.apache.spark.sql.execution.columnar.InMemoryTableScanExec
val inmemoryScan = plan.collectFirst { case exec: InMemoryTableScanExec => exec }.get

// supportsBatch flag is off since the schema uses java.sql.Date
assert(inmemoryScan.supportsBatch == false)

val rdd = inmemoryScan.inputRDDs.head
scala> rdd.toDebugString
res2: String =
(1) MapPartitionsRDD[12] at inputRDDs at <console>:28 []
 |  MapPartitionsRDD[11] at inputRDDs at <console>:28 []
 |  LocalTableScan [date#15]
 MapPartitionsRDD[9] at cache at <console>:25 []
 |  MapPartitionsRDD[8] at cache at <console>:25 []
 |  ParallelCollectionRDD[7] at cache at <console>:25 []
----

NOTE: `inputRDD` is used when `InMemoryTableScanExec` is requested for the <<inputRDDs, input RDDs>> and to <<doExecute, execute>>.

=== [[doExecute]] Executing Physical Operator (Generating RDD[InternalRow]) -- `doExecute` Method

[source, scala]
----
doExecute(): RDD[InternalRow]
----

`doExecute` branches off per <<supportsBatch, supportsBatch>> flag.

With <<supportsBatch, supportsBatch>> flag on, `doExecute` creates a WholeStageCodegenExec.md#creating-instance[WholeStageCodegenExec] (with the `InMemoryTableScanExec` physical operator as the WholeStageCodegenExec.md#child[child] and WholeStageCodegenExec.md#codegenStageId[codegenStageId] as `0`) and requests it to SparkPlan.md#execute[execute].

Otherwise, when <<supportsBatch, supportsBatch>> flag is off, `doExecute` simply gives the <<inputRDD, input RDD of internal rows>>.

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.
-->
