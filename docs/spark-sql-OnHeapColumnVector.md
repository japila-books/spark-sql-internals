# OnHeapColumnVector

`OnHeapColumnVector` is a concrete spark-sql-WritableColumnVector.md[WritableColumnVector] that...FIXME

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

`allocateColumns` creates an array of `OnHeapColumnVector` for every field (to hold `capacity` number of elements of the spark-sql-DataType.md[data type] per field).

[NOTE]
====
`allocateColumns` is used when:

* `AggregateHashMap` is created

* `InMemoryTableScanExec` is requested to spark-sql-SparkPlan-InMemoryTableScanExec.md#createAndDecompressColumn[createAndDecompressColumn]

* `VectorizedParquetRecordReader` is requested to spark-sql-VectorizedParquetRecordReader.md#initBatch[initBatch] (with `ON_HEAP` memory mode)

* `OrcColumnarBatchReader` is requested to `initBatch` (with `ON_HEAP` memory mode)

* `ColumnVectorUtils` is requested to convert an iterator of rows into a single `ColumnBatch` (aka `toBatch`)
====

=== [[creating-instance]] Creating OnHeapColumnVector Instance

`OnHeapColumnVector` takes the following when created:

* [[capacity]] Number of elements to hold in a vector (aka `capacity`)
* [[type]] spark-sql-DataType.md[Data type] of the elements stored

When created, `OnHeapColumnVector` <<reserveInternal, reserveInternal>> (for the given <<capacity, capacity>>) and spark-sql-WritableColumnVector.md#reset[reset].

=== [[reserveInternal]] `reserveInternal` Method

[source, java]
----
void reserveInternal(int newCapacity)
----

NOTE: `reserveInternal` is part of spark-sql-WritableColumnVector.md#reserveInternal[WritableColumnVector Contract] to...FIXME.

`reserveInternal`...FIXME

=== [[reserveNewColumn]] `reserveNewColumn` Method

[source, java]
----
OnHeapColumnVector reserveNewColumn(int capacity, DataType type)
----

NOTE: `reserveNewColumn` is part of spark-sql-WritableColumnVector.md#reserveNewColumn[WritableColumnVector Contract] to...FIXME.

`reserveNewColumn`...FIXME
