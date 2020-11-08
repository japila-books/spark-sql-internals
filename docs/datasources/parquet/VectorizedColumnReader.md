# VectorizedColumnReader

`VectorizedColumnReader` is a vectorized column reader that [VectorizedParquetRecordReader](VectorizedParquetRecordReader.md#columnReaders) uses for [Vectorized Parquet Decoding](../../vectorized-parquet-reader.md).

`VectorizedColumnReader` is <<creating-instance, created>> exclusively when `VectorizedParquetRecordReader` is requested to <<VectorizedParquetRecordReader.md#checkEndOfRowGroup, checkEndOfRowGroup>> (when requested to <<nextBatch, read next rows into a columnar batch>>).

Once <<creating-instance, created>>, `VectorizedColumnReader` is requested to <<readBatch, read rows as a batch>> (when `VectorizedParquetRecordReader` is requested to <<VectorizedParquetRecordReader.md#nextBatch, read next rows into a columnar batch>>).

`VectorizedColumnReader` is given a [WritableColumnVector](../../WritableColumnVector.md) to store rows  <<readBatch, read as a batch>>.

[[creating-instance]]
`VectorizedColumnReader` takes the following to be created:

* [[descriptor]] Parquet `ColumnDescriptor`
* [[originalType]] Parquet `OriginalType`
* [[pageReader]] Parquet `PageReader`
* [[convertTz]] `TimeZone` (for timezone conversion to apply to int96 timestamps. `null` for no conversion)

=== [[readBatch]] Reading Rows As Batch -- `readBatch` Method

[source, java]
----
void readBatch(
  int total,
  WritableColumnVector column) throws IOException
----

`readBatch`...FIXME

NOTE: `readBatch` is used exclusively when `VectorizedParquetRecordReader` is requested to <<VectorizedParquetRecordReader.md#nextBatch, read next rows into a columnar batch>>.
