title: BroadcastHashJoinExec

# BroadcastHashJoinExec Binary Physical Operator for Broadcast Hash Join

`BroadcastHashJoinExec` is a SparkPlan.md#BinaryExecNode[binary physical operator] to <<doExecute, perform>> a *broadcast hash join*.

`BroadcastHashJoinExec` is <<creating-instance, created>> after applying [JoinSelection](../execution-planning-strategies/JoinSelection.md) execution planning strategy to spark-sql-ExtractEquiJoinKeys.md[ExtractEquiJoinKeys]-destructurable logical query plans (i.e. [INNER, CROSS, LEFT OUTER, LEFT SEMI, LEFT ANTI](../execution-planning-strategies/JoinSelection.md#canBuildRight)) of which the `right` physical operator [can be broadcast](../execution-planning-strategies/JoinSelection.md#canBroadcast).

`BroadcastHashJoinExec` supports [Java code generation](CodegenSupport.md) (aka _codegen_).

```text
val tokens = Seq(
  (0, "playing"),
  (1, "with"),
  (2, "BroadcastHashJoinExec")
).toDF("id", "token")

scala> spark.conf.get("spark.sql.autoBroadcastJoinThreshold")
res0: String = 10485760

val q = tokens.join(tokens, Seq("id"), "inner")
scala> q.explain
== Physical Plan ==
*Project [id#15, token#16, token#21]
+- *BroadcastHashJoin [id#15], [id#20], Inner, BuildRight
   :- LocalTableScan [id#15, token#16]
   +- BroadcastExchange HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)))
      +- LocalTableScan [id#20, token#21]
```

`BroadcastHashJoinExec` <<requiredChildDistribution, requires that partition requirements>> for the two children physical operators match [BroadcastDistribution](BroadcastDistribution.md) (with a [HashedRelationBroadcastMode](HashedRelationBroadcastMode.md)) and [UnspecifiedDistribution](UnspecifiedDistribution.md) (for <<left, left>> and <<right, right>> sides of a join or vice versa).

[[metrics]]
.BroadcastHashJoinExec's Performance Metrics
[cols="1,2,2",options="header",width="100%"]
|===
| Key
| Name (in web UI)
| Description

| [[numOutputRows]] `numOutputRows`
| number of output rows
|

| [[avgHashProbe]] `avgHashProbe`
| avg hash probe
|
|===

.BroadcastHashJoinExec in web UI (Details for Query)
image::images/spark-sql-BroadcastHashJoinExec-webui-query-details.png[align="center"]

NOTE: The prefix for variable names for `BroadcastHashJoinExec` operators in [CodegenSupport](CodegenSupport.md)-generated code is *bhj*.

[source, scala]
----
scala> q.queryExecution.debug.codegen
Found 1 WholeStageCodegen subtrees.
== Subtree 1 / 1 ==
*Project [id#15, token#16, token#21]
+- *BroadcastHashJoin [id#15], [id#20], Inner, BuildRight
   :- LocalTableScan [id#15, token#16]
   +- BroadcastExchange HashedRelationBroadcastMode(List(cast(input[0, int, false] as bigint)))
      +- LocalTableScan [id#20, token#21]

Generated code:
/* 001 */ public Object generate(Object[] references) {
/* 002 */   return new GeneratedIterator(references);
/* 003 */ }
/* 004 */
/* 005 */ final class GeneratedIterator extends org.apache.spark.sql.execution.BufferedRowIterator {
/* 006 */   private Object[] references;
/* 007 */   private scala.collection.Iterator[] inputs;
/* 008 */   private scala.collection.Iterator inputadapter_input;
/* 009 */   private org.apache.spark.broadcast.TorrentBroadcast bhj_broadcast;
/* 010 */   private org.apache.spark.sql.execution.joins.LongHashedRelation bhj_relation;
/* 011 */   private org.apache.spark.sql.execution.metric.SQLMetric bhj_numOutputRows;
/* 012 */   private UnsafeRow bhj_result;
/* 013 */   private org.apache.spark.sql.catalyst.expressions.codegen.BufferHolder bhj_holder;
/* 014 */   private org.apache.spark.sql.catalyst.expressions.codegen.UnsafeRowWriter bhj_rowWriter;
...
----

[[requiredChildDistribution]]
.BroadcastHashJoinExec's Required Child Output Distributions
[cols="1m,2,2",options="header",width="100%"]
|===
| BuildSide
| Left Child
| Right Child

| BuildLeft
| [BroadcastDistribution](BroadcastDistribution.md) with [HashedRelationBroadcastMode](HashedRelationBroadcastMode.md) broadcast mode of [build join keys](HashJoin.md#buildKeys)
| [UnspecifiedDistribution](UnspecifiedDistribution.md)

| BuildRight
| [UnspecifiedDistribution](UnspecifiedDistribution.md)
| [BroadcastDistribution](BroadcastDistribution.md) with [HashedRelationBroadcastMode](HashedRelationBroadcastMode.md) broadcast mode of [build join keys](HashJoin.md#buildKeys)
|===

=== [[doExecute]] Executing Physical Operator (Generating RDD[InternalRow]) -- `doExecute` Method

[source, scala]
----
doExecute(): RDD[InternalRow]
----

NOTE: `doExecute` is part of <<SparkPlan.md#doExecute, SparkPlan Contract>> to generate the runtime representation of a structured query as a distributed computation over <<spark-sql-InternalRow.md#, internal binary rows>> on Apache Spark (i.e. `RDD[InternalRow]`).

`doExecute`...FIXME

=== [[codegenInner]] Generating Java Source Code for Inner Join -- `codegenInner` Internal Method

[source, scala]
----
codegenInner(ctx: CodegenContext, input: Seq[ExprCode]): String
----

`codegenInner`...FIXME

NOTE: `codegenInner` is used exclusively when `BroadcastHashJoinExec` is requested to <<doConsume, generate the Java code for the "consume" path in whole-stage code generation>>.

=== [[codegenOuter]] Generating Java Source Code for Left or Right Outer Join -- `codegenOuter` Internal Method

[source, scala]
----
codegenOuter(ctx: CodegenContext, input: Seq[ExprCode]): String
----

`codegenOuter`...FIXME

NOTE: `codegenOuter` is used exclusively when `BroadcastHashJoinExec` is requested to <<doConsume, generate the Java code for the "consume" path in whole-stage code generation>>.

=== [[codegenSemi]] Generating Java Source Code for Left Semi Join -- `codegenSemi` Internal Method

[source, scala]
----
codegenSemi(ctx: CodegenContext, input: Seq[ExprCode]): String
----

`codegenSemi`...FIXME

NOTE: `codegenSemi` is used exclusively when `BroadcastHashJoinExec` is requested to <<doConsume, generate the Java code for the "consume" path in whole-stage code generation>>.

=== [[codegenAnti]] Generating Java Source Code for Anti Join -- `codegenAnti` Internal Method

[source, scala]
----
codegenAnti(ctx: CodegenContext, input: Seq[ExprCode]): String
----

`codegenAnti`...FIXME

NOTE: `codegenAnti` is used exclusively when `BroadcastHashJoinExec` is requested to <<doConsume, generate the Java code for the "consume" path in whole-stage code generation>>.

=== [[codegenExistence]] `codegenExistence` Internal Method

[source, scala]
----
codegenExistence(ctx: CodegenContext, input: Seq[ExprCode]): String
----

`codegenExistence`...FIXME

NOTE: `codegenExistence` is used exclusively when `BroadcastHashJoinExec` is requested to <<doConsume, generate the Java code for the "consume" path in whole-stage code generation>>.

=== [[genStreamSideJoinKey]] `genStreamSideJoinKey` Internal Method

[source, scala]
----
genStreamSideJoinKey(
  ctx: CodegenContext,
  input: Seq[ExprCode]): (ExprCode, String)
----

`genStreamSideJoinKey`...FIXME

NOTE: `genStreamSideJoinKey` is used when `BroadcastHashJoinExec` is requested to generate the Java source code for <<codegenInner, inner>>, <<codegenOuter, outer>>, <<codegenSemi, left semi>>, <<codegenAnti, anti>> and <<codegenExistence, existence>> joins (for the "consume" path in whole-stage code generation).

=== [[creating-instance]] Creating BroadcastHashJoinExec Instance

`BroadcastHashJoinExec` takes the following when created:

* [[leftKeys]] Left join key expressions/Expression.md[expressions]
* [[rightKeys]] Right join key expressions/Expression.md[expressions]
* [[joinType]] spark-sql-joins.md#join-types[Join type]
* [[buildSide]] `BuildSide`
* [[condition]] Optional join condition expressions/Expression.md[expression]
* [[left]] Left SparkPlan.md[physical operator]
* [[right]] Right SparkPlan.md[physical operator]
