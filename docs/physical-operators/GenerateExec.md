---
title: GenerateExec
---

# GenerateExec Unary Physical Operator

`GenerateExec` is a [unary physical operator](UnaryExecNode.md) to manage execution of a [Generator](#generator) expression.

`GenerateExec` represents [Generate](../logical-operators/Generate.md) unary logical operator at execution time.

When [executed](#doExecute), `GenerateExec` [executes](../expressions/Generator.md#eval) (aka _evaluates_) the [Generator](#boundGenerator) expression on every row in a RDD partition.

![GenerateExec's Execution -- `doExecute` Method](../images/spark-sql-GenerateExec-doExecute.png)

`GenerateExec` supports [Java code generation](CodegenSupport.md) (aka _codegen_) only when this [Generator](#generator) does.

## Creating Instance

`GenerateExec` takes the following to be created:

* <span id="generator"> [Generator](../expressions/Generator.md) Expression
* [Required child attributes](#requiredChildOutput)
* <span id="outer"> `outer` Flag
* <span id="generatorOutput"> Generator Output [Attribute](../expressions/Attribute.md)s
* <span id="child"> Child [Physical Operator](SparkPlan.md)

`GenerateExec` is created when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (to plan [Generate](../logical-operators/Generate.md) logical operator)

### Required Child Attributes { #requiredChildOutput }

`GenerateExec` is given the required child [attribute](../expressions/Attribute.md)s when [created](#creating-instance).

The required child attributes are by default the [requiredChildOutput](../logical-operators/Generate.md#requiredChildOutput) of this [Generator](#generator) expression.

## Performance Metrics { #metrics }

Key             | Name (in web UI)        | Description
----------------|-------------------------|---------
numOutputRows   | number of output rows   | Number of output rows

![GenerateExec in web UI (Details for Query)](../images/spark-sql-GenerateExec-webui-details-for-query.png)

## Executing Operator { #doExecute }

??? note "SparkPlan"

    ```scala
    doExecute(): RDD[InternalRow]
    ```

    `doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute` requests the [child physical operator](#child) to [execute](SparkPlan.md#execute) (that creates a `RDD[InternalRow]`).

`doExecute` uses `RDD.mapPartitionsWithIndexInternal` operator to process each partition of the RDD.

For every partition, `doExecute` requests the [boundGenerator](#boundGenerator) to [initialize](../expressions/Nondeterministic.md#initialize) (with the partition index) if [Nondeterministic](../expressions/Nondeterministic.md).

With some extra _voodoo_, `doExecute` requests the [boundGenerator](#boundGenerator) to [eval](../expressions/Generator.md#eval) on every row in the current partition.

After all rows in a partition have been processed, `doExecute` requests the [boundGenerator](#boundGenerator) to [terminate](../expressions/Generator.md#terminate).

In the end, `doExecute` converts the rows to [UnsafeRow](../UnsafeRow.md)s and increments the [numOutputRows](#numOutputRows) metric.

## supportCodegen { #supportCodegen }

??? note "CodegenSupport"

    ```scala
    supportCodegen: Boolean
    ```

    `supportCodegen` is part of the [CodegenSupport](CodegenSupport.md#supportCodegen) abstraction.

`supportCodegen` is the [supportCodegen](CodegenSupport.md#supportCodegen) of this [Generator](#generator).

## Demo

```scala
val nums = Seq((0 to 4).toArray).toDF("nums")
val q = nums.withColumn("explode", explode($"nums"))
```

```text
scala> q.explain
== Physical Plan ==
*(1) Generate explode(nums#4), [nums#4], false, [explode#7]
+- *(1) LocalTableScan [nums#4]
```

```scala
val sparkPlan = q.queryExecution.executedPlan
import org.apache.spark.sql.execution.GenerateExec
val ge = sparkPlan.collect { case ge: GenerateExec => ge }.head
```

```text
scala> :type ge
org.apache.spark.sql.execution.GenerateExec
```

```scala
val rdd = ge.execute
```

```text
scala> rdd.toDebugString
res1: String =
(1) MapPartitionsRDD[2] at execute at <console>:1 []
 |  MapPartitionsRDD[1] at execute at <console>:1 []
 |  ParallelCollectionRDD[0] at execute at <console>:1 []
```

### Code Generation

??? note "spark.sql.codegen.comments"
    Turn [spark.sql.codegen.comments](../configuration-properties.md#spark.sql.codegen.comments) on to see comments in the code.

    ```text
    ./bin/spark-shell --conf spark.sql.codegen.comments=true
    ```

```text
val q = spark.range(1)
  .selectExpr("inline(array(struct(1, 'a'), struct(2, 'b')))")
```

```text
scala> q.explain
== Physical Plan ==
*(1) Generate inline([[1,a],[2,b]]), false, [col1#12, col2#13]
+- *(1) Project
   +- *(1) Range (0, 1, step=1, splits=16)
```

```scala
val sparkPlan = q.queryExecution.executedPlan
import org.apache.spark.sql.execution.GenerateExec
val ge = sparkPlan.collect { case ge: GenerateExec => ge }.head
```

!!! note "FIXME"

```scala
import org.apache.spark.sql.execution.WholeStageCodegenExec
val wsce = ge.child.asInstanceOf[WholeStageCodegenExec]
val (_, code) = wsce.doCodeGen
import org.apache.spark.sql.catalyst.expressions.codegen.CodeFormatter
val formattedCode = CodeFormatter.format(code)
```

```text
scala> println(formattedCode)
/* 001 */ public Object generate(Object[] references) {
/* 002 */   return new GeneratedIterator(references);
/* 003 */ }
/* 004 */
/* 005 */ /**
 * Codegend pipeline for
 * Project
 * +- Range (0, 1, step=1, splits=8)
 */
/* 006 */ final class GeneratedIterator extends org.apache.spark.sql.execution.BufferedRowIterator {
/* 007 */   private Object[] references;
/* 008 */   private scala.collection.Iterator[] inputs;
/* 009 */   private org.apache.spark.sql.execution.metric.SQLMetric range_numOutputRows;
/* 010 */   private boolean range_initRange;
/* 011 */   private long range_number;
/* 012 */   private TaskContext range_taskContext;
/* 013 */   private InputMetrics range_inputMetrics;
/* 014 */   private long range_batchEnd;
/* 015 */   private long range_numElementsTodo;
/* 016 */   private scala.collection.Iterator range_input;
/* 017 */   private UnsafeRow range_result;
/* 018 */   private org.apache.spark.sql.catalyst.expressions.codegen.BufferHolder range_holder;
/* 019 */   private org.apache.spark.sql.catalyst.expressions.codegen.UnsafeRowWriter range_rowWriter;
/* 020 */
/* 021 */   public GeneratedIterator(Object[] references) {
/* 022 */     this.references = references;
/* 023 */   }
/* 024 */
/* 025 */   public void init(int index, scala.collection.Iterator[] inputs) {
/* 026 */     partitionIndex = index;
/* 027 */     this.inputs = inputs;
/* 028 */     range_numOutputRows = (org.apache.spark.sql.execution.metric.SQLMetric) references[0];
/* 029 */     range_initRange = false;
/* 030 */     range_number = 0L;
/* 031 */     range_taskContext = TaskContext.get();
/* 032 */     range_inputMetrics = range_taskContext.taskMetrics().inputMetrics();
/* 033 */     range_batchEnd = 0;
/* 034 */     range_numElementsTodo = 0L;
/* 035 */     range_input = inputs[0];
/* 036 */     range_result = new UnsafeRow(1);
/* 037 */     range_holder = new org.apache.spark.sql.catalyst.expressions.codegen.BufferHolder(range_result, 0);
/* 038 */     range_rowWriter = new org.apache.spark.sql.catalyst.expressions.codegen.UnsafeRowWriter(range_holder, 1);
/* 039 */
/* 040 */   }
/* 041 */
/* 042 */   private void initRange(int idx) {
/* 043 */     java.math.BigInteger index = java.math.BigInteger.valueOf(idx);
/* 044 */     java.math.BigInteger numSlice = java.math.BigInteger.valueOf(8L);
/* 045 */     java.math.BigInteger numElement = java.math.BigInteger.valueOf(1L);
/* 046 */     java.math.BigInteger step = java.math.BigInteger.valueOf(1L);
/* 047 */     java.math.BigInteger start = java.math.BigInteger.valueOf(0L);
/* 048 */     long partitionEnd;
/* 049 */
/* 050 */     java.math.BigInteger st = index.multiply(numElement).divide(numSlice).multiply(step).add(start);
/* 051 */     if (st.compareTo(java.math.BigInteger.valueOf(Long.MAX_VALUE)) > 0) {
/* 052 */       range_number = Long.MAX_VALUE;
/* 053 */     } else if (st.compareTo(java.math.BigInteger.valueOf(Long.MIN_VALUE)) < 0) {
/* 054 */       range_number = Long.MIN_VALUE;
/* 055 */     } else {
/* 056 */       range_number = st.longValue();
/* 057 */     }
/* 058 */     range_batchEnd = range_number;
/* 059 */
/* 060 */     java.math.BigInteger end = index.add(java.math.BigInteger.ONE).multiply(numElement).divide(numSlice)
/* 061 */     .multiply(step).add(start);
/* 062 */     if (end.compareTo(java.math.BigInteger.valueOf(Long.MAX_VALUE)) > 0) {
/* 063 */       partitionEnd = Long.MAX_VALUE;
/* 064 */     } else if (end.compareTo(java.math.BigInteger.valueOf(Long.MIN_VALUE)) < 0) {
/* 065 */       partitionEnd = Long.MIN_VALUE;
/* 066 */     } else {
/* 067 */       partitionEnd = end.longValue();
/* 068 */     }
/* 069 */
/* 070 */     java.math.BigInteger startToEnd = java.math.BigInteger.valueOf(partitionEnd).subtract(
/* 071 */       java.math.BigInteger.valueOf(range_number));
/* 072 */     range_numElementsTodo  = startToEnd.divide(step).longValue();
/* 073 */     if (range_numElementsTodo < 0) {
/* 074 */       range_numElementsTodo = 0;
/* 075 */     } else if (startToEnd.remainder(step).compareTo(java.math.BigInteger.valueOf(0L)) != 0) {
/* 076 */       range_numElementsTodo++;
/* 077 */     }
/* 078 */   }
/* 079 */
/* 080 */   protected void processNext() throws java.io.IOException {
/* 081 */     // PRODUCE: Project
/* 082 */     // PRODUCE: Range (0, 1, step=1, splits=8)
/* 083 */     // initialize Range
/* 084 */     if (!range_initRange) {
/* 085 */       range_initRange = true;
/* 086 */       initRange(partitionIndex);
/* 087 */     }
/* 088 */
/* 089 */     while (true) {
/* 090 */       long range_range = range_batchEnd - range_number;
/* 091 */       if (range_range != 0L) {
/* 092 */         int range_localEnd = (int)(range_range / 1L);
/* 093 */         for (int range_localIdx = 0; range_localIdx < range_localEnd; range_localIdx++) {
/* 094 */           long range_value = ((long)range_localIdx * 1L) + range_number;
/* 095 */
/* 096 */           // CONSUME: Project
/* 097 */           // CONSUME: WholeStageCodegen
/* 098 */           append(unsafeRow);
/* 099 */
/* 100 */           if (shouldStop()) { range_number = range_value + 1L; return; }
/* 101 */         }
/* 102 */         range_number = range_batchEnd;
/* 103 */       }
/* 104 */
/* 105 */       range_taskContext.killTaskIfInterrupted();
/* 106 */
/* 107 */       long range_nextBatchTodo;
/* 108 */       if (range_numElementsTodo > 1000L) {
/* 109 */         range_nextBatchTodo = 1000L;
/* 110 */         range_numElementsTodo -= 1000L;
/* 111 */       } else {
/* 112 */         range_nextBatchTodo = range_numElementsTodo;
/* 113 */         range_numElementsTodo = 0;
/* 114 */         if (range_nextBatchTodo == 0) break;
/* 115 */       }
/* 116 */       range_numOutputRows.add(range_nextBatchTodo);
/* 117 */       range_inputMetrics.incRecordsRead(range_nextBatchTodo);
/* 118 */
/* 119 */       range_batchEnd += range_nextBatchTodo * 1L;
/* 120 */     }
/* 121 */   }
/* 122 */
/* 123 */ }
```
