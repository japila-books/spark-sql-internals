# OnHeapColumnVector

`OnHeapColumnVector` is a concrete [WritableColumnVector](WritableColumnVector.md).

<!---
## Review Me
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

`allocateColumns` creates an array of `OnHeapColumnVector` for every field (to hold `capacity` number of elements of the [data type](types/DataType.md) per field).

`allocateColumns` is used when:

* `AggregateHashMap` is created

* `InMemoryTableScanExec` is requested to InMemoryTableScanExec.md#createAndDecompressColumn[createAndDecompressColumn]

* `VectorizedParquetRecordReader` is requested to [initBatch](datasources/parquet/VectorizedParquetRecordReader.md#initBatch) (with `ON_HEAP` memory mode)

* `OrcColumnarBatchReader` is requested to `initBatch` (with `ON_HEAP` memory mode)

* `ColumnVectorUtils` is requested to convert an iterator of rows into a single `ColumnBatch` (aka `toBatch`)

## Creating Instance

`OnHeapColumnVector` takes the following when created:

* [[capacity]] Number of elements to hold in a vector (aka `capacity`)
* [[type]] [Data type](types/DataType.md) of the elements stored

When created, `OnHeapColumnVector` <<reserveInternal, reserveInternal>> (for the given <<capacity, capacity>>) and [reset](WritableColumnVector.md#reset).
-->
