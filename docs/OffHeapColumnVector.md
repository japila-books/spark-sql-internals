# OffHeapColumnVector

`OffHeapColumnVector` is a concrete [WritableColumnVector](WritableColumnVector.md).

=== [[allocateColumns]] Allocating Column Vectors -- `allocateColumns` Static Method

[source, java]
----
OffHeapColumnVector[] allocateColumns(int capacity, StructType schema) // <1>
OffHeapColumnVector[] allocateColumns(int capacity, StructField[] fields)
----
<1> Simply converts `StructType` to `StructField[]` and calls the other `allocateColumns`

`allocateColumns` creates an array of `OffHeapColumnVector` for every field (to hold `capacity` number of elements of the [data type](types/DataType.md) per field).

NOTE: `allocateColumns` is used when...FIXME
