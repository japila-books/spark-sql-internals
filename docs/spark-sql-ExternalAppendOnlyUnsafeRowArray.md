title: ExternalAppendOnlyUnsafeRowArray

# ExternalAppendOnlyUnsafeRowArray -- Append-Only Array for UnsafeRows (with Disk Spill Threshold)

`ExternalAppendOnlyUnsafeRowArray` is an append-only array for UnsafeRow.md[UnsafeRows] that spills content to disk when a <<numRowsSpillThreshold, predefined spill threshold of rows>> is reached.

NOTE: Choosing a proper *spill threshold of rows* is a performance optimization.

`ExternalAppendOnlyUnsafeRowArray` is created when:

* `WindowExec` physical operator is WindowExec.md#doExecute[executed] (and creates an internal buffer for window frames)

* `WindowFunctionFrame` is spark-sql-WindowFunctionFrame.md#prepare[prepared]

* `SortMergeJoinExec` physical operator is SortMergeJoinExec.md#doExecute[executed] (and creates a `RowIterator` for INNER and CROSS joins) and for `getBufferedMatches`

* `SortMergeJoinScanner` creates an internal `bufferedMatches`

* `UnsafeCartesianRDD` is computed

[[internal-registries]]
.ExternalAppendOnlyUnsafeRowArray's Internal Registries and Counters
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| [[initialSizeOfInMemoryBuffer]] `initialSizeOfInMemoryBuffer`
| FIXME

Used when...FIXME

| [[inMemoryBuffer]] `inMemoryBuffer`
| FIXME

Can grow up to <<numRowsSpillThreshold, numRowsSpillThreshold>> rows (i.e. new `UnsafeRows` are <<add, added>>)

Used when...FIXME

| [[spillableArray]] `spillableArray`
| `UnsafeExternalSorter`

Used when...FIXME

| [[numRows]] `numRows`
|

Used when...FIXME

| [[modificationsCount]] `modificationsCount`
|

Used when...FIXME

| [[numFieldsPerRow]] `numFieldsPerRow`
|

Used when...FIXME
|===

[TIP]
====
Enable `INFO` logging level for `org.apache.spark.sql.execution.ExternalAppendOnlyUnsafeRowArray` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.execution.ExternalAppendOnlyUnsafeRowArray=INFO
```

Refer to spark-logging.md[Logging].
====

=== [[generateIterator]] `generateIterator` Method

[source, scala]
----
generateIterator(): Iterator[UnsafeRow]
generateIterator(startIndex: Int): Iterator[UnsafeRow]
----

CAUTION: FIXME

=== [[add]] `add` Method

[source, scala]
----
add(unsafeRow: UnsafeRow): Unit
----

CAUTION: FIXME

[NOTE]
====
`add` is used when:

* `WindowExec` is executed (and WindowExec.md#fetchNextPartition[fetches all rows in a partition for a group].

* `SortMergeJoinScanner` buffers matching rows

* `UnsafeCartesianRDD` is computed
====

=== [[clear]] `clear` Method

[source, scala]
----
clear(): Unit
----

CAUTION: FIXME

=== [[creating-instance]] Creating ExternalAppendOnlyUnsafeRowArray Instance

`ExternalAppendOnlyUnsafeRowArray` takes the following when created:

* [[taskMemoryManager]] spark-taskscheduler-taskmemorymanager.md[TaskMemoryManager]
* [[blockManager]] spark-blockmanager.md[BlockManager]
* [[serializerManager]] spark-SerializerManager.md[SerializerManager]
* [[taskContext]] spark-taskscheduler-taskcontext.md[TaskContext]
* [[initialSize]] Initial size
* [[pageSizeBytes]] Page size (in bytes)
* [[numRowsSpillThreshold]] Number of rows to hold before spilling them to disk

`ExternalAppendOnlyUnsafeRowArray` initializes the <<internal-registries, internal registries and counters>>.
