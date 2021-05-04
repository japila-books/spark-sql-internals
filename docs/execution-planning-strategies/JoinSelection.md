# JoinSelection Execution Planning Strategy

`JoinSelection` is an [execution planning strategy](SparkStrategy.md) for [Join](../logical-operators/Join.md) logical operators.

`JoinSelection` is part of the [strategies](../SparkPlanner.md#strategies) of the [SparkPlanner](../SparkPlanner.md).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): Seq[SparkPlan]
```

`apply` is part of the [GenericStrategy](../catalyst/GenericStrategy.md#apply) abstraction.

`apply` is made up of three parts (each with its own Scala extractor object to destructure the input [LogicalPlan](../logical-operators/LogicalPlan.md)):

1. [ExtractEquiJoinKeys](#ExtractEquiJoinKeys)
1. [ExtractSingleColumnNullAwareAntiJoin](#ExtractSingleColumnNullAwareAntiJoin)
1. [Other Joins](#other-joins)

### <span id="ExtractEquiJoinKeys"> ExtractEquiJoinKeys

`apply` uses [ExtractEquiJoinKeys](../ExtractEquiJoinKeys.md) to find [Join](../logical-operators/Join.md) logical operators with [EqualTo](../expressions/EqualTo.md) and [EqualNullSafe](../expressions/EqualNullSafe.md) condition predicate expressions.

`apply` does the following (in the order until a join physical operator has been determined):

1. [createBroadcastHashJoin](#createBroadcastHashJoin) (based on the hints only)
1. With a [hintToSortMergeJoin](#hintToSortMergeJoin) defined, [createSortMergeJoin](#createSortMergeJoin)
1. [createShuffleHashJoin](#createShuffleHashJoin) (based on the hints only)
1. With a [hintToShuffleReplicateNL](#hintToShuffleReplicateNL) defined, [createCartesianProduct](#createCartesianProduct)
1. [createJoinWithoutHint](#createJoinWithoutHint)

### <span id="ExtractSingleColumnNullAwareAntiJoin"> ExtractSingleColumnNullAwareAntiJoin

`apply` uses [ExtractSingleColumnNullAwareAntiJoin](../ExtractSingleColumnNullAwareAntiJoin.md) to find [Join](../logical-operators/Join.md) logical operators.

For every `Join` operator, `apply` creates a [BroadcastHashJoinExec](../physical-operators/BroadcastHashJoinExec.md) physical operator with the following:

* `LeftAnti` join type
* `BuildRight` build side
* Undefined join condition expressions
* `isNullAwareAntiJoin` flag enabled (`true`)

### Other Joins

`apply` determines the desired build side. For `InnerLike` and `FullOuter` join types, `apply` [getSmallerSide](#getSmallerSide). For all other join types, `apply` [canBuildBroadcastLeft](#canBuildBroadcastLeft) and prefers `BuildLeft` over `BuildRight`.

In the end, `apply` does the following (in the order until a join physical operator has been determined):

1. [createBroadcastNLJoin](#createBroadcastNLJoin) (based on the hints only for the [left](#hintToBroadcastLeft) and [right](#hintToBroadcastRight) side)
1. With a [hintToShuffleReplicateNL](#hintToShuffleReplicateNL) defined, [createCartesianProduct](#createCartesianProduct)
1. [createJoinWithoutHint](#createJoinWithoutHint)

## <span id="canBroadcastBySize"> canBroadcastBySize

```scala
canBroadcastBySize(
  plan: LogicalPlan,
  conf: SQLConf): Boolean
```

`canBroadcastBySize` is enabled (`true`) when the [size](../logical-operators/Statistics.md#sizeInBytes) of the table (the given [LogicalPlan](../logical-operators/LogicalPlan.md)) is small for a broadcast join (between `0` and the [spark.sql.autoBroadcastJoinThreshold](../configuration-properties.md#spark.sql.autoBroadcastJoinThreshold) configuration property inclusive).

## <span id="canBuildBroadcastLeft"> canBuildBroadcastLeft

```scala
canBuildBroadcastLeft(
  joinType: JoinType): Boolean
```

`canBuildBroadcastLeft` is enabled (`true`) for `InnerLike` and `RightOuter` join types.

## <span id="canBuildLocalHashMapBySize"> canBuildLocalHashMapBySize

```scala
canBuildLocalHashMapBySize(
  plan: LogicalPlan,
  conf: SQLConf): Boolean
```

`canBuildLocalHashMapBySize` is enabled (`true`) when the [size](../logical-operators/Statistics.md#sizeInBytes) of the table (the given [LogicalPlan](../logical-operators/LogicalPlan.md)) is small for a shuffle hash join (below the [spark.sql.autoBroadcastJoinThreshold](../configuration-properties.md#spark.sql.autoBroadcastJoinThreshold) configuration property multiplied by the configured [number of shuffle partitions](../SQLConf.md#numShufflePartitions)).

## <span id="createBroadcastHashJoin"> Creating BroadcastHashJoinExec

```scala
createBroadcastHashJoin(
  onlyLookingAtHint: Boolean): Option[Seq[BroadcastHashJoinExec]]
```

`createBroadcastHashJoin` [determines a BroadcastBuildSide](#getBroadcastBuildSide) and, if determined, creates a [BroadcastHashJoinExec](../physical-operators/BroadcastHashJoinExec.md).

## <span id="createBroadcastNLJoin"> Creating BroadcastNestedLoopJoinExec

```scala
createBroadcastNLJoin(
  buildLeft: Boolean,
  buildRight: Boolean): Option[Seq[BroadcastNestedLoopJoinExec]]
```

`createBroadcastNLJoin` creates a [BroadcastNestedLoopJoinExec](../physical-operators/BroadcastNestedLoopJoinExec.md) when at least one of the `buildLeft` or `buildRight` flags are enabled.

## <span id="createShuffleHashJoin"> createShuffleHashJoin

```scala
createShuffleHashJoin(
  onlyLookingAtHint: Boolean): Option[Seq[ShuffledHashJoinExec]]
```

`createShuffleHashJoin` [determines a ShuffleHashJoinBuildSide](#getShuffleHashJoinBuildSide) and, if determined, creates a [ShuffledHashJoinExec](../physical-operators/ShuffledHashJoinExec.md).

## <span id="createSortMergeJoin"> Creating SortMergeJoinExec

```scala
createSortMergeJoin(): Option[Seq[SortMergeJoinExec]]
```

`createSortMergeJoin` creates a [SortMergeJoinExec](../physical-operators/SortMergeJoinExec.md) if the left keys are [orderable](../expressions/RowOrdering.md#isOrderable).

## <span id="createCartesianProduct"> createCartesianProduct

```scala
createCartesianProduct(): Option[Seq[CartesianProductExec]]
```

`createCartesianProduct` creates a [CartesianProductExec](../physical-operators/CartesianProductExec.md) for `InnerLike` join type.

## <span id="createJoinWithoutHint"> createJoinWithoutHint

```scala
createJoinWithoutHint(): Seq[BaseJoinExec]
```

`createJoinWithoutHint`...FIXME

## <span id="getBroadcastBuildSide"> getBroadcastBuildSide

```scala
getBroadcastBuildSide(
  left: LogicalPlan,
  right: LogicalPlan,
  joinType: JoinType,
  hint: JoinHint,
  hintOnly: Boolean,
  conf: SQLConf): Option[BuildSide]
```

`getBroadcastBuildSide` determines if build on the left side (`buildLeft`). With `hintOnly` enabled (`true`), `getBroadcastBuildSide` [hintToBroadcastLeft](#hintToBroadcastLeft). Otherwise, `getBroadcastBuildSide` checks if [canBroadcastBySize](#canBroadcastBySize) and not [hintToNotBroadcastLeft](#hintToNotBroadcastLeft).

`getBroadcastBuildSide` determines if build on the right side (`buildRight`). With `hintOnly` enabled (`true`), `getBroadcastBuildSide` [hintToBroadcastRight](#hintToBroadcastRight). Otherwise, `getBroadcastBuildSide` checks if [canBroadcastBySize](#canBroadcastBySize) and not [hintToNotBroadcastRight](#hintToNotBroadcastRight).

In the end, `getBroadcastBuildSide` [getBuildSide](#getBuildSide) with the following:

* [canBuildBroadcastLeft](#canBuildBroadcastLeft) for the given `JoinType` and the `buildLeft` flag
* [canBuildBroadcastRight](#canBuildBroadcastRight) for the given `JoinType` and the `buildRight` flag
* Left [physical operator](../logical-operators/LogicalPlan.md)
* Right [physical operator](../logical-operators/LogicalPlan.md)

## <span id="getShuffleHashJoinBuildSide"> getShuffleHashJoinBuildSide

```scala
getShuffleHashJoinBuildSide(
  left: LogicalPlan,
  right: LogicalPlan,
  joinType: JoinType,
  hint: JoinHint,
  hintOnly: Boolean,
  conf: SQLConf): Option[BuildSide]
```

`getShuffleHashJoinBuildSide` determines if build on the left side (`buildLeft`). With `hintOnly` enabled (`true`), `getShuffleHashJoinBuildSide` [hintToShuffleHashJoinLeft](#hintToShuffleHashJoinLeft). Otherwise, `getShuffleHashJoinBuildSide` checks if [canBuildLocalHashMapBySize](#canBuildLocalHashMapBySize) and the left operator is [muchSmaller](#muchSmaller) than the right.

`getShuffleHashJoinBuildSide` determines if build on the right side (`buildRight`). With `hintOnly` enabled (`true`), `getShuffleHashJoinBuildSide` [hintToShuffleHashJoinRight](#hintToShuffleHashJoinRight). Otherwise, `getShuffleHashJoinBuildSide` checks if [canBuildLocalHashMapBySize](#canBuildLocalHashMapBySize) and the right operator is [muchSmaller](#muchSmaller) than the left.

In the end, `getShuffleHashJoinBuildSide` [getBuildSide](#getBuildSide) with the following:

* [canBuildShuffledHashJoinLeft](#canBuildShuffledHashJoinLeft) for the given `JoinType` and the `buildLeft` flag
* [canBuildShuffledHashJoinRight](#canBuildShuffledHashJoinRight) for the given `JoinType` and the `buildRight` flag
* Left [physical operator](../logical-operators/LogicalPlan.md)
* Right [physical operator](../logical-operators/LogicalPlan.md)

## <span id="getSmallerSide"> getSmallerSide

```scala
getSmallerSide(
  left: LogicalPlan,
  right: LogicalPlan): BuildSide
```

`getSmallerSide` is `BuildLeft` unless the [size](../logical-operators/Statistics.md#sizeInBytes) of the right table (the given `right` [LogicalPlan](../logical-operators/LogicalPlan.md)) is not larger than the size of the left table (the given `left` [LogicalPlan](../logical-operators/LogicalPlan.md)). Otherwise, `getSmallerSide` is `BuildRight`.

## <span id="hintToBroadcastLeft"> hintToBroadcastLeft

```scala
hintToBroadcastLeft(
  hint: JoinHint): Boolean
```

`hintToBroadcastLeft` is enabled (`true`) when the given `JoinHint` has `BROADCAST`, `BROADCASTJOIN` or `MAPJOIN` hints associated with the left operator.

## <span id="hintToShuffleHashJoinLeft"> hintToShuffleHashJoinLeft

```scala
hintToShuffleHashJoinLeft(
  hint: JoinHint): Boolean
```

`hintToShuffleHashJoinLeft` is enabled (`true`) when the given `JoinHint` has `SHUFFLE_HASH` hint associated with the left operator.

## <span id="hintToShuffleHashJoinRight"> hintToShuffleHashJoinRight

```scala
hintToShuffleHashJoinRight(
  hint: JoinHint): Boolean
```

`hintToShuffleHashJoinRight` is enabled (`true`) when the given `JoinHint` has `SHUFFLE_HASH` hint associated with the right operator.

## <span id="hintToSortMergeJoin"> hintToSortMergeJoin

```scala
hintToSortMergeJoin(
  hint: JoinHint): Boolean
```

`hintToSortMergeJoin`...FIXME

## <span id="hintToShuffleReplicateNL"> hintToShuffleReplicateNL

```scala
hintToShuffleReplicateNL(
  hint: JoinHint): Boolean
```

`hintToShuffleReplicateNL`...FIXME

## <span id="muchSmaller"> muchSmaller

```scala
muchSmaller(
  a: LogicalPlan,
  b: LogicalPlan): Boolean
```

`muchSmaller` is enabled (`true`) when the [size](../logical-operators/Statistics.md#sizeInBytes) of the left table (the given `a` [LogicalPlan](../logical-operators/LogicalPlan.md)) is at least 3 times smaller than the size of the right table (the given `b` [LogicalPlan](../logical-operators/LogicalPlan.md)).

## Review Me

`JoinSelection` firstly <<apply, considers>> join physical operators per whether join keys are used or not. When join keys are used, `JoinSelection` considers <<BroadcastHashJoinExec, BroadcastHashJoinExec>>, <<ShuffledHashJoinExec, ShuffledHashJoinExec>> or <<SortMergeJoinExec, SortMergeJoinExec>> operators. Without join keys, `JoinSelection` considers <<BroadcastNestedLoopJoinExec, BroadcastNestedLoopJoinExec>> or <<CartesianProductExec, CartesianProductExec>>.

[[join-selection-requirements]]
.Join Physical Operator Selection Requirements (in the order of preference)
[cols="1,3",options="header",width="100%"]
|===
| Physical Join Operator
| Selection Requirements

| BroadcastHashJoinExec.md[BroadcastHashJoinExec]
a| [[BroadcastHashJoinExec]] There are join keys and one of the following holds:

* Join type is spark-sql-joins.md#CROSS[CROSS], spark-sql-joins.md#INNER[INNER], spark-sql-joins.md#LEFT_ANTI[LEFT ANTI], spark-sql-joins.md#LEFT_OUTER[LEFT OUTER], spark-sql-joins.md#LEFT_SEMI[LEFT SEMI] or spark-sql-joins.md#ExistenceJoin[ExistenceJoin] (i.e. <<canBuildRight, canBuildRight>> for the input `joinType` is positive) and right join side <<canBroadcast, can be broadcast>>

* Join type is spark-sql-joins.md#CROSS[CROSS], spark-sql-joins.md#INNER[INNER] or spark-sql-joins.md#RIGHT_OUTER[RIGHT OUTER] (i.e. <<canBuildLeft, canBuildLeft>> for the input `joinType` is positive) and left join side <<canBroadcast, can be broadcast>>

| ShuffledHashJoinExec.md[ShuffledHashJoinExec]
a| [[ShuffledHashJoinExec]] There are join keys and one of the following holds:

* [spark.sql.join.preferSortMergeJoin](../configuration-properties.md#spark.sql.join.preferSortMergeJoin) is disabled, the join type is [CROSS](../spark-sql-joins.md#CROSS), [INNER](../spark-sql-joins.md#INNER), [LEFT ANTI](../spark-sql-joins.md#LEFT_ANTI), [LEFT OUTER](../spark-sql-joins.md#LEFT_OUTER), [LEFT SEMI](../spark-sql-joins.md#LEFT_SEMI) or [ExistenceJoin](../spark-sql-joins.md#ExistenceJoin) (i.e. <<canBuildRight, canBuildRight>> for the input `joinType` is positive), <<canBuildLocalHashMap, canBuildLocalHashMap>> for right join side and finally right join side is <<muchSmaller, much smaller>> than left side

* [spark.sql.join.preferSortMergeJoin](../configuration-properties.md#spark.sql.join.preferSortMergeJoin) is disabled, the join type is spark-sql-joins.md#CROSS[CROSS], spark-sql-joins.md#INNER[INNER] or spark-sql-joins.md#RIGHT_OUTER[RIGHT OUTER] (i.e. <<canBuildLeft, canBuildLeft>> for the input `joinType` is positive), <<canBuildLocalHashMap, canBuildLocalHashMap>> for left join side and finally left join side is <<muchSmaller, much smaller>> than right

* Left join keys are *not* SortMergeJoinExec.md#orderable[orderable]

| SortMergeJoinExec.md[SortMergeJoinExec]
| [[SortMergeJoinExec]] Left join keys are SortMergeJoinExec.md#orderable[orderable]

| BroadcastNestedLoopJoinExec.md[BroadcastNestedLoopJoinExec]
a| [[BroadcastNestedLoopJoinExec]] There are no join keys and one of the following holds:

* Join type is spark-sql-joins.md#CROSS[CROSS], spark-sql-joins.md#INNER[INNER], spark-sql-joins.md#LEFT_ANTI[LEFT ANTI], spark-sql-joins.md#LEFT_OUTER[LEFT OUTER], spark-sql-joins.md#LEFT_SEMI[LEFT SEMI] or spark-sql-joins.md#ExistenceJoin[ExistenceJoin] (i.e. <<canBuildRight, canBuildRight>> for the input `joinType` is positive) and right join side <<canBroadcast, can be broadcast>>

* Join type is spark-sql-joins.md#CROSS[CROSS], spark-sql-joins.md#INNER[INNER] or spark-sql-joins.md#RIGHT_OUTER[RIGHT OUTER] (i.e. <<canBuildLeft, canBuildLeft>> for the input `joinType` is positive) and left join side <<canBroadcast, can be broadcast>>

| CartesianProductExec.md[CartesianProductExec]
| [[CartesianProductExec]] There are no join keys and spark-sql-joins.md#join-types[join type] is spark-sql-joins.md#CROSS[CROSS] or spark-sql-joins.md#INNER[INNER]

| BroadcastNestedLoopJoinExec.md[BroadcastNestedLoopJoinExec]
| No other join operator has matched already
|===

NOTE: `JoinSelection` uses ExtractEquiJoinKeys.md[ExtractEquiJoinKeys] Scala extractor to destructure a `Join` logical operator.

==== [[apply-BroadcastHashJoinExec]] Considering BroadcastHashJoinExec Physical Operator

`apply` gives a BroadcastHashJoinExec.md#creating-instance[BroadcastHashJoinExec] physical operator if the plan <<canBroadcastByHints, should be broadcast per join type and broadcast hints used>> (for the join type and left or right side of the join). `apply` <<broadcastSideByHints, selects the build side per join type and broadcast hints>>.

`apply` gives a BroadcastHashJoinExec.md#creating-instance[BroadcastHashJoinExec] physical operator if the plan <<canBroadcastBySizes, should be broadcast per join type and size of join sides>> (for the join type and left or right side of the join). `apply` <<broadcastSideBySizes, selects the build side per join type and total size statistic of join sides>>.
