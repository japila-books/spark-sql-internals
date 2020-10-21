title: SpecificParquetRecordReaderBase

# SpecificParquetRecordReaderBase -- Hadoop RecordReader

`SpecificParquetRecordReaderBase` is the base Hadoop `RecordReader` for *parquet* format readers that directly materialize to `T`.

NOTE: https://hadoop.apache.org/docs/r2.7.3/api/org/apache/hadoop/mapreduce/RecordReader.html[RecordReader] reads `<key, value>` pairs from an Hadoop `InputSplit`.

NOTE: spark-sql-VectorizedParquetRecordReader.md[VectorizedParquetRecordReader] is the one and only `SpecificParquetRecordReaderBase` that directly materialize to Java `Objects`.

[[internal-registries]]
.SpecificParquetRecordReaderBase's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| [[sparkSchema]] `sparkSchema`
| Spark [schema](StructType.md)

Initialized when `SpecificParquetRecordReaderBase` is requested to <<initialize, initialize>> (from the value of [org.apache.spark.sql.parquet.row.requested_schema](ParquetFileFormat.md#org.apache.spark.sql.parquet.row.requested_schema) configuration as set when `ParquetFileFormat` is requested to [build a data reader with partition column values appended](ParquetFileFormat.md#buildReaderWithPartitionValues))
|===

=== [[initialize]] `initialize` Method

[source, scala]
----
void initialize(InputSplit inputSplit, TaskAttemptContext taskAttemptContext)
----

NOTE: `initialize` is part of ++https://hadoop.apache.org/docs/r2.7.3/api/org/apache/hadoop/mapreduce/RecordReader.html#initialize(org.apache.hadoop.mapreduce.InputSplit,%20org.apache.hadoop.mapreduce.TaskAttemptContext)++[RecordReader Contract] to initialize a `RecordReader`.

`initialize`...FIXME
