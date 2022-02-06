# Debugging Query Execution

`debug` is a Scala package object with utilities for debugging query execution and an in-depth analysis of structured queries.

```scala
import org.apache.spark.sql.execution.debug._

// Every Dataset (incl. DataFrame) has now the debug and debugCodegen methods
val q: DataFrame = ???
q.debug
q.debugCodegen
```

!!! tip "Package Objects"
    Read up on [Package Objects](https://www.scala-lang.org/docu/files/packageobjects/packageobjects.html) in the Scala programming language.

[debug](#debug) and [debugCodegen](#debugCodegen) are part of an implicit class (`DebugQuery`) that takes a [Dataset](Dataset.md) when created (that is the query to execute`debug` on).

!!! tip
    Read up on [Implicit Classes](https://docs.scala-lang.org/overviews/core/implicit-classes.html) in the official documentation of the Scala programming language.

## Demo

```scala
val q = spark.range(5).join(spark.range(10), Seq("id"), "inner")
```

```scala
import org.apache.spark.sql.execution.debug._
```

```text
scala> q.debugCodegen
Found 0 WholeStageCodegen subtrees.
```

What?! "Found 0 WholeStageCodegen subtrees."! _Inconceivable!_

The reason is that the query has not been [Adaptive Query Execution](adaptive-query-execution/index.md)-optimized yet (the [isFinalPlan](physical-operators/AdaptiveSparkPlanExec.md#isFinalPlan) flag is `false`).

```text
scala> println(q.queryExecution.executedPlan.numberedTreeString)
00 AdaptiveSparkPlan isFinalPlan=false
01 +- Project [id#4L]
02    +- BroadcastHashJoin [id#4L], [id#6L], Inner, BuildLeft, false
03       :- BroadcastExchange HashedRelationBroadcastMode(List(input[0, bigint, false]),false), [id=#16]
04       :  +- Range (0, 5, step=1, splits=16)
05       +- Range (0, 10, step=1, splits=16)
```

Execute [Adaptive Query Execution](adaptive-query-execution/index.md) optimization.

```scala
q.queryExecution.executedPlan.executeTake(1)
```

Note that the [isFinalPlan](physical-operators/AdaptiveSparkPlanExec.md#isFinalPlan) flag is `true`.

```text
scala> println(q.queryExecution.executedPlan.numberedTreeString)
00 AdaptiveSparkPlan isFinalPlan=true
01 +- == Final Plan ==
02    *(2) Project [id#4L]
03    +- *(2) BroadcastHashJoin [id#4L], [id#6L], Inner, BuildLeft, false
04       :- BroadcastQueryStage 0
05       :  +- BroadcastExchange HashedRelationBroadcastMode(List(input[0, bigint, false]),false), [id=#22]
06       :     +- *(1) Range (0, 5, step=1, splits=16)
07       +- *(2) Range (0, 10, step=1, splits=16)
08 +- == Initial Plan ==
09    Project [id#4L]
10    +- BroadcastHashJoin [id#4L], [id#6L], Inner, BuildLeft, false
11       :- BroadcastExchange HashedRelationBroadcastMode(List(input[0, bigint, false]),false), [id=#16]
12       :  +- Range (0, 5, step=1, splits=16)
13       +- Range (0, 10, step=1, splits=16)
```

```text
scala> q.debugCodegen
Found 2 WholeStageCodegen subtrees.
== Subtree 1 / 2 (maxMethodCodeSize:282; maxConstantPoolSize:175(0.27% used); numInnerClasses:0) ==
*(1) Range (0, 5, step=1, splits=16)

Generated code:
/* 001 */ public Object generate(Object[] references) {
/* 002 */   return new GeneratedIteratorForCodegenStage1(references);
/* 003 */ }
/* 004 */
/* 005 */ // codegenStageId=1
/* 006 */ final class GeneratedIteratorForCodegenStage1 extends org.apache.spark.sql.execution.BufferedRowIterator {
/* 007 */   private Object[] references;
/* 008 */   private scala.collection.Iterator[] inputs;
/* 009 */   private boolean range_initRange_0;
/* 010 */   private long range_nextIndex_0;
/* 011 */   private TaskContext range_taskContext_0;
/* 012 */   private InputMetrics range_inputMetrics_0;
/* 013 */   private long range_batchEnd_0;
/* 014 */   private long range_numElementsTodo_0;
...
```

## <span id="debug"> debug

```scala
debug(): Unit
```

### Review Me

`debug` requests the <<Dataset.md#queryExecution, QueryExecution>> (of the <<query, structured query>>) for the [optimized physical query plan](QueryExecution.md#executedPlan).

`debug` [transforms](catalyst/TreeNode.md#transform) the optimized physical query plan to add a new <<DebugExec.md#, DebugExec>> physical operator for every physical operator.

`debug` requests the query plan to <<SparkPlan.md#execute, execute>> and then counts the number of rows in the result. It prints out the following message:

```text
Results returned: [count]
```

In the end, `debug` requests every `DebugExec` physical operator (in the query plan) to <<DebugExec.md#dumpStats, dumpStats>>.

```text
val q = spark.range(10).where('id === 4)

scala> :type q
org.apache.spark.sql.Dataset[Long]

// Extend Dataset[Long] with debug and debugCodegen methods
import org.apache.spark.sql.execution.debug._

scala> q.debug
Results returned: 1
== WholeStageCodegen ==
Tuples output: 1
 id LongType: {java.lang.Long}
== Filter (id#0L = 4) ==
Tuples output: 0
 id LongType: {}
== Range (0, 10, step=1, splits=8) ==
Tuples output: 0
 id LongType: {}
```

## <span id="debugCodegen"> debugCodegen

```scala
debugCodegen(): Unit
```

`debugCodegen` displays the Java source code generated for a structured query in [whole-stage code generation](whole-stage-code-generation/index.md) (i.e. the output of each [WholeStageCodegen subtree](physical-operators/WholeStageCodegenExec.md) in the query plan).

### Review Me

`debugCodegen` requests the [QueryExecution](Dataset.md#queryExecution) (of the [structured query](#query)) for the [optimized physical query plan](QueryExecution.md#executedPlan).

In the end, `debugCodegen` prints out the result to the standard output.

```text
scala> spark.range(10).where('id === 4).debugCodegen
Found 1 WholeStageCodegen subtrees.
== Subtree 1 / 1 ==
*Filter (id#29L = 4)
+- *Range (0, 10, splits=8)

Generated code:
/* 001 */ public Object generate(Object[] references) {
/* 002 */   return new GeneratedIterator(references);
/* 003 */ }
/* 004 */
/* 005 */ final class GeneratedIterator extends org.apache.spark.sql.execution.BufferedRowIterator {
/* 006 */   private Object[] references;
...
```
