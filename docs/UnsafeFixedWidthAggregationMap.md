# UnsafeFixedWidthAggregationMap

`UnsafeFixedWidthAggregationMap` is a tiny layer (_extension_) around Spark Core's [BytesToBytesMap](#map) with [UnsafeRow](UnsafeRow.md) keys and values.

## <span id="supportsAggregationBufferSchema"> supportsAggregationBufferSchema

```java
boolean supportsAggregationBufferSchema(
  StructType schema)
```

`supportsAggregationBufferSchema` is enabled (`true`) if all of the [top-level fields](types/StructType.md#fields) (of the given [schema](types/StructType.md)) are [mutable](UnsafeRow.md#isMutable).

```scala
import org.apache.spark.sql.execution.UnsafeFixedWidthAggregationMap
import org.apache.spark.sql.types._
```

```scala
val schemaWithImmutableField = StructType(
  StructField("name", StringType) :: Nil)
assert(UnsafeFixedWidthAggregationMap.supportsAggregationBufferSchema(schemaWithImmutableField) == false)
```

```scala
val schemaWithMutableFields = StructType(
  StructField("id", IntegerType) :: StructField("bool", BooleanType) :: Nil)
assert(UnsafeFixedWidthAggregationMap.supportsAggregationBufferSchema(schemaWithMutableFields))
```

`supportsAggregationBufferSchema` is used when:

* `HashAggregateExec` utility is used for the [selection requirements](physical-operators/HashAggregateExec.md#supportsAggregate)

## Review Me

Whenever requested for performance metrics (i.e. <<getAverageProbesPerLookup, average number of probes per key lookup>> and <<getPeakMemoryUsedBytes, peak memory used>>), `UnsafeFixedWidthAggregationMap` simply requests the underlying <<map, BytesToBytesMap>>.

`UnsafeFixedWidthAggregationMap` is <<creating-instance, created>> when:

* `HashAggregateExec` physical operator is requested to [create a new UnsafeFixedWidthAggregationMap](physical-operators/HashAggregateExec.md#createHashMap) (when `HashAggregateExec` physical operator is requested to [generate the Java source code for "produce" path in Whole-Stage Code Generation](physical-operators/HashAggregateExec.md#doProduceWithKeys))

* `TungstenAggregationIterator` is <<TungstenAggregationIterator.md#hashMap, created>> (when `HashAggregateExec` physical operator is requested to [execute](physical-operators/HashAggregateExec.md#doExecute) in traditional / non-Whole-Stage-Code-Generation execution path)

[[internal-registries]]
.UnsafeFixedWidthAggregationMap's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1m,2",options="header",width="100%"]
|===
| Name
| Description

| currentAggregationBuffer
| [[currentAggregationBuffer]] Re-used pointer (as an <<UnsafeRow.md#, UnsafeRow>> with the number of fields to match the <<aggregationBufferSchema, aggregationBufferSchema>>) to the current aggregation buffer

Used exclusively when `UnsafeFixedWidthAggregationMap` is requested to <<getAggregationBufferFromUnsafeRow, getAggregationBufferFromUnsafeRow>>.

| emptyAggregationBuffer
| [[emptyAggregationBuffer-byte-array]] <<emptyAggregationBuffer, Empty aggregation buffer>> ([encoded in UnsafeRow format](expressions/UnsafeProjection.md#create))

| groupingKeyProjection
| [[groupingKeyProjection]] [UnsafeProjection](expressions/UnsafeProjection.md) for the <<groupingKeySchema, groupingKeySchema>> (to encode grouping keys as UnsafeRows)

| map
a| [[map]] Spark Core's `BytesToBytesMap` with the <<taskMemoryManager, taskMemoryManager>>, <<initialCapacity, initialCapacity>>, <<pageSizeBytes, pageSizeBytes>> and performance metrics enabled
|===

## Creating Instance

`UnsafeFixedWidthAggregationMap` takes the following when created:

* [[emptyAggregationBuffer]] Empty aggregation buffer (as an [InternalRow](InternalRow.md))
* [[aggregationBufferSchema]] Aggregation buffer [schema](types/StructType.md)
* [[groupingKeySchema]] Grouping key [schema](types/StructType.md)
* [[taskMemoryManager]] Spark Core's `TaskMemoryManager`
* [[initialCapacity]] Initial capacity
* [[pageSizeBytes]] Page size (in bytes)

`UnsafeFixedWidthAggregationMap` initializes the <<internal-registries, internal registries and counters>>.

=== [[getAggregationBufferFromUnsafeRow]] `getAggregationBufferFromUnsafeRow` Method

[source, scala]
----
UnsafeRow getAggregationBufferFromUnsafeRow(UnsafeRow key) // <1>
UnsafeRow getAggregationBufferFromUnsafeRow(UnsafeRow key, int hash)
----
<1> Uses the hash code of the key

`getAggregationBufferFromUnsafeRow` requests the <<map, BytesToBytesMap>> to `lookup` the input `key` (to get a `BytesToBytesMap.Location`).

`getAggregationBufferFromUnsafeRow`...FIXME

[NOTE]
====
`getAggregationBufferFromUnsafeRow` is used when:

* `TungstenAggregationIterator` is requested to <<TungstenAggregationIterator.md#processInputs, processInputs>> (exclusively when `TungstenAggregationIterator` is <<TungstenAggregationIterator.md#creating-instance, created>>)

* (for testing only) `UnsafeFixedWidthAggregationMap` is requested to <<getAggregationBuffer, getAggregationBuffer>>
====

=== [[getAggregationBuffer]] `getAggregationBuffer` Method

[source, java]
----
UnsafeRow getAggregationBuffer(InternalRow groupingKey)
----

`getAggregationBuffer`...FIXME

NOTE: `getAggregationBuffer` seems to be used exclusively for testing.

=== [[iterator]] Getting KVIterator -- `iterator` Method

[source, java]
----
KVIterator<UnsafeRow, UnsafeRow> iterator()
----

`iterator`...FIXME

`iterator` is used when:

* `HashAggregateExec` physical operator is requested to [finishAggregate](physical-operators/HashAggregateExec.md#finishAggregate)

* [TungstenAggregationIterator](TungstenAggregationIterator.md) is created (and pre-loads the first key-value pair from the map)

=== [[getPeakMemoryUsedBytes]] `getPeakMemoryUsedBytes` Method

[source, java]
----
long getPeakMemoryUsedBytes()
----

`getPeakMemoryUsedBytes`...FIXME

`getPeakMemoryUsedBytes` is used when:

* `HashAggregateExec` physical operator is requested to [finishAggregate](physical-operators/HashAggregateExec.md#finishAggregate)

* `TungstenAggregationIterator` is [used in TaskCompletionListener](TungstenAggregationIterator.md#TaskCompletionListener)

=== [[getAverageProbesPerLookup]] `getAverageProbesPerLookup` Method

[source, java]
----
double getAverageProbesPerLookup()
----

`getAverageProbesPerLookup`...FIXME

`getAverageProbesPerLookup` is used when:

* `HashAggregateExec` physical operator is requested to [finishAggregate](physical-operators/HashAggregateExec.md#finishAggregate)

* `TungstenAggregationIterator` is [used in TaskCompletionListener](TungstenAggregationIterator.md#TaskCompletionListener)

=== [[free]] `free` Method

[source, java]
----
void free()
----

`free`...FIXME

`free` is used when:

* `HashAggregateExec` physical operator is requested to [finishAggregate](physical-operators/HashAggregateExec.md#finishAggregate)

* `TungstenAggregationIterator` is requested to [processInputs](TungstenAggregationIterator.md#processInputs) (when [TungstenAggregationIterator](TungstenAggregationIterator.md) is created), [get the next UnsafeRow](TungstenAggregationIterator.md#next), [outputForEmptyGroupingKeyWithoutInput](TungstenAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput) and is [created](TungstenAggregationIterator.md)

=== [[destructAndCreateExternalSorter]] `destructAndCreateExternalSorter` Method

[source, java]
----
UnsafeKVExternalSorter destructAndCreateExternalSorter() throws IOException
----

`destructAndCreateExternalSorter`...FIXME

`destructAndCreateExternalSorter` is used when:

* `HashAggregateExec` physical operator is requested to [finishAggregate](physical-operators/HashAggregateExec.md#finishAggregate)

* [TungstenAggregationIterator](TungstenAggregationIterator.md) is created (and requested to [processInputs](TungstenAggregationIterator.md#processInputs))
