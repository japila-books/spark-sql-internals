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

`BroadcastHashJoinExec` is created when:

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

`requiredChildDistribution` is part of the [SparkPlan](SparkPlan.md#requiredChildDistribution) abstraction.

BuildSide | Left Child | Right Child
----------|------------|------------
 BuildLeft | [BroadcastDistribution](BroadcastDistribution.md) with [HashedRelationBroadcastMode](HashedRelationBroadcastMode.md) broadcast mode of [build join keys](HashJoin.md#buildKeys) | [UnspecifiedDistribution](UnspecifiedDistribution.md)
 BuildRight | [UnspecifiedDistribution](UnspecifiedDistribution.md) | [BroadcastDistribution](BroadcastDistribution.md) with [HashedRelationBroadcastMode](HashedRelationBroadcastMode.md) broadcast mode of [build join keys](HashJoin.md#buildKeys)

## <span id="outputPartitioning"> Output Data Partitioning Requirements

```scala
outputPartitioning: Partitioning
```

`outputPartitioning` is part of the [SparkPlan](SparkPlan.md#outputPartitioning) abstraction.

`outputPartitioning`...FIXME

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

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

`codegenAnti` is part of the [HashJoin](HashJoin.md#codegenAnti) abstraction.

`codegenAnti`...FIXME

## Demo

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

```text
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
```
