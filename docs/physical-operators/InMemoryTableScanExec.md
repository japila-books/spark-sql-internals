# InMemoryTableScanExec Leaf Physical Operator

`InMemoryTableScanExec` is a [leaf physical operator](LeafExecNode.md) that represents an [InMemoryRelation](#relation) logical operator at execution time.

`InMemoryTableScanExec` is <<creating-instance, created>> exclusively when [InMemoryScans](../execution-planning-strategies/InMemoryScans.md) execution planning strategy is executed and finds an InMemoryRelation.md[InMemoryRelation] logical operator in a logical query plan.

[[creating-instance]]
`InMemoryTableScanExec` takes the following to be created:

* [[attributes]] [Attribute](../expressions/Attribute.md) expressions
* [[predicates]] Predicate [expressions](../expressions/Expression.md)
* [[relation]] [InMemoryRelation](../logical-operators/InMemoryRelation.md) logical operator

`InMemoryTableScanExec` is a [ColumnarBatchScan](ColumnarBatchScan.md) that <<supportsBatch, supports batch decoding>>.

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

[[metrics]]
.InMemoryTableScanExec's Performance Metrics
[cols="1,2,2",options="header",width="100%"]
|===
| Key
| Name (in web UI)
| Description

| [[numOutputRows]] `numOutputRows`
| number of output rows
|
|===

.InMemoryTableScanExec in web UI (Details for Query)
image::images/spark-sql-InMemoryTableScanExec-webui-query-details.png[align="center"]

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
| [Schema](../StructType.md) of a columnar batch

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

NOTE: `vectorTypes` is part of spark-sql-ColumnarBatchScan.md#vectorTypes[ColumnarBatchScan Contract] to...FIXME.

`vectorTypes` uses [spark.sql.columnVector.offheap.enabled](../configuration-properties.md#spark.sql.columnVector.offheap.enabled) internal configuration property to select the name of the concrete column vector ([OnHeapColumnVector](../OnHeapColumnVector.md) or [OffHeapColumnVector](../OffHeapColumnVector.md)).

`vectorTypes` gives as many column vectors as the [attribute expressions](#attributes).

## <span id="supportsBatch"> supportsBatch Flag

```scala
supportsBatch: Boolean
```

`supportsBatch` is part of the [ColumnarBatchScan](ColumnarBatchScan.md#supportsBatch) abstraction.

`supportsBatch` is enabled when all of the following holds:

1. [spark.sql.inMemoryColumnarStorage.enableVectorizedReader](../configuration-properties.md#spark.sql.inMemoryColumnarStorage.enableVectorizedReader) configuration property is enabled

1. The [output schema](../catalyst/QueryPlan.md#schema) of the [InMemoryRelation](#relation) uses primitive data types only [BooleanType](../DataType.md#BooleanType), [ByteType](../DataType.md#ByteType), [ShortType](../DataType.md#ShortType), [IntegerType](../DataType.md#IntegerType), [LongType](../DataType.md#LongType), [FloatType](../DataType.md#FloatType), [DoubleType](../DataType.md#DoubleType)

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

=== [[statsFor]] `statsFor` Internal Method

[source, scala]
----
statsFor(a: Attribute)
----

`statsFor`...FIXME

NOTE: `statsFor` is used when...FIXME

=== [[createAndDecompressColumn]] `createAndDecompressColumn` Internal Method

```scala
createAndDecompressColumn(
   cachedColumnarBatch: CachedBatch): ColumnarBatch
```

`createAndDecompressColumn` takes the number of rows in the input `CachedBatch`.

`createAndDecompressColumn` requests [OffHeapColumnVector](../OffHeapColumnVector.md#allocateColumns) or [OnHeapColumnVector](../OnHeapColumnVector.md#allocateColumns) to allocate column vectors (with the number of rows and [columnarBatchSchema](#columnarBatchSchema)) per the [spark.sql.columnVector.offheap.enabled](../configuration-properties.md#spark.sql.columnVector.offheap.enabled) internal configuration flag.

`createAndDecompressColumn` creates a [ColumnarBatch](../ColumnarBatch.md) for the allocated column vectors (as an array of `ColumnVector`).

`createAndDecompressColumn` [sets the number of rows in the columnar batch](../ColumnarBatch.md#numRows).

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

=== [[buildFilter]] `buildFilter` Property

[source, scala]
----
buildFilter: PartialFunction[Expression, Expression]
----

NOTE: `buildFilter` is a Scala lazy value which is computed once when accessed and cached afterwards.

`buildFilter` is a Scala https://www.scala-lang.org/api/2.11.11/#scala.PartialFunction[PartialFunction] that accepts an expressions/Expression.md[Expression] and produces an expressions/Expression.md[Expression], i.e. `PartialFunction[Expression, Expression]`.

[[buildFilter-expressions]]
.buildFilter's Expressions
[cols="1,2",options="header",width="100%"]
|===
| Input Expression
| Description

| `And`
|

| `Or`
|

| `EqualTo`
|

| `EqualNullSafe`
|

| `LessThan`
|

| `LessThanOrEqual`
|

| `GreaterThan`
|

| `GreaterThanOrEqual`
|

| `IsNull`
|

| `IsNotNull`
|

| `In` with a non-empty spark-sql-Expression-In.md#list[list] of spark-sql-Expression-Literal.md[Literal] expressions
|
For every `Literal` expression in the expression list, `buildFilter` creates an `And` expression with the lower and upper bounds of the <<statsFor, partition statistics for the attribute>> and the `Literal`.

In the end, `buildFilter` joins the `And` expressions with `Or` expressions.
|===

NOTE: `buildFilter` is used exclusively when `InMemoryTableScanExec` is requested for <<partitionFilters, partitionFilters>>.

=== [[innerChildren]] `innerChildren` Method

[source, scala]
----
innerChildren: Seq[QueryPlan[_]]
----

NOTE: `innerChildren` is part of catalyst/QueryPlan.md#innerChildren[QueryPlan Contract] to...FIXME.

`innerChildren`...FIXME
