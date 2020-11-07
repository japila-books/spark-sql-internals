# OnHeapColumnVector

`OnHeapColumnVector` is a concrete [WritableColumnVector](WritableColumnVector.md).

`OnHeapColumnVector` is <<creating-instance, created>> when:

* `OnHeapColumnVector` is requested to <<allocateColumns, allocate column vectors>> and <<reserveNewColumn, reserveNewColumn>>

* `OrcColumnarBatchReader` is requested to `initBatch`

=== [[allocateColumns]] Allocating Column Vectors -- `allocateColumns` Static Method

[source, java]
----
OnHeapColumnVector[] allocateColumns(int capacity, StructType schema) // <1>
OnHeapColumnVector[] allocateColumns(int capacity, StructField[] fields)
----
<1> Simply converts `StructType` to `StructField[]` and calls the other `allocateColumns`

`allocateColumns` creates an array of `OnHeapColumnVector` for every field (to hold `capacity` number of elements of the [data type](DataType.md) per field).

`allocateColumns` is used when:

* `AggregateHashMap` is created

* `InMemoryTableScanExec` is requested to InMemoryTableScanExec.md#createAndDecompressColumn[createAndDecompressColumn]

* `VectorizedParquetRecordReader` is requested to spark-sql-VectorizedParquetRecordReader.md#initBatch[initBatch] (with `ON_HEAP` memory mode)

* `OrcColumnarBatchReader` is requested to `initBatch` (with `ON_HEAP` memory mode)

* `ColumnVectorUtils` is requested to convert an iterator of rows into a single `ColumnBatch` (aka `toBatch`)

## Creating Instance

`OnHeapColumnVector` takes the following when created:

* [[capacity]] Number of elements to hold in a vector (aka `capacity`)
* [[type]] [Data type](DataType.md) of the elements stored

When created, `OnHeapColumnVector` <<reserveInternal, reserveInternal>> (for the given <<capacity, capacity>>) and [reset](WritableColumnVector.md#reset).

=== [[reserveInternal]] `reserveInternal` Method

[source, java]
----
void reserveInternal(int newCapacity)
----

`reserveInternal` is part of the [WritableColumnVector](WritableColumnVector.md#reserveInternal) abstraction.

`reserveInternal`...FIXME

=== [[reserveNewColumn]] `reserveNewColumn` Method

[source, java]
----
OnHeapColumnVector reserveNewColumn(
    int capacity,
    DataType type)
----

`reserveNewColumn` is part of the [WritableColumnVector](WritableColumnVector.md#reserveNewColumn) abstraction.

`reserveNewColumn`...FIXME
