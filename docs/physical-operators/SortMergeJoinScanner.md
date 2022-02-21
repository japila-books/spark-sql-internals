# SortMergeJoinScanner

## Creating Instance

`SortMergeJoinScanner` takes the following to be created:

* <span id="streamedKeyGenerator"> `streamedKeyGenerator` [Projection](../expressions/Projection.md)
* <span id="bufferedKeyGenerator"> `bufferedKeyGenerator` [Projection](../expressions/Projection.md)
* <span id="keyOrdering"> Key `Ordering[InternalRow]`
* <span id="streamedIter"> Streamed `RowIterator`
* <span id="bufferedIter"> Buffered `RowIterator`
* <span id="inMemoryThreshold"> inMemoryThreshold
* <span id="spillThreshold"> spillThreshold
* <span id="eagerCleanupResources"> eagerCleanupResources (`() => Unit`)
* <span id="onlyBufferFirstMatch"> `onlyBufferFirstMatch` flag (default: `false`)

`SortMergeJoinScanner` is created when:

* `SortMergeJoinExec` physical operator is requested to [doExecute](SortMergeJoinExec.md#doExecute) (for `InnerLike`, `LeftOuter`, `RightOuter`, `LeftSemi`, `LeftAnti`, `ExistenceJoin` joins)

## <span id="bufferedMatches"> ExternalAppendOnlyUnsafeRowArray

`SortMergeJoinScanner` creates an [ExternalAppendOnlyUnsafeRowArray](../ExternalAppendOnlyUnsafeRowArray.md) (with the given [inMemoryThreshold](#inMemoryThreshold) and [spillThreshold](#spillThreshold) thresholds) when [created](#creating-instance).

The `ExternalAppendOnlyUnsafeRowArray` is requested to [add an UnsafeRow](../ExternalAppendOnlyUnsafeRowArray.md#add) in [bufferMatchingRows](#bufferMatchingRows).

The `ExternalAppendOnlyUnsafeRowArray` is [cleared](../ExternalAppendOnlyUnsafeRowArray.md#clear) in [findNextInnerJoinRows](#findNextInnerJoinRows), [findNextOuterJoinRows](#findNextOuterJoinRows) and [bufferMatchingRows](#bufferMatchingRows).

### <span id="getBufferedMatches"> getBufferedMatches

```scala
getBufferedMatches: ExternalAppendOnlyUnsafeRowArray
```

`getBufferedMatches` returns the [bufferedMatches](#bufferedMatches).

`getBufferedMatches` is used when:

* `SortMergeJoinExec` physical operator is requested to [doExecute](SortMergeJoinExec.md#doExecute) (for `InnerLike`, `LeftSemi`, `LeftAnti`, `ExistenceJoin` joins), [advanceStream](SortMergeJoinExec.md#advanceStream) and [advanceBufferUntilBoundConditionSatisfied](SortMergeJoinExec.md#advanceBufferUntilBoundConditionSatisfied)

## <span id="bufferMatchingRows"> bufferMatchingRows

```scala
bufferMatchingRows(): Unit
```

`bufferMatchingRows`...FIXME

`bufferMatchingRows` is used when:

* `SortMergeJoinScanner` is requested to [findNextInnerJoinRows](#findNextInnerJoinRows) and [findNextOuterJoinRows](#findNextOuterJoinRows)
