# ShuffledHashJoinExec Physical Operator

`ShuffledHashJoinExec` is a [ShuffledJoin](#ShuffledJoin) and [HashJoin](#HashJoin) for [shuffle-hash join](#doExecute).

`ShuffledHashJoinExec` supports [Java code generation](CodegenSupport.md) for [all the join types except FullOuter](#supportCodegen) ([variable prefix](CodegenSupport.md#variablePrefix): `shj`).

## <span id="metrics"> Performance Metrics

Key            | Name (in web UI)        | Description
---------------|-------------------------|---------
 numOutputRows | number of output rows   | Number of output rows
 buildDataSize | data size of build side |
 buildTime     | time to build hash map  |

![ShuffledHashJoinExec in web UI (Details for Query)](../images/spark-sql-ShuffledHashJoinExec-webui-query-details.png)

## Creating Instance

`ShuffledHashJoinExec` takes the following to be created:

* <span id="leftKeys"> Left Key [Expression](../expressions/Expression.md)s
* <span id="rightKeys"> Right Key [Expression](../expressions/Expression.md)s
* <span id="joinType"> [Join Type](../joins.md#join-types)
* <span id="buildSide"> `BuildSide`
* <span id="condition"> Optional Join Condition [Expression](../expressions/Expression.md)
* <span id="left"> Left Child [Physical Operator](SparkPlan.md)
* <span id="right"> Right Child [Physical Operator](SparkPlan.md)
* [isSkewJoin](#isSkewJoin) flag

`ShuffledHashJoinExec` is created when:

* [JoinSelection](../execution-planning-strategies/JoinSelection.md) execution planning strategy is executed ([createShuffleHashJoin](../execution-planning-strategies/JoinSelection.md#createShuffleHashJoin))

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

!!! danger
    Review Me

`doExecute` requests [streamedPlan](HashJoin.md#streamedPlan) physical operator to [execute](SparkPlan.md#execute) (and generate a `RDD[InternalRow]`).

`doExecute` requests [buildPlan](HashJoin.md#buildPlan) physical operator to [execute](SparkPlan.md#execute) (and generate a `RDD[InternalRow]`).

`doExecute` requests [streamedPlan](HashJoin.md#streamedPlan) physical operator's `RDD[InternalRow]` to zip partition-wise with [buildPlan](HashJoin.md#buildPlan) physical operator's `RDD[InternalRow]` (using `RDD.zipPartitions` method with `preservesPartitioning` flag disabled).

`doExecute` uses `RDD.zipPartitions` with a function applied to zipped partitions that takes two iterators of rows from the partitions of `streamedPlan` and `buildPlan`.

For every partition (and pairs of rows from the RDD), the function [buildHashedRelation](#buildHashedRelation) on the partition of `buildPlan` and [join](HashJoin.md#join) the `streamedPlan` partition iterator, the [HashedRelation](HashedRelation.md), [numOutputRows](#numOutputRows) and [avgHashProbe](#avgHashProbe) metrics.

## <span id="buildHashedRelation"> Building HashedRelation

```scala
buildHashedRelation(
  iter: Iterator[InternalRow]): HashedRelation
```

!!! danger
    Review Me

`buildHashedRelation` creates a [HashedRelation](HashedRelation.md#apply) (for the input `iter` iterator of `InternalRows`, [buildKeys](HashJoin.md#buildKeys) and the current `TaskMemoryManager`).

`buildHashedRelation` records the time to create the `HashedRelation` as [buildTime](#buildTime).

`buildHashedRelation` requests the `HashedRelation` for [estimatedSize](../KnownSizeEstimation.md#estimatedSize) that is recorded as [buildDataSize](#buildDataSize).

`buildHashedRelation` is used when:

* `ShuffledHashJoinExec` is requested to [execute](#doExecute) (when [streamedPlan](HashJoin.md#streamedPlan) and [buildPlan](HashJoin.md#buildPlan) physical operators are executed and their RDDs zipped partition-wise using `RDD.zipPartitions` method

## <span id="supportCodegen"> supportCodegen

```scala
supportCodegen: Boolean
```

`supportCodegen` is part of the [CodegenSupport](CodegenSupport.md#supportCodegen) abstraction.

`supportCodegen` is `true` for [all the join types except FullOuter](../joins.md#join-types).

## <span id="needCopyResult"> needCopyResult

```scala
needCopyResult: Boolean
```

`needCopyResult` is part of the [CodegenSupport](CodegenSupport.md#needCopyResult) abstraction.

`needCopyResult` is `true`.

## Demo

Enable `DEBUG` logging level for [ExtractEquiJoinKeys](../ExtractEquiJoinKeys.md#logging) logger to see the join condition and the left and right join keys.

```text
// Use ShuffledHashJoinExec's selection requirements
// 1. Disable auto broadcasting
// JoinSelection (canBuildLocalHashMap specifically) requires that
// plan.stats.sizeInBytes < autoBroadcastJoinThreshold * numShufflePartitions
// That gives that autoBroadcastJoinThreshold has to be at least 1
spark.conf.set("spark.sql.autoBroadcastJoinThreshold", 1)

scala> println(spark.sessionState.conf.numShufflePartitions)
200

// 2. Disable preference on SortMergeJoin
spark.conf.set("spark.sql.join.preferSortMergeJoin", false)

val dataset = Seq(
  (0, "playing"),
  (1, "with"),
  (2, "ShuffledHashJoinExec")
).toDF("id", "token")
// Self LEFT SEMI join
val q = dataset.join(dataset, Seq("id"), "leftsemi")

val sizeInBytes = q.queryExecution.optimizedPlan.stats.sizeInBytes
scala> println(sizeInBytes)
72

// 3. canBuildLeft is on for leftsemi

// the right join side is at least three times smaller than the left side
// Even though it's a self LEFT SEMI join there are two different join sides
// How is that possible?

// BINGO! ShuffledHashJoin is here!

// Enable DEBUG logging level
import org.apache.log4j.{Level, Logger}
val logger = "org.apache.spark.sql.catalyst.planning.ExtractEquiJoinKeys"
Logger.getLogger(logger).setLevel(Level.DEBUG)

// ShuffledHashJoin with BuildRight
scala> q.explain
== Physical Plan ==
ShuffledHashJoin [id#37], [id#41], LeftSemi, BuildRight
:- Exchange hashpartitioning(id#37, 200)
:  +- LocalTableScan [id#37, token#38]
+- Exchange hashpartitioning(id#41, 200)
   +- LocalTableScan [id#41]

scala> println(q.queryExecution.executedPlan.numberedTreeString)
00 ShuffledHashJoin [id#37], [id#41], LeftSemi, BuildRight
01 :- Exchange hashpartitioning(id#37, 200)
02 :  +- LocalTableScan [id#37, token#38]
03 +- Exchange hashpartitioning(id#41, 200)
04    +- LocalTableScan [id#41]
```

`doExecute` generates a `ZippedPartitionsRDD2` that you can see in a RDD lineage.

```text
scala> println(q.queryExecution.toRdd.toDebugString)
(200) ZippedPartitionsRDD2[8] at toRdd at <console>:26 []
  |   ShuffledRowRDD[3] at toRdd at <console>:26 []
  +-(3) MapPartitionsRDD[2] at toRdd at <console>:26 []
     |  MapPartitionsRDD[1] at toRdd at <console>:26 []
     |  ParallelCollectionRDD[0] at toRdd at <console>:26 []
  |   ShuffledRowRDD[7] at toRdd at <console>:26 []
  +-(3) MapPartitionsRDD[6] at toRdd at <console>:26 []
     |  MapPartitionsRDD[5] at toRdd at <console>:26 []
     |  ParallelCollectionRDD[4] at toRdd at <console>:26 []
```

## <span id="HashJoin"> HashJoin

`ShuffledHashJoinExec` is a [HashJoin](HashJoin.md).

### <span id="buildSide"> BuildSide

```scala
buildSide: BuildSide
```

`ShuffledHashJoinExec` is given a `BuildSide` when [created](#creating-instance).

`buildSide` is part of the [HashJoin](HashJoin.md#buildSide) abstraction.

### <span id="prepareRelation"> prepareRelation

```scala
prepareRelation(
  ctx: CodegenContext): HashedRelationInfo
```

`prepareRelation` requests the given [CodegenContext](../whole-stage-code-generation/CodegenContext.md) for a [code to reference](../whole-stage-code-generation/CodegenContext.md#addReferenceObj) this `ShuffledHashJoinExec` (with `plan` name).

`prepareRelation` requests the given [CodegenContext](../whole-stage-code-generation/CodegenContext.md) for a [code with relationTerm mutable state](../whole-stage-code-generation/CodegenContext.md#addMutableState) (with the `HashedRelation` class name, `relation` variable name, etc.)

In the end, `prepareRelation` creates a `HashedRelationInfo`.

```text
```

`prepareRelation` is part of the [HashJoin](HashJoin.md#prepareRelation) abstraction.

## <span id="ShuffledJoin"> ShuffledJoin

`ShuffledHashJoinExec` is a [ShuffledJoin](ShuffledJoin.md) and performs a hash join of two child relations by first shuffling the data using the join keys.

### <span id="isSkewJoin"> isSkewJoin Flag

`ShuffledHashJoinExec` can be given `isSkewJoin` flag when [created](#creating-instance). It is assumed disabled (`false`) by default.

`isSkewJoin` can only be enabled (`true`) when `OptimizeSkewedJoin` adaptive physical optimization is requested to [optimize a skew join](../physical-optimizations/OptimizeSkewedJoin.md#optimizeSkewJoin).

`isSkewJoin` is part of the [ShuffledJoin](ShuffledJoin.md#isSkewJoin) abstraction.
