# UnsafeFixedWidthAggregationMap

`UnsafeFixedWidthAggregationMap` is a tiny layer (_extension_) over Spark Core's [BytesToBytesMap](#map) with [UnsafeRow](UnsafeRow.md) keys and values.

`UnsafeFixedWidthAggregationMap` is used in [HashAggregateExec](physical-operators/HashAggregateExec.md#createHashMap) physical operator.

## Creating Instance

`UnsafeFixedWidthAggregationMap` takes the following to be created:

* <span id="emptyAggregationBuffer"> Empty aggregation buffer ([InternalRow](InternalRow.md))
* <span id="aggregationBufferSchema"> Aggregation Buffer Schema ([StructType](types/StructType.md))
* <span id="groupingKeySchema"> Grouping Key Schema ([StructType](types/StructType.md))
* <span id="taskContext"> `TaskContext` ([Spark Core]({{ book.spark_core }}/scheduler/TaskContext))
* [Initial Capacity](#initialCapacity)
* <span id="pageSizeBytes"> Page Size (in bytes)

`UnsafeFixedWidthAggregationMap` is created when:

* `HashAggregateExec` physical operator is requested to [create a HashMap](physical-operators/HashAggregateExec.md#createHashMap)
* `TungstenAggregationIterator` is requested for the [hashMap](physical-operators/TungstenAggregationIterator.md#hashMap)

### <span id="initialCapacity"> Initial Capacity

`UnsafeFixedWidthAggregationMap` is given the initial capacity of the [BytesToBytesMap](#map) when [created](#creating-instance).

The initial capacity is hard-coded to `1024 * 16` (when created for [HashAggregateExec](physical-operators/HashAggregateExec.md#createHashMap) and [TungstenAggregationIterator](physical-operators/TungstenAggregationIterator.md#hashMap)).

## <span id="map"> BytesToBytesMap

`UnsafeFixedWidthAggregationMap` creates a `BytesToBytesMap` ([Spark Core]({{ book.spark_core }}/memory/BytesToBytesMap)) with the following when [created](#creating-instance):

* `TaskMemoryManager` ([Spark Core]({{ book.spark_core }}/memory/TaskMemoryManager)) of the [TaskContext](#taskContext)
* [Initial Capacity](#initialCapacity)
* [Page Size](#pageSizeBytes)

The `BytesToBytesMap` is used when:

* [getAggregationBufferFromUnsafeRow](#getAggregationBufferFromUnsafeRow) to look up
* [iterator](#iterator)
* [getPeakMemoryUsedBytes](#getPeakMemoryUsedBytes)
* [free](#free)
* [getAvgHashProbeBucketListIterations](#getAvgHashProbeBucketListIterations)
* [destructAndCreateExternalSorter](#destructAndCreateExternalSorter)

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

## <span id="getAggregationBufferFromUnsafeRow"> getAggregationBufferFromUnsafeRow

```java
UnsafeRow getAggregationBufferFromUnsafeRow(
  UnsafeRow key) // (1)!
UnsafeRow getAggregationBufferFromUnsafeRow(
  UnsafeRow key,
  int hash)
```

1. Uses the hash code of the given key

`getAggregationBufferFromUnsafeRow` returns the following:

* `null` when the given `key` was not found and had to be inserted but failed
* [currentAggregationBuffer](#currentAggregationBuffer) pointed to the value (object)

---

`getAggregationBufferFromUnsafeRow` uses the [BytesToBytesMap](#map) to look up `BytesToBytesMap.Location` of the given (grouping) `key`.

If the key has not been found (is not defined at the key's position), `getAggregationBufferFromUnsafeRow` inserts a copy of the [emptyAggregationBuffer](#emptyAggregationBuffer) into the [map](#map). `getAggregationBufferFromUnsafeRow` returns `null` if insertion failed.

`getAggregationBufferFromUnsafeRow` requests the [currentAggregationBuffer](#currentAggregationBuffer) to [pointTo](UnsafeRow.md#pointTo) to an object at `BytesToBytesMap.Location`.

---

`getAggregationBufferFromUnsafeRow` is used when:

* `TungstenAggregationIterator` is requested to [process the input rows](physical-operators/TungstenAggregationIterator.md#processInputs)

## <span id="currentAggregationBuffer"> currentAggregationBuffer

`UnsafeFixedWidthAggregationMap` creates a [UnsafeRow](UnsafeRow.md) when [created](#creating-instance).

The number of fields of this `UnsafeRow` is the length of the [aggregationBufferSchema](#aggregationBufferSchema).

The `UnsafeRow` is (re)used to point to the value (that was stored or looked up) in [getAggregationBufferFromUnsafeRow](#getAggregationBufferFromUnsafeRow).

<!---
## Review Me

Whenever requested for performance metrics (i.e. <<getAverageProbesPerLookup, average number of probes per key lookup>> and <<getPeakMemoryUsedBytes, peak memory used>>), `UnsafeFixedWidthAggregationMap` simply requests the underlying <<map, BytesToBytesMap>>.

[[internal-registries]]
.UnsafeFixedWidthAggregationMap's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1m,2",options="header",width="100%"]
|===
| Name
| Description

| emptyAggregationBuffer
| [[emptyAggregationBuffer-byte-array]] <<emptyAggregationBuffer, Empty aggregation buffer>> ([encoded in UnsafeRow format](expressions/UnsafeProjection.md#create))

| groupingKeyProjection
| [[groupingKeyProjection]] [UnsafeProjection](expressions/UnsafeProjection.md) for the <<groupingKeySchema, groupingKeySchema>> (to encode grouping keys as UnsafeRows)
|===
-->
