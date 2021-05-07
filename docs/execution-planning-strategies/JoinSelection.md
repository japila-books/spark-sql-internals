# JoinSelection Execution Planning Strategy

`JoinSelection` is an [execution planning strategy](SparkStrategy.md) for [Join](../logical-operators/Join.md) logical operators.

`JoinSelection` is part of the [strategies](../SparkPlanner.md#strategies) of the [SparkPlanner](../SparkPlanner.md).

## Join Selection Requirements

The following sections are in the order of preference.

!!! danger
    These sections have to be reviewed for correctness.

`JoinSelection` [considers](#apply) join physical operators per whether join keys are used or not:

* If used, `JoinSelection` considers [BroadcastHashJoinExec](#BroadcastHashJoinExec), [ShuffledHashJoinExec](#ShuffledHashJoinExec) or [SortMergeJoinExec](#SortMergeJoinExec) operators
* Otherwise, `JoinSelection` considers [BroadcastNestedLoopJoinExec](#BroadcastNestedLoopJoinExec) or [CartesianProductExec](#CartesianProductExec)

### <span id="BroadcastHashJoinExec"> BroadcastHashJoinExec

`JoinSelection` plans a [BroadcastHashJoinExec](../physical-operators/BroadcastHashJoinExec.md) when there are join keys and one of the following holds:

* Join type is [CROSS](../joins.md#CROSS), [INNER](../joins.md#INNER), [LEFT ANTI](../joins.md#LEFT_ANTI), [LEFT OUTER](../joins.md#LEFT_OUTER), [LEFT SEMI](../joins.md#LEFT_SEMI) or [ExistenceJoin](../joins.md#ExistenceJoin)

* Join type is [CROSS](../joins.md#CROSS), [INNER](../joins.md#INNER) or [RIGHT OUTER](../joins.md#RIGHT_OUTER)

`BroadcastHashJoinExec` is created for [ExtractEquiJoinKeys](../ExtractEquiJoinKeys.md)-destructurable logical query plans ([INNER, CROSS, LEFT OUTER, LEFT SEMI, LEFT ANTI](#canBuildRight)) of which the `right` physical operator [can be broadcast](#canBroadcast).

### <span id="ShuffledHashJoinExec"> ShuffledHashJoinExec

`JoinSelection` plans a [ShuffledHashJoinExec](../physical-operators/ShuffledHashJoinExec.md) when there are join keys and one of the following holds:

* [spark.sql.join.preferSortMergeJoin](../configuration-properties.md#spark.sql.join.preferSortMergeJoin) is disabled, the join type is [CROSS](../joins.md#CROSS), [INNER](../joins.md#INNER), [LEFT ANTI](../joins.md#LEFT_ANTI), [LEFT OUTER](../joins.md#LEFT_OUTER), [LEFT SEMI](../joins.md#LEFT_SEMI) or [ExistenceJoin](../joins.md#ExistenceJoin)

* [spark.sql.join.preferSortMergeJoin](../configuration-properties.md#spark.sql.join.preferSortMergeJoin) is disabled, the join type is [CROSS](../joins.md#CROSS), [INNER](../joins.md#INNER) or [RIGHT OUTER](../joins.md#RIGHT_OUTER)

* Left join keys are *not* [orderable](../physical-operators/SortMergeJoinExec.md#orderable)

### <span id="SortMergeJoinExec"> SortMergeJoinExec

`JoinSelection` plans a [SortMergeJoinExec](../physical-operators/SortMergeJoinExec.md) when the left join keys are [orderable](../physical-operators/SortMergeJoinExec.md#orderable).

### <span id="BroadcastNestedLoopJoinExec"> BroadcastNestedLoopJoinExec

`JoinSelection` plans a [BroadcastNestedLoopJoinExec](../physical-operators/BroadcastNestedLoopJoinExec.md) when there are no join keys and one of the following holds:

* Join type is [CROSS](../joins.md#CROSS), [INNER](../joins.md#INNER), [LEFT ANTI](../joins.md#LEFT_ANTI), [LEFT OUTER](../joins.md#LEFT_OUTER), [LEFT SEMI](../joins.md#LEFT_SEMI) or [ExistenceJoin](../joins.md#ExistenceJoin)

* Join type is [CROSS](../joins.md#CROSS), [INNER](../joins.md#INNER) or [RIGHT OUTER](../joins.md#RIGHT_OUTER)

### <span id="CartesianProductExec"> CartesianProductExec

`JoinSelection` plans a [CartesianProductExec](../physical-operators/CartesianProductExec.md) when there are no join keys and [join type](../joins.md#join-types) is [CROSS](../joins.md#CROSS) or [INNER](../joins.md#INNER)

### <span id="BroadcastNestedLoopJoinExec"> BroadcastNestedLoopJoinExec

`JoinSelection` plans a [BroadcastNestedLoopJoinExec](../physical-operators/BroadcastNestedLoopJoinExec.md) when no other join operator has matched already

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

`apply` uses [ExtractEquiJoinKeys](../ExtractEquiJoinKeys.md) to match on [Join](../logical-operators/Join.md) logical operators with [EqualTo](../expressions/EqualTo.md) and [EqualNullSafe](../expressions/EqualNullSafe.md) condition predicate expressions.

`apply` does the following (in the order until a join physical operator has been determined):

1. [createBroadcastHashJoin](#createBroadcastHashJoin) (based on the hints only)
1. With a [hintToSortMergeJoin](#hintToSortMergeJoin) defined, [createSortMergeJoin](#createSortMergeJoin)
1. [createShuffleHashJoin](#createShuffleHashJoin) (based on the hints only)
1. With a [hintToShuffleReplicateNL](#hintToShuffleReplicateNL) defined, [createCartesianProduct](#createCartesianProduct)
1. [createJoinWithoutHint](#createJoinWithoutHint)

### <span id="ExtractSingleColumnNullAwareAntiJoin"> ExtractSingleColumnNullAwareAntiJoin

`apply` uses [ExtractSingleColumnNullAwareAntiJoin](../ExtractSingleColumnNullAwareAntiJoin.md) to match on [Join](../logical-operators/Join.md) logical operators.

For every `Join` operator, `apply` creates a [BroadcastHashJoinExec](../physical-operators/BroadcastHashJoinExec.md) physical operator with the following:

* [LeftAnti](../joins.md#joinType) join type
* `BuildRight` build side
* Undefined join condition expressions
* [isNullAwareAntiJoin](../physical-operators/BroadcastHashJoinExec.md#isNullAwareAntiJoin) flag enabled (`true`)

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

`createBroadcastHashJoin` [determines a BroadcastBuildSide](#getBroadcastBuildSide) and, if successful, creates a [BroadcastHashJoinExec](../physical-operators/BroadcastHashJoinExec.md).

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

## <span id="getBuildSide"> Build Side

```scala
getBuildSide(
  canBuildLeft: Boolean,
  canBuildRight: Boolean,
  left: LogicalPlan,
  right: LogicalPlan): Option[BuildSide]
```

`getBuildSide` is the following (in the order):

1. The [smaller side](#getSmallerSide) of the left and right operators when the `canBuildLeft` and `canBuildRight` flags are both enabled (`true`)
1. `BuildLeft` for `canBuildLeft` flag enabled
1. `BuildRight` for `canBuildRight` flag enabled
1. Undefined (`None`)

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

## <span id="getSmallerSide"> Smaller Side

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

## <span id="hintToBroadcastRight"> hintToBroadcastRight

```scala
hintToBroadcastRight(
  hint: JoinHint): Boolean
```

`hintToBroadcastRight` is enabled (`true`) when the given `JoinHint` has `BROADCAST`, `BROADCASTJOIN` or `MAPJOIN` hints associated with the right operator.

## <span id="hintToNotBroadcastLeft"> hintToNotBroadcastLeft

```scala
hintToNotBroadcastLeft(
  hint: JoinHint): Boolean
```

`hintToNotBroadcastLeft` is enabled (`true`) when the given `JoinHint` has the internal `NO_BROADCAST_HASH` hint associated with the left operator (to discourage broadcast hash join).

## <span id="hintToNotBroadcastRight"> hintToNotBroadcastRight

```scala
hintToNotBroadcastRight(
  hint: JoinHint): Boolean
```

`hintToNotBroadcastRight` is enabled (`true`) when the given `JoinHint` has the internal `NO_BROADCAST_HASH` hint associated with the right operator (to discourage broadcast hash join).

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
