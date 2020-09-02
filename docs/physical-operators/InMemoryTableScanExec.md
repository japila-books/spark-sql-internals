title: InMemoryTableScanExec

# InMemoryTableScanExec Leaf Physical Operator

`InMemoryTableScanExec` is a SparkPlan.md#LeafExecNode[leaf physical operator] that represents an <<relation, InMemoryRelation>> logical operator at execution time.

`InMemoryTableScanExec` is <<creating-instance, created>> exclusively when [InMemoryScans](../execution-planning-strategies/InMemoryScans.md) execution planning strategy is executed and finds an spark-sql-LogicalPlan-InMemoryRelation.md[InMemoryRelation] logical operator in a logical query plan.

[[creating-instance]]
`InMemoryTableScanExec` takes the following to be created:

* [[attributes]] spark-sql-Expression-Attribute.md[Attribute] expressions
* [[predicates]] Predicate expressions/Expression.md[expressions]
* [[relation]] spark-sql-LogicalPlan-InMemoryRelation.md[InMemoryRelation] logical operator

`InMemoryTableScanExec` is a spark-sql-ColumnarBatchScan.md[ColumnarBatchScan] that <<supportsBatch, supports batch decoding>> (when <<creating-instance, created>> for a <<reader, DataSourceReader>> that supports it, i.e. the `DataSourceReader` is a spark-sql-SupportsScanColumnarBatch.md[SupportsScanColumnarBatch] with the spark-sql-SupportsScanColumnarBatch.md#enableBatchRead[enableBatchRead] flag enabled).

`InMemoryTableScanExec` supports <<filteredCachedBatches, partition batch pruning>> (only when spark-sql-properties.md#spark.sql.inMemoryColumnarStorage.partitionPruning[spark.sql.inMemoryColumnarStorage.partitionPruning] internal configuration property is enabled which is so by default).

[source, scala]
----
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
----

[source, scala]
----
val q = spark.range(4).cache
val plan = q.queryExecution.executedPlan
import org.apache.spark.sql.execution.columnar.InMemoryTableScanExec
val inmemoryScan = plan.collectFirst { case exec: InMemoryTableScanExec => exec }.get
assert(inmemoryScan.supportCodegen == inmemoryScan.supportsBatch)
----

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
`InMemoryTableScanExec` spark-sql-CodegenSupport.md#supportCodegen[supports Java code generation] only if <<supportsBatch, batch decoding>> is enabled.

[[inputRDDs]]
`InMemoryTableScanExec` gives the single <<inputRDD, inputRDD>> as the spark-sql-CodegenSupport.md#inputRDDs[only RDD of internal rows] (when `WholeStageCodegenExec` physical operator is spark-sql-SparkPlan-WholeStageCodegenExec.md#doExecute[executed]).

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
| spark-sql-StructType.md[Schema] of a columnar batch

Used exclusively when `InMemoryTableScanExec` is requested to <<createAndDecompressColumn, createAndDecompressColumn>>.

| [[stats]] `stats`
| spark-sql-LogicalPlan-InMemoryRelation.md#partitionStatistics[PartitionStatistics] of the <<relation, InMemoryRelation>>

Used when `InMemoryTableScanExec` is requested for <<partitionFilters, partitionFilters>>, <<filteredCachedBatches, partition batch pruning>> and <<statsFor, statsFor>>.
|===

=== [[vectorTypes]] `vectorTypes` Method

[source, scala]
----
vectorTypes: Option[Seq[String]]
----

NOTE: `vectorTypes` is part of spark-sql-ColumnarBatchScan.md#vectorTypes[ColumnarBatchScan Contract] to...FIXME.

`vectorTypes` uses spark-sql-properties.md#spark.sql.columnVector.offheap.enabled[spark.sql.columnVector.offheap.enabled] internal configuration property to select the name of the concrete column vector, i.e. spark-sql-OnHeapColumnVector.md[OnHeapColumnVector] or spark-sql-OffHeapColumnVector.md[OffHeapColumnVector] when the property is off or on, respectively.

`vectorTypes` gives as many column vectors as the <<attributes, attribute expressions>>.

=== [[supportsBatch]] `supportsBatch` Property

[source, scala]
----
supportsBatch: Boolean
----

NOTE: `supportsBatch` is part of spark-sql-ColumnarBatchScan.md#supportsBatch[ColumnarBatchScan Contract] to control whether the physical operator supports spark-sql-vectorized-parquet-reader.md[vectorized decoding] or not.

`supportsBatch` is enabled when all of the following holds:

. spark-sql-properties.md#spark.sql.inMemoryColumnarStorage.enableVectorizedReader[spark.sql.inMemoryColumnarStorage.enableVectorizedReader] configuration property is enabled (default: `true`)

. The catalyst/QueryPlan.md#schema[output schema] of the <<relation, InMemoryRelation>> uses primitive data types only, i.e. spark-sql-DataType.md#BooleanType[BooleanType], spark-sql-DataType.md#ByteType[ByteType], spark-sql-DataType.md#ShortType[ShortType], spark-sql-DataType.md#IntegerType[IntegerType], spark-sql-DataType.md#LongType[LongType], spark-sql-DataType.md#FloatType[FloatType], spark-sql-DataType.md#DoubleType[DoubleType]

. The number of nested fields in the output schema of the <<relation, InMemoryRelation>> is at most spark-sql-properties.md#spark.sql.codegen.maxFields[spark.sql.codegen.maxFields] internal configuration property

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

`filteredCachedBatches` requests <<stats, PartitionStatistics>> for the output schema and <<relation, InMemoryRelation>> for spark-sql-LogicalPlan-InMemoryRelation.md#cachedColumnBuffers[cached column buffers] (as a `RDD[CachedBatch]`).

`filteredCachedBatches` takes the cached column buffers (as a `RDD[CachedBatch]`) and transforms the RDD per partition with index (i.e. `RDD.mapPartitionsWithIndexInternal`) as follows:

. Creates a partition filter as a new SparkPlan.md#newPredicate[GenPredicate] for the <<partitionFilters, partitionFilters>> expressions (concatenated together using `And` binary operator and the schema)

. Requests the generated partition filter `Predicate` to `initialize`

. Uses spark-sql-properties.md#spark.sql.inMemoryColumnarStorage.partitionPruning[spark.sql.inMemoryColumnarStorage.partitionPruning] internal configuration property to enable *partition batch pruning* and filtering out (skipping) `CachedBatches` in a partition based on column stats and the generated partition filter `Predicate`

NOTE: If spark-sql-properties.md#spark.sql.inMemoryColumnarStorage.partitionPruning[spark.sql.inMemoryColumnarStorage.partitionPruning] internal configuration property is disabled (i.e. `false`), `filteredCachedBatches` does nothing and simply passes all CachedBatch elements along.

NOTE: spark-sql-properties.md#spark.sql.inMemoryColumnarStorage.partitionPruning[spark.sql.inMemoryColumnarStorage.partitionPruning] internal configuration property is enabled by default.

NOTE: `filteredCachedBatches` is used exclusively when `InMemoryTableScanExec` is requested for the <<inputRDD, inputRDD>> internal property.

=== [[statsFor]] `statsFor` Internal Method

[source, scala]
----
statsFor(a: Attribute)
----

`statsFor`...FIXME

NOTE: `statsFor` is used when...FIXME

=== [[createAndDecompressColumn]] `createAndDecompressColumn` Internal Method

[source, scala]
----
createAndDecompressColumn(cachedColumnarBatch: CachedBatch): ColumnarBatch
----

`createAndDecompressColumn` takes the number of rows in the input `CachedBatch`.

`createAndDecompressColumn` requests spark-sql-OffHeapColumnVector.md#allocateColumns[OffHeapColumnVector] or spark-sql-OnHeapColumnVector.md#allocateColumns[OnHeapColumnVector] to allocate column vectors (with the number of rows and <<columnarBatchSchema, columnarBatchSchema>>) per the spark-sql-properties.md#spark.sql.columnVector.offheap.enabled[spark.sql.columnVector.offheap.enabled] internal configuration flag, i.e. `true` or `false`, respectively.

NOTE: spark-sql-properties.md#spark.sql.columnVector.offheap.enabled[spark.sql.columnVector.offheap.enabled] internal configuration flag is disabled by default which means that spark-sql-OnHeapColumnVector.md[OnHeapColumnVector] is used.

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

. Requests `GenerateColumnAccessor` to spark-sql-CodeGenerator.md#generate[generate] the Java code for a `ColumnarIterator` to perform expression evaluation for the given <<attributes, column types>>.

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

NOTE: `doExecute` is part of <<SparkPlan.md#doExecute, SparkPlan Contract>> to generate the runtime representation of a structured query as a distributed computation over <<spark-sql-InternalRow.md#, internal binary rows>> on Apache Spark (i.e. `RDD[InternalRow]`).

`doExecute` branches off per <<supportsBatch, supportsBatch>> flag.

With <<supportsBatch, supportsBatch>> flag on, `doExecute` creates a spark-sql-SparkPlan-WholeStageCodegenExec.md#creating-instance[WholeStageCodegenExec] (with the `InMemoryTableScanExec` physical operator as the spark-sql-SparkPlan-WholeStageCodegenExec.md#child[child] and spark-sql-SparkPlan-WholeStageCodegenExec.md#codegenStageId[codegenStageId] as `0`) and requests it to SparkPlan.md#execute[execute].

Otherwise, when <<supportsBatch, supportsBatch>> flag is off, `doExecute` simply gives the <<inputRDD, input RDD of internal rows>>.

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
