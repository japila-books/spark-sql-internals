# HashedRelation

`HashedRelation` is an [extension](#contract) of the [KnownSizeEstimation](KnownSizeEstimation.md) abstraction for [relations](#implementations) with values hashed by some key.

??? note "sealed trait"
    `HashedRelation` is a Scala sealed trait which means that all possible implementations (`HashedRelation`s) are all in the same compilation unit (file).

## Contract

### <span id="asReadOnlyCopy"> asReadOnlyCopy

```scala
asReadOnlyCopy(): HashedRelation
```

A read-only copy of this `HashedRelation` to be safely used in a separate thread

Used when [BroadcastHashJoinExec](physical-operators/BroadcastHashJoinExec.md) physical operator is [executed](physical-operators/BroadcastHashJoinExec.md#doExecute)

### <span id="close"> close

```scala
close(): Unit
```

Used when [ShuffledHashJoinExec](physical-operators/ShuffledHashJoinExec.md) physical operator is requested to [buildHashedRelation](physical-operators/ShuffledHashJoinExec.md#buildHashedRelation)

### <span id="get"> get

```scala
get(
  key: InternalRow): Iterator[InternalRow]
get(
  key: Long): Iterator[InternalRow]
```

Gets [internal rows](spark-sql-InternalRow.md) for the given key or `null`

Used when:

* `HashJoin` is requested to [innerJoin](HashJoin.md#innerJoin), [outerJoin]/HashJoin.md#outerJoin), [semiJoin](HashJoin.md#semiJoin), [existenceJoin](HashJoin.md#existenceJoin) and [antiJoin](HashJoin.md#antiJoin)
* `LongHashedRelation` is requested to [get a value for a key](LongHashedRelation.md#get)

### <span id="getValue"> getValue

```scala
getValue(
  key: InternalRow): InternalRow
getValue(
  key: Long): InternalRow
```

Gives the value [internal row](spark-sql-InternalRow.md) for the given key

Used when `LongHashedRelation` is requested to [get a value for a key](LongHashedRelation.md#getValue)

### <span id="keyIsUnique"> keyIsUnique

```scala
keyIsUnique: Boolean
```

Used when [BroadcastHashJoinExec](physical-operators/BroadcastHashJoinExec.md) physical operator is requested to [multipleOutputForOneInput](physical-operators/BroadcastHashJoinExec.md#multipleOutputForOneInput), [codegenInner](physical-operators/BroadcastHashJoinExec.md#codegenInner), [codegenOuter](physical-operators/BroadcastHashJoinExec.md#codegenOuter), [codegenSemi](physical-operators/BroadcastHashJoinExec.md#codegenSemi), [codegenAnti](physical-operators/BroadcastHashJoinExec.md#codegenAnti), [codegenExistence](physical-operators/BroadcastHashJoinExec.md#codegenExistence)

### <span id="keys"> keys

```scala
keys(): Iterator[InternalRow]
```

Used when [SubqueryBroadcastExec](physical-operators/SubqueryBroadcastExec.md) physical operator is requested for [relationFuture](physical-operators/SubqueryBroadcastExec.md#relationFuture)

## Implementations

* [LongHashedRelation](LongHashedRelation.md)
* [UnsafeHashedRelation](UnsafeHashedRelation.md)

## <span id="apply"> Creating HashedRelation

```scala
apply(
  input: Iterator[InternalRow],
  key: Seq[Expression],
  sizeEstimate: Int = 64,
  taskMemoryManager: TaskMemoryManager = null): HashedRelation
```

`apply` creates a [LongHashedRelation](LongHashedRelation.md#apply) when the input `key` collection has a single [expression](expressions/Expression.md) of type `long` or a [UnsafeHashedRelation](UnsafeHashedRelation.md#apply) otherwise.

!!! note
    The input `key` expressions are:

    * [Build join keys](HashJoin.md#buildKeys) of `ShuffledHashJoinExec` physical operator
    * [Canonicalized build-side join keys](physical-operators/HashedRelationBroadcastMode.md#canonicalized) of `HashedRelationBroadcastMode` (of [BroadcastHashJoinExec](physical-operators/BroadcastHashJoinExec.md#requiredChildDistribution) physical operator)

`apply` is used when:

* `ShuffledHashJoinExec` physical operator is requested to [build a HashedRelation for given internal rows](physical-operators/ShuffledHashJoinExec.md#buildHashedRelation)
* `HashedRelationBroadcastMode` is requested to [transform](physical-operators/HashedRelationBroadcastMode.md#transform)
