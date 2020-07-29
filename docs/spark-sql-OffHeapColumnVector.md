# OffHeapColumnVector

`OffHeapColumnVector` is a concrete spark-sql-WritableColumnVector.md[WritableColumnVector] that...FIXME

=== [[allocateColumns]] Allocating Column Vectors -- `allocateColumns` Static Method

[source, java]
----
OffHeapColumnVector[] allocateColumns(int capacity, StructType schema) // <1>
OffHeapColumnVector[] allocateColumns(int capacity, StructField[] fields)
----
<1> Simply converts `StructType` to `StructField[]` and calls the other `allocateColumns`

`allocateColumns` creates an array of `OffHeapColumnVector` for every field (to hold `capacity` number of elements of the spark-sql-DataType.md[data type] per field).

NOTE: `allocateColumns` is used when...FIXME
