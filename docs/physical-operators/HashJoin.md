# HashJoin &mdash; Hash-Based Join Physical Operators

`HashJoin` is an [extension](#contract) of the [BaseJoinExec](BaseJoinExec.md) abstraction for [hash-based join physical operators](#implementations) with support for [Java code generation](CodegenSupport.md).

## Contract

### <span id="buildSide"> buildSide

```scala
buildSide: BuildSide
```

### <span id="prepareRelation"> Preparing Relation

```scala
prepareRelation(
  ctx: CodegenContext): HashedRelationInfo
```

## Implementations

* [BroadcastHashJoinExec](BroadcastHashJoinExec.md)
* [ShuffledHashJoinExec](ShuffledHashJoinExec.md)

## <span id="join"> join

```scala
join(
  streamedIter: Iterator[InternalRow],
  hashed: HashedRelation,
  numOutputRows: SQLMetric): Iterator[InternalRow]
```

`join` branches off per [JoinType](BaseJoinExec.md#joinType) to create an joined rows iterator (off the rows from the input `streamedIter` and `hashed`):

* [innerJoin](#innerJoin) for a [InnerLike](../joins.md#InnerLike) join

* [outerJoin](#outerJoin) for a [LeftOuter](../joins.md#LeftOuter) or a [RightOuter](../joins.md#RightOuter) join

* [semiJoin](#semiJoin) for a [LeftSemi](../joins.md#LeftSemi) join

* [antiJoin](#antiJoin) for a [LeftAnti](../joins.md#LeftAnti) join

* [existenceJoin](#existenceJoin) for a [ExistenceJoin](../joins.md#ExistenceJoin) join

`join` [creates a result projection](#createResultProjection).

In the end, for every row in the joined rows iterator `join` increments the input `numOutputRows` SQL metric and applies the result projection.

`join` reports an `IllegalArgumentException` for unsupported [JoinType](BaseJoinExec.md#joinType):

```text
HashJoin should not take [joinType] as the JoinType
```

`join` is used when:

* [BroadcastHashJoinExec](BroadcastHashJoinExec.md) and [ShuffledHashJoinExec](ShuffledHashJoinExec.md) physical operators are executed
