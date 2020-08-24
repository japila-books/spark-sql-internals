# HashJoin &mdash; Hash-Based Join Physical Operators

`HashJoin` is an [abstraction](#contract) of [hash-based join physical operators](#implementations).

## Contract

### <span id="leftKeys"> leftKeys

```scala
leftKeys: Seq[Expression]
```

### <span id="rightKeys"> rightKeys

```scala
rightKeys: Seq[Expression]
```

### <span id="joinType"> joinType

```scala
joinType: JoinType
```

### <span id="buildSide"> buildSide

```scala
buildSide: BuildSide
```

### <span id="condition"> condition

```scala
condition: Option[Expression]
```

### <span id="left"> left

```scala
left: SparkPlan
```

### <span id="right"> right

```scala
right: SparkPlan
```

## Implementations

* [BroadcastHashJoinExec](BroadcastHashJoinExec.md)
* [ShuffledHashJoinExec](ShuffledHashJoinExec.md)

## <span id="join"> join Method

```scala
join(
  streamedIter: Iterator[InternalRow],
  hashed: HashedRelation,
  numOutputRows: SQLMetric): Iterator[InternalRow]
```

`join` branches off per [joinType](#joinType) to create a join iterator of internal rows (`Iterator[InternalRow]`) for the input `streamedIter` and `hashed`:

* [innerJoin](#innerJoin) for a [InnerLike](../spark-sql-joins.md#InnerLike) join

* [outerJoin](#outerJoin) for a [LeftOuter](../spark-sql-joins.md#LeftOuter) or a [RightOuter](../spark-sql-joins.md#RightOuter) join

* [semiJoin](#semiJoin) for a [LeftSemi](../spark-sql-joins.md#LeftSemi) join

* [antiJoin](#antiJoin) for a [LeftAnti](../spark-sql-joins.md#LeftAnti) join

* [existenceJoin](#existenceJoin) for a [ExistenceJoin](../spark-sql-joins.md#ExistenceJoin) join

`join` requests `TaskContext` to add a `TaskCompletionListener` to update the input avg hash probe SQL metric. The `TaskCompletionListener` is executed on a task completion (regardless of the task status: success, failure, or cancellation) and uses [getAverageProbesPerLookup](HashedRelation.md#getAverageProbesPerLookup) from the input `hashed` to set the input avg hash probe.

`join` [createResultProjection](#createResultProjection).

In the end, for every row in the join iterator of internal rows `join` increments the input `numOutputRows` SQL metric and applies the result projection.

`join` reports a `IllegalArgumentException` when the [joinType](#joinType) is not supported:

```text
[x] JoinType is not supported
```

`join` is used when [BroadcastHashJoinExec](BroadcastHashJoinExec.md) and [ShuffledHashJoinExec](ShuffledHashJoinExec.md) are executed.
