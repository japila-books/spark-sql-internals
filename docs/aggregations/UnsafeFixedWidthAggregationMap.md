# UnsafeFixedWidthAggregationMap

`UnsafeFixedWidthAggregationMap` is a tiny layer (_extension_) over Spark Core's [BytesToBytesMap](#map) for [UnsafeRow](../UnsafeRow.md) keys and values.

`UnsafeFixedWidthAggregationMap` is used when [HashAggregateExec](../physical-operators/HashAggregateExec.md) physical operator is executed:

* Directly in [createHashMap](../physical-operators/HashAggregateExec.md#createHashMap)
* Indirectly through [TungstenAggregationIterator](TungstenAggregationIterator.md#hashMap) while [doExecute](../physical-operators/HashAggregateExec.md#doExecute)

## Creating Instance

`UnsafeFixedWidthAggregationMap` takes the following to be created:

* [Empty Aggregation Buffer](#emptyAggregationBuffer)
* <span id="aggregationBufferSchema"> Aggregation Buffer Schema ([StructType](../types/StructType.md))
* <span id="groupingKeySchema"> Grouping Key Schema ([StructType](../types/StructType.md))
* <span id="taskContext"> `TaskContext` ([Spark Core]({{ book.spark_core }}/scheduler/TaskContext))
* [Initial Capacity](#initialCapacity)
* [Page Size](#pageSizeBytes)

### Page Size { #pageSizeBytes }

`UnsafeFixedWidthAggregationMap` is given the page size (in bytes) of the [BytesToBytesMap](#map) when [created](#creating-instance).

The page size is what the `TaskMemoryManager` ([Spark Core]({{ book.spark_core }}/memory/TaskMemoryManager/#page-size)) is configured with.

### Initial Capacity { #initialCapacity }

`UnsafeFixedWidthAggregationMap` is given the initial capacity of the [BytesToBytesMap](#map) when [created](#creating-instance).

The initial capacity is hard-coded to `1024 * 16`.

## Empty Aggregation Buffer { #emptyAggregationBuffer }

??? note "There are two `emptyAggregationBuffer`s"

```java
InternalRow emptyAggregationBuffer
```

`UnsafeFixedWidthAggregationMap` is given an [InternalRow](../InternalRow.md) (`emptyAggregationBuffer`) when [created](#creating-instance).

This `emptyAggregationBuffer` is used to initialize another `emptyAggregationBuffer` to be of type `byte[]`.

```java
byte[] emptyAggregationBuffer
```

??? note "private final"
    `emptyAggregationBuffer` is a `private final`  value that has to be initialized when this `UnsafeFixedWidthAggregationMap` is [created](#creating-instance).

`emptyAggregationBuffer` is initialized to be `byte`s of an [UnsafeProjection](../expressions/UnsafeProjection.md#create) (with the [aggregationBufferSchema](#aggregationBufferSchema)) applied to the input `emptyAggregationBuffer`.

`emptyAggregationBuffer` is used to [getAggregationBufferFromUnsafeRow](#getAggregationBufferFromUnsafeRow) as the (default) value for new keys (a "zero" of an aggregate function).

## BytesToBytesMap { #map }

When [created](#creating-instance), `UnsafeFixedWidthAggregationMap` creates a `BytesToBytesMap` ([Spark Core]({{ book.spark_core }}/BytesToBytesMap)) with the following:

* `TaskMemoryManager` ([Spark Core]({{ book.spark_core }}/memory/TaskMemoryManager)) of this [TaskContext](#taskContext)
* [Initial Capacity](#initialCapacity)
* [Page Size](#pageSizeBytes)

The `BytesToBytesMap` is used when:

* [getAggregationBufferFromUnsafeRow](#getAggregationBufferFromUnsafeRow) to look up
* [iterator](#iterator)
* [getPeakMemoryUsedBytes](#getPeakMemoryUsedBytes)
* [free](#free)
* [getAvgHashProbeBucketListIterations](#getAvgHashProbeBucketListIterations)
* [destructAndCreateExternalSorter](#destructAndCreateExternalSorter)

## supportsAggregationBufferSchema { #supportsAggregationBufferSchema }

```java
boolean supportsAggregationBufferSchema(
  StructType schema)
```

`supportsAggregationBufferSchema` is enabled (`true`) if all of the [top-level fields](../types/StructType.md#fields) (of the given [schema](../types/StructType.md)) are [mutable](../UnsafeRow.md#isMutable).

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

* `HashAggregateExec` utility is used for the [selection requirements](../physical-operators/HashAggregateExec.md#supportsAggregate)

## Looking Up Aggregation Value Buffer for Grouping Key { #getAggregationBufferFromUnsafeRow }

```java
UnsafeRow getAggregationBufferFromUnsafeRow(
  UnsafeRow key) // (1)!
UnsafeRow getAggregationBufferFromUnsafeRow(
  UnsafeRow key,
  int hash)
```

1. Uses the hash code of the given key

`getAggregationBufferFromUnsafeRow` gives one of the following:

* [currentAggregationBuffer](#currentAggregationBuffer) pointed to the value for the grouping `key`
* `null` for no value for the given `key` and insertion failed

---

`getAggregationBufferFromUnsafeRow` looks up the given (grouping) `key` (in the [BytesToBytesMap](#map)).

Unless found, `getAggregationBufferFromUnsafeRow` uses the [Empty Aggregation Buffer](#emptyAggregationBuffer) as the value instead.

??? note "`null` when insertion fails"
    The [Empty Aggregation Buffer](#emptyAggregationBuffer) is copied over to the [BytesToBytesMap](#map) for the grouping key.

    In case the insertion fails, `getAggregationBufferFromUnsafeRow` returns `null`.

In the end, `getAggregationBufferFromUnsafeRow` requests the [currentAggregationBuffer](#currentAggregationBuffer) to [pointTo](../UnsafeRow.md#pointTo) to the value (that was just stored or looked up).

---

`getAggregationBufferFromUnsafeRow` is used when:

* `TungstenAggregationIterator` is requested to [process input rows](TungstenAggregationIterator.md#processInputs)

## Current Aggregation Buffer { #currentAggregationBuffer }

`UnsafeFixedWidthAggregationMap` creates an [UnsafeRow](../UnsafeRow.md) when [created](#creating-instance).

The number of fields of this `UnsafeRow` is the length of the [aggregationBufferSchema](#aggregationBufferSchema).

The `UnsafeRow` is (re)used to point to the value (that was stored or looked up) in [getAggregationBufferFromUnsafeRow](#getAggregationBufferFromUnsafeRow).
