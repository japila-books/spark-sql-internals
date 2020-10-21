# HashedRelation

`HashedRelation` is an [extension](#contract) of the [KnownSizeEstimation](../KnownSizeEstimation.md) abstraction for [relations](#implementations) with values hashed by some key.

??? note "sealed trait"
    `HashedRelation` is a Scala sealed trait which means that all possible implementations (`HashedRelation`s) are all in the same compilation unit (file).

## Contract

### <span id="asReadOnlyCopy"> asReadOnlyCopy

```scala
asReadOnlyCopy(): HashedRelation
```

A read-only copy of this `HashedRelation` to be safely used in a separate thread

Used when [BroadcastHashJoinExec](BroadcastHashJoinExec.md) physical operator is [executed](BroadcastHashJoinExec.md#doExecute)

### <span id="close"> close

```scala
close(): Unit
```

Used when [ShuffledHashJoinExec](ShuffledHashJoinExec.md) physical operator is requested to [buildHashedRelation](ShuffledHashJoinExec.md#buildHashedRelation)

### <span id="get"> get

```scala
get(
  key: InternalRow): Iterator[InternalRow]
get(
  key: Long): Iterator[InternalRow]
```

Gets [internal rows](../InternalRow.md) for the given key or `null`

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

Gives the value [internal row](../InternalRow.md) for the given key

Used when `LongHashedRelation` is requested to [get a value for a key](LongHashedRelation.md#getValue)

### <span id="keyIsUnique"> keyIsUnique

```scala
keyIsUnique: Boolean
```

Used when [BroadcastHashJoinExec](BroadcastHashJoinExec.md) physical operator is requested to [multipleOutputForOneInput](BroadcastHashJoinExec.md#multipleOutputForOneInput), [codegenInner](BroadcastHashJoinExec.md#codegenInner), [codegenOuter](BroadcastHashJoinExec.md#codegenOuter), [codegenSemi](BroadcastHashJoinExec.md#codegenSemi), [codegenAnti](BroadcastHashJoinExec.md#codegenAnti), [codegenExistence](BroadcastHashJoinExec.md#codegenExistence)

### <span id="keys"> keys

```scala
keys(): Iterator[InternalRow]
```

Used when [SubqueryBroadcastExec](SubqueryBroadcastExec.md) physical operator is requested for [relationFuture](SubqueryBroadcastExec.md#relationFuture)

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

`apply` creates a [LongHashedRelation](LongHashedRelation.md#apply) when the input `key` collection has a single [expression](../expressions/Expression.md) of type `long` or a [UnsafeHashedRelation](UnsafeHashedRelation.md#apply) otherwise.

!!! note
    The input `key` expressions are:

    * [Build join keys](HashJoin.md#buildKeys) of `ShuffledHashJoinExec` physical operator
    * [Canonicalized build-side join keys](HashedRelationBroadcastMode.md#canonicalized) of `HashedRelationBroadcastMode` (of [BroadcastHashJoinExec](BroadcastHashJoinExec.md#requiredChildDistribution) physical operator)

`apply` is used when:

* `ShuffledHashJoinExec` physical operator is requested to [build a HashedRelation for given internal rows](ShuffledHashJoinExec.md#buildHashedRelation)
* `HashedRelationBroadcastMode` is requested to [transform](HashedRelationBroadcastMode.md#transform)
