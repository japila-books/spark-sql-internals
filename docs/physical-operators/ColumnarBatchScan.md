# ColumnarBatchScan

`ColumnarBatchScan` is an <<contract, extension>> of [CodegenSupport](CodegenSupport.md) abstraction for <<implementations, physical operators>> that <<supportsBatch, support columnar batch scan>> (aka *vectorized reader*).

`ColumnarBatchScan` uses the <<supportsBatch, supportsBatch>> flag that is enabled (i.e. `true`) by default. It is expected that physical operators would override it to support vectorized decoding only when specific conditions are met (i.e. FileSourceScanExec.md#supportsBatch[FileSourceScanExec], InMemoryTableScanExec.md#supportsBatch[InMemoryTableScanExec] and DataSourceV2ScanExec.md#supportsBatch[DataSourceV2ScanExec] physical operators).

[[needsUnsafeRowConversion]]
`ColumnarBatchScan` uses the `needsUnsafeRowConversion` flag to control the name of the variable for an input row while [generating the Java source code to consume generated columns or row from a physical operator](CodegenSupport.md#consume) that is used while <<produceRows, generating the Java source code for producing rows>>. `needsUnsafeRowConversion` flag is enabled (i.e. `true`) by default that gives no name for the row term.

[[implementations]]
.ColumnarBatchScans
[cols="1,3",options="header",width="100%"]
|===
| ColumnarBatchScan
| Description

| <<FileSourceScanExec.md#, FileSourceScanExec>>
| [[FileSourceScanExec]] <<FileSourceScanExec.md#supportsBatch, Supports vectorized decoding>> for [FileFormats](../datasources/FileFormat.md) that [support returning columnar batches](../datasources/FileFormat.md#supportBatch) (default: `false`)

| <<InMemoryTableScanExec.md#, InMemoryTableScanExec>>
a| [[InMemoryTableScanExec]] <<InMemoryTableScanExec.md#supportsBatch, Supports vectorized decoding>> when all of the following hold:

* [spark.sql.inMemoryColumnarStorage.enableVectorizedReader](../configuration-properties.md#spark.sql.inMemoryColumnarStorage.enableVectorizedReader) configuration property is enabled

* Uses primitive data types only for the output schema

* Number of fields in the output schema is not more than [spark.sql.codegen.maxFields](../configuration-properties.md#spark.sql.codegen.maxFields) configuration property
|===

=== [[genCodeColumnVector]] `genCodeColumnVector` Internal Method

[source, scala]
----
genCodeColumnVector(
  ctx: CodegenContext,
  columnVar: String,
  ordinal: String,
  dataType: DataType,
  nullable: Boolean): ExprCode
----

`genCodeColumnVector`...FIXME

NOTE: `genCodeColumnVector` is used exclusively when `ColumnarBatchScan` is requested to <<produceBatches, produceBatches>>.

=== [[produceBatches]] Generating Java Source Code to Produce Columnar Batches (for Vectorized Reading) -- `produceBatches` Internal Method

[source, scala]
----
produceBatches(ctx: CodegenContext, input: String): String
----

`produceBatches` gives the Java source code to produce batches...FIXME

[source, scala]
----
// Example to show produceBatches to generate a Java source code
// Uses InMemoryTableScanExec as a ColumnarBatchScan

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
----

NOTE: `produceBatches` is used exclusively when `ColumnarBatchScan` is requested to <<doProduce, generate the Java source code for produce path in whole-stage code generation>> (when <<supportsBatch, supportsBatch>> flag is on).

=== [[supportsBatch]] `supportsBatch` Method

[source, scala]
----
supportsBatch: Boolean = true
----

`supportsBatch` flag controls whether a [FileFormat](../datasources/FileFormat.md) supports [vectorized decoding](../vectorized-decoding/index.md) or not. `supportsBatch` is enabled (i.e. `true`) by default.

`supportsBatch` is used when:

* `ColumnarBatchScan` is requested to <<doProduce, generate the Java source code for produce path in whole-stage code generation>>

* `FileSourceScanExec` physical operator is requested for FileSourceScanExec.md#metadata[metadata] (for *Batched* metadata) and to FileSourceScanExec.md#doExecute[execute]

* `InMemoryTableScanExec` physical operator is requested for InMemoryTableScanExec.md#supportCodegen[supportCodegen] flag, InMemoryTableScanExec.md#inputRDD[input RDD] and to InMemoryTableScanExec.md#doExecute[execute]

* `DataSourceV2ScanExec` physical operator is requested to DataSourceV2ScanExec.md#doExecute[execute]

=== [[doProduce]] Generating Java Source Code for Produce Path in Whole-Stage Code Generation -- `doProduce` Method

[source, scala]
----
doProduce(ctx: CodegenContext): String
----

`doProduce` firstly requests the input `CodegenContext` to [add a mutable state](../whole-stage-code-generation/CodegenContext.md#addMutableState) for the first input RDD of a <<implementations, physical operator>>.

`doProduce` <<produceBatches, produceBatches>> when <<supportsBatch, supportsBatch>> is enabled or <<produceRows, produceRows>>.

NOTE: <<supportsBatch, supportsBatch>> is enabled by default unless overriden by a physical operator.

`doProduce` is part of the [CodegenSupport](CodegenSupport.md#doProduce) abstraction.

[source, scala]
----
// Example 1: ColumnarBatchScan with supportsBatch enabled
// Let's create a query with a InMemoryTableScanExec physical operator that supports batch decoding
// InMemoryTableScanExec is a ColumnarBatchScan
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

// Example 2: ColumnarBatchScan with supportsBatch disabled

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
----

=== [[produceRows]] Generating Java Source Code for Producing Rows -- `produceRows` Internal Method

[source, scala]
----
produceRows(ctx: CodegenContext, input: String): String
----

`produceRows` creates a new [metric term](CodegenSupport.md#metricTerm) for the <<numOutputRows, numOutputRows>> metric.

`produceRows` creates a [fresh term name](../whole-stage-code-generation/CodegenContext.md#freshName) for a `row` variable and assigns it as the name of the [INPUT_ROW](../whole-stage-code-generation/CodegenContext.md#INPUT_ROW).

`produceRows` resets (`nulls`) [currentVars](../whole-stage-code-generation/CodegenContext.md#currentVars).

For every [output schema attribute](../catalyst/QueryPlan.md#output), `produceRows` creates a [BoundReference](../expressions/BoundReference.md) and requests it to [generate code for expression evaluation](../expressions/Expression.md#genCode).

`produceRows` selects the name of the row term per <<needsUnsafeRowConversion, needsUnsafeRowConversion>> flag.

`produceRows` [generates the Java source code to consume generated columns or row from the current physical operator](CodegenSupport.md#consume) and uses it to generate the final Java source code for producing rows.

[source, scala]
----
// Demo: ColumnarBatchScan.produceRows in Action
// 1. FileSourceScanExec as a ColumnarBatchScan
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
----

NOTE: `produceRows` is used exclusively when `ColumnarBatchScan` is requested to <<doProduce, generate the Java source code for produce path in whole-stage code generation>> (when <<supportsBatch, supportsBatch>> flag is off).

=== [[vectorTypes]] Fully-Qualified Class Names (Types) of Concrete ColumnVectors -- `vectorTypes` Method

[source, scala]
----
vectorTypes: Option[Seq[String]] = None
----

`vectorTypes` defines the fully-qualified class names (_types_) of the concrete [ColumnVector](../ColumnVector.md)s for every column used in a columnar batch.

`vectorTypes` gives no vector types by default (`None`).

`vectorTypes` is used when `ColumnarBatchScan` is requested to [produceBatches](#produceBatches).

## <span id="metrics"> Performance Metrics

Key            | Name (in web UI)        | Description
---------------|-------------------------|---------
 numOutputRows | number of output rows   | Number of output rows
 scanTime      | scan time |
