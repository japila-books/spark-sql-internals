# VectorizedParquetRecordReader

`VectorizedParquetRecordReader` is a [SpecificParquetRecordReaderBase](SpecificParquetRecordReaderBase.md) for [Parquet Data Source](index.md) for [Vectorized Decoding](../../vectorized-decoding/index.md).

## Creating Instance

`VectorizedParquetRecordReader` takes the following to be created:

* <span id="convertTz"> `ZoneId` (for timezone conversion)
* <span id="datetimeRebaseMode"> Datetime Rebase Mode
* <span id="datetimeRebaseTz"> Datetime Rebase Timezone
* <span id="int96RebaseMode"> int96 Rebase Mode
* <span id="int96RebaseTz"> int96 Rebase Timezone
* [useOffHeap](#useOffHeap)
* [Capacity](#capacity)

`VectorizedParquetRecordReader` is created when:

* `ParquetFileFormat` is requested to [buildReaderWithPartitionValues](ParquetFileFormat.md#buildReaderWithPartitionValues) (with [enableVectorizedReader](ParquetFileFormat.md#enableVectorizedReader) flag enabled)
* `ParquetPartitionReaderFactory` is requested to [createParquetVectorizedReader](ParquetPartitionReaderFactory.md#createParquetVectorizedReader)

### <span id="capacity"> Capacity

`VectorizedParquetRecordReader` is given capacity when [created](#creating-instance).

The capacity is configured using [spark.sql.parquet.columnarReaderBatchSize](../../configuration-properties.md#spark.sql.parquet.columnarReaderBatchSize) configuration property.

### <span id="MEMORY_MODE"><span id="useOffHeap"> Memory Mode

`VectorizedParquetRecordReader` uses the given [useOffHeap](#useOffHeap) to initialize the internal `MEMORY_MODE` registry when [created](#creating-instance):

useOffHeap | MEMORY_MODE | WritableColumnVector
-----------|-------------|---------------------
 `true`  | `OFF_HEAP` | [OffHeapColumnVector](../../vectorized-decoding/OffHeapColumnVector.md)
 `false` | `ON_HEAP`  | [OnHeapColumnVector](../../vectorized-decoding/OnHeapColumnVector.md)

The `MEMORY_MODE` is used to [initBatch](#initBatch) (to choose the correct implementation of [WritableColumnVector](../../vectorized-decoding/WritableColumnVector.md)).

!!! note "useOffHeap"
    `useOffHeap` is the value of [spark.sql.columnVector.offheap.enabled](../../configuration-properties.md#spark.sql.columnVector.offheap.enabled) configuration property when the following are executed with [spark.sql.parquet.enableVectorizedReader](../../configuration-properties.md#spark.sql.parquet.enableVectorizedReader) enabled and [supported schema for columnar read](ParquetUtils.md#isBatchReadSupportedForSchema):
    
    * `ParquetFileFormat` is requested to [buildReaderWithPartitionValues](ParquetFileFormat.md#buildReaderWithPartitionValues)
    * `ParquetPartitionReaderFactory` is requested to [createVectorizedReader](ParquetPartitionReaderFactory.md#createVectorizedReader)

## <span id="columnVectors"> WritableColumnVectors

`VectorizedParquetRecordReader` defines an array of allocated [WritableColumnVector](../../vectorized-decoding/WritableColumnVector.md)s.

`columnVectors` is allocated when [initBatch](#initBatch).

---

`columnVectors` is used when:

* [initBatch](#initBatch)
* [nextBatch](#nextBatch)

## <span id="enableReturningBatches"> enableReturningBatches

```java
void enableReturningBatches()
```

`enableReturningBatches` simply turns the [returnColumnarBatch](#returnColumnarBatch) flag on.

---

`enableReturningBatches` is used when:

* `ParquetFileFormat` is requested to [buildReaderWithPartitionValues](ParquetFileFormat.md#buildReaderWithPartitionValues)
* `ParquetPartitionReaderFactory` is requested to [buildColumnarReader](ParquetPartitionReaderFactory.md#buildColumnarReader)

## <span id="initBatch"> Initializing Columnar Batch

```java
void initBatch() // (1)!
void initBatch(
  StructType partitionColumns,
  InternalRow partitionValues) // (2)!
void initBatch(
  MemoryMode memMode,
  StructType partitionColumns,
  InternalRow partitionValues) // (3)!
```

1. Uses the [MEMORY_MODE](#MEMORY_MODE) and no [partitionColumns](#partitionColumns) nor [partitionValues](#partitionValues)
2. Uses the [MEMORY_MODE](#MEMORY_MODE)
3. A private helper method

!!! note "MemoryMode"
    The given `MemoryMode` is the value of [MEMORY_MODE](#MEMORY_MODE).

`initBatch` creates a [batch schema](../../types/index.md) that is [sparkSchema](SpecificParquetRecordReaderBase.md#sparkSchema) and the input `partitionColumns` schema (if available).

`initBatch` requests [OffHeapColumnVector](../../vectorized-decoding/OffHeapColumnVector.md#allocateColumns) or [OnHeapColumnVector](../../vectorized-decoding/OnHeapColumnVector.md#allocateColumns) to allocate column vectors per the input `memMode` (i.e., [OFF_HEAP](#OFF_HEAP) or [ON_HEAP](#ON_HEAP) memory modes, respectively). `initBatch` records the allocated column vectors as the internal [WritableColumnVectors](#columnVectors).

!!! note "spark.sql.columnVector.offheap.enabled"
    [OnHeapColumnVector](../../vectorized-decoding/OnHeapColumnVector.md) is used based on [spark.sql.columnVector.offheap.enabled](../../configuration-properties.md#spark.sql.columnVector.offheap.enabled) configuration property.

`initBatch` creates a [ColumnarBatch](#columnarBatch) (with the [allocated WritableColumnVectors](#columnVectors)).

`initBatch` does some additional maintenance to the [WritableColumnVectors](#columnVectors).

---

`initBatch` is used when:

* `ParquetFileFormat` is requested to [build a data reader (with partition column values appended)](ParquetFileFormat.md#buildReaderWithPartitionValues)
* `ParquetPartitionReaderFactory` is requested to [createVectorizedReader](ParquetPartitionReaderFactory.md#createVectorizedReader)
* `VectorizedParquetRecordReader` is requested for a [result ColumnarBatch](#resultBatch)

### <span id="allocateColumns"> Allocating ColumnVectors

```java
ColumnVector[] allocateColumns(
  int capacity,
  StructType schema,
  boolean useOffHeap,
  int constantColumnLength)
```

`allocateColumns` creates [ColumnVector](../../vectorized-decoding/ColumnVector.md)s (one per every field in the given [StructType](../../types/StructType.md)).

For the given `useOffHeap` enabled, `allocateColumns` creates [OffHeapColumnVector](../../vectorized-decoding/OffHeapColumnVector.md)s. Otherwise, `allocateColumns` creates [OnHeapColumnVector](../../vectorized-decoding/OnHeapColumnVector.md)s.

!!! note "useOffHeap"
    `useOffHeap` flag is enabled when `memMode` of [initBatch](#initBatch) is `MemoryMode.OFF_HEAP`.

## <span id="nextKeyValue"> nextKeyValue

??? note "Signature"

    ```java
    boolean nextKeyValue()
    ```

    `nextKeyValue` is part of the `RecordReader` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/mapreduce/RecordReader.html#nextKeyValue--)) abstraction.

`nextKeyValue` [resultBatch](#resultBatch).

With [returnColumnarBatch](#returnColumnarBatch) enabled, `nextKeyValue` returns [nextBatch](#nextBatch).

Otherwise, `nextKeyValue`...FIXME

---

`nextKeyValue` is used when:

* `ParquetPartitionReaderFactory` is requested to [build a PartitionReader](ParquetPartitionReaderFactory.md#buildReader) and [buildColumnarReader](ParquetPartitionReaderFactory.md#buildColumnarReader)

### <span id="resultBatch"> resultBatch

```java
ColumnarBatch resultBatch()
```

`resultBatch` returns the [columnarBatch](#columnarBatch) if available. Otherwise, `resultBatch` [initBatch](#initBatch) first.

<!---
## Review Me

`VectorizedParquetRecordReader` uses <<OFF_HEAP, OFF_HEAP>> memory mode when [spark.sql.columnVector.offheap.enabled](../../configuration-properties.md#spark.sql.columnVector.offheap.enabled) internal configuration property is enabled (`true`).

[[internal-registries]]
.VectorizedParquetRecordReader's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1m,3",options="header",width="100%"]
|===
| Name
| Description

| batchIdx
| [[batchIdx]] Current batch index that is the index of an `InternalRow` in the <<columnarBatch, ColumnarBatch>>. Used when `VectorizedParquetRecordReader` is requested to <<getCurrentValue, getCurrentValue>> with the <<returnColumnarBatch, returnColumnarBatch>> flag disabled

Starts at `0`

Increments every <<nextKeyValue, nextKeyValue>>

Reset to `0` when <<nextBatch, reading next rows into a columnar batch>>

| columnarBatch
| [[columnarBatch]] [ColumnarBatch](../../vectorized-query-execution/ColumnarBatch.md)

| columnReaders
| [[columnReaders]] [VectorizedColumnReader](VectorizedColumnReader.md)s (one reader per column) to <<nextBatch, read rows as batches>>

Intialized when <<checkEndOfRowGroup, checkEndOfRowGroup>> (when requested to <<nextBatch, read next rows into a columnar batch>>)

| missingColumns
| [[missingColumns]] Bitmap of columns (per index) that are missing (or simply the ones that the reader should not read)

| returnColumnarBatch
| [[returnColumnarBatch]] Optimization flag to control whether `VectorizedParquetRecordReader` offers rows as the <<columnarBatch, ColumnarBatch>> or one row at a time only

Default: `false`

Enabled (`true`) when `VectorizedParquetRecordReader` is requested to <<enableReturningBatches, enable returning batches>>

Used in <<nextKeyValue, nextKeyValue>> (to <<nextBatch, read next rows into a columnar batch>>) and <<getCurrentValue, getCurrentValue>> (to return the internal <<columnarBatch, ColumnarBatch>> not a single `InternalRow`)

| rowsReturned
| [[rowsReturned]] Number of rows read already

| totalRowCount
| [[totalRowCount]] Total number of rows to be read

|===

## <span id="nextBatch"> Reading Next Rows Into Columnar Batch

```java
boolean nextBatch()
```

`nextBatch` reads at least <<capacity, capacity>> rows and returns `true` when there are rows available. Otherwise, `nextBatch` returns `false` (to "announce" there are no rows available).

Internally, `nextBatch` firstly requests every [WritableColumnVector](../../WritableColumnVector.md) (in the <<columnVectors, columnVectors>> internal registry) to [reset itself](../../WritableColumnVector.md#reset).

`nextBatch` requests the <<columnarBatch, ColumnarBatch>> to [specify the number of rows (in batch)](../../vectorized-query-execution/ColumnarBatch.md#setNumRows) as `0` (effectively resetting the batch and making it available for reuse).

When the <<rowsReturned, rowsReturned>> is greater than the <<totalRowCount, totalRowCount>>, `nextBatch` finishes with (_returns_) `false` (to "announce" there are no rows available).

`nextBatch` <<checkEndOfRowGroup, checkEndOfRowGroup>>.

`nextBatch` calculates the number of rows left to be returned as a minimum of the <<capacity, capacity>> and the <<totalCountLoadedSoFar, totalCountLoadedSoFar>> reduced by the <<rowsReturned, rowsReturned>>.

`nextBatch` requests every <<columnReaders, VectorizedColumnReader>> to [readBatch](VectorizedColumnReader.md#readBatch) (with the number of rows left to be returned and associated <<columnVectors, WritableColumnVector>>).

NOTE: <<columnReaders, VectorizedColumnReaders>> use their own <<columnVectors, WritableColumnVectors>> for storing values read. The numbers of <<columnReaders, VectorizedColumnReaders>> and <<columnVectors, WritableColumnVector>> are equal.

NOTE: The number of rows in the internal <<columnarBatch, ColumnarBatch>> matches the number of rows that <<columnReaders, VectorizedColumnReaders>> decoded and stored in corresponding <<columnVectors, WritableColumnVectors>>.

In the end, `nextBatch` registers the progress as follows:

* The number of rows read is added to the <<rowsReturned, rowsReturned>> counter

* Requests the internal <<columnarBatch, ColumnarBatch>> to [set the number of rows (in batch)](../../vectorized-query-execution/ColumnarBatch.md#setNumRows) to be the number of rows read

* The <<numBatched, numBatched>> registry is exactly the number of rows read

* The <<batchIdx, batchIdx>> registry becomes `0`

`nextBatch` finishes with (_returns_) `true` (to "announce" there are rows available).

NOTE: `nextBatch` is used exclusively when `VectorizedParquetRecordReader` is requested to <<nextKeyValue, nextKeyValue>>.

## <span id="getCurrentValue"> Getting Current Value (as Columnar Batch or Single InternalRow)

```java
Object getCurrentValue()
```

NOTE: `getCurrentValue` is part of the Hadoop https://hadoop.apache.org/docs/r2.7.5/api/org/apache/hadoop/mapreduce/RecordReader.html[RecordReader] Contract to break the data into key/value pairs for input to a Hadoop `Mapper`.

`getCurrentValue` returns the entire <<columnarBatch, ColumnarBatch>> with the <<returnColumnarBatch, returnColumnarBatch>> flag enabled (`true`) or requests it for a [single row](../../vectorized-query-execution/ColumnarBatch.md#getRow) instead.

`getCurrentValue` is used when:

* `NewHadoopRDD` is requested to compute a partition (`compute`)

* `RecordReaderIterator` is requested for the [next internal row](../RecordReaderIterator.md#next)
-->
