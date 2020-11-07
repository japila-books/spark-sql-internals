# Vectorized Parquet Decoding (Reader)

**Vectorized Parquet Decoding** (**Vectorized Parquet Reader**) allows for reading datasets in parquet format in batches, i.e. rows are decoded in batches. That aims at improving memory locality and cache utilization.

Quoting [SPARK-12854 Vectorize Parquet reader](https://issues.apache.org/jira/browse/SPARK-12854):

> The parquet encodings are largely designed to decode faster in batches, column by column. This can speed up the decoding considerably.

Vectorized Parquet Decoding is used exclusively when `ParquetFileFormat` is requested for a [data reader](ParquetFileFormat.md#buildReaderWithPartitionValues) when [spark.sql.parquet.enableVectorizedReader](#spark.sql.parquet.enableVectorizedReader) property is enabled (`true`) and the read schema uses [AtomicTypes](DataType.md#AtomicType) data types only.

Vectorized Parquet Decoding uses [VectorizedParquetRecordReader](spark-sql-VectorizedParquetRecordReader.md) for vectorized decoding.

## <span id="spark.sql.parquet.enableVectorizedReader"> spark.sql.parquet.enableVectorizedReader Configuration Property

[spark.sql.parquet.enableVectorizedReader](configuration-properties.md#spark.sql.parquet.enableVectorizedReader) configuration property is on by default.

```scala
val isParquetVectorizedReaderEnabled = spark.conf.get("spark.sql.parquet.enableVectorizedReader").toBoolean
assert(isParquetVectorizedReaderEnabled, "spark.sql.parquet.enableVectorizedReader should be enabled by default")
```