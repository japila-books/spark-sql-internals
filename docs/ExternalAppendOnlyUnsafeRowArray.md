# ExternalAppendOnlyUnsafeRowArray

`ExternalAppendOnlyUnsafeRowArray` is an append-only array of [UnsafeRow](UnsafeRow.md)s.

`ExternalAppendOnlyUnsafeRowArray` keeps rows in memory until the [spill threshold](#numRowsSpillThreshold) is reached that triggers disk spilling.

## Creating Instance

`ExternalAppendOnlyUnsafeRowArray` takes the following to be created:

* <span id="taskMemoryManager"> `TaskMemoryManager` ([Apache Spark]({{ book.spark_core }}/memory/TaskMemoryManager))
* <span id="blockManager"> `BlockManager` ([Apache Spark]({{ book.spark_core }}/storage/BlockManager))
* <span id="serializerManager"> `SerializerManager` ([Apache Spark]({{ book.spark_core }}/serializer/SerializerManager))
* <span id="taskContext"> `TaskContext` ([Apache Spark]({{ book.spark_core }}/scheduler/TaskContext))
* <span id="initialSize"> Initial size (default: `1024`)
* <span id="pageSizeBytes"> Page size (in bytes)
* [numRowsInMemoryBufferThreshold](#numRowsInMemoryBufferThreshold)
* [numRowsSpillThreshold](#numRowsSpillThreshold)

`ExternalAppendOnlyUnsafeRowArray` is created when:

* `SortMergeJoinScanner` is requested for [bufferedMatches](physical-operators/SortMergeJoinScanner.md#bufferedMatches)
* `UnsafeCartesianRDD` is requested to `compute`
* `UpdatingSessionsIterator` is requested to `startNewSession`
* `WindowExec` physical operator is requested to [doExecute](physical-operators/WindowExec.md#doExecute) (and creates an internal buffer for window frames)
* `WindowInPandasExec` ([PySpark]({{ book.pyspark }}/sql/WindowInPandasExec)) is requested to `doExecute`

### <span id="numRowsInMemoryBufferThreshold"> numRowsInMemoryBufferThreshold

`numRowsInMemoryBufferThreshold` is used for the following:

* [initialSizeOfInMemoryBuffer](#initialSizeOfInMemoryBuffer)
* [add](#add)

### <span id="numRowsSpillThreshold"> numRowsSpillThreshold

`numRowsSpillThreshold` is used for the following:

* Create an [UnsafeExternalSorter](#spillableArray) (after the [numRowsInMemoryBufferThreshold](#numRowsInMemoryBufferThreshold) is reached)

## <span id="numRows"> numRows Counter

`ExternalAppendOnlyUnsafeRowArray` uses `numRows` internal counter for the number of [rows added](#add).

### <span id="length"> length

```scala
length: Int
```

`length` returns the [numRows](#numRows).

`length` is used when:

* `SortMergeJoinExec` physical operator is requested to [doExecute](physical-operators/SortMergeJoinExec.md#doExecute) (for `LeftSemi`, `LeftAnti` and `ExistenceJoin` joins)
* `FrameLessOffsetWindowFunctionFrame` is requested to `doWrite`
* `OffsetWindowFunctionFrameBase` is requested to `findNextRowWithNonNullInput`
* `SlidingWindowFunctionFrame` is requested to `write`
* `UnboundedFollowingWindowFunctionFrame` is requested to `write` and `currentUpperBound`
* `UnboundedOffsetWindowFunctionFrame` is requested to `prepare`
* `UnboundedPrecedingWindowFunctionFrame` is requested to `prepare`
* `UnboundedWindowFunctionFrame` is requested to `prepare`

## <span id="inMemoryBuffer"> inMemoryBuffer

`ExternalAppendOnlyUnsafeRowArray` creates an `inMemoryBuffer` internal array of [UnsafeRow](UnsafeRow.md)s when [created](#creating-instance) and the [initialSizeOfInMemoryBuffer](#initialSizeOfInMemoryBuffer) is greater than `0`.

A new `UnsafeRow` can be added to `inMemoryBuffer` in [add](#add) (up to the [numRowsInMemoryBufferThreshold](#numRowsInMemoryBufferThreshold)).

`inMemoryBuffer` is cleared in [clear](#clear) or [add](#add) (when the number of `UnsafeRow`s is above the [numRowsInMemoryBufferThreshold](#numRowsInMemoryBufferThreshold)).

## <span id="initialSizeOfInMemoryBuffer"> initialSizeOfInMemoryBuffer

`ExternalAppendOnlyUnsafeRowArray` uses `initialSizeOfInMemoryBuffer` internal value as the number of [UnsafeRow](UnsafeRow.md)s in the [inMemoryBuffer](#inMemoryBuffer).

`initialSizeOfInMemoryBuffer` is at most `128` and can be configured using the[numRowsInMemoryBufferThreshold](#numRowsInMemoryBufferThreshold) (if smaller).

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.ExternalAppendOnlyUnsafeRowArray` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.ExternalAppendOnlyUnsafeRowArray=ALL
```

Refer to [Logging](spark-logging.md)
