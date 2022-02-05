# BroadcastHashJoinExec Physical Operator

`BroadcastHashJoinExec` is a [hash-based join physical operator](HashJoin.md) for [broadcast hash join](#doExecute).

`BroadcastHashJoinExec` supports [Java code generation](CodegenSupport.md) ([variable prefix](CodegenSupport.md#variablePrefix): `bhj`).

## <span id="metrics"> Performance Metrics

Key             | Name (in web UI)        | Description
----------------|-------------------------|---------
 numOutputRows  | number of output rows   | Number of output rows

![BroadcastHashJoinExec in web UI (Details for Query)](../images/spark-sql-BroadcastHashJoinExec-webui-query-details.png)

## Creating Instance

`BroadcastHashJoinExec` takes the following to be created:

* <span id="leftKeys"> Left Key [Expression](../expressions/Expression.md)s
* <span id="rightKeys"> Right Key [Expression](../expressions/Expression.md)s
* <span id="joinType"> [Join Type](../joins.md#join-types)
* <span id="buildSide"> `BuildSide`
* <span id="condition"> Optional Join Condition [Expression](../expressions/Expression.md)
* <span id="left"> Left Child [Physical Operator](SparkPlan.md)
* <span id="right"> Right Child [Physical Operator](SparkPlan.md)
* [isNullAwareAntiJoin](#isNullAwareAntiJoin) flag

`BroadcastHashJoinExec` is created when:

* [JoinSelection](../execution-planning-strategies/JoinSelection.md) execution planning strategy is executed ([createBroadcastHashJoin](../execution-planning-strategies/JoinSelection.md#createBroadcastHashJoin) and [ExtractSingleColumnNullAwareAntiJoin](../execution-planning-strategies/JoinSelection.md#ExtractSingleColumnNullAwareAntiJoin))
* [LogicalQueryStageStrategy](../execution-planning-strategies/LogicalQueryStageStrategy.md) execution planning strategy is executed ([ExtractEquiJoinKeys](../execution-planning-strategies/LogicalQueryStageStrategy.md#ExtractEquiJoinKeys) and [ExtractSingleColumnNullAwareAntiJoin](../execution-planning-strategies/LogicalQueryStageStrategy.md#ExtractSingleColumnNullAwareAntiJoin))

## <span id="isNullAwareAntiJoin"> isNullAwareAntiJoin Flag

`BroadcastHashJoinExec` can be given `isNullAwareAntiJoin` flag when [created](#creating-instance).

`isNullAwareAntiJoin` flag is `false` by default.

`isNullAwareAntiJoin` flag is `true` when:

* [JoinSelection](../execution-planning-strategies/JoinSelection.md) execution planning strategy is executed (for an [ExtractSingleColumnNullAwareAntiJoin](../execution-planning-strategies/JoinSelection.md#ExtractSingleColumnNullAwareAntiJoin))
* [LogicalQueryStageStrategy](../execution-planning-strategies/LogicalQueryStageStrategy.md) execution planning strategy is executed (for an [ExtractSingleColumnNullAwareAntiJoin](../execution-planning-strategies/LogicalQueryStageStrategy.md#ExtractSingleColumnNullAwareAntiJoin))

If enabled, `BroadcastHashJoinExec` makes sure that the following all hold:

1. There is one [left key](#leftKeys) only
1. There is one [right key](#rightKeys) only
1. [Join Type](#joinType) is [LeftAnti](../joins.md#joinType)
1. [Build Side](#buildSide) is `BuildRight`
1. [Join condition](#condition) is not defined

`isNullAwareAntiJoin` is used for the following:

* [Required Child Output Distribution](#requiredChildDistribution) (and create a [HashedRelationBroadcastMode](HashedRelationBroadcastMode.md))
* [Executing Physical Operator](#doExecute)
* [Generating Java Code for Anti Join](#codegenAnti)

## <span id="requiredChildDistribution"> Required Child Output Distribution

```scala
requiredChildDistribution: Seq[Distribution]
```

`requiredChildDistribution` is part of the [SparkPlan](SparkPlan.md#requiredChildDistribution) abstraction.

BuildSide | Left Child | Right Child
----------|------------|------------
 BuildLeft | [BroadcastDistribution](BroadcastDistribution.md) with [HashedRelationBroadcastMode](HashedRelationBroadcastMode.md) broadcast mode of [build join keys](HashJoin.md#buildKeys) | [UnspecifiedDistribution](UnspecifiedDistribution.md)
 BuildRight | [UnspecifiedDistribution](UnspecifiedDistribution.md) | [BroadcastDistribution](BroadcastDistribution.md) with [HashedRelationBroadcastMode](HashedRelationBroadcastMode.md) broadcast mode of [build join keys](HashJoin.md#buildKeys)

## <span id="outputPartitioning"> Output Data Partitioning Requirements

```scala
outputPartitioning: Partitioning
```

`outputPartitioning` is part of the [SparkPlan](SparkPlan.md#outputPartitioning) abstraction.

`outputPartitioning`...FIXME

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute` requests the [buildPlan](HashJoin.md#buildPlan) to [executeBroadcast](SparkPlan.md#executeBroadcast) (that gives a broadcast variable with a [HashedRelation](HashedRelation.md)).

`doExecute` branches off based on [isNullAwareAntiJoin](#isNullAwareAntiJoin) flag: [enabled](#doExecute-isNullAwareAntiJoin-enabled) or [not](#doExecute-isNullAwareAntiJoin-disabled).

### <span id="doExecute-isNullAwareAntiJoin-enabled"> isNullAwareAntiJoin Enabled

`doExecute`...FIXME

### <span id="doExecute-isNullAwareAntiJoin-disabled"> isNullAwareAntiJoin Disabled

`doExecute` requests the [streamedPlan](HashJoin.md#streamedPlan) to [execute](SparkPlan.md#execute) (that gives an `RDD[InternalRow]`) and maps over partitions (`RDD.mapPartitions`):

1. Takes the read-only copy of the [HashedRelation](HashedRelation.md#asReadOnlyCopy) (from the broadcast variable)
1. Increment the peak execution memory (of the task) by the [size](../KnownSizeEstimation.md#estimatedSize) of the `HashedRelation`
1. [Joins](HashJoin.md#join) the rows with the `HashedRelation` (with the [numOutputRows](#metrics) metric)

## <span id="codegenAnti"> Generating Java Code for Anti Join

```scala
codegenAnti(
  ctx: CodegenContext,
  input: Seq[ExprCode]): String
```

`codegenAnti` is part of the [HashJoin](HashJoin.md#codegenAnti) abstraction.

`codegenAnti`...FIXME

## Demo

```scala
val tokens = Seq(
  (0, "playing"),
  (1, "with"),
  (2, "BroadcastHashJoinExec")
).toDF("id", "token")
```

```scala
val q = tokens.join(tokens, Seq("id"), "inner")
```

```text
scala> println(q.queryExecution.executedPlan.numberedTreeString)
00 AdaptiveSparkPlan isFinalPlan=false
01 +- Project [id#18, token#19, token#25]
02    +- BroadcastHashJoin [id#18], [id#24], Inner, BuildRight, false
03       :- LocalTableScan [id#18, token#19]
04       +- BroadcastExchange HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [id=#16]
05          +- LocalTableScan [id#24, token#25]
```

```scala
import org.apache.spark.sql.execution.adaptive.AdaptiveSparkPlanExec
val op = q
  .queryExecution
  .executedPlan
  .collect { case op: AdaptiveSparkPlanExec => op }
  .head
```

```text
scala> println(op.treeString)
AdaptiveSparkPlan isFinalPlan=false
+- Project [id#18, token#19, token#25]
   +- BroadcastHashJoin [id#18], [id#24], Inner, BuildRight, false
      :- LocalTableScan [id#18, token#19]
      +- BroadcastExchange HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [id=#16]
         +- LocalTableScan [id#24, token#25]
```

Execute the adaptive operator to generate the final execution plan.

```scala
op.executeTake(1)
```

Mind the [isFinalPlan](AdaptiveSparkPlanExec.md#isFinalPlan) flag that is now enabled.

```text
scala> println(op.treeString)
AdaptiveSparkPlan isFinalPlan=true
+- == Final Plan ==
   *(1) Project [id#18, token#19, token#25]
   +- *(1) BroadcastHashJoin [id#18], [id#24], Inner, BuildRight, false
      :- *(1) LocalTableScan [id#18, token#19]
      +- BroadcastQueryStage 0
         +- BroadcastExchange HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [id=#16]
            +- LocalTableScan [id#24, token#25]
+- == Initial Plan ==
   Project [id#18, token#19, token#25]
   +- BroadcastHashJoin [id#18], [id#24], Inner, BuildRight, false
      :- LocalTableScan [id#18, token#19]
      +- BroadcastExchange HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [id=#16]
         +- LocalTableScan [id#24, token#25]
```

With the [isFinalPlan](AdaptiveSparkPlanExec.md#isFinalPlan) flag enabled, it is possible to print out the [WholeStageCodegen](WholeStageCodegenExec.md) subtrees.

```text
scala> q.queryExecution.debug.codegen
Found 1 WholeStageCodegen subtrees.
== Subtree 1 / 1 (maxMethodCodeSize:265; maxConstantPoolSize:146(0.22% used); numInnerClasses:0) ==
*(1) Project [id#18, token#19, token#25]
+- *(1) BroadcastHashJoin [id#18], [id#24], Inner, BuildRight, false
   :- *(1) LocalTableScan [id#18, token#19]
   +- BroadcastQueryStage 0
      +- BroadcastExchange HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)),false), [id=#16]
         +- LocalTableScan [id#24, token#25]

Generated code:
/* 001 */ public Object generate(Object[] references) {
/* 002 */   return new GeneratedIteratorForCodegenStage1(references);
/* 003 */ }
/* 004 */
/* 005 */ // codegenStageId=1
/* 006 */ final class GeneratedIteratorForCodegenStage1 extends org.apache.spark.sql.execution.BufferedRowIterator {
/* 007 */   private Object[] references;
/* 008 */   private scala.collection.Iterator[] inputs;
/* 009 */   private scala.collection.Iterator localtablescan_input_0;
/* 010 */   private org.apache.spark.sql.execution.joins.LongHashedRelation bhj_relation_0;
/* 011 */   private org.apache.spark.sql.catalyst.expressions.codegen.UnsafeRowWriter[] bhj_mutableStateArray_0 = new org.apache.spark.sql.catalyst.expressions.codegen.UnsafeRowWriter[2];
/* 012 */
/* 013 */   public GeneratedIteratorForCodegenStage1(Object[] references) {
/* 014 */     this.references = references;
/* 015 */   }
/* 016 */
/* 017 */   public void init(int index, scala.collection.Iterator[] inputs) {
/* 018 */     partitionIndex = index;
/* 019 */     this.inputs = inputs;
/* 020 */     localtablescan_input_0 = inputs[0];
/* 021 */
/* 022 */     bhj_relation_0 = ((org.apache.spark.sql.execution.joins.LongHashedRelation) ((org.apache.spark.broadcast.TorrentBroadcast) references[1] /* broadcast */).value()).asReadOnlyCopy();
/* 023 */     incPeakExecutionMemory(bhj_relation_0.estimatedSize());
/* 024 */
/* 025 */     bhj_mutableStateArray_0[0] = new org.apache.spark.sql.catalyst.expressions.codegen.UnsafeRowWriter(4, 64);
/* 026 */     bhj_mutableStateArray_0[1] = new org.apache.spark.sql.catalyst.expressions.codegen.UnsafeRowWriter(3, 64);
/* 027 */
/* 028 */   }
...
```

Let's access the generated source code via [WholeStageCodegenExec](WholeStageCodegenExec.md) physical operator.

```scala
val aqe = op
import org.apache.spark.sql.execution.WholeStageCodegenExec
val wsce = aqe.executedPlan
  .collect { case op: WholeStageCodegenExec => op }
  .head
val (_, source) = wsce.doCodeGen
```

```text
import org.apache.spark.sql.catalyst.expressions.codegen.CodeFormatter
val formattedCode = CodeFormatter.format(source)
```

```text
scala> println(formattedCode)
/* 001 */ public Object generate(Object[] references) {
/* 002 */   return new GeneratedIteratorForCodegenStage1(references);
/* 003 */ }
/* 004 */
/* 005 */ // codegenStageId=1
/* 006 */ final class GeneratedIteratorForCodegenStage1 extends org.apache.spark.sql.execution.BufferedRowIterator {
/* 007 */   private Object[] references;
/* 008 */   private scala.collection.Iterator[] inputs;
/* 009 */   private scala.collection.Iterator localtablescan_input_0;
/* 010 */   private org.apache.spark.sql.execution.joins.LongHashedRelation bhj_relation_0;
/* 011 */   private org.apache.spark.sql.catalyst.expressions.codegen.UnsafeRowWriter[] bhj_mutableStateArray_0 = new org.apache.spark.sql.catalyst.expressions.codegen.UnsafeRowWriter[2];
/* 012 */
/* 013 */   public GeneratedIteratorForCodegenStage1(Object[] references) {
/* 014 */     this.references = references;
/* 015 */   }
...
```
