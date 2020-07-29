# UnsafeFixedWidthAggregationMap

`UnsafeFixedWidthAggregationMap` is a tiny layer (_extension_) around Spark Core's <<map, BytesToBytesMap>> to allow for <<spark-sql-UnsafeRow.md#, UnsafeRow>> keys and values.

Whenever requested for performance metrics (i.e. <<getAverageProbesPerLookup, average number of probes per key lookup>> and <<getPeakMemoryUsedBytes, peak memory used>>), `UnsafeFixedWidthAggregationMap` simply requests the underlying <<map, BytesToBytesMap>>.

`UnsafeFixedWidthAggregationMap` is <<creating-instance, created>> when:

* `HashAggregateExec` physical operator is requested to <<spark-sql-SparkPlan-HashAggregateExec.md#createHashMap, create a new UnsafeFixedWidthAggregationMap>> (when `HashAggregateExec` physical operator is requested to <<spark-sql-SparkPlan-HashAggregateExec.md#doProduceWithKeys, generate the Java source code for "produce" path in Whole-Stage Code Generation>>)

* `TungstenAggregationIterator` is <<spark-sql-TungstenAggregationIterator.md#hashMap, created>> (when `HashAggregateExec` physical operator is requested to <<spark-sql-SparkPlan-HashAggregateExec.md#doExecute, execute>> in traditional / non-Whole-Stage-Code-Generation execution path)

[[internal-registries]]
.UnsafeFixedWidthAggregationMap's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1m,2",options="header",width="100%"]
|===
| Name
| Description

| currentAggregationBuffer
| [[currentAggregationBuffer]] Re-used pointer (as an <<spark-sql-UnsafeRow.md#, UnsafeRow>> with the number of fields to match the <<aggregationBufferSchema, aggregationBufferSchema>>) to the current aggregation buffer

Used exclusively when `UnsafeFixedWidthAggregationMap` is requested to <<getAggregationBufferFromUnsafeRow, getAggregationBufferFromUnsafeRow>>.

| emptyAggregationBuffer
| [[emptyAggregationBuffer-byte-array]] <<emptyAggregationBuffer, Empty aggregation buffer>> (<<spark-sql-UnsafeProjection.md#create, encoded in UnsafeRow format>>)

| groupingKeyProjection
| [[groupingKeyProjection]] <<spark-sql-UnsafeProjection.md#, UnsafeProjection>> for the <<groupingKeySchema, groupingKeySchema>> (to encode grouping keys as UnsafeRows)

| map
a| [[map]] Spark Core's `BytesToBytesMap` with the <<taskMemoryManager, taskMemoryManager>>, <<initialCapacity, initialCapacity>>, <<pageSizeBytes, pageSizeBytes>> and performance metrics enabled
|===

=== [[supportsAggregationBufferSchema]] `supportsAggregationBufferSchema` Static Method

[source, java]
----
boolean supportsAggregationBufferSchema(StructType schema)
----

`supportsAggregationBufferSchema` is a predicate that is enabled (`true`) unless there is a <<spark-sql-StructField.md#, field>> (in the <<spark-sql-StructType.md#fields, fields>> of the input <<spark-sql-StructType.md#, schema>>) whose <<spark-sql-StructField.md#dataType, data type>> is not <<spark-sql-UnsafeRow.md#isMutable, mutable>>.

[NOTE]
====
The <<spark-sql-UnsafeRow.md#isMutable, mutable>> data types: <<spark-sql-DataType.md#BooleanType, BooleanType>>, <<spark-sql-DataType.md#ByteType, ByteType>>, <<spark-sql-DataType.md#DateType, DateType>>, <<spark-sql-DataType.md#DecimalType, DecimalType>>, <<spark-sql-DataType.md#DoubleType, DoubleType>>, <<spark-sql-DataType.md#FloatType, FloatType>>, <<spark-sql-DataType.md#IntegerType, IntegerType>>, <<spark-sql-DataType.md#LongType, LongType>>, <<spark-sql-DataType.md#NullType, NullType>>, <<spark-sql-DataType.md#ShortType, ShortType>> and <<spark-sql-DataType.md#TimestampType, TimestampType>>.

Examples (possibly all) of data types that are not <<spark-sql-UnsafeRow.md#isMutable, mutable>>: <<spark-sql-DataType.md#ArrayType, ArrayType>>, <<spark-sql-DataType.md#BinaryType, BinaryType>>, <<spark-sql-DataType.md#StringType, StringType>>, <<spark-sql-DataType.md#CalendarIntervalType, CalendarIntervalType>>, <<spark-sql-DataType.md#MapType, MapType>>, <<spark-sql-DataType.md#ObjectType, ObjectType>> and <<spark-sql-DataType.md#StructType, StructType>>.
====

[source, scala]
----
import org.apache.spark.sql.execution.UnsafeFixedWidthAggregationMap

import org.apache.spark.sql.types._
val schemaWithImmutableField = StructType(StructField("string", StringType) :: Nil)
assert(UnsafeFixedWidthAggregationMap.supportsAggregationBufferSchema(schemaWithImmutableField) == false)

val schemaWithMutableFields = StructType(
  StructField("int", IntegerType) :: StructField("bool", BooleanType) :: Nil)
assert(UnsafeFixedWidthAggregationMap.supportsAggregationBufferSchema(schemaWithMutableFields))
----

NOTE: `supportsAggregationBufferSchema` is used exclusively when `HashAggregateExec` is requested to <<spark-sql-SparkPlan-HashAggregateExec.md#supportsAggregate, supportsAggregate>>.

=== [[creating-instance]] Creating UnsafeFixedWidthAggregationMap Instance

`UnsafeFixedWidthAggregationMap` takes the following when created:

* [[emptyAggregationBuffer]] Empty aggregation buffer (as an <<spark-sql-InternalRow.md#, InternalRow>>)
* [[aggregationBufferSchema]] Aggregation buffer <<spark-sql-StructType.md#, schema>>
* [[groupingKeySchema]] Grouping key <<spark-sql-StructType.md#, schema>>
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

* `TungstenAggregationIterator` is requested to <<spark-sql-TungstenAggregationIterator.md#processInputs, processInputs>> (exclusively when `TungstenAggregationIterator` is <<spark-sql-TungstenAggregationIterator.md#creating-instance, created>>)

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

[NOTE]
====
`iterator` is used when:

* `HashAggregateExec` physical operator is requested to <<spark-sql-SparkPlan-HashAggregateExec.md#finishAggregate, finishAggregate>>

* `TungstenAggregationIterator` is <<spark-sql-TungstenAggregationIterator.md#creating-instance, created>> (and pre-loads the first key-value pair from the map)
====

=== [[getPeakMemoryUsedBytes]] `getPeakMemoryUsedBytes` Method

[source, java]
----
long getPeakMemoryUsedBytes()
----

`getPeakMemoryUsedBytes`...FIXME

[NOTE]
====
`getPeakMemoryUsedBytes` is used when:

* `HashAggregateExec` physical operator is requested to <<spark-sql-SparkPlan-HashAggregateExec.md#finishAggregate, finishAggregate>>

* `TungstenAggregationIterator` is <<spark-sql-TungstenAggregationIterator.md#TaskCompletionListener, used in TaskCompletionListener>>
====

=== [[getAverageProbesPerLookup]] `getAverageProbesPerLookup` Method

[source, java]
----
double getAverageProbesPerLookup()
----

`getAverageProbesPerLookup`...FIXME

[NOTE]
====
`getAverageProbesPerLookup` is used when:

* `HashAggregateExec` physical operator is requested to <<spark-sql-SparkPlan-HashAggregateExec.md#finishAggregate, finishAggregate>>

* `TungstenAggregationIterator` is <<spark-sql-TungstenAggregationIterator.md#TaskCompletionListener, used in TaskCompletionListener>>
====

=== [[free]] `free` Method

[source, java]
----
void free()
----

`free`...FIXME

[NOTE]
====
`free` is used when:

* `HashAggregateExec` physical operator is requested to <<spark-sql-SparkPlan-HashAggregateExec.md#finishAggregate, finishAggregate>>

* `TungstenAggregationIterator` is requested to <<spark-sql-TungstenAggregationIterator.md#processInputs, processInputs>> (when `TungstenAggregationIterator` is <<spark-sql-TungstenAggregationIterator.md#creating-instance, created>>), <<spark-sql-TungstenAggregationIterator.md#next, get the next UnsafeRow>>, <<spark-sql-TungstenAggregationIterator.md#outputForEmptyGroupingKeyWithoutInput, outputForEmptyGroupingKeyWithoutInput>> and is <<spark-sql-TungstenAggregationIterator.md#creating-instance, created>>
====

=== [[destructAndCreateExternalSorter]] `destructAndCreateExternalSorter` Method

[source, java]
----
UnsafeKVExternalSorter destructAndCreateExternalSorter() throws IOException
----

`destructAndCreateExternalSorter`...FIXME

[NOTE]
====
`destructAndCreateExternalSorter` is used when:

* `HashAggregateExec` physical operator is requested to <<spark-sql-SparkPlan-HashAggregateExec.md#finishAggregate, finishAggregate>>

* `TungstenAggregationIterator` is requested to <<spark-sql-TungstenAggregationIterator.md#processInputs, processInputs>> (when `TungstenAggregationIterator` is <<spark-sql-TungstenAggregationIterator.md#creating-instance, created>>)
====
